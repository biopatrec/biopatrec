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
% Function to compute the classification output of the Ago-antagonist
% scheme.
% 
% outMov    : Index of the selected patterns
% outVector : Vector the raw classification output
%
% ------------------------- Updates & Contributors ------------------------
% 2011-12-04 / Max Ortiz  / Creation
% 20xx-xx-xx / Author / Comment on update
function [outMov outVector] = PatRec_OneVsAllT(patRec, x)

    outVector = [];
    outMov = [];
    outThrs = 0.5;
    
    for j = 1 : size(patRec.patRecTrained,2)
        [outMovTemp outMatrix(:,j)] = OneShotPatRec(patRec.patRecTrained(j),x);                                 
        % Create the out Vector by gathering the probability of each
        % movement to happen
        outVector = [outVector ; outMatrix(1,j)];
    end
    
    % Use of a threshold
    for i = 1 : size(outVector,1)
        if outVector(i) >= outThrs
            outMov(end+1) = i;
        end
    end
   
end