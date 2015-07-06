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
% This function extract the corresponding set of selected movements. 
% It keeps the format of xSets and xOuts but only with the rows
% corresponding to the selected movements (selSets)
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-11-29 / Max Ortiz  / Creation


function [trSetsX, trOutsX, vSetsX, vOutsX] = ExtractSets_Stack(trSets, trOuts, vSets, vOuts, selSets)
    
    % Init the matrices
    trSetsX = [];
    trOutsX = [];
    vSetsX  = [];
    vOutsX  = [];

    % Extract the training set
    for i = 1 : size(selSets,2)
        % Training
        setsIdx = find(trOuts(:,selSets(i)));
        trSetsX = [trSetsX ; trSets(setsIdx,:)];
        nS = size(setsIdx,1);
        % This would only work with equal number of sets per class
        % trOutsX(1+(nS*(i-1)):nS*i,i) = 1;
        
        % This works for different set sizes
        if isempty(trOutsX)
            trOutsX(1:nS,i) = 1;             
        else
            trOutsX(end+1:end+nS,i) = 1; 
        end
        
        % Validation
        setsIdx = find(vOuts(:,selSets(i)));
        vSetsX = [vSetsX ; vSets(setsIdx,:)];
        nS = size(setsIdx,1);
        % This would only work with equal number of sets per class
        % vOutsX(1+(nS*(i-1)):nS*i,i) = 1; 

        % This works for different set sizes
        if isempty(vOutsX)
            vOutsX(1:nS,i) = 1;             
        else
            vOutsX(end+1:end+nS,i) = 1; 
        end
        
    end
    
    
    % Bad (slow) way
%     for i = 1 : size(trOuts,1)
%         if find(selSets == find(trOuts(i,:),1))
%             trSetsX = [trSetsX ; trSets(i,:)]; 
%             trOutsX = [trOutsX ; trOuts(i,:)]; 
%         end
%     end


end
