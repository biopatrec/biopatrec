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
% Function to activate the standard prosthetic components for
% a defined amount of time.
%
% --------------------------Updates--------------------------
% 2013-06-03 / Max Ortiz  / Creation

function [motors, movement] = MoveMotorWifi(obj, movement, movDeg, motors)
    
    movMotors = movement.motor;
    motorPct = motors(movMotors).pct;

    % Decode PWM id by looking at the motor and its direction
    pwmID = cell2mat(motors(movMotors).id);
    if pwmID == 'A' && movement.vreDir == 0
        pwmID = 'A';
    elseif pwmID == 'A' && movement.vreDir == 1
        pwmID = 'B';
    elseif pwmID == 'B' && movement.vreDir == 0
        pwmID = 'C';
    elseif pwmID == 'B' && movement.vreDir == 1
        pwmID = 'D';
    elseif pwmID == 'C' && movement.vreDir == 0
        pwmID = 'E';
    elseif pwmID == 'C' && movement.vreDir == 1
        pwmID = 'F';
    end
    
    time = movDeg;
    ActivateSP_FixedTime(obj,pwmID,motorPct,time);

end
