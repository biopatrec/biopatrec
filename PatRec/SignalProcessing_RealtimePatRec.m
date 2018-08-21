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
%------------------------- Function Description -------------------------
% Function to execute the general steps of signal processing required in
% real-time PatRec.
%
% ------------------------------- Updates ---------------------------------
% 2011-08-02 / Max Ortiz  / Creation
% 20xx-xx-xx / Author / Comment on update

function tSet = SignalProcessing_RealtimePatRec(data, patRec)

	% Apply conventionalfilters
    data = ApplyFilters(patRec, data); 
    
    % Apply Signal Separation algorithms
    if isfield(patRec,'sigSeparation')
        data = data * patRec.sigSeparation.W;
    end
    
    % Get signal features
    tFeatures = GetSigFeatures(data,patRec.sF,'None',patRec.selFeatures);    
    
    % Create a vector with the signal features
    tSet = [];
    for i = 1 : size(patRec.selFeatures,1)
        tSet = [tSet tFeatures.(patRec.selFeatures{i})];  
    end
    
    % Normalize if required
    tSet = NormalizeSet(tSet,patRec);
    
    % Apply Feature Reduction (PCA) if required
    tSet = ApplyFeatureReduction(tSet, patRec);
    
    %if patRec.norm 
    %    tSet = ((tSet - patRec.nMean) ./ patRec.nVar);
    %end
    
end
