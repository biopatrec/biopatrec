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
% accN  Accuracy Neurons
% accP  Accuracy Patterns
% rmse  Root mean square error
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 20xx-xx-xx / Max Ortiz  / Creation
% 2011-09-20 / Max Ortiz  / New routine for BioPatRec based in previous implementation
%                           for EMG_AQ
%

function [accP rmse accN] = FullTestANN(ANN,x,y) 

    nSets = length(x(:,1));
    nM   = size(y,2);        % Number of movements
    nSpM = nSets/nM ;     % Number of sets per movement.
    accN = zeros(nM,1);
    accP = zeros(nM,1);
    rmse = zeros(nM,1); 
    
    setIdx = 1;
    for i = 1 : nM          % Run through number of movements
        cP  = 0;
        cN  = 0;
        mse = 0;
        for j = 1 : nSpM    % Run trhough the number of sets per movement
            ANN = EvaluateANN(x(setIdx,:),ANN);            
            rO = round(ANN.o);
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
    
    % Validation routine
    % 110920 MO NOTE: To be implemented

   