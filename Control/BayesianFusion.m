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
% BayesianFusion control algorithm. This algorithm uses the predicted
% probabilities in outVec in the buffer instead of the predicted outmoves.
% The idea is that EMG signals recorded from windows disjoint in time are
% weakly correlated and the conditional propabilites of each move can be
% described as a product of the probabilities each time.
%
% Not suitable for simulataneous control because it only output one
% movement, the one with highest probability.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-09 / Joel Falk-Dahlin  / Creation
% 2013-01-25 / Joel Falk-Dahlin  / Changed algorithm to not make
%                                  predictions if classifier did not find
%                                  any movement (pass 'rest' through).
% 20xx-xx-xx / Author  / Comment on update

function [patRec, outMov] = BayesianFusion(patRec, outMov, outVec)

% Update buffer
patRec.control.outBuffer(1:end-1,:) = patRec.control.outBuffer(2:end,:);
patRec.control.outBuffer(end,:) = outVec;

% Check if movement is Rest, if not make new prediction (Movement is rest
% if classifier did not find any motion, and no new prediction should be
% made)
if ismember(patRec.nOuts,outMov) && strcmp(patRec.mov{end},'Rest')
     outMov = patRec.nOuts;
     patRec.control.outBuffer(:) = 0;
else
     % Read parameters
     k = patRec.control.controlAlg.prop.k;
    
    % Calculate Joint probabilities
    prob = prod(patRec.control.outBuffer + k);
    %prob = prob/sum(prob,1);
    
    % Set outMov to movement with highest joint probability
    if max(prob) > 0
        outMov = find( prob == max(prob) )';
    else
        outMov = patRec.nOuts;
    end
end