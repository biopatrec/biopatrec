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
% A TAC Test is performed using the VRE. It then uses the TacTestResult
% function to display the gathered data.
%
% The function is written in such a way that it requires the movement
% "rest" to run properly.
% --------------------------Updates--------------------------
% [Contributors are welcome to add their email]
% 2012-06-07 / Nichlas Sander   / Creation of TACTest
% 2012-08-08 / Nichlas Sander   / Data is saved in correct order.
% 2012-08-08 / Nichlas Sander   / Added calculations of path efficiency.
% 2012-10-05 / Joel Falk-Dahlin / Changed ApplyControl to work with new version
%                                 Removed InitControl since is perfomed
%                                 within the GUI
% 2012-10-05 / Joel Falk-Dahlin / Changed speed to be read from mainGUI
%                                 handles. This way TAC-test works the same
%                                 way as the realtime patRec. Changed so
%                                 the predicted movement is outputed to
%                                 mainGUI.
% 2012-10-26 / Joel Falk-Dahlin / Added ApplyProportionalControl
% 2012-11-23 / Joel Falk-Dahlin / Moved speeds to patRec from handles,
%                                 added a tracker to keep track of the state space position during TAC-test
%                                 trajectories can be plotted with
%                                 GUI_SSPresentation
%                                 Added ResetControl to make sure control
%                                 is reinitialized between trials
% 2013-06-10 / Nichlas Sander   / Changed the tracker used for state space
%                                 tracking to one that is not limited to
%                                 a set number of movements.
% 2015-02-02 / Enzo Mastinu     / All this function has been re-organizated
%                                 to be compatible with the functions
%                                 placed into COMM/AFE folder. For more
%                                 details read RecordingSession.m log.
% 2015-02-27 / Enzo Mastinu     / Fix some bugs with the custom devices TAC
%                                 test.
% 2015-12-04 / Francesco Clemente / Adding of SMC Test routines.
% 2016-12-09 / Jake Gusman      / Addition of overshoot metric 
% 2016-12-16 / Jake Gusman      / Addition of Distance input
%                                 Modifications to allow for randomization
%                                 of distance (D) and allowance (A).
%                                 Distance and allowance inputs can also
%                                 now be vectors.
% 2018-02-23/ James Austin      / Added window overlap as the cycletime for real time
%                                 pattern recognition implementation from
%                                 NI devices (replacing tWs for PEEK time).                                
% 2018-08-01 / Andreas Eiler        Adapted code to new function 'count' by
%                                   replacing variable count by count_rep
% 20xx-xx-xx / Author     / Comment on update                          



function success = TACTest(patRecX, handlesX)
    clear global;

    %global speed
    global time
    global patRec;    
    global handles;
    global tempData;

    global wantedMovementId;
    global tacComplete;
    global firstTacTime;
    global startTimer;
    global completionTime;
    global selectionTime;
    global selectionTimeA;
    global nTW;
    global recordedMovements;
    global thresholdGUIData
    
    global distance %FIX
    global overshoot
    global nOvershoot
    
    patRec = patRecX;
    handles = handlesX;
    
    % pDiv = 2; %Event is fired every TW/value milliseconds, ie 100ms if TW = 200ms & pDiv = 2.
    trials = str2double(get(handles.tb_trials,'String'));
    reps = str2double(get(handles.tb_repetitions,'String'));
    timeOut = str2double(get(handles.tb_executeTime,'String'));
    % allowance = str2double(get(handles.tb_allowance,'String'));
    A = str2num(get(handles.tb_allowance,'String'));
    D = str2num(get(handles.tb_distance,'String'));
    %speed = str2double(get(handles.tb_speed,'String'));
    time = str2double(get(handles.tb_time,'String'));

    pause on; %Enable pausing

    tacComplete = 0;
    firstTacTime = [];

    % Get needed info from patRec structure
    tacTest.patRec      = patRec;
    tacTest.sF          = patRec.sF;
    % tacTest.tW          = patRec.tW;
    tacTest.trials      = trials;
    tacTest.nR          = reps;
    tacTest.timeOut     = timeOut;

    sF                  = tacTest.sF;
    nCh                 = length(patRec.nCh);       
    ComPortType         = patRec.comm;
    deviceName          = patRec.dev;

    % Get sampling time
    sT = tacTest.timeOut;
    tW = patRec.tW;                                                            % Time window size
    tWs = tW*sF;                                                           % Time window samples
    oW = patRec.wOverlap;                                                  % Timestep length from window overlap
    oWs = oW*sF;                                                           % Overlap samples
    iW = tW-oW;
    iWs = floor(iW*sF);
    
    % Is threshold (thOut) used?
    if(isfield(patRec.patRecTrained,'thOut'))
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
            handles.patRecHandles.(s0) = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','normal','visible','on');
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

    %Initialise the control algorithm.
    %patRec = InitControl(patRec);  % No longer needed, initialization is performed inside the GUI

    % Start the test
    tempData = [];

    com = handles.vre_Com;

    %Sends a value to set the TAC hand to ON.
    if (handles.SMCtestEnabled)
        fwrite(com,sprintf('%c%c%c%c','c',char(8),char(1),char(0))); % run sTAC
        fread(com,1);
        fwrite(com,sprintf('%c%c%c%c','c',char(9),char(1),char(0))); % show green hand
        fread(com,1);
    else
        fwrite(com,sprintf('%c%c%c%c','c',char(2),char(1),char(0))); % run normal TAC
        fread(com,1);
    end

