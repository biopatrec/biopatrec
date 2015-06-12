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
% 2012-10-10 / Max Ortiz / Creation
% 20xx-xx-xx / Author / Comment on update

function [trSet vSet mn st] = NormalizeSets_Mean0Std1(trSet, vSet)

    %Get mean
    mn = mean(trSet,1);
    %Ger variance
    st = std(trSet);
    % Normalize 
    trSet = (trSet - mn(ones(size(trSet,1), 1), :)) ./ st(ones(size(trSet,1), 1), :);
    vSet  = (vSet  - mn(ones(size(vSet, 1), 1), :)) ./ st(ones(size(vSet, 1), 1), :);

    
    