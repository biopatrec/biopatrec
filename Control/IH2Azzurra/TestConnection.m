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
% ------------------- Function Description ------------------
% Function to test the communicatio object
% --------------------------Updates--------------------------
% 2015-11-09 / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment

%% IH2 Azzurra communication test
function result = TestConnection(com)

    % Empty the serial port buffer, if not
    if com.BytesAvailable>0
        fread(com,com.BytesAvailable);
    end
    
    % Try to read two motor positions
    fwrite(com,[69 1 69 2]);
    pos = fread(com,2);
    if numel(pos)==2
        result=1;
    else
        result=0;
    end
end