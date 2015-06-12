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
% Function to apply the spatial filter 2A-B-D considering a circunferencial
% arrengment of electrode A - B - C- D - ...
% The number of channels can be grater than 4 but not less than 3
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-07-18 / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment on update


function sigTreated = SpatialFilter_1()

    [file, path] = uigetfile('*.mat');
    if ~isequal(file, 0)
        load([path,file]);
        if exist('recSession','var')
            nCh = length(recSession.tdata(1,:,1));
            sigTreated = recSession;

            % Removed useless fields for following operations
            if isfield(sigTreated,'tdata')
                sigTreated = rmfield(sigTreated,'tdata');         
            end
            if isfield(sigTreated,'trdata')
                sigTreated = rmfield(sigTreated,'trdata');                 
            end
            
            % Compute the filter            
            if sigTreated.nCh == nCh;
                trdata = recSession.trdata;
                for i = 1 : nCh
                    A = i;
                    % Compute B
                    if i == nCh
                        B = 1;
                    else
                        B = i + 1;                       
                    end
                    % Compute D
                    if i == 1
                        D = nCh;
                    else
                        D = i - 1;                       
                    end                    
                    tempData(:,A,:) = (trdata(:,A,:) .* 2) - trdata(:,B,:) - trdata(:,D,:);
                end
            else
                disp('nCh does not match tdata matrix');
            end
            
            sigTreated.trdata = tempdata;

        end
    end
end

