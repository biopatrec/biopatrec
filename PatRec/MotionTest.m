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
% ------------------- Function Description ------------------
% Motion Test for to evaluate real-time performance of the patRec
% This test is implemented in such a way that the "rest" movement is
% required
%
% --------------------------Updates--------------------------
% [Contributors are welcome to add their email]
% 2012-01-xx / Max Ortiz        / Creation from MotionTestLegacy
% 2012-05-29 / Max Ortiz        / Addition of "clear" commands
% 2012-07-24 / Max Ortiz        / Use fpTW to compute the predition time of the
%                                 first prediction in order to calculate the selection time
% 2012-10-05 / Joel Falk-Dahlin / Added ApplyControl after OneShotPatRec
%                                 to allow for the use of control algorithms in the motion test
% 2012-10-26 / Joel Falk-Dahlin / Added ApplyProportionalControl
% 2012-11-06 / Max Ortiz        / Create RealimePatRec_OneShot to concentrate
%                                 critical routines of realtime patrec
% 2013-01-29 / Nichlas Sander   / Added possibility to use VRE as guidance
%                                 during the motion test.
% 2015-02-02 / Enzo Mastinu     / All this function has been re-organizated
%                                 to be compatible with the functions
%                                 placed into COMM/AFE folder. For more
%                                 details read RecordingSession.m log.
% 2016-05-03 / Julian Maier     / Artifact inseration added to tempdata if
%                                 required
% 2018-02-23/ James Austin      / Added window overlap as the cycletime for real time
%                                 pattern recognition implementation from
%                                 NI devices (replacing tWs for PEEK time).                          
% 20xx-xx-xx / Author     / Comment on update



function motionTest = MotionTest(patRecX, handlesX)

clear global;

global patRec;
global handles;
global nTW;             % Number of time windows evaluated
global fpTW;     % Time window of the first prediction
global dataTW;          % Raw data from each time windows
global tempData;        % Reset tempData if it is the first call
global motorCoupling;
global vreCoupling; 
global thresholdGUIData;

% Time markers
global selTimeTic;

% Key performance indicators
global nCorrMov;
global selTime;     % Selection time (selected = expected movement)
global selTimeTW;   
global compTime;    % Completion time (selected = expected movement)
global compTimeTW;
global nwCompTime;  % Number of time windows to consider completion time
global predictions;
global procTime;    % Processing time

% Key performance indicators for at least 1 correct prediction
global nCorrMov1;   % Number of at least 1 correct number
global selTime1;    % Selection time (selected = at leas 1 expected mov)
global selTime1TW;   
global compTime1;   % Completion time (selected = at leas 1 expected mov)
global compTime1TW;
% Variables to keep track of testing movement
global mIdx;
global m;

%% Init variable
patRec  = patRecX;
handles = handlesX;
trials  = str2double(get(handles.et_trials,'String'));
nR      = str2double(get(handles.et_nR,'String'));
timeOut = str2double(get(handles.et_timeOut,'String'));
nwCompTime = 20;    % Number of windows to consider completion time
pause on;   % Enable pauses

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
if isfield(handles,'cb_motionTestVRE')
    trainUsingVre = get(handles.cb_motionTestVRE,'Value');    
else
    trainUsingVre = 0;
end

%% Is there an option for coupling with the motors?
if isfield(handles,'cb_motorCoupling')
    motorCoupling = get(handles.cb_motorCoupling,'Value');    
else
    motorCoupling = 0;
end

%% Init motionTest structure
motionTest.patRec   = patRec;
motionTest.sF       = patRec.sF;
% motionTest.tW       = patRec.tW;
motionTest.trails   = trials;
motionTest.nR       = nR;
motionTest.timeOut  = timeOut;

sF                  = motionTest.sF;
nCh                 = length(patRec.nCh);       
ComPortType         = patRec.comm;
deviceName          = patRec.dev;

