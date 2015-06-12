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
%
%   controlAlgs = ReadValidControlAlgs()
%
%       Function to read control algorithms and default parameters from the
%       text file \Control\ValidControlAlgs.txt
%
%       This function is used in the initialization of a control algorithm
%       (InitControl.m).
%
%   INPUTS:
%
%       None
%
%   OUTPUTS:
%       
%       controlAlg - a cell containing all available controlAlg structures,
%       using their default parameters.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-08 / Joel Falk-Dahlin  / Creation
% 2012-10-09 / Joel Falk-Dahlin  / Changed so parameters can be floats
% 20xx-xx-xx / Author  / Comment on update

function controlAlgs = ReadValidControlAlgs()
fid = fopen('/Control/ValidControlAlgs.txt');

controlAlgs = [];

% Read the fist line of file, making sure it is not empty
% or the end of file (-1)
tline = fgetl(fid);
while isempty(tline) && sum( tline == -1 ) == 0
    tline = fgetl(fid);
end

while sum( tline == -1 ) == 0
    
    % If { character is found, read ControlAlg structure
    if strcmp('{',tline(1))
        currentControlAlg = struct;
        tline = fgetl(fid);
        name = textscan(tline,'name = %s');
        currentControlAlg.name = name{1};
        fncH = str2func(name{1}{1});
        currentControlAlg.fnc = fncH;
        tline = fgetl(fid);
        tline = fgetl(fid);
        
        % Read parameters and default values until } character is found
        parameters = [];
        while ~strcmp('}',tline(1))
            currentParameter = textscan(tline,'%s = %f');
            if isempty(currentParameter{2})
                currentParameter = textscan(tline,'%s = %s');
            end
            
            if isnumeric(currentParameter{1,2})
                parameters.(currentParameter{1,1}{1}) = double(currentParameter{1,2});
            elseif ischar(currentParameter{1,2}{1})
                parameters.(currentParameter{1,1}{1}) = currentParameter{1,2}{1};
            end
            tline = fgetl(fid);
        end
        
        % Set read parameters to current ControlAlg
        currentControlAlg.parameters = parameters;
        
        % Store current ControlAlg
        controlAlgs = [controlAlgs, {currentControlAlg}];
        
    end
    
    tline = fgetl(fid);
    while isempty(tline) && sum( tline == -1 ) == 0
        tline = fgetl(fid);
    end
    
end

fclose(fid);

end