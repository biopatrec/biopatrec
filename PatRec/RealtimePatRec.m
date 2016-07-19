% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec © which is open and free software under 
% the GNU Lesser General Public License (LGPL). See the file "LICENSE" for 
% the full license governing this code and copyrights.
%
% BioPatRec was initially developed by Max J. Ortiz C. at Integrum AB and 
% Chalmers University of Technology. All authors? contributions must be kept
% acknowledged below in the section "Updates % Contributors". 
%
% Would you like to contribute to science and sum efforts to improve 
% amputees? quality of life? Join this project! or, send your comments to:
% maxo@chalmers.se.
%
% The entire copyright notice must be kept in this or any source file 
% linked to BioPatRec. This will ensure communication with all authors and
% acknowledge contributions here and in the project web page (optional).
%
% -------------------------- Function Description -------------------------
% Function to execute real-time patrec using the offline trained algorithm
% which information is stored in patRec
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-07-27 / Max Ortiz  / Creation
% 2011-08-03 / Max Ortiz  / Separation of "SignalProcessing_RealtimePatRec"
% 2011-11-17 / Max Ortiz  / Added the motors coupling
% 2011-12-07 / Nichlas Sander / Added VRE Coupling and VRE commands.
% 2011-12-07 / Max Ortiz  / Upgrade to Session-based interface for DAQ, the
%                           prevous version was called RealtimePatRec_Legacy.m
% 2012-08-13 / Morten Kristoffersen  / Added GUI interface to see and control 
% 									   the threshold values for the MLP ThOut algorithm.
% 2012-10-05 / Joel Falk-Dahlin / Changed inputs and outputs of
%                                 ApplyControl to work with updated version.
%                                 Removed InitControl since it is
%                                 performed inside the GUI
% 2012-10-26 / Joel Falk-Dahlin / Added ApplyProportionalControl
% 2012-11-06 / Max Ortiz        / Create RealimePatRec_OneShot to concentrate
%                                 critical routines of realtimepatrec
% 2012-11-23 / Joel Falk-Dahlin / Moved speeds from handles to patRec,
%                                 changed VRE to use the new speeds
% 2013-04-17 / Max Ortiz        / Made independent routines for control of
%                                 differend devices
% 2013-06-03 / Max Ortiz        / Addition of necessary routines to control
%                                 Standard proshetic components (SPC) using wifi.
% 2014-11-12 / Enzo Mastinu     / Added code for ADS1299 AFE RealTime PatRec
% 2015-01-20 / Enzo Mastinu     / All this function has been re-organized
%                                 to be compatible with the functions
%                                 placed into COMM/AFE folder. For more
%                                 details read about RecordingSession.m with 
%                                 other custom devices for BioPatRec_TRE.
% 2016-02-10 / Max Ortiz        / change the initialization of the NI card
%                                 to use the vector of channels rather than only the number
% 20xx-xx-xx / Author  / Comment on update

function handlesX = RealtimePatRec(patRecX, handlesX)

    clear global;
    clear persistent;

    global patRec;
    global handles;
    global nTW;
    global procT;
    global motorCoupling;
    global vreCoupling;
    global pwmIDs;
    global pwmAs;
    global pwmBs;
    global tempData;
    global outVectorMotorLast;
    
    %global data;            % only needed for testing
    global thresholdGUIData;

    patRec   = patRecX;
    handles  = handlesX;
    nTW      = 1;
    procT    = [];
    tempData = [];
    outVectorMotorLast = zeros(patRec.nOuts,1);
                         
    % Get needed info from patRec structure
    sF                  = patRec.sF;
    nCh                 = length(patRec.nCh);       
    ComPortType         = patRec.comm;
    deviceName          = patRec.dev;
                         
    % Get sampling time
    sT = str2double(get(handles.et_testingT,'String'));
    tW = patRec.tW;                                                        % Time window size
    tWs = tW*sF;                                                           % Time window samples
   

    % Initialze control algorithms
    %patRec = InitControl(patRec); % No longer needed, Initialization is done in GUI

    %% Is threshold (thOut) used?
    if(isfield(patRec.patRecTrained,'thOut'));
        %Threshold GUI init
        thresholdGUI = GUI_Threshold; 
        thresholdGUIData = guidata(thresholdGUI);
        set(GUI_Threshold,'CloseRequestFcn', 'set(GUI_Threshold, ''Visible'', ''off'')');
        xpatch = [1 1 0 0];
        ypatch = [0 0 0 0];
            for i=0:patRec.nOuts-1
                s = sprintf('movementSelector%d',i);
                s0 = sprintf('thPatch%d',i);
                s1 = sprintf('meter%d',i);
                axes(thresholdGUIData.(s1));
                handles.(s0) = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','normal','visible','on');
                ylim(thresholdGUIData.(s1), [0 1]);
                xlim('auto');
                set(thresholdGUIData.(s),'String',patRec.mov(patRec.indMovIdx));
                if (size(patRec.mov(patRec.indMovIdx),1) < i+1); 
                    set(thresholdGUIData.(s),'Value',size(patRec.indMovIdx,2));
                else
                    set(thresholdGUIData.(s),'Value',i+1);
                end
            end
    end

    %% Is the VRE selected?
    vreCoupling = 0;
    if isfield(handles,'vre_Com');  
        %If there is a vre communication, is it open?
        vreCoupling = strcmp(handles.vre_Com.Status,'open');
    end

    %% Is there an option for coupling with the motors?
    if isfield(handles,'cb_motorCoupling') %&& ~isfield(handles,'com')
        motorCoupling = get(handles.cb_motorCoupling,'Value');    
    else
        motorCoupling = 0;
    end

