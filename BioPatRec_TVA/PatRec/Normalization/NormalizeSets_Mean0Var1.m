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
% Normalization to zero mean and unit variance
% Requires test and validation set
%
% ------------- Updates -------------
% 2011-10-06 / Max Ortiz / Creation (maxo@chalmers.se)
% 2011-10-10 / Max Ortiz / Normalization paramenters only taken from trSet

function [trSet vSet mn vr] = NormalizeSets_Mean0Var1(trSet, vSet)

    %Get mean
    mn = mean(trSet,1);
    %Ger variance
    vr = var(trSet);
    % Normalize 
    trSet = (trSet - mn(ones(size(trSet,1), 1), :)) ./ vr(ones(size(trSet,1), 1), :);
    vSet  = (vSet  - mn(ones(size(vSet, 1), 1), :)) ./ vr(ones(size(vSet, 1), 1), :);


%% Old implementation where Tr and V sets where normalized together
%     %put together all the sets
%     allsets = trset;
%     allsets(length(trset(:,1))+1 : length(trset(:,1))+length(vset(:,1)),:) = vset;
%     % get mean
%     mn = mean(allsets,1);
%     %get variance
%     vr = var(allsets);
%     %normalize each set
%     trset = (trset - mn(ones(size(trset,1), 1), :)) ./ vr(ones(size(trset,1), 1), :);
%     vset  = (vset  - mn(ones(size(vset, 1), 1), :)) ./ vr(ones(size(vset, 1), 1), :);
    
    
    