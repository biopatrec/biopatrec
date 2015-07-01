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
% Function to update the motors. A motor is paired to 2 movements which make
% the different directions for the motor. If both movements are selected at
% the same time, they are both discarted.
%
% It runs over the lenght of pwmIDs/2 and assigns the corresponding pwm
% value saved in pwmAs and pwmBs. The selected motors to activate are taken
% from outMov.
%
% --------------------------Updates--------------------------
% 2011-11-17 / Max Ortiz  / Creation
% 2012-03-19 / Max Ortiz  / Review if the recieved outMov is different from
%                           the last one, otherwise don't update the motors PWM


function ActivateMotors(com, pwmIDs, pwmAs, pwmBs, outMov)

persistent outMovLast;

if isempty(outMovLast)
    outMovLast = zeros(1,size(pwmIDs,1));
end

toutMov = zeros(1,10);
    if outMov ~= 0
        toutMov(outMov) = 1;
    end
outMov = toutMov;

if ~strcmp(outMov,outMovLast)
    % Go through all PWMS
    for i = 1 : 2 : size(pwmIDs)
        % Only send the PWMs that have change
        if outMov(i) ~= outMovLast(i) || outMov(i+1) ~= outMovLast(i+1)
            % Only considered one movement per motor (or nothing)
            if xor(outMov(i), outMov(i+1))
                if outMov(i)
                    pwmA = pwmAs(i);
                    pwmB = pwmBs(i);
                else
                    pwmA = pwmAs(i+1);
                    pwmB = pwmBs(i+1);            
                end
            else
                pwmA = 0;
                pwmB = 0;        
            end

            % Send motor values
            if ~Update2PWMusingSCI(com, pwmIDs(i), pwmA, pwmB)
                set(handles.t_msg,'String',['Failed in motor ' pwmID(round(i/2))]);
            end
        end
    end
end

outMovLast = outMov;
