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
%   patRec = ApplyProportionalControl(tSet,patRec)
%
%       Calculates degrees to move based upon the variables stored inside
%       patRec.control.propControl. If propControl does not exist, the
%       movements are performed at maximum degrees per movement, which is
%       stored within patRec.control.maxDegPerMov
%
%   INPUTS:
%
%           tSet - feature set calculated from one time window, can be
%           calculated by SignalProcessing_RealtimePatRec().
%
%           patRec - the pattern recognition structure
%
%   OUTPUTS:
%
%           patRec - updated pattern recognition structure containing
%           patRec.control.currentDegPerMov, which are the degrees to move
%           the device with for this particular prediction.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-26 / Joel Falk-Dahlin  / Creation
%
% 2012-11-06 / Joel Falk-Dahlin / Changed so that features are not
%                               recalculated, uses tSet vector instead.
%
% 2012-11-23 / Joel Falk-Dahlin  / Removed handles since speeds now are in
%                                  patRec
%
% 20xx-xx-xx / Author  / Comment on update

function patRec = ApplyProportionalControl(tSet,patRec)

% If proportional control is being used, calculate desired speed
if isfield(patRec.control,'propControl')

    % Extract proportional Control variables
    propMinThresh = patRec.control.propControl.propMinThresh;
    propMaxThresh = patRec.control.propControl.propMaxThresh;
    propSpeedMap = patRec.control.propControl.propSpeedMap;
    
    % Extract tSet indicies
    nCh = length(patRec.nCh);
    selFeature = patRec.control.propControl.propFeature;
    idx = nCh*(selFeature-1)+1:nCh*(selFeature-1)+nCh;
    
    % Calculate Feature value
    featureVal = abs( mean( tSet(idx) ) );
    
    % Map Feature value to speed percent
    speedPercent = CalculateDesiredSpeedPercent(featureVal, propMinThresh, ...
        propMaxThresh, propSpeedMap);
    
    % Output Speeds
    patRec.control.currentDegPerMov = patRec.control.maxDegPerMov.*speedPercent'.*0.01;

% If not proportional control is used, set speed to maximum speed    
else
    patRec.control.currentDegPerMov = patRec.control.maxDegPerMov;
end