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
% Reads the file movements.def and loads the data into movement objects.
% --------------------------Updates--------------------------
% 2012-05-29 / Nichlas Sander  / Creation
% 20xx-xx-xx / Author  / Comment on update

function obj = InitMovements
fid = fopen('movements.def');
tline = fgetl(fid);
i = 1;
while(ischar(tline))
    %Go through the string
    t = textscan(tline,'%s','delimiter',',');
    t = t{1};
    
    %process t(5) here
    m = textscan(cell2mat(t(5)),'%s','delimiter',' ');
    j = 1;
    clear motors;
    while(j <= size(m{1},1))
        motors(j) = str2double(m{1}(j));
        j = j + 1;
    end
    obj(i) = movement(str2double(t(1)),t(2),str2double(t(3)),str2double(t(4)),motors);
    tline = fgetl(fid);
    i = i+1;
end
fclose(fid);