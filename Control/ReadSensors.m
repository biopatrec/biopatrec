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
% Function serving as an interface between the control framework
% of BioPatRec © and IH2 Azzurra by Prensilia SRL. The function allows
% to read the External Sensors from the hardware. Please refer
% to the IH2 Azzurra manual for more information about External Sensors
%
% --------------------------Updates--------------------------
% 20xx-xx-xx / Author  / Comment on update

function data = ReadSensors(obj, SensorsIDs, SensorsNo)

data = NaN*ones(1,SensorsNo);

for n = 1:SensorsNo

    id = cell2mat(SensorsIDs(n).id);
    fwrite(obj,'S');
    fwrite(obj,id);

    reply = char(fread(obj,1,'char'));
    if strcmp(reply,id)
        rx = fread(obj, 1, 'char');
        data(1,n) = rx;
    else
    % set(handles.t_msg,'String','Error on A');        
    end
end