% pathLength = CalculatePathLength(ssTraj,target,allowance)
%
%   Calculates path length of a state space trajectory, removing any
%   movements within the allowance space.
%
%   INPUTS:
%
%       ssTraj - Coordinates of the trajectrory in state space, each
%       coordinate should be stored in the rows of the matrix ssTraj.
%
%       target - Coordinates to the target in state space, should be a
%       row vector.
%
%       allowance - the number of degrees that are considered to be close
%       enough to the target. The allowance space is contained by the box 
%       target (plus minus) allowance / 2.

function pathLength = CalculatePathLength(ssTraj,target,allowance)

pathLength = 0;

posOld = ssTraj(1,:);
for iPos = 2:size(ssTraj,1)
    
    posNew = ssTraj(iPos,:);
    
    % Check if system jumped into allowance space
    if InAllowanceSpace(posNew,target,allowance) && ~InAllowanceSpace(posOld,target,allowance)
        
        crossingPoint = FindCrossing(posOld,posNew,target,allowance);
        pathLength = pathLength + norm(crossingPoint - posOld);
        
    % Check if system jumped out of allowance space
    elseif InAllowanceSpace(posOld,target,allowance) && ~InAllowanceSpace(posNew,target,allowance)
        
        crossingPoint = FindCrossing( posNew, posOld,target,allowance );
        pathLength = pathLength + norm(crossingPoint - posNew);
        
    % Check if trajectory is inside allowance space
    elseif InAllowanceSpace(posOld,target,allowance) && InAllowanceSpace(posNew,target,allowance)
    
    % Check if trajectory is outside of allowance space
    elseif ~InAllowanceSpace(posOld,target,allowance) && ~InAllowanceSpace(posNew,target,allowance)
        pathLength = pathLength + norm(posNew - posOld);
    end
    
    posOld = posNew;
    
end

function crossingPoint = FindCrossing(posOut,posIn,target,allowance)

len = norm( posIn - posOut ); % Calculate length between posOld and posNew
dir = (posIn - posOut)./len; % Calculate unity direction between pos1 and pos2

while len > 1e-5
    
    posTmp = posOut+len/2.*dir; % Take half a step between out and in
    
    % If the new position is inside the allowance space we have stepped too far
    if InAllowanceSpace(posTmp,target,allowance)
        posIn = posTmp; % move the inside position to tmp position
    
    % else if it is outside we have stepped to short
    else
        posOut = posTmp; % move the outside position to tmp position
    end
        
    len = norm( posIn - posOut ); % recalculate the length between the two points
    
end

crossingPoint = posIn;

function inside = InAllowanceSpace(pos,target,allowance)

inside = 0;

if norm(pos-target) < allowance
    inside = 1;
end