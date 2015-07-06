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
% Use of the ANN MLP struct
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2009-07-27 / Max Ortiz / Creation
% 2012-06-01 / Max Ortiz / Adapted to new coding standard
% 

function PSO = InitPSO_MLP(ANN)

PSO.sSize   = 20;                          %Swarm size

PSO.nVar    = ANN.nIn * ANN.nHn(1);         % Weight inputs and first layer
PSO.nVar    = PSO.nVar + ANN.nHn(1);        % Bias first layer
for i = 2 : length(ANN.nHn)
    PSO.nVar = PSO.nVar + ANN.nHn(i-1)*ANN.nHn(i);  %Weight hidden layer
    PSO.nVar = PSO.nVar + ANN.nHn(i);               % Bias Hiden Layers
end
PSO.nVar    = PSO.nVar + ANN.nHn(end)*ANN.nOn;  % Weight output
PSO.nVar    = PSO.nVar + ANN.nOn;               % Bias outputs
    
PSO.xMin    = -1;                  %minumum
PSO.xMax    = 1;                   %maximum

PSO.dt      = 1;                   %time step lengh
PSO.alpha   = 1;                    %constant
PSO.c1      = 2;                     %Constant C1
PSO.c2      = 2;                      %Constant C2

PSO.beta    = .6;          %Beta for inertia weight
PSO.w       = 1.4;           %weigh for inertia weight
PSO.pcr     = 0.1;            %Craziness probability

PSO.maxSimulations = 100;  %max number of simulations

% Initialization of Vmax
PSO.vMax = (PSO.xMax - PSO.xMin) / PSO.dt;

PSO.opelite = 1; %input('Do you want to use elite particle? Yes (1) or No (2):       ');
PSO.opcrazy = 1; %input('Do you want to use crazy operator? Yes (1) or No (2):       ');


%Initializations
PSO.positions = PSO.xMin + rand(PSO.sSize,PSO.nVar).*(PSO.xMax - PSO.xMin);
PSO.velocities = InitVelocities(PSO.sSize,PSO.nVar,PSO.xMin,PSO.xMax,PSO.dt,PSO.alpha,PSO.vMax);

% Initialization of best
PSO.fitness(1:PSO.sSize)    = inf;
PSO.pBestFit(1:PSO.sSize)   = inf;
PSO.sBestFit                = inf;
PSO.pBestPos                = zeros(PSO.sSize,PSO.nVar);
