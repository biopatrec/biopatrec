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
% ------------------- Function Description ------------------
% Function to create the communicatio object

% --------------------------Updates--------------------------
% 2011-11-09 / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment



function obj = Connect_ALC(conn)
    %conn, Connection String
    %Find serial port objects with specified property values
    obj.io=instrfind('Status','open');
    if isempty(obj.io)
        obj.io=serial(conn, 'BaudRate', 14400);
        pause(1)
        % Open io for read and write access
        set(obj.io,'InputBuffer',1024*64)
        fopen(obj.io)
        pause(1)
    end

end
