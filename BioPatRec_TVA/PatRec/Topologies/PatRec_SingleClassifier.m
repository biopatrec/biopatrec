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
% Function to compute the classification output of a single classifier
% Simple function to keep standarizeed the call for different classifiers 
% topologies
% 
% outMov    : Index of the selected patterns
% outVector : Vector the raw classification output
%
% ------------------------- Updates & Contributors ------------------------
% 2011-12-08 / Max Ortiz  / Creation
% 20xx-xx-xx / Author / Comment on update

function [outMov outVector] = PatRec_SingleClassifier(patRec, x)

    [outMov outVector] = OneShotPatRec(patRec.patRecTrained,x);       
    
end