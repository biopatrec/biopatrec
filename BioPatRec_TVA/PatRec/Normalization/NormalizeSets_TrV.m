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
% ------------- Function Description -------------
% Function to normalize the Trainig and Validation Sets, the testing set
% is normalize according to how the the two latter where normalized
%
% ------------- Updates -------------
% 2011-10-09 / Max Ortiz / 
% 20xx-xx-xx / Author / Comment on update 

function [trSet vSet patRec] = NormalizeSets_TrV(normSetsType, trSet, vSet, patRec)

    if strcmp(normSetsType,'Select Normalization')
        normSets.type = 'None';  

    elseif strcmp(normSetsType,'Mean0Var1')
        %[trSet vSet tSet mn vr] = NormalizeSets_mean0_var1(trSet, vSet, tSet);
        [trSet vSet mn vr] = NormalizeSets_Mean0Var1(trSet, vSet);
        normSets.type   = normSetsType;  
        normSets.nMean  = mn;
        normSets.nVar   = vr;

    elseif strcmp(normSetsType,'Mean0Std1')
        [trSet vSet mn st] = NormalizeSets_Mean0Std1(trSet, vSet);
        normSets.type   = normSetsType;  
        normSets.nMean  = mn;
        normSets.nStd   = st;
        
    elseif strcmp(normSetsType,'UnitaryRange')
        [trSet vSet mRange mMin] = NormalizeSets_UnitaryRange(trSet, vSet);
        normSets.type   = normSetsType;  
        normSets.min = mMin;  
        normSets.range = mRange;  

    elseif strcmp(normSetsType,'Midrange0Range2')
        [trSet vSet mRange mMidrange] = NormalizeSets_Midrange0Range2(trSet, vSet);
        normSets.type   = normSetsType;  
        normSets.midrange = mMidrange;  
        normSets.range = mRange;          

    elseif strcmp(normSetsType,'NormLog')
         [trSet vSet mMin] = NormalizeSets_normLog(trSet, vSet);
         normSets.type   = normSetsType;  
         normSets.min = mMin;
         
    else
        
        disp('No normalization method found');
        
    end
    patRec.normSets = normSets;

end