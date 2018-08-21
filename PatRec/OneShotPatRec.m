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
% Funtion to execute a one shot pattern recognition for a single testing
% set. The patrec algorithm is here selected according to how it was
% previusly trainned
%
% OutMov    : Is the index of the selected movement (only one)
% OutVector : Is a vector with the raw output of the classifier per
%             movement. Multiple movements can be selected from it.
% 
% ------------------------- Updates & Contributors ------------------------
% 2011-09-11 / Max Ortiz  / Creation
% 2012-02-26 / Max Ortiz  / Created MLPTest to standarize calls for testing
%                           routines
% 2012-03-04 / Max Ortiz  / Added a validation to prevent sending empty
%                           outMov
% 2014-11-07 / Diep Khong / Added SVM
% 20xx-xx-xx / Author / Comment on update 

function [outMov outVector] = OneShotPatRec(patRecTrained,tSet)
    
    if strcmp(patRecTrained.algorithm,'MLP') || ...
        strcmp(patRecTrained.algorithm,'MLP thOut')
    
        [outMov outVector] = MLPTest(patRecTrained, tSet);
                
    elseif strcmp(patRecTrained.algorithm,'DA')

        [outMov outVector] = DiscriminantTest(patRecTrained.coeff,tSet,patRecTrained.training);        

    elseif strcmp(patRecTrained.algorithm,'RFN')     

        [outMov outVector] = RegulationFeedbackTest(patRecTrained.connMat, tSet');

    elseif strcmp(patRecTrained.algorithm,'RFN thOut')     
        % NOTE: This is under development Max O
        [outMov outVector] = RegulationFeedbackTest(patRecTrained.connMat, tSet',[], patRecTrained.thOut);

     elseif strcmp(patRecTrained.algorithm,'SOM')

        [outMov outVector] = SOMTest(patRecTrained,tSet);   
        
     elseif strcmp(patRecTrained.algorithm,'SSOM')

        [outMov outVector] = SSOMTest(patRecTrained,tSet);   
        
    elseif strcmp(patRecTrained.algorithm,'KNN')

       [outMov outVector] = KNNTest(patRecTrained,tSet);        
        
    elseif strcmp(patRecTrained.algorithm,'SVM')
        
        [outMov outVector] = SVMTest(patRecTrained, tSet);

    elseif strcmp(patRecTrained.algorithm,'NetLab MLP')
            
        [outMov outVector] = NetLab_MLPTest(patRecTrained, tSet);

    elseif strcmp(patRecTrained.algorithm,'NetLab GLM')
            
        [outMov outVector] = NetLab_GLMTest(patRecTrained, tSet);
        
    elseif strcmp(patRecTrained.algorithm,'DA + RFN')
        % NOTE: This is under development Max O
        % Get result from DA
        [outMovDA outVector] = DiscriminantTest(patRecTrained.coeff,tSet,patRecTrained.training);
        % Normalize from 0 to 1
        minV = min(outVector);
        rangeV = range(outVector);
        newVector = (outVector - minV)./ rangeV;
        % Compute RFN
        [outMovRFN outVector unstable] = RegulationFeedbackTest(patRecTrained.connMat, tSet', newVector);

        %Output Option 1 (seems to work better than option 2)
         outMov = outMovRFN;            
         
        %Output Option 2
%         % Only use RFN if it converged
%         if unstable
%             outMov = outMovDA;
%         else
%             outMov = outMovRFN;            
%         end

    elseif strcmp(patRecTrained.algorithm,'MLP + RFN')
        % NOTE: This is under development Max O
        % Get result from MLP
        [outMovMLP outVectorMLP] = MLPTest(patRecTrained, tSet);
        % Compute RFN
        [outMovRFN outVectorRFN unstable] = RegulationFeedbackTest(patRecTrained.connMat, tSet', outVectorMLP);
        
        % Possibility of combination 1
%         % Scale outputs to their validation accuracy
%         outVectorMLP = outVectorMLP .* patRecTrained.accMLP(1:end-1);
%         outVectorRFN = outVectorRFN .* patRecTrained.accRFN(1:end-1);
%         % average the output vector
%         outVector = mean([outVectorMLP outVectorRFN],2);
%         % get the final output
%         outMov = find(round(outVector));

        % Possibility of combination 2 (seems to be better than poss 1)
        % Only use RFN if it converged
        if unstable
            outMov = outMovMLP;
            outVector = outVectorMLP;
        else
            outMov = outMovRFN;            
            outVector = outVectorRFN;
        end
        
    end

    % Validation to prevent outMov to be empty which cause problems on the
    % GUI
    if isempty(outMov)
        outMov = 0;
    end    
    
end