%     % Init variables for hard-coded control (not using objects) %% CHECK
%     if motorCoupling && ~isfield(handles,'movList')
%         if deviceID == 1 % Multifunctinal prosthesis with DC motors 
%             [pwmIDs pwmAs pwmBs] = InitMF_Hand_DC_Hardcoded(handles);        
%         elseif deviceID == 3  % Standard prosthetic units (wireless)
% 
%         end
%     end
    
    % Get connection object for control external robotic devices
    if motorCoupling
        if ~isfield(handles,'Control_obj')
            set(handles.t_msg,'String','No connection obj found');   
            return;
        end
        if ~strcmp(handles.Control_obj.status,'open')
            fopen(handles.Control_obj);
        end        
    end

    cData = zeros(tWs,nCh);
    
    %%%%% Real Time PatRec with NI DAQ card %%%%%
    if strcmp (ComPortType, 'NI')

        % Init SBI
        sCh = patRec.nCh;                                                  % Vector of channels
        s = InitSBI_NI(sF,sT,sCh); 
        s.NotifyWhenDataAvailableExceeds = tWs;                            % PEEK time
        lh = s.addlistener('DataAvailable', @RealtimePatRec_OneShot); 

        % Start DAQ
        s.startBackground();                                               % Run in the backgroud

        if ~s.IsDone                                                       % check if is done
            s.wait();
        end
        delete(lh);

    %%%%% Real Time PatRec with other custom device %%%%%   
    else

        % Prepare handles for next function calls
        handles.deviceName  = deviceName;
        handles.ComPortType = ComPortType;
        if strcmp (ComPortType, 'COM')
            handles.ComPortName = patRec.comn;
        end
        handles.sF          = sF;
        handles.sT          = sT;
        handles.nCh         = nCh;
        handles.sTall       = sT;

        % Delete connection object
        if isfield(handles,'obj')
            delete(handles.obj);
        end

        % Connect the chosen device, it returns the connection object
        obj = ConnectDevice(handles);
        handles.obj = obj;

        % Set the selected device and Start the acquisition
        SetDeviceStartAcquisition(handles, obj);

        for timeWindowNr = 1:sT/tW

            cData = Acquire_tWs(deviceName, obj, nCh, tWs);            % acquire a new time window of samples
            acquireEvent.Data = cData;
            RealtimePatRec_OneShot(0, acquireEvent);                       
        end

        % Stop acquisition
        StopAcquisition(deviceName, obj);
    end
    
    %Stop motors
    if motorCoupling
        if ~strcmp(handles.Control_obj.status,'open')
            fopen(handles.Control_obj);
        end   
        if(isfield(handles,'movList')) % Is the movement obj used?
            for i=1 : length(handles.movList)
                [handles.motors, ~] = MotorsOff(handles.Control_obj, handles.movList(i), handles.motors);
            end
        else % from hardcoded GUI GUI_TestPatRec
            ActivateMotors(handles.com, pwmIDs, pwmAs, pwmBs, 0);
        end
    end

    % Write the average processing time
    set(handles.et_avgProcTime,'String',num2str(mean(procT(2:end))));

    handlesX = handles;

    %Reset Threshold GUI 
    if(isfield(patRec.patRecTrained,'thOut'));
        for i=0:patRec.nOuts-1
            s0 = sprintf('thPatch%d',i);
            set(handles.(s0), 'YData', [0 0 0 0]);
            %delete(GUI_Threshold);
        end
    end

    %Plot processing time
    figure();
    hist(procT(2:end));
    set(handles.pb_RealtimePatRec, 'Enable', 'on');   
