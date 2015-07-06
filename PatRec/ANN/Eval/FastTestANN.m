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
% Purpose:
%
% Variables:
% accP  Accuracy Patterns (in 100%)
% rmse  Root mean square error
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 20xx-xx-xx / Author  / Creation
% 2011-09-20 /Max Ortiz / New routine for BioPatRec based in previous implementation
%                         for EMG_AQ
%

function [accP rmse] = FastTestANN(ANN,x,y) 
        
    nSets = length(x(:,1));
    nOuts = ANN.nOn;
    %Get the deviation
    d = zeros(nSets,nOuts);  % This vector is used to validate output

    
    dsum=0;
    for i = 1:nSets
        ANN = EvaluateANN(x(i,:),ANN);
        d(i,:)= ANN.o;
        dsum = dsum + sum((d(i,:)-y(i,:)).^2);        
    end
        
    % Correct neuron firing only / total sets
    rD = round(d);
    rY = round(y);        
    er   = find(sum(abs(rD-rY),2) >= 1);    %Find the index of incorrect patterns
    accP = (1 - (length(er)/nSets)) * 100;
     
     % An alternative algorithm to compute pattern accuracy
     % eq1 = (rD == rY);
     % eq2 = sum(eq1,2);
     % vY(1:nSets) = nOuts;
     % eq3 = (eq2' == vY);
     % ap = (sum(eq3)/nSets) * 100;

    rmse = sqrt(dsum/(nSets*nOuts)); % Root mean squere error
    
    
    
    
    