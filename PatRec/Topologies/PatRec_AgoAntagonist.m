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
% 2012-03-06 / Max Ortiz  / Creation from PatRec_AgoAntagonistAndMixed to do
%                           not considered the Mixed

function [outMov outVector] = PatRec_AgoAntagonist(patRec, x)
        
    if strcmp(patRec.mov(end),'Rest')
        restFlag = 1;
        tempRest = [];
    else
        restFlag = 0;
    end
    outVector = [];
    outMov = [];
    movIdx = 1;
    
    for j = 1 : size(patRec.patRecTrained,2)
        [outMovTemp outVectorTemp] = OneShotPatRec(patRec.patRecTrained(j),x);
        % Create outVector
        if restFlag
            tempRest = [tempRest ; outVectorTemp(end)];
        end
        outVector = [outVector ; outVectorTemp(1:2)];
        
        
        % How many patterns were predicted?
        nPredMov = length(outMovTemp);
        if nPredMov > 0
            if restFlag
                if outVectorTemp(1) > outVectorTemp(2)
                    outMov(end+1) = movIdx;
                elseif outVectorTemp(2) > outVectorTemp(3)
                    outMov(end+1) = movIdx+1;
                end

                % The following line doesn't worn since it does't consider
                % that some classifier can predict several outputs.
                %if outMovTemp ~= 3
                %    outMov(end+1) = outMovTemp + (2*(j-1));
                %end
            else
                if outVectorTemp(1) > outVectorTemp(2)
                    outMov(end+1) = movIdx;
                else
                    outMov(end+1) = movIdx+1;
                end
                % The following line doesn't worn since it does't consider
                % that some classifier can predict several outputs.
                %outMov(end+1) = outMovTemp + (2*(j-1));
            end

        end
        movIdx = movIdx + 2;
    end
    
    % Add the average of rest to the outVector
    if restFlag
        outVector(end+1) = mean(tempRest);
        % Select rest if nothing else is selected
        if isempty(outMov)
            outMov = size(outVector,1);
        end
    end
            
end