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
% Function to activate the DC or servo motors. The speed of
% DC motors this is given by the PWM duty cycle. In the
% case of servor motors, the position is simply incremented.
%
% --------------------------Updates--------------------------
% 2012-05-22 / Max Ortiz  / Creation (MoveMotor)
% 2012-07-03 / Max Ortiz  / Creation of specific routines for activation
%                           and deactivation to improve speed.
% 2015-06-11 / Sebastian Karlsson  / Changed to update the current
%                                    speed/position of all types of motors. 
%                                    Moved to motor-type identification
%                                    to be implemented on the connected devices 
%                                    firmware instead of handled by
%                                    this function, according to the standardized framework.
% 2015-07-07 / Enzo Mastinu  / The Update2PWMusingSCI function has been
%                            replaced with the general SendMotorCommand, 
%                            used to implement the control framework

function [motors, movement] = MotorsOn(com, movement, motors, ctrl_val)
    
if strcmp(movement.name,'Rest')
    return;
end

noPIDs = size(movement.motor,2);

% Activate and update
for i = 1 : noPIDs
    % Check the speed Updating
    motors(movement.motor(1,i)).pct = ctrl_val; %%% SERVE?
    % Extract control type (defined in "motors.def" file)
    ctrl_type = motors(movement.motor(1,i)).type;
    % Extract motor index (defined in "motors.def" file)
    motor_index = cell2mat(motors(movement.motor(1,i)).id);
    % Extract movement direction (for speed control)
    mov_dir = movement.motor(2,i);

    
    % Send motor commands
    if ~SendMotorCommand(com, ctrl_type, motor_index, mov_dir, ctrl_val);
        disp('Failed'); % CHECK
        fclose(com);
    end
end 
