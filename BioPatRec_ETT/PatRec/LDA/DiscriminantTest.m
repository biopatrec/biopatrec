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
% Function to execute the discrimant analysis use the coeficient previusly
% calculated
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-08-01 / Max Ortiz / Created
% 2011-10-02 / Max Ortiz / Modified to return outVector and outMov

function [outMov outVector] = DiscriminantTest(coeff, tSet, dType)
        
    nM = size(coeff,1);
    tempRes = zeros(nM,nM);
    
    % Linears
    if strcmp(dType,'linear') || strcmp(dType,'diaglinear')
        for i = 1 : nM
            for j = 1 : nM
                if i ~= j
                    K = coeff(i,j).const;
                    L = coeff(i,j).linear;
                    tempRes(i,j) = K + tSet * L;      % k + f1*L1 + f2*L2 ......
                end
            end
        end
        
    % Quadratrics
    elseif strcmp(dType,'quadratic') || strcmp(dType,'diagquadratic') || strcmp(dType,'mahalanobis')        
        for i = 1 : nM
            for j = 1 : nM
                if i ~= j
                    K = coeff(i,j).const;
                    L = coeff(i,j).linear;
                    Q = coeff(i,j).quadratic;
                    tempRes(i,j) = K + tSet*L + sum((tSet * Q) .* tSet, 2);
                end
            end
        end
    end
    
    outVector = sum(tempRes,2);        
    [maxV, outMov] = max(outVector);  
        
end