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
% Requires all available sets
%
% ------------- Updates -------------
% 2011-10-10 / Max Ortiz  / Creation (maxo@chalmers.se)
% 20xx-xx-xx / Author / Comment on update


function [trSet vSet mRange mMidrange] = NormalizeSets_Midrange0Range2(trSet, vSet)
    
    mMin     = min(trSet);   % matrix min
    mMax     = max(trSet);   %matrix max
    mRange    = mMax - mMin;
    mMidrange = (mMax + mMin)/2;

    % Normalize by using the range which will create a distribution between
    % 0 and 1
    for i = 1 : size(trSet,2)
        trSet(:,i) = (trSet(:,i) - mMidrange(i)) ./ (mRange(i)/2);
    end 
    
    % Normalize the validation set from the information of training set
    for i = 1 : size(vSet,2)
        vSet(:,i) = (vSet(:,i) - mMidrange(i)) ./ (mRange(i)/2);
    end 

    
     