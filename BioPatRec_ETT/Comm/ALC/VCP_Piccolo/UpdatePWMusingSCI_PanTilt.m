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
% Function to send the PWM for control of the servo motors for the Pan &
% Tilt unit.
%
% --------------------------Updates--------------------------
% 2012-05-04 / Max Ortiz  / Creation
% 2012-06-29 / Max Ortiz  / Modified the protocolo for communication with
%                           the microcontroller, now it will only send a "S"
%                           before the servo ID, and duty cycle.
% 20xx-xx-xx / Author     / 


function [result pwmPer] = UpdatePWMusingSCI_PanTilt(obj, pwmID, pwmPer)

    %% Safety routine (specifically for the servocity pantilt)
    %Tilt
    if strcmp(pwmID,'L')
        maxP = 85;
        minP = 7;
        if minP > pwmPer
            pwmPer = minP;        
        end
        if maxP < pwmPer
            pwmPer = maxP;        
        end
    end
    %Pan
    if strcmp(pwmID,'K')
        maxP = 100;
        minP = 1;
        if minP > pwmPer
            pwmPer = minP;        
        end
        if maxP < pwmPer
            pwmPer = maxP;        
        end
    end
    
    %% Send values to controller
    % Send the Test routine in the ALC
    % fwrite(obj.io,'T');
    % pause(0.01);       % Delay seems to not be neccesary
    % Send the Test ID
    % fwrite(obj.io,'X');

    % Send servo indentifier
    fwrite(obj.io,'S');
    %Send ID
    fwrite(obj.io,pwmID);
    %pause(0.01)        % Delay seems to not be neccesary    
    % Send duty cycle
    fwrite(obj.io,pwmPer,'uint8','async')            
    %pause(0.01)         % Delay seems to not be neccesary       

    if fread(obj.io,1)==1
        result=1;
    else
        result=0;
        return;
    end

end
