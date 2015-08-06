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
% 2012-01-26 / Max Ortiz  / Fixed bug on predictions outMovTemp = 0
% 2013-03-03 / Max Ortiz  / Revision of the whole prediction chain and
%                           simplification of the outMov computation
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

        % Create the outMov vector using the winners from each classifier
        if length(outMovTemp) == 1
            if outMovTemp == 1
                outMov(end+1) = movIdx;
            elseif outMovTemp == 2;
                outMov(end+1) = movIdx +1;                
            end 
            
        % If there is more than 1 movement predicted, take the highest     
        elseif length(outMovTemp) >= 1
            [mMax mIdx] = max(outMatrix(:,j));
             if mIdx == 1
                 outMov(end+1) = movIdx;
             elseif mIdx == 2;
                 outMov(end+1) = movIdx +1;                
             end            
        end
        
% Code prior 2013-03-03        
%         % Find the winner looking at the outVector
%         % This is done to handle cases where outMovTemp has more than 1 value 
%         % If rest or the mixed class are the winners, outMov is not
%         % modified
%         [mMax mIdx] = max(outMatrix(:,j));
%         nPredMov = length(outMovTemp);
%         if nPredMov > 0 & outMovTemp ~= 0
%             if mIdx == 1
%                 outMov(end+1) = movIdx;
%             elseif mIdx == 2;
%                 outMov(end+1) = movIdx +1;                
%             end
%         end
        
        % Increase the Index number for the movements
        movIdx = movIdx + 2;

        % Create outVector
        outVector = [outVector ; outMatrix(1:2,j)];        
        if restFlag
            tempRest = [tempRest ; outMatrix(end,j)];
        end

        
    end
    % If no movement was predicted and rest exist, then rest it is.
    % Add the average of rest to the outVector (this is not the best
    % computation of the strenght of the rest prediction)
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