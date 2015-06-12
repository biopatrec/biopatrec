% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec, Copyright © 2009 Max J. Ortiz C.
% BioPatRec is free software under the GNU GPL v3, or any later version.
% See the file "LICENSE" for the full license governing this code.
%
% BioPatRec was initially developed by Max J. Ortiz C. at Chalmers
% University of Technology. Valuable authors’ contributions are mentioned
% below and in the acknowledgements in the project web page. 
%
% Would you like to contribute to science and sum efforts to improve 
% amputees’ quality of life? Join this project, or send your comments to:
% maxo@chalmers.se.
%
% This copyright notice must be kept in this or any new source file linked 
% to BioPatRec
%
% -------------------------- Function Description -------------------------
% This function extract the corresponding set of selected movements. 
% It keeps the format of xSets and xOuts but only with the rows
% corresponding to the selected movements (selSets)
%
% It differs from ExtractSets_Stack by also including a mix of ALL the 
% remaing movements in sets with a single output.
% 
% ------------------------- Updates & Contributors ------------------------
% 2012-03-04 / Max Ortiz  / Creation
% 2012-04-08 / Max Ortiz  / Modified to handle mixed-classes


function [trSetsX, trOutsX, vSetsX, vOutsX, selSets, movLables] = ExtractSets_Stack_MixRest(trSets, trOuts, vSets, vOuts, selSets, movLables)
    
    %% Init the matrices
    trSetsX = [];
    trOutsX = [];
    vSetsX  = [];
    vOutsX  = [];

    %% Extract the training set
    for i = 1 : size(selSets,2)
        % Training
        trSetsIdx = find(trOuts(:,selSets(i)));
        trSetsX = [trSetsX ; trSets(trSetsIdx,:)];
        nTrS = size(trSetsIdx,1);
        % This would only work with equal number of sets per class
        % trOutsX(1+(nTrS*(i-1)):nTrS*i,i) = 1; 
        
        % This works for different set sizes
        if isempty(trOutsX)
            trOutsX(1:nTrS,i) = 1;             
        else
            trOutsX(end+1:end+nTrS,i) = 1; 
        end
        
        
        % Validation
        vSetsIdx = find(vOuts(:,selSets(i)));
        vSetsX = [vSetsX ; vSets(vSetsIdx,:)];
        nVs = size(vSetsIdx,1);
        % This would only work with equal number of sets per class
        % vOutsX(1+(nVs*(i-1)):nVs*i,i) = 1; 
        
        % This works for different set sizes
        if isempty(vOutsX)
            vOutsX(1:nVs,i) = 1;             
        else
            vOutsX(end+1:end+nVs,i) = 1; 
        end        
    end
   
    
    %% Get mixed sets
     mixSet = [];
     % Get index of non selected sets
     restSets = zeros(1,size(trOuts,2));
     restSets(selSets) = 1;
    
    for i = 1 : size(trSets,1)
        mask = and(trOuts(i,:), restSets);             
        if ~mask 
            mixSet = [mixSet ; trSets(i,:)];    
        end             
    end

    trSetsX = [trSetsX ; mixSet];
    trOutsX(end+1:size(trSetsX,1),end+1) = 1; 

    %% Get mixed sets for validation
    mixSet = [];

    for i = 1 : size(vSets,1)
        mask = and(vOuts(i,:), restSets);             
        if ~mask 
            mixSet = [mixSet ; vSets(i,:)];    
        end             
    end
     
    vSetsX = [vSetsX ; mixSet];
    vOutsX(end+1:size(vSetsX,1),end+1) = 1;     
    
    %% Modify lables and index
    % A new lable needs to be created for the mixed sets
    if ~strcmp(movLables(end),'Mixed')
        movLables(end+1) = {'Mixed'};
    end
    selSets(end+1) = size(movLables,1); 
    
    
    if size(trSetsX,1) ~= size(trOutsX,1) || size(vSetsX,1) ~= size(vOutsX,1)
         disp('Error obtaining the lables in ExtractSets_Stack_AllButSome')
         patRec = [];
         return;
     end


end
