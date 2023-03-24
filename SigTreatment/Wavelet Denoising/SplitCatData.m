% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec © which is open and free software under 
% the GNU Lesser General Public License (LGPL). See the file "LICENSE" for
% the full license governing this code and copyrights.
%
% BioPatRec was initially developed by Max J. Ortiz C. at Integrum AB and
% Chalmers University of Technology. All authors? contributions must be kept
% acknowledged below in the section "Updates % Contributors".
%
% Would you like to contribute to science and sum efforts to improve
% amputees? quality of life? Join this project! or, send your comments to:
% maxo@chalmers.se.
%
% The entire copyright notice must be kept in this or any source file
% linked to BioPatRec. This will ensure communication with all authors and
% acknowledge contributions here and in the project web page (optional).
%
% -------------------------- Function Description -------------------------
% Splits concanated tr-,v- and t-sets.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-04-01 / Julian Maier / Creation
% 20xx-xx-xx / Author  / Comment on update

function [trData,vData,tData] = SplitCatData(dataAll,sigTreated)

if numel(size(dataAll)) == 4 %  apply on cat data set
    trData = dataAll(:,:,:,1:sigTreated.trSets);
    vData = dataAll(:,:,:,sigTreated.trSets+1:sigTreated.trSets+sigTreated.vSets);
    tData =dataAll(:,:,:,sigTreated.trSets+sigTreated.vSets+1:end);
elseif numel(size(dataAll)) == 2 % apply on cat features set
    trData = dataAll(:,1:sigTreated.trSets)';
    vData = dataAll(:,sigTreated.trSets+1:sigTreated.trSets+sigTreated.vSets)';
    tData =dataAll(:,sigTreated.trSets+sigTreated.vSets+1:end)';
end
