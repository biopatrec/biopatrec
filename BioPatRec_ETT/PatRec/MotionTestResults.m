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
% Function to print the results of the motion test
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-04-02 / Max Ortiz / Creation
% 2012-05-30 / Max Ortiz / Modified to return motionTest with values
% 20xx-xx-xx / Author    / Comment on update

function motionTest = MotionTestResults(motionTest)

nSucct = zeros(motionTest.patRec.nM-1,1);

% General matrix
for t = 1 : motionTest.trails
    for m = 1 : motionTest.patRec.nM - 1
        for r = 1 : motionTest.nR
            selTime(r+(motionTest.nR*(t-1)),m)    = motionTest.test(r,m,t).selTime;
            selTimeTW(r+(motionTest.nR*(t-1)),m)  = motionTest.test(r,m,t).selTimeTW;
            compTime(r+(motionTest.nR*(t-1)),m)   = motionTest.test(r,m,t).compTime;
            compTimeTW(r+(motionTest.nR*(t-1)),m) = motionTest.test(r,m,t).compTimeTW;
            acc(r+(motionTest.nR*(t-1)),m)        = motionTest.test(r,m,t).acc;

            % Check the numer of succesful trails
            if ~motionTest.test(r,m,t).fail
                 nSucct(m) = nSucct(m) + 1;  % Number of succesful trials
            end
        end
    end
end

compRate = nSucct ./ (motionTest.nR*motionTest.trails);


%% Add a mean
compRate(end+1) = mean(compRate);
selTime(:,end+1) = nanmean(selTime,2);
compTime(:,end+1) = nanmean(compTime,2);
acc(:,end+1) = nanmean(acc,2);

%% Save results

motionTest.compRate     = compRate;
motionTest.selTime      = selTime;
motionTest.selTimeTW    = selTimeTW;
motionTest.compTime     = compTime;
motionTest.compTimeTW   = compTimeTW;
motionTest.acc          = acc;

%% plot and save results
% Selection Time
figure();
boxplot(selTime,'plotstyle','compact')
hold on;
plot(nanmean(selTime),'r*');
title('Selection Time');
xlabel('Movements (mean @ end)');
ylabel('Seconds');

% Selection Time - Time Window
figure();
boxplot(selTimeTW,'plotstyle','compact')
hold on;
plot(nanmean(selTimeTW),'r*');
title('Selection Time - TW');
xlabel('Movements');
ylabel('Number of Time Windows');

% Completion Time
figure();
boxplot(compTime,'plotstyle','compact')
hold on;
plot(nanmean(compTime),'r*');
title('Completion Time');
xlabel('Movements (mean @ end)');
ylabel('Seconds');

% Completion Time - Time Window
figure();
boxplot(compTimeTW,'plotstyle','compact')
hold on;
plot(nanmean(compTimeTW),'r*');
title('Completion Time - TW');
xlabel('Movements');
ylabel('Number of Time Windows');

% Completion rate
figure();
plot(compRate,'r-*');
title('Completion rate');
xlabel('Movements (mean @ end)');
ylabel('% of completion');

% Accuracy
figure();
boxplot(acc,'plotstyle','compact')
hold on;
plot(nanmean(acc),'r*');
title('Prediction accuracy on completed motions');
xlabel('Movements');
ylabel('Accuracy');