%     fwrite(com,sprintf('%c%c%c%c','c',char(3),char(allowance),char(0)));
%     fread(com,1);
% 
%     CurrentPosition('init',patRec,allowance, handles.movList);
%     TrackStateSpace('initialize',patRec,allowance); 
    
    %Run through all the trials
    for t = 1 : trials
        %Create a random order for the wanted movements.
        indexOrder = GetMovementCombination(handles.dofs,patRec.nOuts-1);
        tacTest.combinations = size(indexOrder,1);

        % randomize use of D and A
        rp = randperm(length(D));
        D = D(rp);
        A = A(rp);
            
        for r = 1 : reps
            set(handles.txt_status,'String',sprintf('Trial: %d , Rep: %d.',t,r));

            %Loop through all of the movements
            for i = 1 : size(indexOrder,1)
                completionTime = NaN;
                selectionTime = NaN;
                selectionTimeA = NaN;
                startTimer = [];
                recordedMovements = [];
                tacComplete = 0;
                nTW = 1;
                wantedMovementId = [];
                printName = '';
                nOvershoot = 0;

                if length(D) > 1
                    if ~exist('count_rep','var') || count_rep == reps
                        count_rep = 0;               % Reset count_rep when it reaches num of reps (end of the list of combos)
                    end                          % E.g. 3-DOFs --> 8 reps. 6 IDs. For each rep, loop runs through 6 IDs.
                                                 % Each subsequent task will
                                                 % have a new ID and new target
                                                 % location. Method ensures
                                                 % each combination of target
                                                 % and ID are presented.

                    count_rep = count_rep +1;

                    if i == 1                   % target location index (count_rep) is set to                                 
                        count_rep = r;             % the repetition number. That way, each target
                    end                          % direction will be presented at each ID.
                else
                    count_rep = 1;
                end
                distance = D(count_rep);
                allowance = A(count_rep);
              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % The following was moved down in order to allow for
            % randomization of movement and allowance/distance within each
            % repetition (Gusman 16/12/2016)
            fwrite(com,sprintf('%c%c%c%c','c',char(3),char(allowance),char(0)));   % moved down here to allow for new allowance per rep
            fread(com,1);
            
            CurrentPosition('init',patRec,allowance, handles.movList);
            TrackStateSpace('initialize',patRec,allowance);
            set(handles.txt_status,'String',sprintf('Trial: %d , Rep: %d.',t,r));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
                
                
                %Reset the TAC hand. Own function?
                fwrite(com,sprintf('%c%c%c%c','r','t',char(0),char(0)));
                fread(com,1);

                fwrite(com,sprintf('%c%c%c%c','r','1',char(0),char(0)));
                fread(com,1);

                %Get all random movements for this set of movements.
                index = indexOrder(i,:);

                set(handles.txt_status,'String','Wait!');
                pause(2);
                name = 'Wanted: ';
                
                %distance = randi(5,1) * 15 + 50;
                
                if (handles.SMCtestEnabled) % if SMC test (-> ONLY ONE DOF)
                    distance = randsample([20 30 40 50],1);
                    handles.SMCposition = 0;
                else
