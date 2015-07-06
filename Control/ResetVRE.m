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
% This is used to reset the position of a specified hand within a
% VRE-session.
% The 'returningValue' specifies whether the VR-system is expected to 
% return a value.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2013-01-29 / Nichlas Sander  / Creation

function ResetVRE(obj,handToReset, returningValue)
    fwrite(obj,sprintf('%c%c%c%c%c','r',char(handToReset),char(0),char(0),char(0)));
    if returningValue
        fread(obj,1);
    end
end

