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
% 2012-01-xx / Max Ortiz  / Creation from MotionTestLegacy
% 2012-05-29 / Max Ortiz  / Addition of "clear" commands
% 2012-07-24 / Max Ortiz  / Use fpTW to compute the predition time of the
%                           first prediction in order to calculate the selection time
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
pDiv    = 4;        % Peeking devider
trials  = str2double(get(handles.et_trials,'String'));
nR      = str2double(get(handles.et_nR,'String'));
timeOut = str2double(get(handles.et_timeOut,'String'));
nwCompTime = 20;    % Number of windows to consider completion time
pause on;   % Enable pauses

%% Is the VRE selected?
if isfield(handles,'cb_VRE') %&& ~isfield(handles,'com')
    vreCoupling = get(handles.cb_VRE,'Value');    
else
    vreCoupling = 0;
end

%% Is there an option for coupling with the motors?
if isfield(handles,'cb_motorCoupling') %&& ~isfield(handles,'com')
    motorCoupling = get(handles.cb_motorCoupling,'Value');    
else
    motorCoupling = 0;
end

%% Init motionTest structure
motionTest.patRec   = patRec;
motionTest.sF       = patRec.sF;
motionTest.tW       = patRec.tW;
motionTest.trails   = trials;
motionTest.nR       = nR;
motionTest.timeOut  = timeOut;

%% Initialize DAQ card
% Note: A function for DAQ selection will be required when more cards are
% added

if strcmp(patRec.dev,'ADH')
    
else % at this poin everything else is SBI (e.g.NI-USB6009)
    chAI = zeros(1,8);
    chAI(patRec.nCh) = 1;
    % create the SBI
    s = InitSBI_NI(patRec.sF,timeOut,chAI);
    % Change the peek time
    s.NotifyWhenDataAvailableExceeds = (patRec.sF*patRec.tW)/pDiv; % Max 0.05, or 20 times per second
    %Add listener
    lh = s.addlistener('DataAvailable', @MotionTest_OneShot);
    %Test the DAQ by ploting the data
    %lh = s.addlistener('DataAvailable', @plotDataTest);
end

%% Motion Test
% Note: Probabily this way of testing only works for the NI
% specific funtions per card might be required.

% run over all the trails
for t = 1 : trials
    
    for i = 1 : 5;
        msg = ['Trial: "' num2str(t) '" in: ' num2str(6-i) ' seconds'];
        set(handles.t_msg,'String',msg);
        pause(1);
    end
    
    % repite the movement the chosen times
    for r = 1 : nR
        % Randomize the aperance of the requested movement
        mIdx = randperm(patRec.nM - 1); % It doesn't include "rest"
        % Run over all movements but "rest"
        for m = 1 : patRec.nM - 1
            
            %Select movement
            mov = patRec.mov{mIdx(m)};    
            %Prepare
            for i = 1 : 3;
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
            predictions = [];   % Vector with the classifier prediction per tw
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

            % Ask the user to execute movement
            set(handles.t_msg,'String',mov);
            drawnow;
            %% Start test
            s.startBackground();  % Start the data acquision for timeOut seconds        
            
            %selTimeTic = tic;    % Start counting after user instruction,
                                  % which might not be as preciase as start counting just after a
                                  % movement is predicted.
            
            % Wait until it has finished done
            %s.IsDone  % will report 0    
            s.wait(); % rather than while    
            %s.IsDone  % will report 1
            
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
                
                %Don't count acc in failed trials
                test.acc = NaN;
                
            else
                corrP = sum(predictions(fpTW:fpTW+compTimeTW-1) == mIdx(m));
                test.acc = corrP / compTimeTW; % compTimeTW considers already the removal of fpTW           
            end
            
            disp(test);
            motionTest.test(r,mIdx(m),t)  = test;
            delete(pic); 
            set(handles.t_msgMT,'Visible','off');
            drawnow;            
        end
    end
end

%Delete listener SBI
delete (lh)
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
        tData = tempData(end-patRec.sF*patRec.tW+1:end,:);  %Copy the temporal data to the test data
        dataTW(:,:,nTW) = tData;                            % Save data for future analisys

        % Start of processing time
        procTimeTic = tic;
        
        %Signal processing
        tSet = SignalProcessing_RealtimePatRec(tData, patRec);

        % One shoot PatRec
        outMov = OneShotPatRecClassifier(patRec, tSet);

        % Finish of processing time
        procTime(nTW) = toc(procTimeTic);
        
        %  Save the classifier prediction for statistics
        predictions(nTW) = outMov;
        
        % Is there a prediction different than "rest"?
        % This conditional considers that there is always a rest movement,
        % and this has the last index, therefore rest = nM
        if isempty(selTimeTic) && outMov ~= patRec.nM             
            selTimeTic = tic;   % Starts counting time for selection and completion
            fpTW = nTW;         % Consider the TW of the first moment
        end
        
        % Show results in the GUI
        set(handles.lb_movements,'Value',outMov);
        drawnow;

        % The following routine is a bit more "complicated" than what you
        % might expect since it considers the case of simultaneous control
        nExpMov = size (patRec.movOutIdx{mIdx(m)},2); % Number of expected mov
        % Compare the expected movement with the actual prediction
        if nExpMov >= size(outMov,2)
            % Number of expected movements that are correct
            nExpMovCorr = sum(patRec.movOutIdx{mIdx(m)} == outMov); 
            % Are all expected movements correct?
            if nExpMovCorr == nExpMov;
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
            % At least one is correct
            % this case is mostly applicable for simultaneous predictions
            elseif nExpMovCorr >= 1
                nCorrMov1 = nCorrMov1 + 1;
                if nCorrMov1 == 1;
                    selTime1 = toc(selTimeTic)+patRec.tW+procTime(fpTW);
                    selTime1TW = nTW-fpTW+1;
                elseif nCorrMov1 == nwCompTime;
                    compTime1 = toc(selTimeTic)+patRec.tW+procTime(fpTW);
                    compTime1TW = nTW-fpTW+1;
                end                                
            end            
        % If the expected movements are less than the predicted movements
        % in other words if more movements were predicted than expected
        else 
            % Check all the predicted movements to see if at least one
            % correct
            for i = 1 : size(outMov,2)
                if patRec.movOutIdx{mIdx(m)} == outMov(i)
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

        % Send vector to the motors
%         if motorCoupling
%             ActivateMotors(handles.com, pwmIDs, pwmAs, pwmBs, outMov);
%         end
% 
%         if vreCoupling
%             dof = round(outMov/2);
%             dofs = [9,7,8];
%             if dof == 2
%                 dir = mod(outMov+1,2);            
%             else
%                 dir = mod(outMov,2);
%             end
%             
%             VREActivation(handles.vre_Com, 20, 0.6, dofs(dof), dir, 0) 
%         end

        % Next cycle
        nTW = nTW + 1;
    end
    
 end

