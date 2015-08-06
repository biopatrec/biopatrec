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
% Function to compute the classification output of One Vs One topology but
% it adds the modification of removing the losing movement of each DoF
% before the final computation
% 
% outMov    : Index of the selected patterns
% outVector : Vector the raw classification output
%
% ------------------------- Updates & Contributors ------------------------
% 2011-12-04 / Max Ortiz  / Creation
% 20xx-xx-xx / Author / Comment on update
function [outMov outVector] = PatRec_OneVsOneDoF(patRec, x)

    % Initialize matrices
    outMovMatrix = zeros(size(patRec.patRecTrained,2),size(patRec.patRecTrained,2));
    outMatrix = outMovMatrix;
    
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
            end
            outMatrix(j,k) = outVectorTemp(1); 
            outMatrix(k,j) = outVectorTemp(2); 
        end
    end

    % Remove rest from the outMatrix
%     if strcmp(patRec.mov(end),'Rest')
%         outMatrix = outMatrix(1:end-1,1:end-1);
%     end
    
    % Make 0 the lossing moving in the same DoF
    for j = 1 : 2 : size(patRec.patRecTrained,1)
        if outMovMatrix(j,j+1) == 1
            outMovMatrix(j+1,:) = 0;
            outMatrix(j+1,:) = 0;
        else
            outMovMatrix(j,:) = 0;
            outMatrix(j,:) = 0;
        end
        % Try by adding an extra point to the winner
        %outVector(j) = outVector(j) + outMovMatrix(j,j+1);
        %outVector(j+1) = outVector(j+1) + outMovMatrix(j+1,j);
    end

    % Get the outVector (average)
%     outVector = sum(outMatrix,2)./ (size(outMatrix,1) - 1);                 
     outVector = sum(outMovMatrix,2)./ (size(outMovMatrix,1) - 1);                 
     outMov = find(sum(outMovMatrix,2) >= (size(outMovMatrix,1) - 2));       

    
%     % ANN delivers simultaneous prediction directly
%     if strcmp(patRec.patRecTrained(1,2).algorithm,'ANN')
%         % Giving good results:
%         %outVector = sum(outMatrix,2)./(size(patRec.patRecTrained,1)/2);                    
%         % Considering the mean
%         %outVector = sum(outMatrix,2)./((size(outMatrix,1) - 2)/2);                 
%         % Mean with reduction by threshold
%         outVector = sum(outMatrix,2)./ (((size(outMatrix,1) - 2)/2)+.5);                 
%         outMov = find(round(outVector));
%         % NOTE: Threshold needs to be implemented in outMov not in
%         % outVector
%     else
%         outVector = sum(outMovMatrix,2);        
%     end

    
    % Check if "rest" exist and select it if nothing else is fired
    if strcmp(patRec.mov(end),'Rest') && isempty(find(round(outVector), 1))
        outVector(end+1) = 1;
    end
    
    % Check againt rest
%     if strcmp(patRec.mov(end),'Rest')
%         %Get the winner without rest
%         [outMax outMov] = max(outVector(1:end-1));        
%         if outMovMatrix(outMov,end) == 1
%             outVector(end) = 0;
%         end
%     end


%    [outMax outMov] = max(outVector);        

end