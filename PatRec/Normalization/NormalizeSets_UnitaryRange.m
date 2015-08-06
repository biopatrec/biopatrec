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
% Normalization between 0 and 1
% Requires all available sets
%
% ------------- Updates -------------
% 2011-09-29 / Max Ortiz  / Creation
% 2011-10-10 / Max Ortiz  / Normalization paramenters only taken from trSet
% 20xx-xx-xx / Author / Comment on update 

function [trSet vSet mRange mMin] = NormalizeSets_UnitaryRange(trSet, vSet)

    tolerance = 0.0000001;
    tempSet = trSet;
    mMin = min(tempSet);
    mMin = mMin - tolerance;    %Quick patch for connMat
    mMax = max(tempSet) + tolerance;
    mRange = mMax - mMin;

    % Normalize by using the range which will create a distribution between
    % 0 and 1
    for i = 1 : size(trSet,2)
        trSet(:,i) = (tempSet(:,i) - mMin(i)) ./ mRange(i);
    end 
    
    % Normalize the validation set from the information of training set
    for i = 1 : size(vSet,2)
        vSet(:,i) = (vSet(:,i) - mMin(i)) ./ mRange(i);
        vSet(find(vSet(:,i) < 0),i) = tolerance;
    end 

    
    
%% Old implementation where Tr and V sets where normalized together
%     %put together all the sets
%     allSets = trSet;
%     allSets(length(trSet(:,1))+1 : length(trSet(:,1))+length(vSet(:,1)),:) = vSet;
%     %allSets(length(trSet(:,1))+length(vSet(:,1))+1 :
%     %length(trSet(:,1))+length(vSet(:,1))+length(tSet(:,1)),:) = tSet;
%     
%     mMin = min(allSets);
%     mMin = mMin + 0.0000001;    %Quick patch for connMat
%     mMax = max(allSets);
%     mRange = mMax - mMin;
% 
%     % Normalize by using the range which will create a distribution between
%     % 0 and 1
%     for i = 1 : size(allSets,2)
%         allSets(:,i) = (allSets(:,i) - mMin(i)) ./ mRange(i);
%     end 
%     
%     trSet = allSets(1:size(trSet,1),:);
%     vSet  = allSets(length(trSet(:,1))+1 : length(trSet(:,1))+length(vSet(:,1)),:);
%     %tSet  = allSets(length(trSet(:,1))+length(vSet(:,1))+1 : length(trSet(:,1))+length(vSet(:,1))+length(tSet(:,1)),:);
%     
%     
%     