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
%
% --------------------------Updates--------------------------
% 2011-08-02 / Max Ortiz  / Creation


function motionTest = MotionTest_Legacy(patRec, handles)

trials = str2double(get(handles.et_trials,'String'));
nR = str2double(get(handles.et_nR,'String'));
timeOut = str2double(get(handles.et_timeOut,'String'));
pause on;

%% Init motionTest structure
motionTest.sF   = patRec.sF;
motionTest.tW   = patRec.tW;
motionTest.trails   = trials;
motionTest.nR       = nR;
motionTest.timeOut  = timeOut;


%% Initialize DAQ card
% Note: A function for DAQ selection will be required when more cards are
% added

if strcmp(patRec.dev,'ADH')
    
else % at this poin everything else is the NI - USB6009
    chAI = zeros(1,8);
    chAI(patRec.nCh) = 1; 
    ai = InitNI(patRec.sF,timeOut,chAI);
end

%% Motion Test
% Note: Probabily this way of testing only works for the NI
% specific funtions per card might be required.

% run over all the trails
for t = 1 : trials

    % Randomize the aperance of the requested movement
    mIdx = randperm(patRec.nM);
    
    % Run over all movements
    for m = 1 : patRec.nM

        %Select movement
        mov = patRec.mov{mIdx(m)};    
        %Prepare
        for i = 1 : 3;
            msg = ['Relax and prepare to "' mov '" in: ' num2str(4-i) ' seconds (trial:' num2str(t) ')' ];
            set(handles.t_msg,'String',msg);
            pause(1);
        end

        % Init required for patRec of the selected movement
        nTW = 1;            % Number of time windows
        nCorrMov = 0;       % Number of corect movements
        selTime = inf;      % Selection time
        selTimeTW = inf;    % nTW when the selection time happen
        compTime = inf;     % Completion time
        compTimeTW = inf;   % nTW when the completion time happen
        clear 'dataTW';


        % Execute movement
        set(handles.t_msg,'String',mov);
        drawnow;
        start(ai);  % Start the data acquision for timeOut seconds
        selTimeS = tic;

        % Wait until the first samples are aquired
        while ai.SamplesAcquired < patRec.sF*patRec.tW
        end
        % start DAQ
        while ai.SamplesAcquired < patRec.sF*timeOut

            %Data Peek
            data = peekdata(ai,patRec.sF*patRec.tW);
            dataTW(:,:,nTW) = data;   % Save data for future analisys

            %Signal processing
            tSet = SignalProcessing_RealtimePatRec(data, patRec);

            % One shoot PatRec
            [selMov outVector] = OneShotPatRecClassifier(patRec, tSet);              
            
%             % Algorithm selection
%             if strcmp(patRec.algorithm,'ANN');
% 
%             elseif strcmp(patRec.algorithm,'DA')
%                 selMov = DiscriminantTest(patRec.coeff, tSet, patRec.training);
%             end    

            % Check the selected movement
            if mIdx(m) == selMov
                nCorrMov = nCorrMov + 1;
                if nCorrMov == 1;
                    selTime = toc(selTimeS);
                    selTimeTW = nTW;
                elseif nCorrMov == 10;
                    compTime = toc(selTimeS);
                    compTimeTW = nTW;
                end
            end

            % Show results
            set(handles.lb_movements,'Value',selMov);
            drawnow;

            % Next cycle
            nTW = nTW + 1;

        end
        % Finish current movement
        test.mov                    = mov;
        test.nTW                    = nTW-1;
        test.nCorrMov               = nCorrMov;
        test.selTime                = selTime;
        test.selTimeTW              = selTimeTW;
        test.compTime               = compTime;
        test.compTimeTW             = compTimeTW;
        test.dataTW                 = dataTW;
        if compTime == inf
            test.fail = 1;
        else
            test.fail = 0;
        end
        disp(test);
        motionTest.test(t,mIdx(m))  = test;
        stop(ai);
    end
end

delete(ai);
pause off;
disp(motionTest);

[filename, pathname] = uiputfile({'*.mat','MAT-files (*.mat)'},'Save as', 'Untitled.mat');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
        save([pathname,filename],'motionTest');    
    end
    