end


function RealtimePatRec_OneShot(src,event)

    global patRec;
    global nTW;
    global procT;
    global motorCoupling;
    global vreCoupling;
    global handles;
    global TAC;
    global pwmIDs;
    global pwmAs;
    global pwmBs;    
    global tempData;
    global outVectorMotorLast;
	global thresholdGUIData;

    %Keep saving all recorded data
    tempData = [tempData; event.Data];
    
    %Output vector
    outVectorMotor = zeros(patRec.nOuts,1);
    
    tData = tempData(end-patRec.sF*patRec.tW+1:end,:);
    
    %Only considered the data once it has at least the size of time window
    if size(tempData,1) >= (patRec.sF*patRec.tW) 

        % Start of processing time
        procTimeS = tic;

        % General routine for RealtimePatRec
        [outMov outVector patRec handles] = OneShotRealtimePatRec(tData, patRec, handles, thresholdGUIData);
        
        % GUI and control Updates
        
        % Game control        
        if get(handles.cb_keys,'Value') && outMov(1) ~= 0
            keys = zeros(patRec.nM,1);
            keys(outMov) = 1;
            savedKeys = [];
            if isfield(handles,'savedKeys')
               savedKeys = handles.savedKeys; 
            end
            SendKeys(keys,savedKeys);
        end
        
        
        % Robot control
        if get(handles.cb_controls,'Value') &&outMov(1) ~=0
            controls = zeros(patRec.nM,1);
            controls(outMov) = 1;
            savedControls = [];
            if isfield(handles,'savedControls')
               savedControls = handles.savedControls; 
            end
            SendControls(controls,savedControls);
        end
                
        % Send vector to the motors
        if(isfield(handles,'movList'))
            if motorCoupling
                % Update outvectorMotor
                outVectorMotor(outMov) = 1;
                % Check if the state has change
                outChanged = find(xor(outVectorMotor, outVectorMotorLast));
                % Only send information to the motors that have changed state
                for i = 1 : size(outChanged,1)
                    if outVectorMotor(outChanged(i))
                        [handles.motors, ~] = MotorsOn(handles.Control_obj, handles.movList(outChanged(i)), handles.motors, patRec.control.currentDegPerMov(outChanged(i)));
                    else
                        [handles.motors, ~] = MotorsOff(handles.Control_obj, handles.movList(outChanged(i)), handles.motors);
                    end
                end    
            end  
            
            % VRE
            if vreCoupling
                for i = 1:length(outMov)
                    speed = patRec.control.currentDegPerMov(outMov(i));
                    perfMov = handles.movList(outMov(i));
                    if VREActivation(handles.vre_Com, speed, [], perfMov.idVRE, perfMov.vreDir, get(handles.cb_moveTAC,'Value'))
                       TAC.acktimes = TAC.acktimes + 1; 
                    end
                end
            end
        else % alternative way for motor control (hard-coded)
            if motorCoupling
                ActivateMotors(handles.com, pwmIDs, pwmAs, pwmBs, outMov);
            end

            if vreCoupling
                dof = round(outMov/2);
                dofs = [9,7,8,0,10];
                dir = mod(outMov,2);

                if (dof == 1 && dir == 1)
                   dof = 5; 
                end

               if (dir == 1)
                  dir = 0;
               else
                  dir = 1;
               end           

                if VREActivation(handles.vre_Com, 25, [], dofs(dof), dir, get(handles.cb_moveTAC,'Value')) == 1
                   % TAC Test Completed
                   TAC.ackTimes = TAC.ackTimes + 1;
                end
            end
        end

        % Next cycle
        nTW = nTW + 1;
        outVectorMotorLast = outVectorMotor;
        % Finish of processing time
        procT(nTW) = toc(procTimeS);
        
        % quick and dirty patch to keep the servos moving
        % this is provisional
        if motorCoupling
            for i = 1 : size(outChanged,1)
                if or(handles.movList(outChanged(i)).motor == 8, ...
                   handles.movList(outChanged(i)).motor == 7)     
                    outVectorMotorLast(outChanged(i)) = 0;
                end
            end        
        end
        
        
    end
 end

 function plotDataTest(src,event)
    persistent tempData;
    global data 
    if(isempty(tempData))
         tempData = [];
         figure();
     end
     plot(event.TimeStamps, event.Data)
     tempData = [tempData;event.Data];
     data = tempData;
 end





