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
% Fitts' Law Test for the evaluation of real-time performance of the patRec
% This test is implemented in such a way that the "rest" movement is
% required.
%comn
%  
%
%
% --------------------------Updates--------------------------
% [Contributors are welcome to add their email]
% 2016-10-07 / Jake Gusman        / Creation                             
% 2016-11-17 / Jake Gusman        / Changed speed to be read from mainGUI
%                                   handles.
% 2016-11-28 / Jake Gusman        / Added distance option "Per DOF".
%                                   Restricts target locations to those
%                                   with equal x, y, and r distance.
%                                   Repetitions defined by number of target
%                                   locations (2 for 1-DOF, 4 for 2-DOF, or
%                                   8 for 3-DOF).
% 2018-08-01 / Andreas Eiler        Adapted code to new function 'count' by
%                                   replacing variable count by count_rep
% 20xx-xx-xx / Author  / Comment on update


function fittsTest = FittsLawTest(patRecX, handlesX)

clear global;

global patRec;
global handles;
global nTW;             % Number of time windows evaluated
global fpTW;     % Time window of the first prediction
global dataTW;          % Raw data from each time windows
global tempData;        % Reset tempData if it is the first call
% global motorCoupling;
% global vreCoupling; 
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
% global mIdx;
% global m;
global target1
global target2
global anim
global x y r xt yt rt
global dwellTime;   % Time (s) how long cursor needs to match target to be correct
global dwelltWs     % number of time windows until success
global success
global speed        % distance units travelled per decision
global tdist
global overshoot
global nOvershoot   % count_reps the number of times target is acquired then lost
global targetWidth   % indicates the allowable margin of error (in all dimensions) permitted to be considered success
global expand
global shrink
global right
global left
global up
global down
global selDist     % Distance travelled before initial selection
global nM
global axeslim
global p
global guidepoint


%% Init variable
patRec  = patRecX;
handles = handlesX;

trials  = str2double(get(handles.et_trials,'String'));
nR  = str2double(get(handles.et_nR,'String'));
timeOut = str2double(get(handles.et_timeOut,'String'));
nwCompTime = 20;    % Number of windows to consider completion time
tW = patRec.tW;                                                 % Time window size
iW = patRec.wOverlap                                                     % Increment window size
oW = tW-iW;                                           % Overlap window size
dwellTime = str2double(get(handles.et_dwellTime,'String'));
dwelltWs = dwellTime/iW;                                 % number of time windows until success
pause on;   % Enable pauses
expand = get(handles.pm_expand,'Value');
shrink = get(handles.pm_shrink,'Value');
right = get(handles.pm_right,'Value');
left = get(handles.pm_left,'Value');
up = get(handles.pm_up,'Value');
down = get(handles.pm_down,'Value');
directions = [expand shrink right left up down];
disttype = get(handles.pm_distance,'Value');
nM = patRec.nM;
targetDOF = get(handles.pm_targetDOF,'Value');

D = str2num(get(handles.et_tDistances,'String')); % Possible Target Distances
W = str2num(get(handles.et_tWidths,'String')); % Possible Target 'Widths'

nIDs = length(D);           % Number of IDs being tested

    % Is threshold (thOut) used?
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

%% Init fittsTest structure
fittsTest.patRec   = patRec;
fittsTest.sF       = patRec.sF;
fittsTest.trials   = trials;
fittsTest.timeOut  = timeOut;
fittsTest.nR       = nR;     % number of repetitions
fittsTest.nIDs     = nIDs;    % number of Idexes of Difficulty

sF                  = fittsTest.sF;
nCh                 = length(patRec.nCh);       
ComPortType         = patRec.comm;
deviceName          = patRec.dev;

% Get sampling time
sT = fittsTest.timeOut;
% tW = patRec.tW;                                                           % Time window size
tWs = tW*sF; 
iWs = floor(iW*sF);

%% Fitts Law Test

axes(handles.ax_game);
cla;

