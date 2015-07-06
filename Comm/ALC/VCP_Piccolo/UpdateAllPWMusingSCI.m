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
% Function to test the i-limb motors. This function will update the values
% of the PWM using a PWM ID and then sending the percentage of duty cycle.
%
% The corresponding function in the ACL has the same name.
%
% This fuction is a slow implementation of SCI communication. It waits
% until the ALC acknowledges the comunication, otherwise it exits with a
% failure (result = 0).
%
% --------------------------Updates--------------------------
% 2011-11-08 / Max Ortiz  / Creation
% 2012-05-03 / Pratham D  / Added K and L
% 2012-07-08 / Max Ortiz  / Update the communication protocol

function result = UpdateAllPWMusingSCI(obj, pwms)

    % Setup IDs
    pwmID = ['A' ; 'B' ; 'C' ; 'D' ; 'E'; 'F' ; 'G' ; 'H' ; 'I' ; 'J'; 'K' ; 'L'];
    
    for i = 1 : size(pwms,2)
        % Send the Test routine in the ALC
%         fwrite(obj.io,'T');
%         %pause(0.01);       % Delay seems to not be neccesary
%         % Send the Test ID
%         fwrite(obj.io,'X');
        % Send Single PWM update
        fwrite(obj.io,'S');
        %Send ID
        fwrite(obj.io,pwmID(i));
        %pause(0.01)        % Delay seems to not be neccesary    
        % Send duty cycle
        fwrite(obj.io,pwms(i),'uint8','async')            
        %pause(0.01)         % Delay seems to not be neccesary   
        
        % If no problems where encountered, the ALC must return 1            
        if fread(obj.io,1)==1
            result=1;
        else
            result=0;
            return;
        end
    end
end
