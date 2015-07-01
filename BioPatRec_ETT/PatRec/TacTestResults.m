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
% Function to print the results of the TAC test
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-07-17 / Nichlas Sander / Created the file from MotionTest and
% changed accordingly

function tacTest = TacTestResults(tacTest)

nSucct = zeros(tacTest.patRec.nM-1,1);

% General matrix
for t = 1 : tacTest.trials
    for r = 1 : tacTest.nR
        for m = 1 : tacTest.patRec.nM - 1
            selectionTime(r+(tacTest.nR*(t-1)),m)    = tacTest.trialResult(t,r,m).selectionTime;
%             selTimeTW(r+(tacTest.nR*(t-1)),m)  = tacTest.trialResult(t,r,m).selTimeTW;
            compTime(r+(tacTest.nR*(t-1)),m)   = tacTest.trialResult(t,r,m).completionTime;
%             compTimeTW(r+(tacTest.nR*(t-1)),m) = tacTest.trialResult(t,r,m).compTimeTW;
%            acc(r+(tacTest.nR*(t-1)),m)        = tacTest.trialResult(t,r,m).acc;
            movements(m) = tacTest.trialResult(t,r,m).movement.name;
            % Check the numer of succesful trails
            if ~tacTest.trialResult(t,r,m).fail
                 nSucct(m) = nSucct(m) + 1;  % Number of succesful trials
            end
        end
    end
end

compRate = nSucct ./ (tacTest.nR*tacTest.trials);


%% Add a mean
compRate(end+1) = mean(compRate);
selectionTime(:,end+1) = nanmean(selectionTime,2);
compTime(:,end+1) = nanmean(compTime,2);
% acc(:,end+1) = nanmean(acc,2);

%% Save results

tacTest.compRate     = compRate;
tacTest.selectionTime      = selectionTime;
% tacTest.selTimeTW    = selTimeTW;
tacTest.compTime     = compTime;
% tacTest.compTimeTW   = compTimeTW;
%tacTest.acc          = acc;

%% plot and save results
% Completion rate
figure();
plot(compRate,'r-*');
title('Completion rate');
xlabel('Movements');
set(gca,'Xtick',1:length(movements),'XtickLabel',[movements 'Mean']);
ylabel('% of completion');

% Completion Time
figure();
boxplot(compTime,'plotstyle','compact');
%plot(nanmean(compTime),'r*');
title('Completion Time');
xlabel('Movements');
set(gca,'Xtick',1:length(movements)+1,'XtickLabel',[movements 'Mean']);
ylabel('Seconds');

% Selection Time
figure();
boxplot(selectionTime,'plotstyle','compact');
%plot(nanmean(selectionTime),'r*');
title('Selection Time');
xlabel('Movements');
set(gca,'Xtick',1:length(movements)+1,'XtickLabel',[movements 'Mean']);
ylabel('Seconds');

% Accuracy
% figure();
% boxplot(acc,'plotstyle','compact');
% %plot(nanmean(acc),'r*');
% title('Prediction accuracy on completed motions');
% xlabel('Movements');
% set(gca,'XtickLabel',[movements]);
% ylabel('Accuracy');

