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
% Similar to RegulationFeedback but using a threshold to selected the
% predicted movements
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-09-26 / Max Ortiz  / Creation 
% 2012-03-29 / Max Ortiz  / Divided for original version to _thOut 
% 2012-05-20 / Max Ortiz  / Eliminate the use of additional _thOut routines
%                           by incorporating thOut into the standard RFN *Acc
%                           and *Test routines
% 20xx-xx-xx / Author  / Comment on update

function [connMat accV thOut] = RegulationFeedback_thOut(tType, trSets, trOuts, vSets, vOuts)

% Get connectivity Matrix
%connMat = Get_connMat(trSet, trOut);
%connMat = Get_connMat_TrV(trSets, trOuts, vSets, vOuts);
connMat = RegulationFeedback(tType, trSets, trOuts, vSets, vOuts);

% Hard-coded threshold
thOut = 0.45;
% Brute force methode to calculate the threshold
bestAcc = 0;
%bestVar = Inf;
for i = .4:0.01:.6
    %accV = RegulationFeedbackAcc_thOut(connMat, i, vSets, vOuts, size(vOuts,2));
    accV = RegulationFeedbackAcc(connMat, vSets, vOuts, size(vOuts,2), i);
%    varV = var(accV(1:end-1));
    if accV(end) >= bestAcc %&& varV <= bestVar
        bestAcc = accV(end);
%        bestVar =varV;
        thOut = i;
    end
end

disp(bestAcc);
disp(thOut);

% Get accuracy of the validation set
%accV = RegulationFeedbackAcc_thOut(connMat, thOut, vSets, vOuts, size(vOuts,2));
accV = RegulationFeedbackAcc(connMat, vSets, vOuts, size(vOuts,2), thOut);
