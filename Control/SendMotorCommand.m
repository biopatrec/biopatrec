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
% Function to implement the Control Framework
%
% It waits until the controller acknowledges the comunication, otherwise 
% it exits with a failure (result = 0).
%
% --------------------------Updates--------------------------
% 2015-07-07 / Enzo Mastinu  / Created  accordingly to the standardized
%                              framework. It sends the motor command to the
%                              external device.
% 2018-02-02 / Adam Naber  / Now sends command atomically. This should make
                             communication with different platforms easier.
% 20xx-xx-xx / Author  / Comment

%% ArduPilot Function to send a motor command
function result = SendMotorCommand(obj, type, index, dir, pwm)
    cmd = ['M',type,index,dir,pwm];
    fwrite(obj,cmd,'char')

    % If no problems where encountered, the controller will return the motor ID
    reply = fread(obj,1);
    if reply == index
        result=1;
    else
        result=0;
        return;
    end       
end
