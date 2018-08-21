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
% 20016-03-01 / Eva Lendaro  / Added scaling of data to 14 bits in case a
%                              frequency filter has been used
% 20xx-xx-xx / Author  / Comment on update


function pF = GetSigFeatures_tcard(pF)

    if strcmp(pF.filter,'None')
        % Do nothing and exit if
        data = pF.data;
    else
        %scale to 14 bits
        a = 4096;   
        b = a;
        a = a * -1;
        
        % Range of the original aquisition
        minX = -5;
        maxX = 5;
        
        % Scale
        data = round((pF.data- minX) .* (b-a) ./ (maxX-minX) + a);
    end


    for ch = 1 : pF.ch
        % Get the number of different values and their number of repetitions
        v = unique(data(:,ch));
        m = size(v,1);      % Number of unique values, or cardinality        
        pF.f.tcard(ch) =  m;
    end
end
