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
% Handles misclassifications differently than Ramp. Instead of a
% downcounter it resumes the counter if the movement is predicted within
% nMisclassificationComp + 1 iterations.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-17 / Joel Falk-Dahlin  / Creation
% 2012-10-26 / Joel Falk-Dahlin  / Changed maxSpeed to be set from desired
%                                  output speed instead of a separate
%                                  variable for the Ramp algorithm. This
%                                  was necessary for prop.control
% 20xx-xx-xx / Author  / Comment on update

function [patRec, outMov] = RampModified(patRec, outMov, outVec)

%% Read Values from patRec object
maxSpeed = patRec.control.currentDegPerMov;
rampLength = patRec.control.controlAlg.parameters.rampLength;
nPredicted = patRec.control.controlAlg.prop.nPredictedBuffer(end,:);
maxPct = patRec.control.controlAlg.prop.maxPct;

%% Update nPrediction buffer

% Save movement in index vector rather then as numbers
outMovIndex = zeros(size(nPredicted));
outMovIndex(outMov) = 1;
outMovIndex = outMovIndex > 0;

% Add one to counter if movement is predicted
nPredicted(outMovIndex) = nPredicted(outMovIndex) + 1;

% Set current nPredicted to zero for non-predicted movements
nPredicted(~outMovIndex) = 0;

% Make sure that counter is not more then rampLength or less then zero
nPredicted( nPredicted > rampLength ) = rampLength;
nPredicted( nPredicted < 0 ) = 0;

% Save nPredicted to nPredictedBuffer
patRec.control.controlAlg.prop.nPredictedBuffer(1:end-1,:) = patRec.control.controlAlg.prop.nPredictedBuffer(2:end,:);
patRec.control.controlAlg.prop.nPredictedBuffer(end,:) = nPredicted;

%% Check for Misclassification compensation

% Find all zeros in nPredicted buffer
zeroMat = patRec.control.controlAlg.prop.nPredictedBuffer == 0;
% Find all movements that contain atleast one zero
containZero = sum(zeroMat) > 0;
% Find all movements that does not only contain zeros in the buffer
notOnlyZeros = sum(zeroMat) < size(patRec.control.controlAlg.prop.nPredictedBuffer,1)-1;
% Find all movements that contain atleast one, but not only, zeros
movWithZero = containZero.*notOnlyZeros > 0;
% Find all movements with atleast one, but not only, zeros with non
% zero input (these are misclassified)
misclassifiedMoves = movWithZero.*nPredicted > 0;
% Find index of misclassified moves
misclassifiedMoves = find(misclassifiedMoves);

% For all misclassified moves
for i = 1:length(misclassifiedMoves)
    % Find all non-zero elements in buffer, except newest
    iRow = find(patRec.control.controlAlg.prop.nPredictedBuffer(1:end-1,misclassifiedMoves(i)));
    % Set current output to previous + 1
    patRec.control.controlAlg.prop.nPredictedBuffer(end,misclassifiedMoves(i)) = ...
         patRec.control.controlAlg.prop.nPredictedBuffer(iRow(end),misclassifiedMoves(i))+1;
end

% Make sure that the buffer never has larger values than allowed
index = patRec.control.controlAlg.prop.nPredictedBuffer(end,:) > rampLength;
patRec.control.controlAlg.prop.nPredictedBuffer(end,index) = rampLength;

% Re-read the current nPredicted from the buffer (after misclass
% compenstion in done)
nPredicted = patRec.control.controlAlg.prop.nPredictedBuffer(end,:);

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
