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
% Function to test the i-limb motors per DoF. 
%
% The corresponding function in the ACL has the same name.
%
% This fuction is a slow implementation of SCI communication. It waits
% until the ALC acknowledges the comunication, otherwise it exits with a
% failure (result = 0).
%
% --------------------------Updates--------------------------
% 2011-11-10 / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment


function result = Update2PWMusingSCI(obj, pwmID, pwm1, pwm2)

    % Send the Test routine in the ALC
    fwrite(obj.io,'D');
    %pause(0.01);       % Delay seems to not be neccesary
    % Send PWM ID
    fwrite(obj.io,pwmID);
    %pause(0.01)        % Delay seems to not be neccesary    
    % Send duty cycle
    fwrite(obj.io,100-pwm1,'uint8','sync')            
    %pause(0.01)         % Delay seems to not be neccesary   
    fwrite(obj.io,100-pwm2,'uint8','sync')            
    %pause(0.01)         % Delay seems to not be neccesary   

    % If no problems where encountered, the ALC must return 1            
    if fread(obj.io,1)==1
        result=1;
    else
        result=0;
        return;
    end
        
end
