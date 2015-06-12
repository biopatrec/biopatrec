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
% Function to initialize the positions according to the range
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2009-07-27 / Max Ortiz  / Creation
% 2012-03-27 / Max Ortiz  / Adapted for BioPatRec from EMG_AQ
% 2012-06-03 / Max Ortiz  / Commented the velocity validation, it's not
%                           necessary since vMax is set for the xMax-xMin range.

function vel = InitVelocities(sSize, nVar, xMin, xMax, dt, alpha, vMax)

vel = alpha .* (xMin + rand(sSize,nVar) .* (xMax - xMin)) ./ dt;

% for i = 1:sSize
%     for j = 1:nVar
%         if vel(i,j) < 0 && vel(i,j) < -vMax
%             vel(i,j) = vMax * -1;
%         elseif vel(i,j) > 0 && vel(i,j) > vMax
%             vel(i,j) = vMax;
%         end
%     end
% end