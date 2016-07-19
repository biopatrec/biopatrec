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
% Function to execute the Offline traning once selected from the GUI in
% Matlab
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-07-26 / Max Ortiz / Creation
% 2011-10-03 / Max Ortiz / Addition of individual movements routine
% 2011-11-29 / Max Ortiz / Addition of the posibility different topologies
% 2012-10-10 / Max Ortiz / Addition of algConf 
% 2012-11-02 / Max Ortiz / Addition of floor noise 
% 2012-11-23 / Joel Falk-Dahlin / Added initialization of speeds
% 2013-01-02 / Max Ortiz / Added Feature Reduction variables
%                          Modified floor noise to compute only the first
%                          feature
% 2014-12-01 / Enzo Mastinu  / Added the handling part for the COM port number
                             % information into the parameters
% 2016-04-29 / Julian Maier / Added new fields sigDenoising, sigSeparation, mFilter, addArtifact to copy to patRec
% 20xx-xx-xx / Author  / Comment on update

function patRec = OfflinePatRec(sigFeatures, selFeatures, randFeatures, normSetsType, alg, tType, algConf, movMix, topology, confMatFlag, featReducAlg)

    %% patRec structure initialization

    patRec.nM           = size(sigFeatures.mov,1);
    patRec.mov          = sigFeatures.mov;
    patRec.sF           = sigFeatures.sF;
    patRec.tW           = sigFeatures.tW;
    patRec.wOverlap     = sigFeatures.wOverlap;
    patRec.nCh          = sigFeatures.nCh;
    patRec.dev          = sigFeatures.dev;
    patRec.fFilter      = sigFeatures.fFilter;    
    patRec.sFilter      = sigFeatures.sFilter;   
    patRec.selFeatures  = selFeatures;     
    patRec.topology     = topology;
    patRec.featureReduction.Alg = featReducAlg;
	
	if isfield(sigFeatures,'sigDenoising')
        patRec.sigDenoising = sigFeatures.sigDenoising;
    end
    
    if isfield(sigFeatures,'sigSeparation')
        patRec.sigSeparation = sigFeatures.sigSeparation;
    end
    
    if isfield(sigFeatures,'mFilter')
        patRec.mFilter = sigFeatures.mFilter;
    end
    
    if isfield(sigFeatures,'addArtifact')
        patRec.addArtifact = sigFeatures.addArtifact;
        patRec.addArtifact.mFilter = sigFeatures.mFilter;
    end
    
    if isfield(sigFeatures, 'comm') 
        patRec.comm = sigFeatures.comm;
        if isfield(sigFeatures, 'comn') 
            patRec.comn = sigFeatures.comn;
        end
    else
        patRec.comm = 'N/A';
    end

    %% Start counting the training time
    trStart = tic;
    
    %% Randomize data (if requested)
    if randFeatures
        sigFeatures = Rand_sigFeatures(sigFeatures);
    end
    
     %% Get data sets

     if strcmp(movMix, 'All Mov')
        [trSets, trOuts, vSets, vOuts, tSets, tOuts] = GetSets_Stack(sigFeatures, selFeatures);      
        movIdx = 1:patRec.nM;
        movOutIdx = num2cell(movIdx);
     elseif strcmp(movMix, 'Individual Mov')
         
        [trSets, trOuts, vSets, vOuts, tSets, tOuts, movIdx, movOutIdx] = GetSets_Stack_IndvMov(sigFeatures, selFeatures);

     elseif strcmp(movMix, 'Mixed Output')
         
        [trSets, trOuts, vSets, vOuts, tSets, tOuts, movIdx, movOutIdx] = GetSets_Stack_MixedOut(sigFeatures, selFeatures);

     end
     patRec.movOutIdx = movOutIdx;
     movLables = sigFeatures.mov(movIdx);  
     
      
    %% Normalize
    [trSets vSets patRec] = NormalizeSets_TrV(normSetsType, trSets, vSets, patRec);
    
    %% Floor noise
    if strcmp(movLables(end),'Rest')
        restIdx = find(trOuts(:,end));  % Get Indices of the rest sets
        restSets = trSets(restIdx,:);   % Get data sets related to rest
        restSets = mean(restSets);      % Mean for all windows
        
        % Compute the floor noise of the first feature only
        floorNoise = mean(restSets(1:size(patRec.nCh,2)));
        
        % Loop to compute the floor noise of each feature
