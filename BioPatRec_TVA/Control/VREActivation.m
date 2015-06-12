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
% Function to move the VRE in a selected direction, given distance and a
% given amount of time.
%
% The VRE communication object (vre_Com) will be used to move the DoF (movDof)
% in the specified direction (movDir) for the given distance (movDist) over
% the specified amount of time (movTime).
%
% The movDir is specified in the following manner;
% 1 - Extension
% 0 - Flexion
%
% movDof is a character indicating which DoF to activate.
%
% movDist is a percentage of distance to move.
%
% Each motor is identified by A, B, ... and they are
% activated by two PWMs.
% --------------------------Updates--------------------------
% 2011-12-07 / Nichlas Sander  / Creation
% 20xx-xx-xx / Author  / Comment on update

function tac = VREActivation(vre_Com, movSpeed, movTime, movDof, movDir, moveTac)
    if ~moveTac
        %Move the normal hand.
        handMoved = 1;
    else
        %Move the TAC hand.
        handMoved = 2;
    end
    if ~isnumeric(movSpeed)
        [movSpeed, fraction] = rat(str2double(movSpeed));
    else
        [movSpeed, fraction] = rat(movSpeed);
    end
    tac = 0;
    fwrite(vre_Com,sprintf('%c%c%c%c%c',char(handMoved),char(movDof),char(movDir),char(movSpeed), char(fraction)));
    ack = fread(vre_Com,1);
    if ack == 't'
        %If the user is within set allowance the returned ack == 't'
        tac = 1;
    end
end