% run over all the trials
for t = 1 : trials
       
    for j = 1 : 5;
        message = ['Trial: "' num2str(t) '" in: ' num2str(6-j) ' seconds'];
        set(handles.t_msg,'String',message);
        pause(1);
    end
    
    %%%
    if disttype == 2

        if [right, left] ~= nM
            DOF_x = 1;
        else
            DOF_x = 0;
        end
        if [up, down] ~= nM
            DOF_y = 1;
        else
            DOF_y = 0;
        end
        if [expand,shrink] ~= nM
            DOF_r = 1;
        else
            DOF_r = 0;
        end
        DOFs = [DOF_x, DOF_y, DOF_r];
        
        [combo, nCombo] = ComboXYR(DOFs,targetDOF);
        
        nR = nCombo;  % set number of repetitions to number of combos
    end

    for rep = 1:nR 
        % randomize use of D and W
        rp = randperm(length(D));
        D = D(rp);
        W = W(rp);
        for ID = 1:nIDs
            set(handles.t_msg,'String','Wait');
            
            message = ['Trial: ' num2str(t) ' | Task: ' num2str((rep-1)*nIDs+ID) ''];
            set(handles.t_msg,'String',message);
            
            % initial cursor position
            x = 0; y = 0; r = 51;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            p = linspace(0,2*pi);
            anim = plot(x+r*cos(p),y+r*sin(p));
            anim.LineWidth = 1.5;
            hold on
            guidepoint = plot(x,y,'*b');
            hold off
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            xi = x; yi = y; ri = r;    % save initial position values
            set(handles.ax_game,'XTick',[]);
            set(handles.ax_game,'XTickLabel','');
            set(handles.ax_game,'YTick',[]);
            set(handles.ax_game,'YTickLabel','');
            axeslim = [-175 175 -175 175];
            xlim([axeslim(1) axeslim(2)]); ylim([axeslim(3) axeslim(4)]);
            
            hold on
            
           targetDist = D(ID);
           targetWidth = W(ID);
            
           %% Target Randomization
           
           
            % Euclidean Distance:
            % Randomize the target location such that the target distance
            % remains constant: targetDist^2 =
            % sqrt((xt-xi)^2+(yt-yi)^2+(rt-ri)^2). Also need to make sure
            % that if a certain DOF is not assigned an input movement, the
            % target coordinate along that DOF is the same as initial.     
            
            if disttype == 3       % Euclidean Distance, random location   
            
                [xt,yt,rt] = FLT_EuclidDist(directions,targetDist,xi,yi,ri);
            
            
            elseif disttype == 2
                if ~exist('count_rep_rep','var') || count_rep == nR
                    count_rep = 0;           % Reset count_rep when it reaches num of reps (end of the list of combos)
                end                          % E.g. 3-DOFs --> 8 reps. 6 IDs. For each rep, loop runs through 6 IDs.
                                             % Each subsequent task will
                                             % have a new ID and new target
                                             % location. Method ensures
                                             % each combination of target
                                             % and ID are presented.
                
                count_rep = count_rep +1;
                
                if ID == 1                   % target location index (count_rep) is set to                                 
                    count_rep = rep;             % the repetition number. That way, each target
                end                          % direction will be presented at each ID.
                xt = xi + combo(count_rep,1).*targetDist;
                yt = yi + combo(count_rep,2).*targetDist;
                rt = ri + combo(count_rep,3).*targetDist;
              
            end
            
            
            % fix for in case target radius becomes negative: adjust starting
            % radius to make target radius positive
                if rt < 0 
                    rt= rt+50;
                    anim.XData = ((ri+50)/ri).*anim.XData;
                    anim.YData = ((ri+50)/ri).*anim.YData;
                    ri = ri+50;
                    r = ri;
                end
                
           hold on
            target1 = fill(xt+(rt+targetWidth/2)*cos(p),yt+(rt+targetWidth/2)*sin(p),'r');
            target2 = fill(xt+(rt-targetWidth/2)*cos(p),yt+(rt-targetWidth/2)*sin(p),'w');
            plot(xt,yt,'*r');
          
