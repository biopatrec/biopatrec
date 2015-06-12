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
% It differes from ExtractSets_Stack by also including a mix of the remaing
% movements in sets with a single output.
% 
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-12-02 / Max Ortiz  / Creation


function [trSetsX, trOutsX, vSetsX, vOutsX, selSets, movLables] = ExtractSets_Stack_MixRestEqual(trSets, trOuts, vSets, vOuts, selSets, movLables)
    
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
    % Setep
    movStep = find(~trOuts(:,1));
    movStep = movStep(1)-1;
    
    % Get sets orderly one per set until the data set is completed
    % Doing this sequencially assures that at least 1 set per movemnts is
    % included
    stopFlag = 0;
    for i = 1 : nTrS
        for j = i : movStep :size(trSets,1)
            mask = and(trOuts(j,:), restSets);
            if ~mask 
                mixSet = [mixSet ; trSets(j,:)];
            end
            if size(mixSet,1) == nTrS
                stopFlag = 1;
                break;
            end
        end
        if stopFlag                
            break;            
        end
    end
    
%     %% Get randomly data sets from the training set
%     %Randomize Idx
%     setIdx = randperm(size(trOuts,1));
%     %Get data sets
%     for i = 1 : size(trSets,1)
%         mask = and(trOuts(setIdx(i),:), restSets);
%         if ~mask 
%             mixSet = [mixSet ; trSets(setIdx(i),:)];
%         end
%         %Stop if the number of mix sets is reached
%         if size(mixSet,1) == nTrS
%             break;
%         end
%     end

    trSetsX = [trSetsX ; mixSet];
    trOutsX(end+1:end+nTrS,end+1) = 1; 

    %% Get mixed sets for validation
    mixSet = [];
    % Setep
    movStep = find(~vOuts(:,1));
    movStep = movStep(1)-1;

    % Get sets orderly one per set until the data set is completed
    stopFlag = 0;
    for i = 1 : nVs
        for j = i : movStep :size(vSets,1)
            mask = and(vOuts(j,:), restSets);
            if ~mask 
                mixSet = [mixSet ; vSets(j,:)];
            end
            if size(mixSet,1) == nVs
                stopFlag = 1;
                break;
            end
        end
        if stopFlag                
            break;            
        end
    end
    
    % Get randomly data sets from the validation set    
%     %Randomize Idx
%     setIdx = randperm(size(vOuts,1));
%     %Get data sets
%     for i = 1 : size(vSets,1)
%         mask = and(vOuts(setIdx(i),:), restSets);
%         if ~mask 
%             mixSet = [mixSet ; vSets(setIdx(i),:)];
%         end
%         %Stop if the number of mix sets is reached
%         if size(mixSet,1) == nVs
%             break;
%         end
%     end
        
    vSetsX = [vSetsX ; mixSet];
    vOutsX(end+1:end+nVs,end+1) = 1;     
    
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
