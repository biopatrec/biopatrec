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
% 2011-11-09 / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment

%% Test Connection
function result = TestConnectionALC(obj)
    %If buffer not empty, 
    if obj.io.BytesAvailable>0
        fread(obj.io,obj.io.BytesAvailable);
    end
    %Send connection test
    fwrite(obj.io,'C');
    pause(0.5);
    if fread(obj.io,1)==1
        result=1;
    else
        result=0;
    end
end