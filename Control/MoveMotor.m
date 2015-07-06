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
% Function to activate the DC or servo motors for some degrees. In the c
% of the DC motors this is given by time and the PWM duty cycle. In the
% case of servor motors, this is given only by the duty cycle.
%
% --------------------------Updates--------------------------
% 2012-05-22 / Max Ortiz  / Creation

function [motors, movement] = MoveMotor(com, movement, movDeg,motors)
    
%pwmIDs = cell2mat(movement.idMotor);
movMotors = movement.motor;
noPIDs = size(movMotors,2);

motorPct = [];
pwmIDs = [];
motorActive = [];

% Get the IDs of al PWM involved in the selected movement
for i=1:length(movMotors)
    motorPct = [motorPct motors(movMotors(i)).pct];
    pwmIDs = [pwmIDs cell2mat(motors(movMotors(i)).id)];    
end


%This only works when movements have motors with the same (motor)type
%% DC motors
if (motors(movMotors(1)).type == 0)  % DC Motors
    pause on;

    % Get the pwm vectors according to the direction of the movement
    if movement.vreDir
        pwmA = zeros(1,noPIDs);
        pwmB = motorPct;
    else
        pwmA = motorPct;
        pwmB = zeros(1,noPIDs);
    end
    
    % Relationship between degrees and time.
    movTime = movDeg / 100;

    % Activate them
    for i = 1 : noPIDs
        % Send motor values
        if ~Update2PWMusingSCI(com, pwmIDs(i), pwmA(i), pwmB(i));
            disp('Failed');
            fclose(com.io);
        end
    end

    % wait for the DoF to move
    pause(movTime);

    % Stop
    for i = 1 : noPIDs
        if ~Update2PWMusingSCI(com, pwmIDs(i), 0, 0);
            disp('Failed');
            fclose(com.io);
        end
    end
    pause off;
    
%% Servo Motors
elseif motors(movMotors(1)).type == 1  

    % Add the position
    if(movement.vreDir)
        movDeg = movDeg * -1;
    end
    
    motors(movMotors(1)).pct = motors(movMotors(1)).pct + movDeg;    
    
    % If no problems where encountered, the ALC must return 1            
    % Send PWM
    
    [result motors(movMotors(1)).pct] = UpdatePWMusingSCI_PanTilt(com, pwmIDs, motors(movMotors(1)).pct);
    
    if ~result
        disp('Failed');
        fclose(handles.com.io);
    end    
        
end
%% End of the routines
motorsLast = motors;
