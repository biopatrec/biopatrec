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
% Particle Swarm Optimization to find ...
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2009-04-23 / Max Ortiz/ Creation
% 2012-04-01 / Max Ortiz/ Adapted for RFN

function [PSO, connMat] = PSO_RFN(PSO, connMat, vSets, vOuts, thO)

if PSO.opcrazy ~= 1
   PSO.pcr = 0; 
end

% Flat connMat
nM = size(connMat,1);   % Number of movements
nF = size(connMat,2);   % Number of features

% Initialization of best
fitness(1:PSO.sSize)    = inf;
pBestFit(1:PSO.sSize)   = inf;
sBestFit                = inf;


%Run until the max number of generations
for sim = 1:PSO.maxSimulations
    
    %Fitness evaluation
    for i = 1:PSO.sSize
        connMat = DecodeConnMat(PSO.positions(i,:), nM, nF);
        fitness(i) = RegulationFeedbackFit(connMat, vSets, vOuts, nM, thO);
        
        %Particle Best Positions
        if (fitness(i) < pBestFit(i)) 
            pBestFit(i) = fitness(i);                             %particle best fitness
            pBestPos(i,:) = PSO.positions(i,:);                       %particle best position
        end
    end
        
    %Find the best in the swarm
    for i=1:PSO.sSize
        if pBestFit(i) < sBestFit           
            sBestFit = pBestFit(i);             %Swarm best fitness
            sBestPos = PSO.positions(i,:);        %Swarm best position
            
            connMat = DecodeConnMat(sBestPos, nM, nF);               
            disp(RegulationFeedbackAcc(connMat, vSets, vOuts, nM));
        end
    end

    %Update velocity
    for i = 1:PSO.sSize
        cr=rand;
        if cr > PSO.pcr
            tempvel = UpdateVel(i, PSO.velocities, PSO.positions, pBestPos, sBestPos, PSO.c1, PSO.c2, PSO.nVar, PSO.dt, PSO.vMax, PSO.w);
        else
            tempvel = -PSO.vMax + 2 * rand(PSO.nVar,1) * PSO.vMax;
        end
        PSO.velocities(i,:) = tempvel;
    end

    %Reduce inertia weight for velocity
    if PSO.w > 0.3 
        PSO.w = PSO.beta * PSO.w;
    end

    %Update position
    PSO.positions = PSO.positions +  PSO.velocities * PSO.dt;
%     % Limit negative values
     negIdx = find(PSO.positions < 0);
     PSO.positions(negIdx) = 0.0000000001;    
%     % Limit values over 1
    negIdx = find(PSO.positions > 1);
    PSO.positions(negIdx) = 1;    
    
    
    %Elite Particle
    if PSO.opelite == 1
        PSO.positions(1,:) = sBestPos;        %This instruction will always keep the best partical position
    end

    disp(sBestFit);
    
end
% Return the best position
connMat = DecodeConnMat(sBestPos, nM, nF);