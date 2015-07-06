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
% Implementation of the RFN
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-09-26 / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment on update

function [acc, connMat] = RFN(trSet, trOut, vSet, vOut, tSet, tOut, dType)

% Integration of training set and validation set
trSet = [trSet ; vSet];
trOut = [trOut ; vOut];

%Variable
nM                  = size(trOut,2);    % Number of Movements
nFeatures           = size(trSet,2);    % Number of Features
nSets               = size(trSet,1);    % Number of Total sets
allSetsPerPattern   = zeros(nSets,nFeatures,nM);
setsPerPattern      = zeros(nSets/nM,nFeatures,nM);
connMat             = zeros(nM,nFeatures);  % Connectivity Matrix
tSetsPerPattern      = size(tOut,1)/size(tOut,2);


% Separate data sets per pattern
for i = 1 : nSets 
    allSetsPerPattern(i,:,find(trOut(i,:))) = trSet(i,:); 
end

% Create connectivity matrix 
for i = 1 : nM;
    idx = find(allSetsPerPattern(:,1,i));
    setsPerPattern(:,:,i) = allSetsPerPattern(idx,:,i);
    connMat(i,:) = mean(setsPerPattern(:,:,i));
end

%connMat = Get_connMat(trSet, trOut, vSet, vOut);

% Test the tSet (test set)

% for i = 1 : size(tSet,1)
%     vRes = RegulationFeedback(connMat, tSet(i,:)');
%     [Y I] = max(vRes);
%     
%     if I == find(tOut(i,:))
%         accAll(i,find(tOut(i,:))) = 1;
%     end
% end
% 
% acc = sum(accAll) ./ tSetsPerPattern;
% acc(nM+1) = mean(acc);
% acc = acc';

acc = RegulationFeedbackAcc(connMat, tSet, tOut);
