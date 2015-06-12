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
% Function to track the state space position of the system during TAC-test
% The results can be viewed in GUI_SSPresentation later.
%
% TrackStateSpace('initialize',patRec,allowance) - Initializes all
%    parameters needed to keep track of the state space system. Should be
%    executed before TAC-test starts
%
% TrackStateSpace('target', movIndex, distance) - Creates a target position
%    in state space. movIndex should be the patRec.movOutIdx, that
%    corresponds to the targeted motion, distance a number that sets the
%    distance to the target in all DoFs.
%
% TrackStateSpace('move', outMov, speeds) - Moves the system in state space
%
% ssTracker = TrackStateSpace('read') - Return a structure containing all
%    the state space information.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-11-23 / Joel Falk-Dahlin  / Creation
% 20xx-xx-xx / Author  / Comment on update

function  ssObj = TrackStateSpace(varargin)

persistent classifiers controllers controlParams movMatrix ssTargets ssTrajectories allowance

if ischar(varargin{1})
    
    if strcmpi(varargin{1},'initialize')
        
        patRec = varargin{2};
        allowance = varargin{3};
        
        movMatrix = CreateMovMatrix(patRec);
        ssTargets = [];
        ssTrajectories = [];
        
        classifiers = {patRec};
        
        if isfield(patRec,'controlAlg')
            
            controllers = patRec.controlAlg.name;
            controlParams = {cell(1,1)};
            params = fieldnames(patRec.controlAlg.parameters);
            paramVec = [];
            for i = 1:length(params)
                paramName = params(i);
                paramValue = patRec.controlAlg.parameters.(params{i});
                paramVec = [paramVec; paramName, {paramValue}];
            end
            controlParams{1}{1} = paramVec;
            
        else
            controllers = {'None'};
            controlParams = {{[]}};
        end
        
    elseif strcmpi(varargin{1},'target')
        
        index = varargin{2};
        distance = varargin{3};
        
        if length(index) > 1
            movement = sum( movMatrix(index,:) );
        else
            movement = movMatrix(index,:);
        end
        
        newTarget = movement.*distance;
        ssTargets = [ssTargets, {newTarget}]; % Save the new target
        
        ssTrajectories = [ssTrajectories; {[0, 0, 0]}];   % Create new position
        
    elseif strcmpi(varargin{1},'move')
        
        ssTrajectory = ssTrajectories{end};
        ssPos = ssTrajectory(end,:);
        outMov = varargin{2};
        speeds = varargin{3};
        
%         outMovIdx = [];
         
%         for i = 1:length(classifiers{1}.movOutIdx)
%             if length(outMov) == length(classifiers{1}.movOutIdx{i})
%                 if classifiers{1}.movOutIdx{i} == outMov'
%                     outMovIdx = i;
%                     break;
%                 end
%             end
%         end
%         
%         if isempty(outMovIdx)
%             outMovIdx = length(classifiers{1}.movOutIdx);
%         end
        
        newPos = MoveSS(ssPos,movMatrix,outMov,speeds); % Calculate new position in state space
        
        newTrajectory = [ssTrajectory; newPos]; % Update the trajectory
        ssTrajectories{end} = newTrajectory; % Save the trajectory
        
    elseif strcmpi(varargin{1},'read')
        
        ssObj.classifiers = classifiers;
        ssObj.controllers = controllers;
        ssObj.controlParams = controlParams;

        ssObj.ssTrajectories = ssTrajectories;
        
        ssObj.ssTargets = ssTargets;
        ssObj.nReps = 1;
        ssObj.allowance = allowance;
        
    elseif strcmpi(varargin{1},'single')
        ssTrajectory = ssTrajectories{end};
        ssTarget = ssTargets{end};
        
        
        userPath = CalculatePathLength(ssTrajectory, ssTarget, allowance);
        perfectPath = CalculatePathLength([0 0 0; ssTarget], ssTarget, allowance);
        
        %Will round the value to nearest value with accuracy of 3-decimal
        %places.
        ssObj = round((perfectPath / userPath)*1000) / 1000;
    end
    
else

end