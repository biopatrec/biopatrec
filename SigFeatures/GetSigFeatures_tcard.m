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
%
% Compute cardinality
%
% I found out that an wrong implementation (trenx) of the rough entropy was
% given improved results than any other feature. This wrong implementation
% turned out to be the "cardinality" of the set. Max Ortz
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-05-01 / Max Ortiz  / Created 
% 20xx-xx-xx / Author  / Comment on update


function pF = GetSigFeatures_tcard(pF)
    for ch = 1 : pF.ch
        % Get the number of different values and their number of repetitions
        v = unique(pF.data(:,ch));
        m = size(v,1);      % Number of unique values, or cardinality        
        pF.f.tcard(ch) =  m;
    end
end