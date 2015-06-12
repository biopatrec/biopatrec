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
% 2012-04-01 / Max Ortiz / Adapted from RegulationFeedbackAcc
% 20xx-xx-xx / Author  / Comment on update

function fitness = RegulationFeedbackFit(connMat, tSets, tOut, nM, thO)

% Variables
% Compute fitness as the root mean square error of the outVector
nSets   = size(tSets,1);
eSum    = 0;

% Compute fitness as the acuracy error
nOut    = size(tOut,2);
good    = zeros(size(tSets,1),1);    % Keep track of the good prediction

for i = 1 : size(tSets,1)
    
    % Evaluate the data sets with he Regulation Feedback Algorithm
    if thO == 0
        [outMov outVector] = RegulationFeedbackTest(connMat, tSets(i,:)');
    else
        [outMov outVector] = RegulationFeedbackTest_thOut(connMat, tSets(i,:)', thO);
    end
    % Compute fitness as the root mean square error of the OutVector
    eSum = eSum + sum((outVector'-tOut(i,:)).^2); 
    
    % Compute fitness as the acuracy error
%     if ~isempty(outMov)
%         if outMov ~= 0
%             mask = zeros(1,nOut);
%             mask(outMov) = 1;
%             % Are these the right movements?
%             if tOut(i,:) == mask    
%                 good(i) = 1;
%             end
%         end
%     end    
    
end

% Compute fitness as the root mean square error of the outVector
fitness = sqrt(eSum/(nSets*nM)); % for minimum

% Compute fitness as the acuracy error
%fitness = 1-(sum(good)/nSets);