pause(2)

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

            success = 0;
            overshoot = 0;
            nOvershoot = 0;
            tdist = 0;

            % Reset the controller between trials
            patRec = ReInitControl(patRec);
            
            
            cData = zeros(iWs,nCh);
            if strcmp (ComPortType, 'NI')                                          % Fitts Law Test not yet tested for this type of input

                % Init SBI
                sCh = 1:nCh;
                s = InitSBI_NI(sF,sT,sCh); 
                s.NotifyWhenDataAvailableExceeds = iWs;   %change to toverlap                         % PEEK time
                lh = s.addlistener('DataAvailable', @FittsLawTest_OneShot); 

                % Start DAQ
                s.startBackground();                                               % Run in the backgroud

                if ~s.IsDone                                                       % check if is done
                    s.wait();
                end
                delete(lh);

            %%%%% Fitts Law Test with other custom device %%%%%   
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

                
                for timeWindowNr = 1:(sT-oW)/iW
                    cData = Acquire_tWs(deviceName, obj, nCh, iWs);         % acquire a new time window of samples
                    acquireEvent.Data = cData;
                    FittsLawTest_OneShot(0, acquireEvent);

                    if success == dwelltWs
                        set(handles.t_msg,'String','Target Achieved!');
                        drawnow;
                        pause(1);
                        break
                    end
                end

                % Stop acquisition
                StopAcquisition(deviceName, obj);
            end
            %% Save data
        %    test.mov                    = mov;
            test.nTW                    = nTW-1;
            test.fpTW                   = fpTW;
        %     test.nCorrMov               = nCorrMov;
            test.predictions            = predictions;
            test.selTime                = selTime;
            test.selTimeTW              = selTimeTW;
            test.compTime               = compTime;
            test.compTimeTW             = compTimeTW;
        %     % Performance for at least 1 movement
        %     test.nCorrMov1              = nCorrMov1;
        %     test.selTime1               = selTime1;
        %     test.selTime1TW             = selTime1TW;
        %     test.compTime1              = compTime1;
        %     test.compTime1TW            = compTime1TW;
            % Data
            test.dataTW                 = dataTW;
            test.procTime               = mean(procTime);  
            test.trialNum               = t;
            test.distanceTraveled       = tdist;
            test.initialXYR             = [xi,yi,ri];
            test.targetXYR              = [xt,yt,rt];
            test.dwellTime              = dwellTime;
            test.nOvershoot             = nOvershoot;
            test.targetWidth             = targetWidth;
            test.targetDistance         = targetDist;
