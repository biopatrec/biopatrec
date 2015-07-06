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
% Function to apply the spatial filter A - B (single differential) conidering
% the electrodes circunferencial arrengment ... | A | B | C | ...
% the number of channels can be grater than 4 but not less than 2
% NOTE: Considerations must be made on how the electrodes were conected to
% the amplifiers inputs
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-07-18 / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment on update

function data = SpatialFilterSDF(data)

    nCh = length(data(1,:,1));

    % Compute the filter            
        for i = 1 : nCh
            A = i;
            % Compute B
            if i == nCh
                B = 1;
            else
                B = i + 1;                       
            end
            tempData(:,A,:) = data(:,A,:) + data(:,B,:);
        end

    data = tempData;


