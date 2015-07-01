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
% Initialization of PSO for RFN
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2009-07-27 / Max Ortiz/ Creation
% 2012-03-29 / Max Ortiz/ Adapted for RFN

function PSO = InitPSO_RFN(connMat)

PSO.sSize   = 20;                                %Swarm size
PSO.nVar    = size(connMat,1)*size(connMat,2);   %Number of variables
PSO.xMin    = 0;                               %minumum
PSO.xMax    = 1;                                %maximum

PSO.dt      = 1;                   %time spet lengh
PSO.alpha   = 1;                    %constant
PSO.c1      = 2;                     %Constant C1
PSO.c2      = 2;                      %Constant C2

PSO.beta    = .9;          %Beta for inertia weight
PSO.w       = 1.4;          %weigh for inertia weight
PSO.pcr     = 0.1;          %Craziness probability

PSO.maxSimulations = 50;  %max number of simulations

% Initialization of Vmax
PSO.vMax = (PSO.xMax - PSO.xMin) / PSO.dt;

PSO.opelite = 1; %input('Do you want to use elite particle? Yes (1) or No (2):       ');
PSO.opcrazy = 1; %input('Do you want to use crazy operator? Yes (1) or No (2):       ');

% Flat connMat
cM = [];
for i=1:size(connMat,1)
    cM = [cM connMat(i,:)];
end

%Initializations
% The first position will be as the connMat
PSO.positions(1,:) = cM;   
% The remianing position will vary +-.5
for i = 2 : PSO.sSize
    randPos = -.5 + rand(1,PSO.nVar); % the rest +- .5
    PSO.positions(i,:) = cM + randPos;
    
     % Limit negative values
     negIdx = find(PSO.positions(i,:) < 0);
     PSO.positions(i,negIdx) = 0.0000000001;    
     % Limit values over 1
     negIdx = find(PSO.positions(i,:) > 1);
     PSO.positions(i,negIdx) = 1; 
    
end

% Random initialization of the position
% PSO.positions = PSO.xMin + rand(PSO.sSize,PSO.nVar).*(PSO.xMax - PSO.xMin);

PSO.velocities = InitVelocities(PSO.sSize,PSO.nVar,PSO.xMin,PSO.xMax,PSO.dt,PSO.alpha,PSO.vMax);






