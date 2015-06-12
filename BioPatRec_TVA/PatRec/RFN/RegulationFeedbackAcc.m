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
% ------------- Function Description -------------
% Compute the overal all Accuracy for a data set using RFN
%
% ------------- Updates -------------
% [Contributors are welcome to add their email]
% 2011-09-26 / Max Ortiz / Created
% 2011-09-26 / Max Ortiz / Addition of nM and modification of the accuracy
%                          computation
% 2012-05-20 / Max Ortiz / Incorporated thOut to delete the additional
%                          thOut routines
% 20xx-xx-xx / Author    / Comment on update

function acc = RegulationFeedbackAcc(connMat, tSet, tOut, nM, thOut)

% Variables
sM          = size(tOut,1)/nM;      % Sets per movement
good        = zeros(size(tSet,1),1);% Keep track of the good prediction
nOut        = size(tOut,2);         % Number of outputs
accMat      = zeros(nM,nOut);
rightOutMat = zeros(nM,nOut);
if ~exist('thOut','var')
    thOut = [];
end

for i = 1 : size(tSet,1)
    
    % Evaluate the data sets with he Regulation Feedback Algorithm
    [outMov outVector] = RegulationFeedbackTest(connMat, tSet(i,:)',[],thOut);
        
%     % Quick and dirty routine to evaluate mixed-classes
%     % IF it's known that more than two patterns are presented
%     nExpMov = length(find(tOut(i,:)));
%     if nExpMov ~= 1 % More than one movement
%         [Y, I] = sort(outVector,'descend');
%         outMov = I(1:nExpMov)';
%     end    
         
    %% Count the number of correct predictions
    expectedOutIdx = find(tOut(i,:)); 
    if ~isempty(outMov)
        if outMov ~= 0
            mask = zeros(1,nOut);
            mask(outMov) = 1;
            % Are these the right movements?
            if tOut(i,:) == mask    
                good(i) = 1;
                                
                %Confusion Matrix
                % This will only considered perfect match of mixed-classes
                % this must be modified to handle the accuracy of each
                % pattern inside the mix
                accMat(expectedOutIdx,outMov) = accMat(expectedOutIdx,outMov) + 1;    
            end
%            %Evaluate only a single movement
%            if tOut(i,outMov) == 1      
%                good(i) = 1;
%            end
        end   
    end
    
    rightOutMat(expectedOutIdx,expectedOutIdx) = rightOutMat(expectedOutIdx,expectedOutIdx) + 1;
    % This way of compute the accuracy and confMat is necessary for
    % handling unbalanced data sets, such as in the case of mixed-classes                               
    
end

accMat = accMat ./ rightOutMat;
accMat(isinf(accMat))= NaN;
acc = nanmean(accMat,2);        % This requires the statistics toolbox
% without the statistics toolbox
%accMat(isnan(accMat))= 0;
%acc = sum(accMat(accMat~=0),2)./sum(accMat~=0,2);

acc(end+1) = mean(acc);

% Compute the accuracy per movement
% Only work if the number of sets is the same per movement.
% acc = zeros(nM+1,1);
% for i = 1 : nM
%     s = 1+((i-1)*sM);
%     e = sM*i;
%     acc(i) = sum(good(s:e))/sM;    
% end    
% acc(i+1) = sum(good) / length(tSet);

