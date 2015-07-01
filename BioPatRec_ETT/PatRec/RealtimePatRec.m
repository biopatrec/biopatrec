% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec © which is open and free software under 
% the GNU Lesser General Public License (LGPL). See the file "LICENSE" for 
% the full license governing this code and copyrights.
%
% BioPatRec was initially developed by Max J. Ortiz C. at Integrum AB and 
% Chalmers University of Technology. All authors’ contributions must be kept
% acknowledged below in the section "Updates % Contributors". 
%
% Would you like to contribute to science and sum efforts to improve 
% amputees’ quality of life? Join this project! or, send your comments to:
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
% 2011-12-07 / Max Ortiz  / Upgrade to Session-based interface for DAQ,the
%                           prevous version was called RealtimePatRec_Legacy.m
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
global outVectorLast;
%global data;            % only needed for testing

patRec   = patRecX;
handles  = handlesX;
nTW      = 1;
procT    = [];
tempData = [];
outVectorLast = zeros(patRec.nOuts,1);
pDiv     = 2;        % Peeking devider, the fastest allowed for the DAQ
                     % which is 20 times per second, so 0.05 for 2k Hz

% Get sampling time
sT = str2double(get(handles.et_testingT,'String'));
% Initialze control algorithms
patRec = InitControl(patRec);

%% Is the VRE selected?
vreCoupling = 0;
if isfield(handles,'vre_Com')
    vreCoupling = strcmp(handles.vre_Com.Status,'open');    
end

%% Is there an option for coupling with the motors?
if isfield(handles,'cb_motorCoupling') %&& ~isfield(handles,'com')
    motorCoupling = get(handles.cb_motorCoupling,'Value');    
else
    motorCoupling = 0;
end

%Is the motor coupling selected?
if motorCoupling

    %Initialize
    motorIdx = zeros(1,10);
    pwmAs = zeros(1,10);
    pwmBs = zeros(1,10);
    movSpeeds = zeros(1,10);
    
    % Get the links to the motors
    for i = 1 : size(motorIdx,2)
        pmID = ['handles.pm_m' num2str(i)];
        motorIdx(i) = get(eval(pmID),'Value'); 
        speedID = ['handles.et_speed' num2str(i)];
        movSpeeds(i) = str2double(get(eval(speedID),'String')); 
    end
    
    % Init variables for control
    pwmIDs = ['A';'A';'B';'B';'C';'C';'D';'D';'E';'E'];
    for i = 1 : 2 : size(pwmIDs)
        pwmAs(i)   = movSpeeds(i);
        pwmBs(i)   = 0;
        pwmAs(i+1) = 0;
        pwmBs(i+1) = movSpeeds(i+1);
    end;
    
    % Arrenge according to selection
    pwmIDs = pwmIDs(motorIdx);
    pwmAs = pwmAs(motorIdx);
    pwmBs = pwmBs(motorIdx);
    
end    

%% Initialize DAQ card
% Note: A function for DAQ selection will be required when more cards are
% added
if strcmp(patRec.dev,'ADH')
    
else % at this poin everything else is the NI - USB6009
    chAI = zeros(1,8);  % 8 ch is the limit for the USB6009
    chAI(patRec.nCh) = 1; 
    %Init the SBI
    s = InitSBI_NI(patRec.sF,sT,chAI);
    % Change the interruption time
    s.NotifyWhenDataAvailableExceeds = (patRec.sF*patRec.tW)/pDiv;    
    lh = s.addlistener('DataAvailable', @RealtimePatRec_OneShot);
    %Test the DAQ by ploting the data
    %lh = s.addlistener('DataAvailable', @plotDataTest);
end


%% Run the Realtime PatRec
% Note: Probabily this way of testing only works for the NI
% Specific funtions per card might be required.
s.startBackground();

% Wait until it has finished done
%s.IsDone  % will report 0    
s.wait(); % rather than while    
%s.IsDone  % will report 1

%% Finish session
%Delete listener SBI
delete (lh)

%Stop motors
if motorCoupling
    if(isfield(handles,'movList'))
        for i=1 : length(handles.movList)
            [handles.motors, ~] = MotorsOff(handles.com, handles.movList(i), handles.motors);
        end
    else
        ActivateMotors(handles.com, pwmIDs, pwmAs, pwmBs, 0);
    end
end

% Write the average processing time
set(handles.et_avgProcTime,'String',num2str(mean(procT(2:end))));

handlesX = handles;

%Plot processing time
figure();
hist(procT(2:end));
    
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
    global outVectorLast;

    %Keep saving all recorded data
    tempData = [tempData; event.Data];
    
    %Output vector
    outVector = zeros(patRec.nOuts,1);
    
    %Only considered the data once it has at least the size of time window
    if size(tempData,1) >= (patRec.sF*patRec.tW) 

        tData = tempData(end-patRec.sF*patRec.tW+1:end,:);   %Copy the temporal data to the test data
        
        % Start of processing time
        procTimeS = tic;

        %Signal processing
        tSet = SignalProcessing_RealtimePatRec(tData, patRec);

        % One shoot PatRec
        outMov = OneShotPatRecClassifier(patRec, tSet);
        
        % Control algorithm
        [patRec outMov] = ApplyControl(patRec, outMov);
        
        % Show results
        if outMov == 0
            outMov = patRec.nM;
        end
        set(handles.lb_movements,'Value',outMov);
        drawnow;

        % Send vector to the motors
        if(isfield(handles,'movList'))
            if motorCoupling
                % Update outvector
                outVector(outMov) = 1;
                % Check if the state has change
                outChanged = find(xor(outVector, outVectorLast));
                % Only send information to the motors that have changed
                % state
                for i = 1 : size(outChanged,1)
                    if outVector(outChanged(i))
                        [handles.motors, ~] = MotorsOn(handles.com, handles.movList(outChanged(i)), handles.motors);                    
                    else
                        [handles.motors, ~] = MotorsOff(handles.com, handles.movList(outChanged(i)), handles.motors);
                    end
                end
            end
            
            % To slow for hand open and close since it continuesly send
            % data to the microcontroller
%             perfMov = handles.movList(outMov);
%             if motorCoupling
%                 %Activate motors here using MoveMotor (for now).
%                 [handles.motors, ~] = MoveMotor(handles.com, perfMov, 1, handles.motors);
%             end
            
            
            % VRE
            if vreCoupling
                perfMov = handles.movList(outMov);
                if VREActivation(handles.vre_Com, 5, [], perfMov.idVRE, perfMov.vreDir, get(handles.cb_moveTAC,'Value'))
                   TAC.acktimes = TAC.acktimes + 1; 
                end
            end
        else % alternative way for motor control
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
        outVectorLast = outVector;
        % Finish of processing time
        procT(nTW) = toc(procTimeS);
        
        % quick and dirty patch to keep the servos moving
        % this is provisional
        if motorCoupling
            for i = 1 : size(outChanged,1)
                if or(handles.movList(outChanged(i)).motor == 8, ...
                   handles.movList(outChanged(i)).motor == 7)     
                    outVectorLast(outChanged(i)) = 0;
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





