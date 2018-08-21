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
% Function to normalize the testing set according to how the previously
% saved normalization parameters
%
% ------------------------- Updates & Contributors ------------------------
% 2011-10-09 / Max Ortiz / Created
% 2012-10-10 / Max Ortiz / Addition of Mean0Std and NormLog
% 20xx-xx-xx / Author / Comment on update

function tSet = NormalizeSet(tSet, patRec)

    if strcmp(patRec.normSets.type,'None')

        return;  
    
    elseif strcmp(patRec.normSets.type,'Mean0Var1')
        
        tSet = (tSet - patRec.normSets.nMean) ./ patRec.normSets.nVar;
        
    elseif strcmp(patRec.normSets.type,'Mean0Std1')
        
        tSet = (tSet - patRec.normSets.nMean) ./ patRec.normSets.nStd;
    
    elseif strcmp(patRec.normSets.type,'UnitaryRange')

        tSet = (tSet - patRec.normSets.min) ./ patRec.normSets.range;                
    
    elseif strcmp(patRec.normSets.type,'Midrange0Range2')
        
        tSet = (tSet - patRec.normSets.midrange) ./ (patRec.normSets.range/2);                

    elseif strcmp(patRec.normSets.type,'NormLog')
        
        tSet = log(abs(tSet - patRec.normSets.min) +1) ;

    else
        disp('Error: No normalization method found');
    end
    
    tSet(isnan(tSet)) = 0;
end
