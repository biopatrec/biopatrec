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
% Reads the file sensors.def and loads the data into sensor objects.
% --------------------------Updates--------------------------
% 2015-06-11 / Sebastian Karlsson  / Creation
% 2016-05-19 / Enzo Mastinu        / The path of the folder must now be passed
%                                    to the function. In case no file name is
%                                    provided, it returns -1.
% 20xx-xx-xx / Author  / Comment on update

function obj = InitSensors(path)

    if(nargin<1)
        obj = -1;
        return
    end
    fid = fopen(strcat(path,'\sensors.def'));
    tline = fgetl(fid);
    i = 1;
    while(ischar(tline))
        t = textscan(tline,'%s','delimiter',',');
        t = t{1};
        obj(i) = sensor(t(1), t(2));
        tline = fgetl(fid);
        i = i + 1;
    end
    fclose(fid);
