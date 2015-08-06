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
% Reads the file motors.def and loads the data into motor objects.
% --------------------------Updates--------------------------
% 2012-05-29 / Nichlas Sander  / Creation
% 2012-07-19 / Max Ortiz  / Added fclose which is necessary to prevent
%                           matlab crashes due to many files open.
% 20xx-xx-xx / Author  / Comment on update

function obj = InitMotors
fid = fopen('motors.def');
tline = fgetl(fid);
i = 1;
while(ischar(tline))
    t = textscan(tline,'%s','delimiter',',');
    t = t{1};
    obj(i) = motor(t(1),str2double(t(2)),str2double(t(3)));
    tline = fgetl(fid);
    i = i + 1;
end

fclose(fid);
