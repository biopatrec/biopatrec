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
% Funtion to activate the motors in a selected direction and by 
% a selected time. It will only activate one motor.
%
% Using the comunication object (com) move the motor (motorDir) 
% in direction (motorDir), at speed (movSpeed) for a time (movTime)
%
% The motor diretion is coded by integers (1,2,3...)
% motorDir = 1 = motor 1 forward
% motorDir = 2 = motor 1 backwars
% motorDir = 3 = motor 2 forward
% motorDir = 4 = motor 2 backwars
% motorDir = . = motor .    .
% motorDir = . = motor .    .
%
% Each motor is identified by A, B, ... and they are
% activated by two PWMs.
% --------------------------Updates--------------------------
% 2011-11-17 / Max Ortiz  / Creation

function ShortMotorActivation(com, movSpeed, movTime, motorDir)

switch motorDir
    case 1
        pwmID = 'A';
        pwmA = 0;
        pwmB = movSpeed;
    case 2
        pwmID = 'A';
        pwmA = movSpeed;
        pwmB = 0;
    case 3
        pwmID = 'B';
        pwmA = 0;
        pwmB = movSpeed;
    case 4
        pwmID = 'B';
        pwmA = movSpeed;
        pwmB = 0;
    case 5
        pwmID = 'C';
        pwmA = 0;
        pwmB = movSpeed;
    case 6
        pwmID = 'C';
        pwmA = movSpeed;
        pwmB = 0;
    case 7
        pwmID = 'D';
        pwmA = 0;
        pwmB = movSpeed;
    case 8
        pwmID = 'D';
        pwmA = movSpeed;
        pwmB = 0;
    case 9
        pwmID = 'E';
        pwmA = 0;
        pwmB = movSpeed;
    case 10
        pwmID = 'E';
        pwmA = movSpeed;
        pwmB = 0;
end

% Send motor values
if Update2PWMusingSCI(com, pwmID, pwmA, pwmB);
    % Wait for a little move to take place
    pause(movTime);
    % Stop the movement
    Update2PWMusingSCI(com, pwmID, 0, 0);
    %disp('Moved');
else
    disp('Failed');
    fclose(com.io);
end
