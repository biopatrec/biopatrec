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
function [outMov outVector] = PatRec_AgoAntagonistAndMixed(patRec, x)

    % Variables init
    if strcmp(patRec.mov(end),'Rest')
        restFlag = 1;
        tempRest = [];
    else
        restFlag = 0;
    end
    outVector = [];
    outMov = [];
    movIdx = 1;
    
    % Go through all DoF
    for j = 1 : size(patRec.patRecTrained,2)
        % Run PatRec
        [outMovTemp outMatrix(:,j)] = OneShotPatRec(patRec.patRecTrained(j),x);

        % Find the winner looking at the outVector
        % If rest or the mixed class are the winners, outMov is not
        % modified
        [mMax mIdx] = max(outMatrix(:,j));
        nPredMov = length(outMovTemp);
        if nPredMov > 0 & outMovTemp ~= 0
            if mIdx == 1
                outMov(end+1) = movIdx;
            elseif mIdx == 2;
                outMov(end+1) = movIdx +1;                
            end                            
        end
        movIdx = movIdx + 2;

        % Create outVector
        outVector = [outVector ; outMatrix(1:2,j)];        
        if restFlag
            tempRest = [tempRest ; outMatrix(end,j)];
        end

        
    end
    % If no movement was predicted and rest exist, then rest it is.
    % Add the average of rest to the outVector
    if restFlag
        outVector(end+1) = mean(tempRest);
        % Select rest if nothing else is selected
        if isempty(outMov)
            outMov = size(outVector,1);
        end
    end
    
    % To comply with standard outMov format
    outMov = outMov';
end