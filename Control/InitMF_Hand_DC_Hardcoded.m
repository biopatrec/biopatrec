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
% -------------------------- Function Description -------------------------
% Function to initialize the vector to be used for control of a
% multifuctional prosthetic device using dc motors
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2013-04-21 / Max Ortiz  / Creation (removed from RealtimePatRec
% 20xx-xx-xx / Author  / Comment on update

function [pwmIDs pwmAs pwmBs] = InitMF_Hand_DC_Hardcoded(handles)

    %Initialize
    motorIdx = zeros(1,10);
    pwmAs = zeros(1,10);
    pwmBs = zeros(1,10);
    movSpeeds = zeros(1,10);
    
    % Get the links to the motors
    for i = 1 : size(motorIdx,2)
        pmID = ['handles.pm_m' num2str(i)];
        motorIdx(i) = get(eval(pmID),'Value'); 
        speedID = ['handles.et_speed' num2str(i)];
        movSpeeds(i) = str2double(get(eval(speedID),'String')); 
    end
    
    % Init variables for control
    pwmIDs = ['A';'A';'B';'B';'C';'C';'D';'D';'E';'E'];
    for i = 1 : 2 : size(pwmIDs)
        pwmAs(i)   = movSpeeds(i);
        pwmBs(i)   = 0;
        pwmAs(i+1) = 0;
        pwmBs(i+1) = movSpeeds(i+1);
    end;
    
    % Arrenge according to selection
    pwmIDs = pwmIDs(motorIdx);
    pwmAs = pwmAs(motorIdx);
    pwmBs = pwmBs(motorIdx);
    
end