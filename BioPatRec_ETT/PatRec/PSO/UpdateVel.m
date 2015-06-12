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
% 2009-07-27 / Max Ortiz/ Creation
% 2012-03-29 / Max Ortiz/ Adapted for BioPatRec from EMG_AQ

function tempvel = UpdateVel(pos, velocities, positions, pBestPos, sBestPos, c1, c2, nVar, dt,vMax, w)

tempvel = zeros(nVar,1);
for j = 1:nVar
    q=rand;
    r=rand;
    tempvel(j) = w * velocities(pos,j) + c1*q*((pBestPos(pos,j) - positions(pos,j))/dt) +...
                    c2*r*((sBestPos(j) - positions(pos,j))/dt);

%     % Contain velocity            
%     if tempvel(j) < -vMax
%         tempvel(j) = -vMax;
%     elseif tempvel(j) > vMax
%         tempvel(j) = vMax;
%     end
    
    % Contain velocity considering inertial weight           
    if tempvel(j) < -vMax
        tempvel(j) = w * -vMax;
    elseif tempvel(j) > vMax
        tempvel(j) = w * vMax;
    end

end