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
% Evaluates the accuracy for the ANN MLP
%
% ------------------------- Updates & Contributors ------------------------
% 2011-09-20 / Max Ortiz  / New routine for BioPatRec based in previous implementation
%                         for EMG_AQ (maxo@chalmers.se)
% 2011-10-09 / Max Ortiz /
%

function [accP rmse accN] = ANN_Accuracy(patRec, ANN, x, y) 

    nSets = length(x(:,1));
    nM   = size(y,2);       % Number of movements
    nSpM = nSets/nM ;       % Number of sets per movement.
    accN = zeros(nM,1);
    accP = zeros(nM,1);
    rmse = zeros(nM,1); 
    
    if strcmp(ANN.Type,'Perceptron')
        setIdx = 1;
        for i = 1 : nM          % Run through number of movements
            cP  = 0;
            cN  = 0;
            mse = 0;
            for j = 1 : nSpM    % Run trhough the number of sets per movement
                
                %Normalize set
                tSet = NormalizeSet(x(setIdx,:), patRec);
                
                % Evaluate ANN
                ANN = EvaluateANN(tSet,ANN);            
                
                % Decide output
                rO = round(ANN.o);
                
                % Compute performance
                cP = cP + sum(and(rO, y(setIdx,:)')); % Correct Patterns            
                cN = cN + sum((rO == y(setIdx,:)'));  % correct neurons

                mse = mse + sum((ANN.o' - y(setIdx,:)).^2); %mean square error                    

                setIdx = setIdx + 1;
            end
            accP(i) = cP / nSpM;        
            accN(i) = cN / (nSpM * nM);
            rmse(i) = sqrt(mse/(nSpM * nM));            % Root mean square error
        end

        accP(end + 1) = mean(accP);
        accN(end + 1) = mean(accN);
        rmse(end + 1) = mean(rmse);
    end
    
    % Validation routine
    % 110920 MO NOTE: To be implemented

end