%             test.indDiff                 = ID;
            test.selDist                = selDist;
            test.targetDOF             = targetDOF;
            
            % Test fail?
            if isnan(compTime)
                test.fail = 1;
            else
                test.fail = 0;
            end

        %     % Compute accuracy between fpTw to achivement of compTime
        %     if test.fail
        %         % Consider the accuracy during fail trials
        %         %corrP = sum(predictions == mIdx(m));
        %         %test.acc = corrP / size(predictions,2);   
        % 
        %         %Don't acount_rep for acc in failed trials
        %         test.acc = NaN;
        % 
        %     else
        %         corrP = 0;
        %         for i = fpTW : compTimeTW+fpTW-1
        %             if isequal(predictions{i},patRec.movOutIdx{mIdx(m)}')
        %                 corrP = corrP +1; 
        %             end
        %         end
        %         %corrP = sum(predictions{fpTW:fpTW+compTimeTW-1} == mIdx(m)); %It doesn't work for simultaneous prediction               
        %         test.acc = corrP / compTimeTW;            
        %     end

            disp(test);
            fittsTest.test(rp(ID),rep,t)  = test;         % rp(ID) puts in order of ID set   
        end
    end
end


% Saved any modification to patRec
fittsTest.patRec   = patRec;

pause off;

fittsTest.distance = D; % save distance and width values.. Order may be different
fittsTest.width = W;
fittsTest.dwellTime              = dwellTime;
% organize and save performance metrics
fittsTest = FittsTestMetrics(fittsTest);  

% Save test
disp(fittsTest);
[filename, pathname] = uiputfile({'*.mat','MAT-files (*.mat)'},'Save as', 'Untitled.mat');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
        save([pathname,filename],'fittsTest');    
    end
    
end



function FittsLawTest_OneShot(src,event)

    % General 
    global patRec;
    global handles;
    global nTW;     % Number of time windows evaluated
    global fpTW;     % Time window of the first prediction
    global dataTW;  % Raw data from each time windows
    global tempData;
	global thresholdGUIData;
    
    % Time markers
    global selTimeTic;
    % Key performance indicators
    global procTime;    
%     global nCorrMov;
     global selTime     % Selection time
%     global selTimeTW;   
     global compTime;    % Completion time
     global compTimeTW;
%     global nwCompTime;  % Number of time windows to consider completion time
    global predictions;
%     % Key performance indicators for at least one movement
%     global nCorrMov1;   % Number of at least 1 correct number
%     global selTime1;    % Selection time (selected = at leas 1 expected mov)
%     global selTime1TW;   
%     global compTime1;   % Completion time (selected = at leas 1 expected mov)
%     global compTime1TW;
%     % Variables to keep track of testing movement
%     global mIdx;
%     global m;
    global x y r xt yt rt
    global anim
    global tdist        % distance traveled by the cursor during trial
    global speed        % distance units travelled per decision
    global success
    global overshoot
    global nOvershoot   % count_reps the number of times target is acquired then lost (overshot)
    global dwelltWs
    global targetWidth
    global expand
    global shrink
    global right
    global left
    global up
    global down
    global target1
    global target2
    global selDist
    global nM
    global axeslim
    global p
    global guidepoint

    tempData = [tempData; event.Data];  % Record all signal
    
    % Is there enough data for a TW?
    if size(tempData,1) >= (patRec.sF*patRec.tW) 
        
        % Add artifact if required
        if isfield(patRec,'addArtifact')
            timeLength=str2double(handles.et_timeOut.String);
            tempDataArt = AddArtifactRealtime(tempData,timeLength);
            tData = tempDataArt(end-patRec.sF*patRec.tW+1:end,:);
        else % Copy the temporal data to the test data
            tData = tempData(end-patRec.sF*patRec.tW+1:end,:);   
        end

        dataTW(:,:,nTW) = tData;                            % Save data for future analysis
    
        % Start of processing time
        procTimeTic = tic;
        
        % General routine for RealtimePatRec
        [outMov outVector patRec handles.patRecHandles] = OneShotRealtimePatRec(tData, patRec, handles.patRecHandles, thresholdGUIData);
        
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
%             maskRest(1:size(outMov)) = patRec.nOuts;
%             if sum(outMov ~= maskRest')
                selTimeTic = tic;   % Starts count_reping time for selection and completion
                fpTW = nTW;         % Consider the TW of the first moment
%             end
        end
    
   speeds = patRec.control.currentDegPerMov;
   speed = speeds(outMov);
        
 %%%%%%%%% ****************** %%%%%%%%%%%%   
         if outMov ~= nM
             if outMov == expand          % open
                 if r < axeslim(2)
                     %             r = r+speed;
                     %             anim.MarkerSize = r;
                     anim.XData = anim.XData + speed*cos(p);
                     anim.YData = anim.YData + speed*sin(p);
                     r = r+speed;
                     tdist = tdist + speed;
                 end
             elseif outMov == shrink      % close
                 if r > 1
                     %             r = r-speed;
                     %             anim.MarkerSize = r;
                     anim.XData = anim.XData - speed*cos(p);
                     anim.YData = anim.YData - speed*sin(p);
                     r = r-speed;
                     tdist = tdist + speed;
                 end
             elseif outMov == left      % flex --> left
                 if x > axeslim(1)
             
                     x = x-speed;
                     %             anim.XData = x;
                     anim.XData = anim.XData - speed;
                     tdist = tdist + speed;
                 end
             elseif outMov == right      % extend --> right
                 if x < axeslim(2)
                     x = x+speed;
                     %             anim.XData = x;
                     anim.XData = anim.XData + speed;
                     tdist = tdist + speed;
                 end
             elseif outMov == down      % pronation --> down
                 if y > axeslim(3)
                     y = y-speed;
                     %             anim.YData = y;
                     anim.YData = anim.YData - speed;
                     tdist = tdist + speed;
                 end
             elseif outMov == up      % supination --> up
                 if y < axeslim(4)
                     y = y+speed;
                     %             anim.YData = y;
                     anim.YData = anim.YData + speed;
                     tdist = tdist + speed;
                 end
             end
             
             guidepoint.XData = x;
             guidepoint.YData = y;
             
             % pause(0.001)
             drawnow
         end

         % Is cursor within target range?
         if [([x,y,r] <= [xt,yt,rt] + targetWidth/2), ([x,y,r] >= [xt,yt,rt] - targetWidth/2)]
             if success == 0
                              selTime = toc(selTimeTic)+patRec.tW+procTime(fpTW); % log the
                 %             selection time
                 selDist = tdist;   % total distance traveled before initial selection of target
             end
             success = success + 1;
             greenshade = success*(1/dwelltWs);
             %             anim.MarkerFaceColor = [1-greenshade 1 1-greenshade];
             anim.Color = [1-greenshade 1 1-greenshade];
             overshoot = 1;
         else
             %             selTime = NaN;
             success = 0;
             %             anim.MarkerFaceColor = [1 1 1];
             anim.Color = 'blue';
             if overshoot == 1
                 nOvershoot = nOvershoot + 1;        % count_reps number of times target was acquired then lost
             end
             overshoot = 0;
         end
         drawnow
         
        
        if success == dwelltWs
            compTime = toc(selTimeTic)+patRec.tW+procTime(fpTW);
            compTimeTW = nTW-fpTW+1;
        end
        hold off
    nTW = nTW+1;
    end
end

    

