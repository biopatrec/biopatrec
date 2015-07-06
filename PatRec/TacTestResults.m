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

nSucct = zeros(tacTest.trials,tacTest.combinations);

% General matrix
for t = 1 : tacTest.trials
    for r = 1 : tacTest.nR
        for m = 1 : tacTest.combinations
            selectionTime(r+(tacTest.nR*(t-1)),m)    = tacTest.trialResult(t,r,m).selectionTime;
            compTime(r+(tacTest.nR*(t-1)),m)   = tacTest.trialResult(t,r,m).completionTime;
            movements{t,m} = tacTest.trialResult(t,r,m).name;
%             selTimeTW(r+(tacTest.nR*(t-1)),m)  = tacTest.trialResult(t,r,m).selTimeTW;
%             compTimeTW(r+(tacTest.nR*(t-1)),m) = tacTest.trialResult(t,r,m).compTimeTW;
            pathEfficiency(r+(tacTest.nR*(t-1)),m)        = tacTest.trialResult(t,r,m).pathEfficiency;
            % Check the numer of succesful trails
            if ~tacTest.trialResult(t,r,m).fail
                 nSucct(t,m) = nSucct(t,m) + 1;  % Number of succesful trials
            end
        end
    end
end

%Save the first repetition of selectionTime and compTime.
selectionTime1 = zeros(size(selectionTime));
selectionTime1 = selectionTime(1:tacTest.nR,1:tacTest.combinations);
comptime1 = zeros(size(compTime));
compTime1 = compTime(1:tacTest.nR,1:tacTest.combinations);


%Add all movements in first trial to corresponding in later ones.
if tacTest.trials > 1
    %Set the success-rate to the first row.
    for i = 1:tacTest.combinations
        name = movements{1,i};
        for j = 2:tacTest.trials
            for k = 1:tacTest.combinations
                if strcmp(name,movements{j,k})
                    nSucct(1,i) = nSucct(1,i) + nSucct(j,k);
                end
            end
        end
    end
    nSucct(2:end,:) = [];
    
    for i = 1:tacTest.combinations
        name = movements{1,i};
        for j = 2:tacTest.trials
            for k = 1:tacTest.combinations
                if strcmp(name,movements{j,k})
                    selectionTime1(((j-1)*tacTest.nR)+1 : ((j-1)*tacTest.nR)+tacTest.nR , i) = selectionTime(((j-1)*tacTest.nR)+1 : ((j-1)*tacTest.nR)+tacTest.nR , k);
                    compTime1(((j-1)*tacTest.nR)+1 : ((j-1)*tacTest.nR)+tacTest.nR , i) = compTime(((j-1)*tacTest.nR)+1 : ((j-1)*tacTest.nR)+tacTest.nR , k);
                end
            end
        end
    end
    %Remove the names of all other rows than the first row.
    movements(2:end,:) = [];
end
compRate = nSucct ./ (tacTest.nR*tacTest.trials);
selectionTime = selectionTime1;
compTime = compTime1;

%% Add a mean
compRate(end+1) = mean(compRate);
selectionTime(:,end+1) = nanmean(selectionTime,2);
compTime(:,end+1) = nanmean(compTime,2);
pathEfficiency(:,end+1) = nanmean(pathEfficiency,2);

%% Save results

tacTest.compRate     = compRate;
tacTest.selectionTime      = selectionTime;
tacTest.compTime     = compTime;
% tacTest.selTimeTW    = selTimeTW;
% tacTest.compTimeTW   = compTimeTW;
tacTest.pathEfficiency          = pathEfficiency;

%% plot and save results
% Completion rate
figure();
plot(compRate,'r-*');
title('Completion rate');
xlabel('Movements');
set(gca,'XTick',1:length(movements)+1,'XtickLabel',[movements 'Mean']);
ylabel('% of completion');

% Completion Time
figure();
hold on;
if(size(compTime,1) > 1)
    plot(nanmean(compTime),'r*');
    boxplot(compTime,'plotstyle','compact');
else
   plot(compTime,'o'); 
end
hold off;
title('Completion Time');
xlabel('Movements');
set(gca,'XTick',1:length(movements)+1,'XtickLabel',[movements 'Mean']);
ylabel('Seconds');

% Selection Time
figure();
hold on;
if(size(selectionTime,1) > 1)
    plot(nanmean(selectionTime),'r*');
    boxplot(selectionTime,'plotstyle','compact');
else
    plot(selectionTime,'o');
end
hold off;
title('Selection Time');
xlabel('Movements');
set(gca,'XTick',1:length(movements)+1,'XtickLabel',[movements 'Mean']);
ylabel('Seconds');

% % Accuracy
figure();
hold on;
if(size(pathEfficiency,1) > 1)
    plot(nanmean(pathEfficiency),'r*');
    boxplot(pathEfficiency,'plotstyle','compact');
else
    plot(pathEfficiency,'o');
end
hold off;
title('Path efficiency');
xlabel('Movements');
set(gca,'XTick',1:length(movements)+1,'XtickLabel',[movements 'Mean']);
ylabel('Accuracy');