%                     distance = 40;
%                     distance = str2double(get(handles.tb_distance,'String'));
                end
                
                for j = 1:length(index)
                    movementIndex = patRec.movOutIdx{index(j)};
                    listOfMovements = handles.movList;
                    movement = listOfMovements(movementIndex);
                    name = strcat(name,movement.name,',');
                    printName = strcat(printName,upper(movement.name{1}(regexp(movement.name{1}, '\<.'))),',');
                    for temp_index = 1:distance
                        VREActivation(com, 1, [], movement.idVRE, movement.vreDir, 1);
                        if (handles.SMCtestEnabled) %&& (mod(temp_index,handles.SMCTargetStep) == 0)% if SMC test
                                % SMCtestMapPosToVib(handles, [], [], movement.vreDir, [],temp_index);
                                % pause(0.2);
                                SMCtestMapPosToVib(handles, [], [], movement.vreDir, [],temp_index);
                                pause(0.15);
                        end
                    end
                    if (handles.SMCtestEnabled)
                        pause(0.5);
                        fwrite(com,sprintf('%c%c%c%c','c',char(10),char(1),char(0))); % hide green hand
                        fread(com,1);
                    end
                    
                    wantedMovementId = [wantedMovementId; movementIndex];
                end
                %Remove the last comma. Other way of solving it?
                name{1}(end) = [];

                set(handles.txt_status,'String',name);

                CurrentPosition('target',index, distance);
                TrackStateSpace('target',index, distance); % ONLY WORKS IF DISTANCE IS THE SAME IN ALL DOFS


                % Reset the controller between trials
                patRec = ReInitControl(patRec);

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
                    lh = s.addlistener('DataAvailable', @TACTest_OneShot);

                    % Start DAQ
                    s.startBackground();                                               % Run in the backgroud

                    if ~s.IsDone                                                       % check if is done
                        s.wait();
                    end
%                     delete(lh);
                    if ~strcmp(deviceName, 'Thalmic MyoBand')
                        delete(lh);
                    end
                    %CK: Stop sampling from MyoBand
                    if strcmp(deviceName, 'Thalmic MyoBand')
                        MyoClient('StopSampling');
                    end
                    
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
                    handles.t_msg       = handles.txt_status;

                    % Connect the chosen device, it returns the connection object
                    obj = ConnectDevice(handles);

                    % Set the selected device and Start the acquisition
                    SetDeviceStartAcquisition(handles, obj);
                    handles.CommObj = obj;
                    handles.success = 0;
                    
                    for timeWindowNr = 1:(sT-oW)/iW
                        cData = Acquire_tWs(deviceName, obj, nCh, iWs);            % acquire a new time window of samples
                        acquireEvent.Data = cData;
                        TACTest_OneShot(0, acquireEvent);   
                        if handles.success
                            % if the previous movement was "success" we can
                            % stop this acquisition and pass to the next
                            break
                        end
                    end
                        % Stop acquisition
                        StopAcquisition(deviceName, obj);
                end


                test.recordedMovements = recordedMovements;
                test.completionTime = completionTime;
                test.selectionTime = selectionTime;
                test.selectionTimeA = selectionTimeA;

                %Record data, present it.
                test.fail = isnan(completionTime);

                test.allowance = allowance;
                test.distance = distance;
                test.nOvershoot = nOvershoot;

                if(test.fail)
                    test.pathEfficiency = NaN;
                else
                    %This is not used for path efficiency any longer
                    %test.pathEfficiency = TrackStateSpace('single');
                    test.pathEfficiency = CurrentPosition('get');
                end

                test.movement = listOfMovements(wantedMovementId);
                test.name = printName(1:end-1); %Use something else?

                %Save the data to the trialResult in each trial, repetitition
                %and movement.
                tacTest.trialResult(t,r,i) = test;

                tempData = [];
                if (handles.SMCtestEnabled) % show green hand for confirmation
                    fwrite(com,sprintf('%c%c%c%c','c',char(9),char(1),char(0)));
                    fread(com,1);
                    pause(1);
                end
                
            end
        end
    end

    tacTest.ssTracker = TrackStateSpace('read');

    % Save test
    [filename, pathname] = uiputfile({'*.mat','MAT-files (*.mat)'},'Save as', 'Untitled.mat');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
        save([pathname,filename],'tacTest');    
    end

    %Display results
    tacTest = TacTestResults(tacTest);
end



