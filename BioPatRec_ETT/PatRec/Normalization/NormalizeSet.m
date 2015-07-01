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
% Function to normalize the Trainig and Validation Sets, the testing set
% is normalize according to how the the two latter where normalized.
%
% ------------------------- Updates & Contributors ------------------------
% 2011-10-09 / Max Ortiz / Created
% 20xx-xx-xx / Author / Comment on update
function tSet = NormalizeSet(tSet, patRec)

    if strcmp(patRec.normSets.type,'None')

        return;  
    
    elseif strcmp(patRec.normSets.type,'Mean0Var1')
        
        tSet = (tSet - patRec.normSets.nMean) ./ patRec.normSets.nVar;
        
    elseif strcmp(patRec.normSets.type,'UnitaryRange')

        tSet = (tSet - patRec.normSets.min) ./ patRec.normSets.range;                
    
    elseif strcmp(patRec.normSets.type,'Midrange0Range2')
        
        tSet = (tSet - patRec.normSets.midrange) ./ (patRec.normSets.range/2);                
        
    end
    
end