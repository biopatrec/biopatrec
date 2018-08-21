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
% This function indentifies the selected PatRec algorithm and then calls
% its selected training method. It requires data sets:
%
% * Training sets: trSets with trOuts
% * Validation sets: vSets with vOuts
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-11-29 / Max Ortiz  / Creation out of OfflinePatRec
% 2012-05-20 / Max Ortiz  / Moved the GetSetLables inside
%                           DiscrimiantAnalysis
% 2012-10-10 / Max Ortiz  / Addition of algConf 
% 2014-11-07 / Diep Khong    / Added SVM
% 20xx-xx-xx / Author     / Comment on update

function patRec = OfflinePatRecTraining(alg, tType, algConf, trSets, trOuts, vSets, vOuts, mov, movIdx)
    % Select and run training
    
    % MLP
    if strcmp(alg,'MLP')

        [MLP accV] = ANN_Perceptron(trSets, trOuts, vSets, vOuts, tType);
        patRec.algorithm = 'MLP';
        patRec.training = tType;
        patRec.ANN = MLP;

    elseif strcmp(alg,'MLP thOut')

        [MLP accV] = ANN_Perceptron(trSets, trOuts, vSets, vOuts, tType);
        patRec.algorithm = 'MLP thOut';
        patRec.training = tType;
        patRec.ANN = MLP;
        % Temp hard-coded threshold
        patRec.thOut(1:size(trOuts,2)) = 0.5; 
        
    % DA    
    elseif strcmp(alg,'Discriminant A.')            

        [coeff accV] = DiscriminantAnalysis(tType, trSets, trOuts, vSets, vOuts, mov, movIdx);
        patRec.algorithm = 'DA';
        patRec.training = tType;
        patRec.coeff = coeff;        
        
    % RFN    
    elseif strcmp(alg,'RFN')
        [connMat accV] = RegulationFeedback(tType, trSets, trOuts, vSets, vOuts);
        patRec.algorithm = 'RFN';
        patRec.training = tType;
        patRec.connMat = connMat;            
        
    % RFN threshold output   
    elseif strcmp(alg,'RFN thOut')
        [connMat accV thOut] = RegulationFeedback_thOut(tType, trSets, trOuts, vSets, vOuts);
        patRec.algorithm = 'RFN thOut';
        patRec.training = tType;
        patRec.connMat = connMat;
        % temp fix
        thOut(1:size(connMat,1)) = thOut;
        patRec.thOut = thOut;            
    
    % SOM
    elseif strcmp(alg,'SOM')
        [SOM accV] = SOM_Mapping(trSets, trOuts, vSets, vOuts, tType, algConf);
        patRec.algorithm = 'SOM';
        patRec.training = tType;
        patRec.SOM=SOM;

    % SSOM
    elseif strcmp(alg,'SSOM')
        [SSOM accV] = SSOM_Mapping(trSets, trOuts, vSets, vOuts, tType, algConf);
        patRec.algorithm = 'SSOM';
        patRec.training = tType;
        patRec.SSOM=SSOM;
        
    % KNN
    elseif strcmp(alg,'KNN')
        [KNN accV] = EvaluateKNN(trSets, trOuts, vSets, vOuts, tType);
        patRec.algorithm = 'KNN';
        patRec.training = tType;
        patRec.KNN=KNN;
        
    % SVM
    elseif strcmp(alg,'SVM')
        [SVM accV] = SVMAnalysis(tType, trSets, trOuts, vSets, vOuts, mov, movIdx);
        patRec.algorithm = 'SVM';
        patRec.training = tType;
        patRec.SVM = SVM;        

    % NetLab MLP
    elseif strcmp(alg,'NetLab MLP')
               
        [MLP accV] = NetLab_MLP_InitAndTrain(trSets, trOuts, vSets, vOuts, tType);
        patRec.algorithm = 'NetLab MLP';
        patRec.training = tType;
        patRec.MLP = MLP;
        
    % NetLab GLM
    elseif strcmp(alg,'NetLab GLM')
               
        [GLM accV] = NetLab_GLM_InitAndTrain(trSets, trOuts, vSets, vOuts, tType);
        patRec.algorithm = 'NetLab GLM';
        patRec.training = tType;
        patRec.GLM = GLM;
        
    %% Mixes    
    % DA + RFN    
    elseif strcmp(alg,'DA + RFN')
        
        % Run DA
        [coeff accVDA] = DiscriminantAnalysis(tType, trSets, trOuts, vSets, vOuts, mov, movIdx);
        % Run RFN
        [connMat accVRFN] = RegulationFeedback('Mean', trSets, trOuts, vSets, vOuts);
        
        accV = mean([accVDA accVRFN],2);
        patRec.algorithm = 'DA + RFN';
        patRec.training = tType;
        patRec.coeff = coeff;        
        patRec.connMat = connMat;                    
        
        
    % MLP + RFN    
    elseif strcmp(alg,'MLP + RFN')

        % Run MLP
        [MLP accVmlp] = ANN_Perceptron(trSets, trOuts, vSets, vOuts, tType);
        patRec.ANN = MLP;
        patRec.accMLP = accVmlp;

        % Run RFN
        [connMat accVrfn] = RegulationFeedback('Mean', trSets, trOuts, vSets, vOuts);
        patRec.connMat = connMat;                    
        patRec.accRFN = accVrfn;
 
        % Save general info
        patRec.algorithm = 'MLP + RFN';
        patRec.training = tType;
        
        accV = mean([accVmlp accVrfn],2);
        
    end
    
    % Save the accuracy of the validation set as part of patRec structure;
    patRec.accV = accV;
    % Add the algConf variable
    patRec.algConf = algConf;    
    
end