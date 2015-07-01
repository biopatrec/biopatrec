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
% Function to create the connectivity matrix
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-10-02 / Max Ortiz /  Created
% 2012-03-04 / Max Ortiz /  Modified to handle non-equal amout of sets per
%                           class
% 2012-04-07 / Max Ortiz /  Modified to handle mixed outputs
% 20xx-xx-xx / Author  / Comment on update

function connMat = Get_connMat_TrV(trSet, trOut, vSet, vOut)

% Integration of training and validation sets in one set
trSet = [trSet ; vSet];
trOut = [trOut ; vOut];

%Variable
nM                  = size(trOut,2);    % Number of Movements
nFeatures           = size(trSet,2);    % Number of Features
nSets               = size(trSet,1);    % Number of Total sets
connMat             = zeros(nM,nFeatures);  % Connectivity Matrix

% Separate data sets per pattern
for i = 1 : nSets 
    movIdx = find(trOut(i,:));
    % This loop takes care of mixed outputs
    for j = 1 : size(movIdx,2)
        k = movIdx(j);
        allSetsPerPattern(i,:,k) = trSet(i,:); 
        %(sets x features x classes)
    end
end

% Create connectivity matrix by computing the mean
for i = 1 : nM;
    idx = find(allSetsPerPattern(:,1,i));
%     setsPerPattern(:,:,i) = allSetsPerPattern(idx,:,i);
%     connMat(i,:) = mean(setsPerPattern(:,:,i));
    setsPerPattern = allSetsPerPattern(idx,:,i);
    connMat(i,:) = mean(setsPerPattern);
end


