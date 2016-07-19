function [MLP, acc] = NetLab_MLP_InitAndTrain(trSet, trOut, vSet, vOut, tType)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



%% Initialize Multi Layer Perceptron
nOn = size(trOut,2);     % Number of output neurons
nIn = size(trSet,2);     % Number of input neurons
nHn = ((nIn)+nOn);       % Number of hiden neurons --> more hidden units->more iterations necessary
maxItr = 200;            % Maximum number iterations


% Selection of output function for proportional control
if strcmp(tType, 'proportional')
    ofunc = 'softmax';
    prop = 1; %proportional control
elseif strcmp(tType, 'proportional logistic')
    ofunc = 'logistic';
    prop = 1; %proportional control
else
    ofunc = tType;
    prop = 0;
end

% Initilization of MLP    
MLP(1) = mlp(nIn, nHn, nOn, ofunc);  %Softmax is best, if only one output can be activated
%MLP = mlp(nIn, nHn, nOn, 'logistic'); 

%% Train Multi Layer Perceptron
options = foptions();    % Standard options
options(14) = maxItr;    % Maximum Iterations
% training with both trSet and vSet (internal training validation)
MLP(1) = netopt(MLP(1), options, [trSet; vSet], [trOut; vOut], 'scg');

if prop %additional net for proportional output, not executed if no proportional output selected
    MLP(2) = mlp(nIn, 4, 1, 'linear');
    MLP(2) = netopt( MLP(2), options, [trSet; vSet], (1-[trOut(:,end); vOut(:,end)]), 'scg' );
end

acc = 0;


end