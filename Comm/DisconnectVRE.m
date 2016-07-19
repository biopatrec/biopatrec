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
% Used to Disconnect any existing VRE on a struct.
% Can be used for Realtime, Training, Motion Test etc.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2013-01-29 / Nichlas Sander  / Creation

function handles = DisconnectVRE(handles)
    if isfield(handles,'vre_Com')
        fclose(handles.vre_Com);
        handles = rmfield(handles,'vre_Com');
    end
    handles = EnableIfExists(handles,'pb_socketConnect');
    handles = EnableIfExists(handles,'pb_VRleg');
    handles = EnableIfExists(handles,'pb_socketConnect2');
    handles = EnableIfExists(handles,'pb_ARarm');
    handles = DisableIfExists(handles,'pb_socketDisconnect');
    handles = DisableIfExists(handles,'pb_Camera');
    handles = DisableIfExists(handles,'pb_ActivateArm');
end

function handles = DisableIfExists(handles,field)
    if isfield(handles,field)
        set(handles.(field),'Enable','off');
    end
end

function handles = EnableIfExists(handles,field)
    if isfield(handles,field)
        set(handles.(field),'Enable','on');
    end
end