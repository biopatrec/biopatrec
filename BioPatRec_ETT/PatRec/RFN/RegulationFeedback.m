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
% Funtion to select the way in which the connectivity matrix will be
% created
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-09-26 / Max Ortiz  / Creation 
% 2012-03-29 / Max Ortiz  / Added the option to use PSO for the connMat 
% 20xx-xx-xx / Author  / Comment on update

function [connMat accV] = RegulationFeedback(tType, trSets, trOuts, vSets, vOuts)

% Get connectivity Matrix
%connMat = Get_connMat(trSet, trOut); %Get connMat using all sets
if strcmp(tType,'Mean')

    connMat = Get_connMat_TrV(trSets, trOuts, vSets, vOuts);

elseif strcmp(tType,'Mean + PSO')
    
    thO = 0;    % Threshold output is only use in the RegFeedback_ThO
    connMat = Get_connMat_TrV(trSets, trOuts, vSets, vOuts);
    PSO = InitPSO_RFN(connMat);
    [PSO, connMat] = PSO_RFN(PSO, connMat, vSets, vOuts, thO);

elseif strcmp(tType,'Exclusive Mean')

    connMat = Get_connMat_eMean(trSets, trOuts, vSets, vOuts);

else
    errordlg('No training algorithm was selected','Error');
    return;
end

% Get accuracy of the validation set
accV = RegulationFeedbackAcc(connMat, vSets, vOuts, size(vOuts,2));
