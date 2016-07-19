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
% 2015-07-20 / Francesco Clemente  / Creation (ReadSensors)
%
% 20xx-xx-xx / Author  / Comment on update

function data = ReadSensors(obj, SensorsIDs, ExtSensNo)

% extract IDs of the sensors to be read
ExtSensID = NaN*ones(ExtSensNo,1);
for n = 1:ExtSensNo
    ExtSensID(n) = str2double(SensorsIDs(n).id);
end

% check if IDs are correct
if sum(ExtSensID > 6) || sum(ExtSensID < 0)
    warning('IH2:Sensor_OOR',...
        ['At least one external sensor address provided is '...
        'out of the allowed range (0:6).'...
        'The closer range limit will be used instead']);
    ExtSensID(ExtSensID>6) = 6;
    ExtSensID(ExtSensID<0) = 0;
end

% send reading commands
CMD = 77*ones(2*ExtSensNo,1);
CMD(2:2:end) = ExtSensID;
fwrite(obj, CMD);
read_bytes = fread(obj, 2*ExtSensNo);

% reconstruct values
data = NaN*ones(1,ExtSensNo);
for n=1:ExtSensNo
    data(1,n) = bitand(3,read_bytes(1+(n-1)*2))*256 + read_bytes((2+(n-1)*2));
end
