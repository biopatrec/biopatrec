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
%
% Compute the overal all Accuracy of the patRec algorithm
% As it is, the number of set per class must be the same for each class
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-10-29 / Max Ortiz  / Created 
% 2012-03-04 / Max Ortiz  / Cleaned from old commented code and include a
%                         validation for outMov == 0
% 2012-04-01 / Max Ortiz  / Cunfusion matrix added to the calculations
% 2012-04-01 / Max Ortiz  / tTime added
% 20xx-xx-xx / Author  / Comment on update

function [acc confMat tTime] = Accuracy_patRec(patRec, tSet, tOut, confMatFlag)

% Init variables
nM      = size(patRec.mov,1);       % Number of movements (total)
sM      = size(tOut,1)/nM;          % Sets per movement
good    = zeros(size(tSet,1),1);    % Keep track of the good prediction
nOut    = size(tOut,2);             % Number of outputs
confMat = zeros(nM,nOut+1);
tTime   = zeros(1,size(tSet,1));

for i = 1 : size(tSet,1)
    % Start the timer for testing/prediction time
    tStart = tic;
    %Normalize set
    x = NormalizeSet(tSet(i,:), patRec);
    
    %% Classification
    [outMov outVector] = OneShotPatRecClassifier(patRec, x);

    tTime(i) = toc(tStart);
  
    %% Dirty patch for simultaneous movements  
    % Dirty patch for classification of simultaneous movements when the
    % algorithm has no way to know how many movements are mixed
%     if strcmp(patRec.topology,'Single Classifier')
%         if strcmp(patRec.patRecTrained(end).algorithm,'DA') ||...
%            strcmp(patRec.patRecTrained(end).algorithm,'RFN')
%             
%             %Quick and dirty routine to evaluate 2 patterns
%             % IF it's known that more than two patterns are presented
%             nExpMov = length(find(tOut(i,:)));
%             if nExpMov ~= 1 % More than one movement
%                 [Y, I] = sort(outVector,'descend');
%                 outMov = I(1:nExpMov)';
%             end    
%         end        
%     end

%     % Stop when more than 1 mov is tested
%     if length(find(tOut(i,:))) ~= 1
%         0;
%     end
    
    %% Count the number of correct predictions
    if ~isempty(outMov)
        if outMov ~= 0
            mask = zeros(1,nOut);
            mask(outMov) = 1;
            % Are these the right movements?
            if tOut(i,:) == mask    
                good(i) = 1;
            else
                %stop for debuggin purposes
            end
            
%             %Evaluate only a single movement
%               if tOut(i,outMov) == 1      
%                   good(i) = 1;
%               end

        else
            %If outMov = 0, then count it for the confusion matrix as no
            %prediction in an additional output
            outMov = nOut+1;
        end
    else
        %If outMov = empty, then count it for the confusion matrix as no
        %prediction in an additional output
        outMov = nOut+1;                
    end
    
    %Confusion Matrix
    if confMatFlag
        % This will only work if there is an equal number of sets per class
        % in the testing sets
        expectedOutIdx = fix((i-1)/sM)+1;   
        confMat(expectedOutIdx,outMov) = confMat(expectedOutIdx,outMov) + 1;
    end    
end

tTime = mean(tTime);

% Compute the accuracy per movement
% This will only work if there are the same number of movements
acc = zeros(nM+1,1);
for i = 1 : nM
    s = 1+((i-1)*sM);
    e = sM*i;
    acc(i) = sum(good(s:e))/sM;    
end    
acc(i+1) = sum(good) / size(tSet,1);

% Print confusion matrix
if confMatFlag
    confMat = confMat ./ sM; % This will only work if there is an equal number of sets per class
    figure;
    imagesc(confMat);
    title('Confusion Matrix')
    xlabel('Movements');
    ylabel('Movements');
end
