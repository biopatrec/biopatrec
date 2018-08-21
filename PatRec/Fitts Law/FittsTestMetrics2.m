% combines multiple fittsTest structures and reorganizes them accourding to
% ID and target. targetD and targetW is hardcoded. Must be input directly
% where appropriate

function NewFitts = FittsTestMetrics2(varargin)

trials = 0;
for i = 1:length(varargin)
    load(varargin{i});
    tests(:,:,(i-1)*fittsTest.trials+1:i*fittsTest.trials) = fittsTest.test;
    trials = trials + fittsTest.trials;
end

NewFitts = fittsTest; % NewFitts struct will be made from the last fittsTest loaded above
NewFitts.test = tests;
NewFitts.trials = trials;

q = zeros([1,24]);

% organize data by index of difficulty and target
for t = 1 : NewFitts.trials
    for n = 1 : NewFitts.nR
        for i = 1 : NewFitts.nIDs
            iXYR = NewFitts.test(i,n,t).initialXYR;
            tXYR = NewFitts.test(i,n,t).targetXYR;
            targetD = NewFitts.test(i,n,t).targetDistance;
            targetW = NewFitts.test(i,n,t).targetWidth;
            
            if targetD == 30 && targetW == 13
                x_index = 1;
                if tXYR == iXYR + [0,0,targetD]
                    y_index = 1;
                    q(1) = q(1)+1;
                elseif tXYR == iXYR + [0,0,-targetD]
                    y_index = 2;
                    q(2) = q(2)+1;
                elseif tXYR == iXYR + [targetD,0,0]
                    y_index = 3;
                    q(3) = q(3)+1;
                elseif tXYR == iXYR + [-targetD,0,0]
                    y_index = 4;
                    q(4) = q(4)+1;
                elseif tXYR == iXYR + [0,targetD,0]
                    y_index = 5;
                    q(5) = q(5)+1;
                elseif tXYR == iXYR + [0,-targetD,0]
                    y_index = 6;
                    q(6) = q(6)+1;
                end
            elseif targetD == 30 && targetW == 8
                x_index = 2;
                if tXYR == iXYR + [0,0,targetD]
                    y_index = 1;
                    q(7) = q(7)+1;
                elseif tXYR == iXYR + [0,0,-targetD]
                    y_index = 2;
                    q(8) = q(8)+1;
                elseif tXYR == iXYR + [targetD,0,0]
                    y_index = 3;
                    q(9) = q(9)+1;
                elseif tXYR == iXYR + [-targetD,0,0]
                    y_index = 4;
                    q(10) = q(10)+1;
                elseif tXYR == iXYR + [0,targetD,0]
                    y_index = 5;
                    q(11) = q(11)+1;
                elseif tXYR == iXYR + [0,-targetD,0]
                    y_index = 6;
                    q(12) = q(12)+1;
                end
            elseif targetD == 60 && targetW == 13
                x_index = 3;
                if tXYR == iXYR + [0,0,targetD]
                    y_index = 1;
                    q(13) = q(13)+1;
                elseif tXYR == iXYR + [0,0,-targetD]
                    y_index = 2;
                    q(14) = q(14)+1;
                elseif tXYR == iXYR + [targetD,0,0]
                    y_index = 3;
                    q(15) = q(15)+1;
                elseif tXYR == iXYR + [-targetD,0,0]
                    y_index = 4;
                    q(16) = q(16)+1;
                elseif tXYR == iXYR + [0,targetD,0]
                    y_index = 5;
                    q(17) = q(17)+1;
                elseif tXYR == iXYR + [0,-targetD,0]
                    y_index = 6;
                    q(18) = q(18)+1;
                end
            elseif targetD == 60 && targetW == 8
                x_index = 4;
                if tXYR == iXYR + [0,0,targetD]
                    y_index = 1;
                    q(19) = q(19)+1;
                elseif tXYR == iXYR + [0,0,-targetD]
                    y_index = 2;
                    q(20) = q(20)+1;
                elseif tXYR == iXYR + [targetD,0,0]
                    y_index = 3;
                    q(21) = q(21)+1;
                elseif tXYR == iXYR + [-targetD,0,0]
                    y_index = 4;
                    q(22) = q(22)+1;
                elseif tXYR == iXYR + [0,targetD,0]
                    y_index = 5;
                    q(23) = q(23)+1;
                elseif tXYR == iXYR + [0,-targetD,0]
                    y_index = 6;
                    q(24) = q(24)+1;
                end
            end
            
            tests2(x_index,n,t) = tests(i,n,t);
        end
    end
end

% Fix for if not all IDs were used in trials:
for t = 1:NewFitts.trials
    row1(t) = ~isempty(tests2(1,1,t).nTW);
    row2(t) = ~isempty(tests2(2,1,t).nTW);
    row3(t) = ~isempty(tests2(3,1,t).nTW);
    row4(t) = ~isempty(tests2(4,1,t).nTW);
end
rows = [];
if row1
    rows = [1];
end
if row2
    rows = [rows,2];
end
if row3
    rows = [rows,3];
end
if row4
    rows = [rows,4];
end
tests2 = tests2(rows,:,:);


NewFitts.test = tests2;



NewFitts = FittsTestMetrics(NewFitts); % Basically repeat metrics calculations, but for all trials combined