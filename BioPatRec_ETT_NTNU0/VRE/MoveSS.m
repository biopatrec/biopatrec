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
% Function used by the StateSpaceTracker, moves the system in the state
% space using 
%       - Last Position
%       - movement matrix
%       - outMovIdx ( separate for all combined movements, used with movement matrix )
%       - outMov ( multiple indexes, one for each DoF, used with speeds )
%       - speeds
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-11-23 / Joel Falk-Dahlin  / Creation
% 20xx-xx-xx / Author  / Comment on update

function ssPos = MoveSS(ssPos,movMatrix,outMov,speeds)

% Only take the desired movements from movMatrix
%movMat = movMatrix(outMovIdx,:);
movMat = movMatrix(outMov,:);
% Take the desired speeds (1 for individual, several for simultaneous)
speeds = speeds(outMov);

for i = 1:size(movMat,1)
    %movMat(i,:) = movMat(i,:)./norm(movMat(i,:)); % Normalize each movement
    movMat(i,:) = movMat(i,:).*speeds(i);
end

% Sum up simultaneous movements to a single movement
movMat = sum(movMat,1);

    
ssPos = ssPos + movMat; % Move the position in state space

% % Limit each dimension to the range [-50,50] (Nichlas percent units)
% ssPos( ssPos > 50 ) = 50;
% ssPos( ssPos < -50 ) = -50;

% Create Boundary inside state space
ssPos( ssPos > 90 ) = 90;
ssPos( ssPos < -90 ) = -90;

% Open / Close hand work differently, can only move a 100 degrees
if ssPos(1) > 50
    ssPos(1) = 50;
elseif ssPos(1) < -50
    ssPos(1) = -50;
end
