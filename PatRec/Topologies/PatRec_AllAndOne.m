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
% Function to compute the classification output of the All-and-One scheme
% which is a combination between One-Vs-All and One-Vs-One where ...
% 
% outMov    : Index of the selected patterns
% outVector : Vector the raw classification output
%
% ---------------------------------- Updates ------------------------------
% 2011-12-06 / Max Ortiz  / Creation
% 20xx-xx-xx / Author / Comment on update
function [outMov outVector] = PatRec_AllAndOne(patRec, x)

    outVector = [];
    
    % One-Vs-All Computation
    for j = 1 : size(patRec.patRecTrained,2)
        [outMovTemp outMatrix(:,j)] = OneShotPatRec(patRec.patRecTrained(j),x);        
        % Create the out Vector by gathering the probability of each
        % movement to happen
        outVector = [outVector ; outMatrix(1,j)];
    end
       
    % Sort the best patterns
    [Y, I] = sort(outVector,'descend');
    bestMov = I(1:2)';
    
    % Order the winners for later comparasion OVO
    if bestMov(1) > bestMov(2)
        m(1) = bestMov(2);
        m(2) = bestMov(1);
    else
        m = bestMov;
    end
    
    % One-Vs-One Computation
    [outMovTemp outVectorTemp] = OneShotPatRec(patRec.patRecTrainedAux(m(1),m(2)),x);
    if outMovTemp == 0
        outMov = bestMov(1);
    else
        outMov = m(outMovTemp);       
    end
    
end