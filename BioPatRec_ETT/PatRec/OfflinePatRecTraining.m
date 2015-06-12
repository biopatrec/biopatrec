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
% 20xx-xx-xx / Author     / Comment on update

function patRec = OfflinePatRecTraining(alg, tType, trSets, trOuts, vSets, vOuts, mov, movIdx)
    % Select and run training
    
    % MLP
    if strcmp(alg,'MLP')

        [ANN accV] = ANN_Perceptron(trSets, trOuts, vSets, vOuts, tType);
        patRec.algorithm = 'MLP';
        patRec.training = tType;
        patRec.ANN = ANN;
                
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
        
    end
    
    % Save the accuracy of the validation set as part of patRec structure;
    patRec.accV = accV;
    
end