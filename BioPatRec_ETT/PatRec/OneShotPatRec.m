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
% Funtion to execute a one shot pattern recognition for a single testing
% set. The patrec algorithm is here selected according to how it was
% previusly trainned
%
% OutMov    : Is the index of the selected movement (only one)
% OutVector : Is a vector with the raw output of the classifier per
%             movement. Multiple movements can be selected from it.
% 
% ------------------------- Updates & Contributors ------------------------
% 2011-09-11 / Max Ortiz  / Creation
% 2012-02-26 / Max Ortiz  / Created MLPTest to standarize calls for testing
%                           routines
% 2012-03-04 / Max Ortiz  / Added a validation to prevent sending empty
%                           outMov
% 20xx-xx-xx / Author / Comment on update 

function [outMov outVector] = OneShotPatRec(patRecTrained,tSet)
    
    if strcmp(patRecTrained.algorithm,'MLP')

        [outMov outVector] = MLPTest(patRecTrained, tSet);

    elseif strcmp(patRecTrained.algorithm,'DA')

        [outMov outVector] = DiscriminantTest(patRecTrained.coeff,tSet,patRecTrained.training);        

        
    elseif strcmp(patRecTrained.algorithm,'RFN')     

        [outMov outVector] = RegulationFeedbackTest(patRecTrained.connMat, tSet');

   end

    % Validation to prevent outMov to be empty which cause problems on the
    % GUI
    if isempty(outMov)
        outMov = 0;
    end    
    
end