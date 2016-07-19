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
%
% Initialization and training of the GLM based in the open source: NetLab
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-10-29 / Cosima Prahm / Creation 
% 20xx-xx-xx / Authors      / Comments



function [GLM, acc] = NetLab_GLM_InitAndTrain(trSet, trOut, vSet, vOut, tType)

%% Initialize GLM
nOn = size(trOut,2);     % Number of output neurons
nIn = size(trSet,2);     % Number of input neurons
maxItr = 200;            % Maximum number iterations

% Selection of output function
if strcmp(tType, 'softmax')
    ofun = 'softmax';
elseif strcmp(tType, 'linear')
    ofun = 'linear';
elseif strcmp(tType, 'logistic')
    ofun = 'logistic';
else
    ofun = 'softmax';
    disp([tType ' is not available, ' ofun ' is used'])
end

% Initilization of GLM    
GLM = glm(nIn, nOn, ofun);  % all possible output functions available


%% Train GLM
options = foptions();    % Standard options
options(14) = maxItr;    % Maximum Iterations

GLM = netopt(GLM, options, [trSet; vSet], [trOut; vOut], 'scg');

acc = 0;


end