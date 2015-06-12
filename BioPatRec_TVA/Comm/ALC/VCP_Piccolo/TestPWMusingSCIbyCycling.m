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
% Function to test the i-limb motors. This function will increase and
% decrease the speed as well as to change the motor direction.
%
% The corresponding function in the ACL has the same name.
%
% This fuction is a VERY slow implementation of SCI communication. It waits
% until the ALC acknowledges the comunication, otherwise it exits with a
% failure (result = 0).
%
% The driver are controlled to work in fast decay (see data-sheet DVR8833)
% in order to achieve this, one PWM sets the speed while the other is held
% low
%
% pwmDC = PWM duty cycle is inverse, so 10 = 90% of duty cycle
%
% comObj is the communication objectt required for data transmission
%
% --------------------------Updates--------------------------
% 2011-11-07 / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment


function result = TestPWMusingSCIbyCycling(comObj)
    
    % Send the Test routine in the ALC
    fwrite(comObj.io,'T')
    pause(0.1)
    % Send the Test ID
    fwrite(comObj.io,'B');
    pause(0.1)
    reps = 2;

    % Repeat the cycle "reps" times
    for i = 1 : reps;

        % Cycle the PWM until 100 percent to go FORWARD
        for pwmDC = 0 : 20 : 100
 
            % Update the all PWM
            for j = 1 : 2 : 10
                
                % First PWM to set the speed
                fwrite(comObj.io,pwmDC,'uint8','async')            
                %pause(0.1)
                % Read answer
                if fread(comObj.io,1) ~= j
                    result=0;
                    return;
                end
                
                % Second PWM held low
                fwrite(comObj.io,100,'uint8','async')            
                %pause(0.1)
                % Read answer
                if fread(comObj.io,1) ~= j+1
                    result=0;
                    return;
                end
                                
            end
            
            % Continue the transmission
            fwrite(comObj.io,'C');
        end

        % Cycle the PWM until 100 percent to go Backwards
        for pwmDC = 0 : 20 : 100
 
            % Update the all PWM
            for j = 1 : 2 : 10
                
                % First PWM to set the speed
                fwrite(comObj.io,100,'uint8','async')            
                %pause(0.1)
                % Read answer
                if fread(comObj.io,1) ~= j
                    result=0;
                    return;
                end
                
                % Second PWM held low
                fwrite(comObj.io,pwmDC,'uint8','async')            
                %pause(0.1)
                % Read answer
                if fread(comObj.io,1) ~= j+1
                    result=0;
                    return;
                end
                                
            end
            
            % Break or continue the repetitions
            if i >= reps && pwmDC >= 100    % Break the cycle
                fwrite(comObj.io,'B')
                %pause(0.1)    
            else                            % Continue the cycle
                fwrite(comObj.io,'C')
                %pause(0.1)    
            end
        end       
        
    end
    
    % Read confirmation
    if fread(comObj.io,1)==1
        result=1;
    else
        result=0;
    end
end