%         sCh = 1;                        % starting channel
%         for i = 1 : size(patRec.selFeatures,1)
%             eCh = sCh + size(patRec.nCh,2)-1;
%             floorNoise(i) = mean(restSets(sCh:eCh));
%             sCh = eCh +1; 
%         end
        
        % Save floor noise in patRec
        patRec.floorNoise = floorNoise;
    end
    % Note: The floor noise must be computed after normalization so it can
    % be used as a threshold after SignalProcessing_Realtime in the
    % real-time testing

    %% Feature Reduction
    [trSets vSets,patRec]=FeatureReduction(trSets,vSets,patRec);
    
    %% Topology and algorithm selection
    if strcmp(patRec.topology,'Single Classifier')
        
        %patRec.patRecTrained = OfflinePatRecTraining(alg, tType, trSets, trOuts, vSets, vOuts, trLables, vLables, movLables);
        patRec.patRecTrained = OfflinePatRecTraining(alg, tType, algConf, trSets, trOuts, vSets, vOuts, sigFeatures.mov, movIdx);

    elseif strcmp(patRec.topology,'Ago-antagonist') || ...
           strcmp(patRec.topology,'Ago-antagonistAndMixed')
        %Compute the number of DoF involved
        if strcmp(movLables(end),'Rest')
            nMov = size(movIdx,2) - 1;
            restIdx = size(movIdx,2);
        else
            nMov = size(movIdx,2);    
            restIdx = [];
        end

        % Run through all DoF and get mov 1 and 2 from each DoF plus a Mix.
        for i = 1 : 2 : nMov
            movIdxX = [i i+1];
            disp(['Training DoF:' num2str(round(i/2))]);
 
            % Train only with the Ago-antagonist movements or also the
            % mixed of the remaining movements.
            % If the rest movement is present. It would be considered in
            % the training of each DoF
            if strcmp(patRec.topology,'Ago-antagonist') 
                [trSetsX, trOutsX, vSetsX, vOutsX] = ...
                ExtractSets_Stack(trSets, trOuts, vSets, vOuts, [movIdxX restIdx]);
                movIdxX(end+1) = restIdx;
            elseif strcmp(patRec.topology,'Ago-antagonistAndMixed') 
                [trSetsX, trOutsX, vSetsX, vOutsX, movIdxX, movLables] = ...
                ExtractSets_Stack_MixRest(trSets, trOuts, vSets, vOuts, [movIdxX restIdx], movLables);                
            end
            
            patRec.patRecTrained(round(i/2)) = OfflinePatRecTraining(alg, tType, algConf, trSetsX, trOutsX, vSetsX, vOutsX, movLables, movIdxX);
            
        end        
        
    elseif strcmp(patRec.topology,'One-vs-All') || ...
           strcmp(patRec.topology,'One-vs-All Th') 
        % Number of selected movementes, it might be different than patRec.nM
        nM = size(movIdx,2);    
        
        % Creat a binary classifiers per movements
        for i = 1 : nM
            disp(['Training movement:' num2str(i)]);
            movIdxX = i;
            [trSetsX, trOutsX, vSetsX, vOutsX, movIdxX, movLables] = ExtractSets_Stack_MixRest(trSets, trOuts, vSets, vOuts, movIdxX, movLables);
            patRec.patRecTrained(i) = OfflinePatRecTraining(alg, tType, algConf, trSetsX, trOutsX, vSetsX, vOutsX, movLables, movIdxX);
        end
        
        
    elseif strcmp(patRec.topology,'One-vs-One') || strcmp(patRec.topology,'One-vs-One DoF')
        
        nM = size(movIdx,2);    % Number of selected movementes, it might be different than patRec.nM
        
        % Creat a matrix with binary classifiers between each movements
        for i = 1 : nM
            for j = i+1 : nM
                disp(['Training movement:' num2str(i) ' vs ' num2str(j)]);
                movIdxX = [i j];
                [trSetsX, trOutsX, vSetsX, vOutsX] = ExtractSets_Stack(trSets, trOuts, vSets, vOuts, movIdxX);
                patRec.patRecTrained(i,j) = OfflinePatRecTraining(alg, tType, algConf, trSetsX, trOutsX, vSetsX, vOutsX, movLables, movIdxX);
            end
        end

    elseif strcmp(patRec.topology,'All-and-One')

        % Number of selected movementes, it might be different than patRec.nM
        nM = size(movIdx,2);    
        % Creat a binary classifiers per movements (One-Vs-All)
        for i = 1 : nM
            movIdxX = i;
            disp(['Training movement:' num2str(i)]);
            [trSetsX, trOutsX, vSetsX, vOutsX, movIdxX, movLables] = ExtractSets_Stack_MixRest(trSets, trOuts, vSets, vOuts, movIdxX, movLables);
            patRec.patRecTrained(i) = OfflinePatRecTraining(alg, tType, algConf, trSetsX, trOutsX, vSetsX, vOutsX, movLables, movIdxX);
        end       

        % Creat a matrix with binary classifiers between each movements
        % (One-Vs-One)
        for i = 1 : nM
            for j = i+1 : nM
                movIdxX = [i j];
                disp(['Training movement:' num2str(i) ' vs ' num2str(j)]);
                [trSetsX, trOutsX, vSetsX, vOutsX] = ExtractSets_Stack(trSets, trOuts, vSets, vOuts, movIdxX);
                patRec.patRecTrainedAux(i,j) = OfflinePatRecTraining(alg, tType, algConf, trSetsX, trOutsX, vSetsX, vOutsX, movLables, movIdxX);
            end
        end
        
    else
        disp('Select topology');
        return;                
    end
    
    % Compute training/validation time.
    patRec.trTime = toc(trStart);
    
    %% Test accuracy of the patRec

    [performance confMat tTime] = Accuracy_patRec(patRec, tSets, tOuts, confMatFlag);
    patRec.tTime = tTime;

    %% Final data to the patRec
    patRec.performance  = performance;
    patRec.confMat      = confMat;
    patRec.date         = fix(clock);
    patRec.indMovIdx    = movIdx;
    patRec.nOuts        = size(movIdx,2);
    patRec.control.maxDegPerMov = ones(1,patRec.nOuts);
end

