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
% Function to compute the classification output of One Vs One topology
% 
% outMov    : Index of the selected patterns
% outVector : Vector the raw classification output
%
% ------------------------- Updates & Contributors ------------------------
% 2011-12-04 / Max Ortiz  / Creation
% 20xx-xx-xx / Author / Comment on update
function [outMov outVector] = PatRec_OneVsOne(patRec, x)

    % Initialize matrices
    outMovMatrix = zeros(size(patRec.patRecTrained,2),size(patRec.patRecTrained,2));
    outMatrix = outMovMatrix;
    nOut = size(patRec.patRecTrained,1);
    
    % Compute the output of each classification
    for j = 1 : size(patRec.patRecTrained,1)
        for k = j+1 : size(patRec.patRecTrained,2)
            [outMovTemp outVectorTemp] = OneShotPatRec(patRec.patRecTrained(j,k),x);
            
            % How many patterns were predicted?
            nPredMov = length(outMovTemp);
            if nPredMov > 0
                % Count the victories of each pattern
                if  outVectorTemp(1) > outVectorTemp(2)                   
                    outMovMatrix(j,k) = 1; 
                    outMovMatrix(k,j) = 0; 
                else
                    outMovMatrix(j,k) = 0; 
                    outMovMatrix(k,j) = 1; 
                end
            % Non-of them was predicted    
            else
                outMovMatrix(j,k) = 0; 
                outMovMatrix(k,j) = 0; 
            end
            outMatrix(j,k) = outVectorTemp(1); 
            outMatrix(k,j) = outVectorTemp(2); 
        end
    end
    
    % Ouput selection by probability
%     outVector = sum(outMovMatrix,2)./ (size(outMovMatrix,1) - 1);  
%     outMov = find(outVector > 0.80);

    % Output selection by threshold
%    outVector = sum(outMovMatrix,2);
%    outMov = find(outVector > patRec.nOut-1);


    % Output selection by majority voting
    outVector = sum(outMovMatrix,2);
    [outMax outMov] = max(outVector);           

end