% Get sampling time
sT = motionTest.timeOut;
tW = patRec.tW;                                                           % Time window size
tWs = tW*sF;                                                              % Time window samples
oW = patRec.wOverlap;                                                     % Timestep length from window overlap
iW = tW-oW;                                                               % Increment window size
iWs = floor(iW*sF);                                                              % Increment window samples

%% Motion Test
% Note: Probabily this way of testing only works for the NI
% specific funtions per card might be required.

if trainUsingVre
    if ~isfield(handles,'vre_Com')
        handles = ConnectVRE(handles,'Virtual Reality.exe');
    end
end


% run over all the trails
for t = 1 : trials
    
    for i = 1 : 5;
        msg = ['Trial: "' num2str(t) '" in: ' num2str(6-i) ' seconds'];
        set(handles.t_msg,'String',msg);
        pause(1);
    end
    
    % repeat the movement the chosen times
    for r = 1 : nR
        % Randomize the aperance of the requested movement
        mIdx = randperm(patRec.nM - 1); % It doesn't include "rest"
        % Run over all movements but "rest"
        for m = 1 : patRec.nM - 1
            
            %Select movement
            movementObjects = handles.movList(patRec.movOutIdx{mIdx(m)});
            mov = patRec.mov{mIdx(m)};
            %Prepare
            for i = 1 : 3
                % Warn the user
                %msg = ['Relax and prepare to "' mov '" in: ' num2str(4-i) ' seconds (trial:' num2str(t) ', rep:' num2str(r) ')'];
                % No warning
                msg = 'Relax';
                set(handles.t_msg,'String',msg);
                pause(1);
            end

            % Warning to the user
            fileName = ['Img/' char(mov) '.jpg'];
            if ~exist(fileName,'file')
                fileName = 'Img/relax.jpg';
            end
            % Display image
            movI = importdata(fileName); % Import Image
            set(handles.a_pic,'Visible','on');  % Turn on visibility
            pic = image(movI,'Parent',handles.a_pic);   % set image
            axis(handles.a_pic,'off');     % Remove axis tick marks            
            
            % Init required for patRec of the selected movement
            nTW = 1;            % Number of time windows
            fpTW = 0;           % Time window of the first prediction
            nCorrMov = 0;       % Number of corect movements
            predictions = {};   % Vector with the classifier prediction per tw
            selTime = NaN;      % Selection time
            selTimeTW = NaN;    % nTW when the selection time happen
            compTime = NaN;     % Completion time
            compTimeTW = NaN;   % nTW when the completion time happen
            
            nCorrMov1 = 0;      % Number of corect movements of at least 1 mov
            selTime1 = NaN;     % Selection time of at least 1 expected mov
            selTime1TW = NaN;   % nTW when the selection time happen
            compTime1 = NaN;    % Completion time
            compTime1TW = NaN;  % nTW when the completion time happen

            selTimeTic = [];    % Resets the time of first movement
            procTime = [];      % Processing time (vector)
            dataTW = [];        % Reset the dataTW (matrix)
            tempData = [];      % Reset tempData if it is the first call
            
            % Move the VRE into place.
            for i = 1:length(movementObjects)
                movementObject = movementObjects(i);
                if trainUsingVre
                    % Send values to VRE to move hand into position.
                    for j = 1:15 %Move it 15 times, distance of 5 each time.
                        VREActivation(handles.vre_Com,5,[],movementObject.idVRE, movementObject.vreDir, 0);
                    end
                end
            end
            
            
            cData = zeros(iWs,nCh);
            if strcmp (ComPortType, 'NI')

                % Init SBI
                sCh = 1:nCh;
                if strcmp(deviceName, 'Thalmic MyoBand')
                    %CK: init MyoBand
                    s = MyoBandSession(sF, sT, sCh);
                else
                    s = InitSBI_NI(sF,sT,sCh);
                end
                s.NotifyWhenDataAvailableExceeds = iWs;                            % PEEK time
                lh = s.addlistener('DataAvailable', @MotionTest_OneShot);

                % Ask the user to execute movement
                set(handles.t_msg,'String',mov);
                drawnow;
                
                % Start DAQ
                s.startBackground();                                               % Run in the backgroud

                if ~s.IsDone                                                       % check if is done
                    s.wait();
                end
