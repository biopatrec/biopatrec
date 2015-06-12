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
% 2011-07-26 Max Ortiz / Creation
% 2011-10-03 Max Ortiz / Addition of individual movements routine
% 2011-11-29 Max Ortiz / Addition of the posibility different topologies
% 20xx-xx-xx / Author  / Comment on update

function patRec = OfflinePatRec(sigFeatures, selFeatures, randFeatures, normSetsType, alg, tType, movMix, topology, confMatFlag)

    %% patRec structure initialization

    patRec.nM = size(sigFeatures.mov,1);
    patRec.mov = sigFeatures.mov;
    patRec.sF = sigFeatures.sF;
    patRec.tW = sigFeatures.tW;
    patRec.nCh = sigFeatures.nCh;
    patRec.dev = sigFeatures.dev;
    patRec.fFilter = sigFeatures.fFilter;    
    patRec.sFilter = sigFeatures.sFilter;   
    patRec.selFeatures = selFeatures;     
    patRec.topology = topology;

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
     else
        disp('Error creating the xSets');
        return;                
     end
     patRec.movOutIdx = movOutIdx;
     movLables = sigFeatures.mov(movIdx);  
      
     
    %% Normalize
    [trSets vSets patRec] = NormalizeSets_TrV(normSetsType, trSets, vSets, patRec);

    %% Topology and algorithm selection
    if strcmp(patRec.topology,'Single Classifier')
        
        %patRec.patRecTrained = OfflinePatRecTraining(alg, tType, trSets, trOuts, vSets, vOuts, trLables, vLables, movLables);
        patRec.patRecTrained = OfflinePatRecTraining(alg, tType, trSets, trOuts, vSets, vOuts, sigFeatures.mov, movIdx);

    else
        disp('Select topology');
        return;                
    end
    
    % Compute training/validation time.
    patRec.trTime = toc(trStart);
    
    %% Test accuracy of the patRec

    [acc confMat tTime] = Accuracy_patRec(patRec, tSets, tOuts, confMatFlag);
    patRec.tTime = tTime;

    %% Final data to the patRec
    patRec.acc       = acc;
    patRec.confMat   = confMat;
    patRec.date      = fix(clock);
    patRec.indMovIdx = movIdx;
    patRec.nOuts     = size(movIdx,2);
end

