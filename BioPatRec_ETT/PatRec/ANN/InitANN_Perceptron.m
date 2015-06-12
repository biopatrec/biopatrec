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
% Funtion to initialize the Artificial Neural Network
% Note: The struct and evaluation algorithms could be shorter but less
% comprehensible
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2009-07-23 / Max Ortiz  / Creation
% 2009-11-09 / Max Ortiz  / Initialization of v, phi and lg to consider a number
%                           of output higer than the number of neurons in the hiden layer
% 2011-09-10 / Max Ortiz  / New routine for BioPatRec based in previous 
%                           implementation for EMG_AQ
% 20xx-xx-xx / Author  / Comment on update

function ANN = InitANN_Perceptron(nIn,nHn,nOn)

ANN.Type    = 'Perceptron';
ANN.nIn     = nIn;
ANN.nHn     = nHn;
ANN.nOn     = nOn;
ANN.w       = zeros(max([nHn nIn nOn]),max([nHn nIn nOn]),length(nHn)+1);  % weight
ANN.b       = zeros(max([nHn nOn]),length(nHn)+1);        % bias
ANN.o       = zeros(nOn,1);                         % output
ANN.a       = 1;                                    % amplitud for activation function

% Back Propagation Algorithm
ANN.v       = zeros(max([nHn nOn]),length(nHn)+1);        % induced activation field
ANN.phi     = zeros(max([nHn nOn]),length(nHn));          % activation function or output
ANN.lg      = zeros(max([nHn nOn]),length(nHn)+1);        % local gradient (lower delta)
ANN.dw      = zeros(max([nHn nIn nOn]),max([nHn nIn nOn]),length(nHn)+1);  % capital delta weight or change in weight
ANN.db      = zeros(max([nHn nOn]),length(nHn)+1);                              % capital delta weight or change in weight of bias

% Evolutionary Algorithm and PSO
ANN.aTr     = 0;
ANN.apTr    = 0;
ANN.fTr     = inf;

ANN.aV      = 0;
ANN.apV     = 0;
ANN.fV      = inf;

ANN.aT      = 0;
ANN.apT     = 0;
ANN.fT      = inf;