%                 delete(lh);
                if ~strcmp(deviceName, 'Thalmic MyoBand')
                    delete(lh);
                end
                %CK: Stop sampling from MyoBand
                if strcmp(deviceName, 'Thalmic MyoBand')
                    MyoClient('StopSampling');
                end
                
                %%%%% Motion Test with other custom device %%%%%
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

                % Connect the chosen device, it returns the connection object
                obj = ConnectDevice(handles);

                % Set the selected device and Start the acquisition
                SetDeviceStartAcquisition(handles, obj);

                % Ask the user to execute movement
                set(handles.t_msg,'String',mov);
                drawnow;
                
                for timeWindowNr = 1:(sT-oW)/iW
                    cData = Acquire_tWs(deviceName, obj, nCh, iWs);      % Acquire a new time window of samples
                    acquireEvent.Data = cData;
                    MotionTest_OneShot(0, acquireEvent);                       
                end

                % Stop acquisition
                StopAcquisition(deviceName, obj);
            end
            
            
            %Reset the VRE.
            if trainUsingVre
                ResetVRE(handles.vre_Com,1,1);
            end
            
            %% Save data
            test.mov                    = mov;
            test.nTW                    = nTW-1;
            test.fpTW                   = fpTW;
            test.nCorrMov               = nCorrMov;
            test.predictions            = predictions;
            test.selTime                = selTime;
            test.selTimeTW              = selTimeTW;
            test.compTime               = compTime;
            test.compTimeTW             = compTimeTW;
            % Performance for at least 1 movement
            test.nCorrMov1              = nCorrMov1;
            test.selTime1               = selTime1;
            test.selTime1TW             = selTime1TW;
            test.compTime1              = compTime1;
            test.compTime1TW            = compTime1TW;
            % Data
            test.dataTW                 = dataTW;
            test.procTime               = mean(procTime);

            % Test fail?
            if isnan(compTime)
                test.fail = 1;
                % Test failed even for 1 movement simul?
                if isnan(compTime1)
                    test.fail1 = 1;
                else
                    test.fail1 = 0;
                end
            else
                test.fail = 0;
                test.fail1 = 0;
            end

            % Compute accuracy between fpTw to achivement of compTime
            if test.fail
                % Consider the accuracy during fail trials
                %corrP = sum(predictions == mIdx(m));
                %test.acc = corrP / size(predictions,2);   
                
                %Don't acount for acc in failed trials
                test.acc = NaN;
                
            else
                corrP = 0;
                for i = fpTW : compTimeTW+fpTW-1
                    if isequal(predictions{i},patRec.movOutIdx{mIdx(m)}')
                        corrP = corrP +1; 
                    end
                end
                %corrP = sum(predictions{fpTW:fpTW+compTimeTW-1} == mIdx(m)); %It doesn't work for simultaneous prediction               
                test.acc = corrP / compTimeTW;            
            end
            
            disp(test);
            motionTest.test(r,mIdx(m),t)  = test;
            delete(pic); 
            set(handles.t_msgMT,'Visible','off');
            drawnow;            
        end
    end
end

if trainUsingVre
    handles = DisconnectVRE(handles);
end

% Saved any modification to patRec
motionTest.patRec   = patRec;

pause off;

% show results
motionTest = MotionTestResults(motionTest);  

% Save test
disp(motionTest);
[filename, pathname] = uiputfile({'*.mat','MAT-files (*.mat)'},'Save as', 'Untitled.mat');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
        save([pathname,filename],'motionTest');    
    end
    
% Clear key variables
clear mIdx;
clear m;
end


function MotionTest_OneShot(src,event)

    % General 
    global patRec;
    global handles;
    global nTW;     % Number of time windows evaluated
    global fpTW;     % Time window of the first prediction
    global dataTW;  % Raw data from each time windows
    global tempData;
    global motorCoupling;
    global vreCoupling;
	global thresholdGUIData;
    
    % Time markers
    global selTimeTic;
    % Key performance indicators
    global procTime;    
    global nCorrMov;
    global selTime;     % Selection time
    global selTimeTW;   
    global compTime;    % Completion time
    global compTimeTW;
    global nwCompTime;  % Number of time windows to consider completion time
    global predictions;
    % Key performance indicators for at least one movement
    global nCorrMov1;   % Number of at least 1 correct number
    global selTime1;    % Selection time (selected = at leas 1 expected mov)
    global selTime1TW;   
    global compTime1;   % Completion time (selected = at leas 1 expected mov)
    global compTime1TW;
    % Variables to keep track of testing movement
    global mIdx;
    global m;
        
    
    tempData = [tempData; event.Data];  % Record all signal
    
    % Is there enough data for a TW?
    if size(tempData,1) >= (patRec.sF*patRec.tW) 
        
        % Save the TW data, maybe useful for further analysis
        %tData = tempData(end-patRec.sF*patRec.tW+1:end,:);  %Copy the temporal data to the test data
       
        % Add artifact if required
        if isfield(patRec,'addArtifact')
            timeLength=str2double(handles.et_timeOut.String);
            tempDataArt = AddArtifactRealtime(tempData,timeLength);
            tData = tempDataArt(end-patRec.sF*patRec.tW+1:end,:);
        else % Copy the temporal data to the test data
            tData = tempData(end-patRec.sF*patRec.tW+1:end,:);   
        end

        dataTW(:,:,nTW) = tData;                            % Save data for future analisys

        % Start of processing time
        procTimeTic = tic;
        
        % General routine for RealtimePatRec
        [outMov outVector patRec handles] = OneShotRealtimePatRec(tData, patRec, handles, thresholdGUIData);
        
        % Finish of processing time
        procTime(nTW) = toc(procTimeTic);
        
        %  Save the classifier prediction for statistics
        predictions{nTW} = outMov;
        
        % Is there a prediction different than "rest"?
        % This conditional considers that there is always a rest movement,
        % and this has the last index, therefore rest Indx = patRec.nOuts
        if isempty(selTimeTic)
            % Compare each outMov to rest
%            maskRest(1:size(outMov)) = patRec.nM;
            maskRest(1:size(outMov)) = patRec.nOuts;
            if sum(outMov ~= maskRest')
                selTimeTic = tic;   % Starts counting time for selection and completion
                fpTW = nTW;         % Consider the TW of the first moment
            end
        end
        
        % Is the output the expected classes?
        if isequal(patRec.movOutIdx{mIdx(m)}, outMov') 
            nCorrMov = nCorrMov + 1;
            if nCorrMov == 1;
                selTime = toc(selTimeTic)+patRec.tW+procTime(fpTW);
                selTimeTW = nTW-fpTW+1;
            elseif nCorrMov == nwCompTime;
                compTime = toc(selTimeTic)+patRec.tW+procTime(fpTW);
                compTimeTW = nTW-fpTW+1;
                set(handles.t_msgMT,'Visible','on');
                drawnow;
            end
        else % At least one movement is correct?
            for i = 1 : size(outMov,1)
                if find(patRec.movOutIdx{mIdx(m)} == outMov(i))
                    nCorrMov1 = nCorrMov1 + 1;
                    if nCorrMov1 == 1;
                        selTime1 = toc(selTimeTic)+patRec.tW+procTime(fpTW);
                        selTime1TW = nTW-fpTW+1;
                    elseif nCorrMov1 == nwCompTime;
                        compTime1 = toc(selTimeTic)+patRec.tW+procTime(fpTW);
                        compTime1TW = nTW-fpTW+1;
                    end
                    break; % Break the for
                end                
            end            
        end   
        
%         if ~isnan(compTime)
%             src.stop();
%             pause(1);
%         end
        % Next cycle
        nTW = nTW + 1;
    end
    
 end

