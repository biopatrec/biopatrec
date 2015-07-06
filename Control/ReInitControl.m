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
%   patRec = ReInitControl(patRec)
%
%       Function to reinitialize the control algorithm using the parameters
%       stored in the structure controlAlg.parameters.
%
%       This function should be called whenever any of these parameters are
%       changed inorder to make sure that the internal properties and the
%       output buffer are set correctly.
%
%   INPUTS:
%
%       patRec - pattern recognition structure
%
%   OUTPUTS:
%
%       patRec - updated pattern recognition structure with reinitialized
%       controlAlg using the parameters stored in controlAlg.parameters.
%      
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-15 / Joel Falk-Dahlin  / Creation (Moved from InitControl_new)
% 20xx-xx-xx / Author  / Comment on update

function patRec = ReInitControl(patRec)

    % Check if additional initialization file exists for control
    % algorithm, if Init'ControlAlg'.m exists, execute it.
    if isfield(patRec.control,'controlAlg')
        if exist(['Init', patRec.control.controlAlg.name{1}],'file') == 2
            patRec = feval(['Init', patRec.control.controlAlg.name{1}], patRec);
        end
    
        % Check if the current Control has a Buffer size, otherwise set to 1
        patRec = InitOutBuffer(patRec);
    end
end