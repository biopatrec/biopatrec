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
% 2012-06-07 / Nichlas Sander  / Creation of TACTest

function success = TACTest(patRecX, handlesX)
clear global;

global speed
global time
global patRec;    
global handles;
global tempData;

global wantedMovement;
global tacComplete;
global firstTacTime;
global startTimer;
global completionTime;
global selectionTime;
global nTW;
global recordedMovements;


patRec = patRecX;
handles = handlesX;
pDiv = 4;
trials = str2double(get(handles.tb_trials,'String'));
reps = str2double(get(handles.tb_repetitions,'String'));
timeOut = str2double(get(handles.tb_executeTime,'String'));
allowance = str2double(get(handles.tb_allowance,'String'));
speed = str2double(get(handles.tb_speed,'String'));
time = str2double(get(handles.tb_time,'String'));

pause on; %Enable pausing

tacComplete = 0;
firstTacTime = [];

tacTest.patRec = patRec;
tacTest.sF = patRec.sF;
tacTest.tW = patRec.tW;
tacTest.trials   = trials;
tacTest.nR       = reps;
tacTest.timeOut  = timeOut;

% Initialize DAQ card
% Note: A function for DAQ selection will be required when more cards are
% added
if strcmp(patRec.dev,'ADH')
    
else % at this point everything else is SBI (e.g.NI-USB6009)
    chAI = zeros(1,8);
    chAI(patRec.nCh) = 1;
    % create the SBI
    s = InitSBI_NI(patRec.sF,timeOut,chAI);
    % Change the peek time
    s.NotifyWhenDataAvailableExceeds = (patRec.sF*patRec.tW)/pDiv; % Max 0.05, or 20 times per second
    %Add listener
    lh = s.addlistener('DataAvailable', @TACTest_OneShot);
    %Test the DAQ by ploting the data
    %lh = s.addlistener('DataAvailable', @plotDataTest);
end

%Initialise the control algorithm.
patRec = InitControl(patRec);

% Start the test
tempData = [];

com = handles.vre_Com;

%Sends a value to set the TAC hand to ON.
fwrite(com,sprintf('%c%c%c%c','c',char(2),char(1),char(0)));
fread(com,1);

fwrite(com,sprintf('%c%c%c%c','c',char(3),char(allowance),char(0)));
fread(com,1);

%Run through all the trials
for t = 1 : trials
    %Create a random order for the wanted movements.
    indexOrder = randperm(patRec.nM -1);    
    for r = 1 : reps
        set(handles.txt_status,'String',sprintf('Trial: %d , Rep: %d.',t,r));
  
        for i = 1 : length(indexOrder)
            completionTime = NaN;
            selectionTime = NaN;
            startTimer = [];
            recordedMovements = [];
            tacComplete = 0;
            nTW = 1;
            distance = randi(5,1) * 15 + 50;
            movementIndex = patRec.movOutIdx{indexOrder(i)};
            listOfMovements = handles.movList;
            movement = listOfMovements(movementIndex)
            wantedMovement = movement;
            %Reset the TAC hand. Own function?
            fwrite(com,sprintf('%c%c%c%c','r','t',char(0),char(0)));
            fread(com,1);
            
            fwrite(com,sprintf('%c%c%c%c','r','1',char(0),char(0)));
            fread(com,1);
            

            set(handles.txt_status,'String','Wait!');
            pause(2);
            
            VREActivation(com, distance, [], movement.idVRE, movement.vreDir, 1);
            
            %Here the movement of the user is to come in. Wait for the
            %listener to finish.
            set(handles.txt_status,'String',strcat('Wanted',': ',movement.name));
            
            %Start the listener, to allow for movements.
            s.startBackground();
            %Wait until the background firing is finished.
            s.wait();
            
            %Save all the data.
            if ~isempty(recordedMovements)
                test.acc = length(find(movement.vreDir == recordedMovements(find(recordedMovements(:,1) == movement.idVRE),2)));
                test.acc = test.acc / length(recordedMovements);
            end
            
            test.completionTime = completionTime;
            test.selectionTime = selectionTime;
            
            %Record data, present it.
            test.fail = isnan(completionTime);
            test.movement = movement;
            
            %Save the data to the trialResult in each trial, repetitition
            %and movement.
            tacTest.trialResult(t,r,i) = test;
        end
    end
end
tacTest = TacTestResults(tacTest);

% Save test
[filename, pathname] = uiputfile({'*.mat','MAT-files (*.mat)'},'Save as', 'Untitled.mat');
if isequal(filename,0) || isequal(pathname,0)
   disp('User pressed cancel')
else
    save([pathname,filename],'tacTest');    
end
end

function TACTest_OneShot(src,event)   
global patRec;
global handles;
global nTW;     % Number of time windows evaluated
global fpTW;    % First time window with any movement.
global dataTW;  % Raw data from each time windows
global tempData;
global speed;
global time;

global wantedMovement;

global completionTime;
global selectionTime;
global tacComplete;
global processingTime;
global firstTacTime;
global startTimer;
global recordedMovements;
    
tempData = [tempData; event.Data];

if size(tempData,1) >= (patRec.sF * patRec.tW)
     tData = tempData(end-patRec.sF*patRec.tW+1:end,:);  %Copy the temporal data to the test data
     dataTW(:,:,nTW) = tData;                            % Save data for future analisys
    
     %Start counting processing time
     processingTimeTic = tic;
     
    %Signal processing
    tSet = SignalProcessing_RealtimePatRec(tData, patRec);

    % One shoot PatRec
    outMov = OneShotPatRecClassifier(patRec, tSet);
    
    %Apply control algorithms.
    [patRec outMov] = ApplyControl(patRec, outMov);
    
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
        if isnan(selectionTime) && (movement.idVRE == wantedMovement.idVRE && movement.vreDir == wantedMovement.vreDir)
            selectionTime = toc(startTimer)+patRec.tW+processingTime(fpTW);
        end
        %Only add the recorded movement if we are not yet done.
        recordedMovements = [recordedMovements; movement.idVRE, movement.vreDir];
        dof = movement.idVRE;
        dir = movement.vreDir;
        
        if(length(movement)>1)
            name = movement(1).name;
            for i = 2:length(movement)
                name = strcat(name,',',movement(i).name);
            end
        else
            name = movement.name;
        end
        set(handles.txt_status2,'String',name);
        if (VREActivation(handles.vre_Com,speed,[],dof,dir,0))
            if (isempty(firstTacTime))
               firstTacTime = tic; 
            else
                heldTime = toc(firstTacTime);
                if(heldTime > time)
                    set(handles.txt_status2,'String','Movement Completed!');
                    completionTime = toc(startTimer);
                    completionTime = completionTime - time;
                    tacComplete = 1;
                    %Pause 1 second once the movement is completed.
                    pause(1);
                    %Stop the acquisition and move on to the next movement.
                    %src.stop();
                    %This means that the TAC-test is completed. This value
                    %is set so no more motion is completed.            
                else
                    set(handles.txt_status2,'String',sprintf('Movement reached. Hold for %0.02f more seconds.',time-heldTime));
                end
            end
        else
            firstTacTime = [];
        end
    end
    nTW = nTW + 1;
end

end