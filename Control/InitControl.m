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
% Funtion to concentrate the calling of control algorithms
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-07-20 / Max Ortiz  / Creation (moved out from RealtimePatRec)
% 20xx-xx-xx / Author  / Comment on update

function patRec = InitControl(patRec)

    if strcmp(patRec.controlAlg,'Majority vote')
        patRec.outBuffer = zeros(4,patRec.nOuts);
    elseif strcmp(patRec.controlAlg,'Buffer output')
        patRec.outBuffer = zeros(4,patRec.nOuts);
    elseif strcmp(patRec.controlAlg,'Ramp')

    end

end
        