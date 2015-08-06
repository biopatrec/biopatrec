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
% [Contributors are welcome to add their email]
% 2011-12-08 / Max Ortiz  / Creation
% 2012-02-29 / Max Ortiz  / Added a validation to prevent sending empty
%                           outMov
% 2012-03-04 / Max Ortiz  / Moved the outMov validation to OneShotPatRec
%                         / this will keep cleaner this routine
% 20xx-xx-xx / Author  / Comment on update

function [outMov outVector] = OneShotPatRecClassifier(patRec, x)

    if strcmp(patRec.topology,'Single Classifier')

        [outMov outVector] = PatRec_SingleClassifier(patRec, x); 
    
    elseif strcmp(patRec.topology,'Ago-antagonist')

        [outMov outVector] = PatRec_AgoAntagonist(patRec, x);    
        
    elseif strcmp(patRec.topology,'Ago-antagonistAndMixed')

        [outMov outVector] = PatRec_AgoAntagonistAndMixed(patRec, x);    
        
    elseif strcmp(patRec.topology,'One-vs-All')

        [outMov outVector] = PatRec_OneVsAll(patRec, x);

    elseif strcmp(patRec.topology,'One-vs-All Th')

        [outMov outVector] = PatRec_OneVsAllT(patRec, x);

    elseif strcmp(patRec.topology,'One-vs-One')

        [outMov outVector] = PatRec_OneVsOne(patRec, x);

    elseif strcmp(patRec.topology,'One-vs-One DoF')

        [outMov outVector] = PatRec_OneVsOneDoF(patRec, x);
        
    elseif strcmp(patRec.topology,'All-and-One')

        [outMov outVector] = PatRec_AllAndOne(patRec, x);        
        
    end
    
end