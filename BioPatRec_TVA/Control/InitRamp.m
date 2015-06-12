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
% Initialization of Ramp controlAlg. Sets up internal properties that are
% used by the algorithm.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-08 / Joel Falk-Dahlin  / Creation
% 20xx-xx-xx / Author  / Comment on update

function patRec = InitRamp(patRec)

motors = InitMotors;
maxPct = zeros(size(motors));
%nMisclassComp = patRec.controlAlg.parameters.nMisclassComp;

for i = 1:size(maxPct,2)
    maxPct(i) = motors(i).pct;
end

patRec.control.controlAlg.prop.maxPct = maxPct;
patRec.control.controlAlg.prop.nPredicted = zeros(1,patRec.nOuts);
%patRec.controlAlg.prop.nPredictedBuffer = zeros(nMisclassComp+2,patRec.nOuts);

end