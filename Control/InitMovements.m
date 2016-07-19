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
% 2015-06-11 / Sebastian Karlsson / The directions of each motor in each
%                                   movement are stored in motors matrix.
% 2016-05-19 / Enzo Mastinu    / The path of the folder is now passed to the
%                                function. In case any file name is
%                                provided, it loads the default def file.
% 20xx-xx-xx / Author  / Comment on update

function obj = InitMovements(path)

    if(nargin)
        fid = fopen(strcat(path,'\movements.def'));
        if(fid==-1)
            errordlg('movements.def file not found in the given folder','Definition File Error');
            return
        end
    else
        fid = fopen('movements_VRE.def');
    end
    tline = fgetl(fid);
    i = 1;
    while(ischar(tline))
        %Go through the string
        t = textscan(tline,'%s','delimiter',',');
        t = t{1};
        %process t(5) here
        m = textscan(cell2mat(t(5)),'%s','delimiter',' ');
        j = 1;
        k = 1;
        clear motors;
        motors = zeros(2,size(m{1},1)/2);
        while(j <= size(m{1},1))
            motors(1,k) = str2double(m{1}(j));      %Motor ID    
            motors(2,k) = str2double(m{1}(j+1));    %Motor Direction
            j = j + 2;
            k = k + 1;
        end
        obj(i) = movement(str2double(t(1)),t(2),str2double(t(3)),str2double(t(4)),motors);
        tline = fgetl(fid);
        i = i+1;
    end
    fclose(fid);