function TACTest_OneShot(src,event)
    pTime = tic;
    global patRec;
    global handles;
    global nTW;     % Number of time windows evaluated
    global fpTW;    % First time window with any movement.
    global dataTW;  % Raw data from each time windows
    global tempData;
    %global speed;
    global time;

    global wantedMovement;
    global wantedMovementId;

    global completionTime;
    global selectionTime;
    global selectionTimeA;
    global tacComplete;
    global processingTime;
    global firstTacTime;
    global startTimer;
    global recordedMovements;
    global thresholdGUIData
    
    global distance %FIX
    global overshoot
    global nOvershoot

    tempData = [tempData; event.Data];

    if size(tempData,1) >= (patRec.sF * patRec.tW)
        tData = tempData(end-patRec.sF*patRec.tW+1:end,:);  %Copy the temporal data to the test data
        dataTW(:,:,nTW) = tData;                            % Save data for future analisys

        %Start counting processing time
        processingTimeTic = tic;

        % General routine for RealtimePatRec
        [outMov, outVector, patRec, handles.patRecHandles] = OneShotRealtimePatRec(tData, patRec, handles.patRecHandles, thresholdGUIData);
        TrackStateSpace('move',outMov, patRec.control.currentDegPerMov);
        CurrentPosition('move',outMov, patRec.control.currentDegPerMov);

        
    %     %Signal processing
    %     tSet = SignalProcessing_RealtimePatRec(tData, patRec);
    % 
    %     % Only predict when signal is over floor noise?
    %     meanFeature1 = mean(tSet(1:size(patRec.nCh,2)));
    %     if meanFeature1 < (patRec.floorNoise(1)/1)
    %         outMov = patRec.nOuts;
    %         outVector = zeros(patRec.nOuts,1);
    %     else
    %         % One shoot PatRec
    %         [outMov, outVector] = OneShotPatRecClassifier(patRec, tSet);
    %         if outMov == 0
    %             outMov = patRec.nOuts;
    %         end
    %     end    
    % 
    %     
    %     % Apply Proportional control
    %     handles = 1ApplyProportionalControl(tData,patRec,handles);
    %     
    %     %Apply control algorithms.
    %     [patRec, outMov, handles] = ApplyControl(patRec, outMov, outVector, handles);
    %     
    %     % Update MainGUI to show outputed Mov
    %     set(handles.patRecHandles.lb_movements,'Value',outMov);
    %     drawnow;

         processingTime(nTW) = toc(processingTimeTic);
        %Apply Majority Vote filtering of movements
        %[patRec outMov] = MajorityVote(patRec,outMov);

        %Check whether to start timer for completionTime and selectionTime.
        if isempty(startTimer) && isempty(find(outMov == patRec.nM))
            startTimer = tic;
            fpTW = nTW;
        end
        %Ensure that on movement or recording of time is done after the TAC has
        %completed.

        if ~tacComplete
            %Get movement from the list of movements.
            movement = handles.movList(outMov);
            speed = patRec.control.currentDegPerMov(outMov);

            %Temporary time 
            if ~isempty(startTimer)
                tempTime = toc(startTimer);
                if isnan(selectionTime) && sum(ismember(outMov,wantedMovementId))
                    selectionTime = tempTime+patRec.tW+processingTime(fpTW);
                end

                if isnan(selectionTimeA) && sum(ismember(wantedMovementId, outMov))
                    selectionTimeA = tempTime+patRec.tW+processingTime(fpTW);
                end
                
                
            end
            %Only add the recorded movement if we are not yet done.

            if(length(movement)>1)
                name = movement(1).name;
                for i = 2:length(movement)
                    name = strcat(name,',',movement(i).name);
                end
            else
                name = movement.name;
            end
            set(handles.txt_status2,'String',name);

            performedMovements = [];

            for i = 1:length(outMov)
                performedMovements = [performedMovements, {movement(i), speed(i)}];
                dof = movement(i).idVRE;
                dir = movement(i).vreDir;
                
                if (handles.SMCtestEnabled) % if SMC test
                    handles.SMCposition = SMCtestMapPosToVib(handles, wantedMovementId(1), dof, dir, speed(i), []);
                end
                
                if (VREActivation(handles.vre_Com,speed(i),[],dof,dir,0))
                    if (isempty(firstTacTime))
                       firstTacTime = tic;
                       overshoot = 1;
                    else
                        heldTime = toc(firstTacTime);
                        if(heldTime > time)
                            set(handles.txt_status2,'String','Movement Completed!');
                            completionTime = toc(startTimer);
                            completionTime = completionTime - time;
                            tacComplete = 1;
                            
                            %Stop the acquisition and move on to the next movement.
                            if strcmp (patRec.comm, 'NI')
                                src.stop(); 
                            else
                                handles.success = 1;
                            end
                            %Pause 1 second once the movement is completed.
                            pause(1);
                            %This means that the TAC-test is completed. This value
                            %is set so no more motion is completed. 
                        else
                            set(handles.txt_status2,'String',sprintf('Movement reached. Hold for %0.02f more seconds.',time-heldTime));
                        end
                    end
                else
                    firstTacTime = [];
                    % overshoot count_reper
                    if overshoot == 1
                        nOvershoot = nOvershoot + 1;
                    end
                    overshoot = 0;
                end
            end
            recordedMovements = [recordedMovements; {performedMovements}];
        end
        nTW = nTW + 1;
    end
end
