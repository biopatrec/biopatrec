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
%
%   patRec = InitPropControl(patRec)
%
%       Function to intialize the propControl structure to a patRec.
%       Initialization is done with default parameters
%
%   INPUTS:
%
%       patRec - pattern recognition structure that are to use proprotional
%       control
%
%   OUTPUTS:
%       
%       patRec - patRec structure with propControl in patRec.control, using
%       default parameters.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-11-27 / Joel Falk-Dahlin  / Creation
% 20xx-xx-xx / Author  / Comment on update

function patRec = InitPropControl(patRec)
    
    % Initialize prop control Vars if they don't exist
    if ~isfield(patRec.control,'propControl')
        patRec.control.propControl.propFeature = 1;
        patRec.control.propControl.propMaxThresh = 5;
        patRec.control.propControl.propMinThresh = 0;
        patRec.control.propControl.propSpeedMap = 'linear';
    end

end