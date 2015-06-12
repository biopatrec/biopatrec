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
% Ramp control strategy. Sets speed for VRE and PWMs depending on how many
% consecutive predictions a motions has. Still to be implemented,
% misclassification protection that saves nPredicted in the case of
% intermittent misclassifications.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-16 / Joel Falk-Dahlin  / Creation
% 2012-10-26 / Joel Falk-Dahlin  / Changed maxSpeed to be set from desired
%                                  output speed instead of a separate
%                                  variable for the Ramp algorithm. This
%                                  was necessary for prop.control
% 20xx-xx-xx / Author  / Comment on update

function [patRec, outMov] = Ramp(patRec, outMov, outVec)

% Read Values from patRec object
maxSpeed = patRec.control.currentDegPerMov;
rampLength = patRec.control.controlAlg.parameters.rampLength;
downCount = patRec.control.controlAlg.parameters.downCount;
nPredicted = patRec.control.controlAlg.prop.nPredicted;
maxPct = patRec.control.controlAlg.prop.maxPct;

% Save movement in index vector rather then as numbers
outMovIndex = zeros(size(nPredicted));
outMovIndex(outMov) = 1;
outMovIndex = outMovIndex > 0;

% Add one to counter if movement is predicted
nPredicted(outMovIndex) = nPredicted(outMovIndex) + 1;

% Remove downCount from counter if movement is not predicted
nPredicted( ~outMovIndex ) = nPredicted(~outMovIndex) - downCount;

% Make sure that counter is not more then rampLength or less then zero
nPredicted( nPredicted > rampLength ) = rampLength;
nPredicted( nPredicted < 0 ) = 0;

% Save nPredicted into the patRec struct
patRec.control.controlAlg.prop.nPredicted = nPredicted;

%% Calculate movement speeds 

% Calculate ramp gain for each movement depending on how many times they
% have been predicted
rampGain = nPredicted./ rampLength;

% Set movement speed to maxSpeed*rampGain for now (maxSpeed can be changed
% to desired speed when proportional control is implemented)
movSpeed = maxSpeed.*rampGain;

% Set non-predicted movements to zero-speed
movSpeed(~outMovIndex) = 0;

%% Update VRE/ARE/Motor speeds

% Update motor speeds
% if isfield(handles,'movList') && isfield(handles,'motors')
%      movements = handles.movList(outMov);
%      for i = 1:size(movements,2)
%         movMotors = movements(i).motor;
%         for j = 1:size(movMotors,2)
%             handles.motors(movMotors(j)).pct = ...
%                 Speed2Pct(movSpeed(outMov(i)), maxSpeed, maxPct(movMotors(j)));
%         end
%      end
% end

% Update VRE/ARE speeds
if isfield(patRec.control, 'currentDegPerMov')
    patRec.control.currentDegPerMov = movSpeed;
    %handles.speeds = round(handles.speeds);
end 

end

%% Internal Speed to Pct converter
function pct = Speed2Pct(movSpeed, maxSpeed, maxPct)
    pct = maxPct./maxSpeed .* movSpeed;
end
