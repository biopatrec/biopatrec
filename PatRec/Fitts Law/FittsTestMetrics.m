
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
% Function to organize and save performance metrics of Fitts' Law Test.
% Adapted from MotionTestResults.m
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-10-10 / Jake Gusman / Creation
% 20xx-xx-xx / Author    / Comment on update

function fittsTest = FittsTestMetrics(fittsTest)

trials = fittsTest.trials;
nR = fittsTest.nR;
nIDs = fittsTest.nIDs;

nSucct = zeros(1,trials*nR);
selTime = zeros(trials*nR,nIDs);
compTime = zeros(trials*nR,nIDs);
distance = zeros(trials*nR,nIDs);
width = zeros(trials*nR,nIDs);
tdist = zeros(trials*nR,nIDs);
nOvershoot = zeros(trials*nR,nIDs);
selDist = zeros(trials*nR,nIDs);


% organize data by index of difficulty
for t = 1 : fittsTest.trials
    for n = 1 : fittsTest.nR
        for i = 1 : fittsTest.nIDs
             selTime((t-1)*fittsTest.nR+n,i)    = fittsTest.test(i,n,t).selTime;
            %selTimeTW((t-1)*fittsTest.nR+n,i)  = fittsTest.test(i,n,t).selTimeTW;
            compTime((t-1)*fittsTest.nR+n,i)   = fittsTest.test(i,n,t).compTime;
            compTime15((t-1)*fittsTest.nR+n,i) = fittsTest.test(i,n,t).compTime;
            moveTime((t-1)*fittsTest.nR+n,i)   = fittsTest.test(i,n,t).compTime - fittsTest.dwellTime;
            
            distance((t-1)*fittsTest.nR+n,i) = fittsTest.test(i,n,t).targetDistance;
            width((t-1)*fittsTest.nR+n,i) = fittsTest.test(i,n,t).targetWidth ; % target width
            tdist((t-1)*fittsTest.nR+n,i) = fittsTest.test(i,n,t).distanceTraveled; % total distance the cursor actually traveled
            nOvershoot((t-1)*fittsTest.nR+n,i) = fittsTest.test(i,n,t).nOvershoot;
%             selDist((t-1)*fittsTest.nR+n,i) = fittsTest.test(i,n,t).selDist;
            
            % Check the number of successful trials
            if ~fittsTest.test(i,n,t).fail
                 nSucct(n) = nSucct(n) + 1;  % Number of successful trials per repetition
            end
             if isnan(compTime((t-1)*fittsTest.nR+n,i)) 
                 compTime15((t-1)*fittsTest.nR+n,i) = 15;
                 %nOvershoot((t-1)*fittsTest.nR+n,i) = NaN;
             end
        end
    end
end
     


%% Throughput (Fitts Law)


% N = fittsTest.trials*fittsTest.nR*fittsTest.nIDs;   % N = total number of conditions
% throughPut = zeros(1,N);
% distance = zeros(1,N);
% indDiff = zeros(1,N);

% for t = 1 : N
    
%     xyr = (fittsTest.test(t).targetXYR - fittsTest.test(t).initialXYR) ;
%     D = sqrt(xyr(1)^2 + xyr(2)^2 + xyr(3)^2);     % target distance
%     distance(t) = D;         % save vector for later use
%      D = fittsTest.test(t).targetDistance;
%      W = fittsTest.test(t).targetWidth ; % target width
    indDiff = log2(distance./width+1);         % Index of Difficulty
%     indDiff(t) = ID;         % Save vector for later use
%     MT = compTime(t); % MT = the time (in seconds) taken to acquire the target

    throughPut = (indDiff./moveTime);

% end
throughPutStd = std(throughPut(:));
throughPut = nanmean(throughPut(:)); % across all IDs

%% Efficiency
% Ratio of the shortest path to the target to the actual path travelled

efficiencyAll = distance./tdist; % for each task
efficiencyStd = std(efficiencyAll(:));
efficiency = nanmean(efficiencyAll(:)); % across all IDs


%% Overshoot
% Average number of times per test that the target was acquired then lost

overshoot = nanmean(nOvershoot(:)); % average number of overshoots (including successes and failures)
overshootStd = std(nOvershoot(:));

%% Stopping Distance   %currently unused

stopDist = tdist - selDist;
stopDistStd = std(stopDist(:));
stopDist = nanmean(stopDist(:));

%% Completion Rate

compRate = nSucct./nIDs;
compRateStd = std(compRate);
compRate = nanmean(compRate);

%% Completion Time

compTimeStd = nanstd(compTime);
compTime = nanmean(compTime);

moveTimeStd = nanstd(moveTime); %currently not saved to fittsTest structure
moveTime = nanmean(moveTime);

selTimeStd = nanstd(selTime);
selTime = nanmean(selTime);

%% Stats %%
% compRate = nSucct / fittsTest.trials;
% selTime(:,end+1) = nanmean(selTime,2);
%  compTime(:,end+1) = nanmean(compTime,2); % mean to the end
% acc(:,end+1) = nanmean(acc,2);
indDiff = nanmean(indDiff);

%% Save results


fittsTest.selTime        = selTime;
fittsTest.selTimeStd     = selTimeStd;
% fittsTest.selTimeTW    = selTimeTW;
fittsTest.compTime       = compTime;
fittsTest.compTimeStd    = compTimeStd;
% fittsTest.compTimeTW   = compTimeTW;
% fittsTest.acc          = acc;
fittsTest.throughPut     = throughPut;
fittsTest.throughPutStd  = throughPutStd;
fittsTest.indDiff        = indDiff;
fittsTest.efficiency     = efficiency;
fittsTest.efficiencyStd  = efficiencyStd;
fittsTest.overshoot      = overshoot;
fittsTest.overshootStd   = overshootStd;
fittsTest.stopDist       = stopDist;
fittsTest.stopDistStd    = stopDistStd;
fittsTest.compRate       = compRate;
fittsTest.compRateStd       = compRateStd;