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
% Function to train the Artificial Neural Network using the so called Back
% Propagation Algorithm
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2009-07-22 / Max Ortiz  / Creation
% 2009-10-27 / Max Ortiz  / Reset update
% 2011-09-10 / Max Ortiz  / New routine for BioPatRec based in previous implementation
%                           for EMG_AQ
% 2011-09-10 / Max Ortiz  / Optimized for speed. Creationg of FastTestANN and
%                           FullTestANN routines
% 2012-04-01 / Max Ortiz  / Change condition of passV to break training
%                           faster
% 20xx-xx-xx / Author  / Comment on update

function [ANN acc] = ANN_Perceptron(trSet, trOut, vSet, vOut, tType)

%% Settings
graph2d   = 1;     % Show 2D graph
nRepF     = 400;   % Number of repeated rmse before restart
maxItr    = 200;   % Maximum number iterations
batchTr   = 0;     % Batch training (1) or sthocastic training (0)

%% Initialize Artificial Neural Network, PSO and EA
nOn = size(trOut,2);    % Number of output neurons
nIn = size(trSet,2);    % Number of input neurons
nHn = [nIn nIn];    % Number of hiden neurons
%nHn = [nIn*2 nIn*2 nIn*2 nIn*2];    
%nHn = nIn*3;    % Number of hiden neurons

ANN  = InitANN_Perceptron(nIn,nHn,nOn);

% Randomize weights -+1 
ANN.w(1:max([nHn nIn nOn]),1:max([nHn nIn nOn]),1:length(nHn)+1) = -1 + rand(max([nHn nIn nOn]),max([nHn nIn nOn]),length(nHn)+1) .* 2;  % weight
ANN.b(1:max(nHn),1:length(nHn)+1)                                = -1 + rand(max(nHn),length(nHn)+1) .* 2;        % bias
tempANN = ANN;

% For Brackpropagation
eta       = 0.1;   % learning rate      
alpha     = 0.1;      
% For PSO
if strcmp(tType,'PSO')
    PSO = InitPSO_MLP(ANN);
end


%% Train and test the ANN
% Variables for the run
rmse     = zeros(1,maxItr);
sim         = 0;
eval        = 0;
passV       = 0;     % Pass test of the validation test
resetFlag   = 0;                
nTrSets     = length(trOut(:,1));

if batchTr
    nEvalRun = nTrSets;
else
    nEvalRun = fix(nTrSets*.7);
end

% Graph -------------------------
if graph2d
    hfig = figure;
    hold on
    set(hfig, 'DoubleBuffer','on');
    axis([1 maxItr 0 .3]);
    hbestplot = plot(1:maxItr+1,zeros(1,maxItr+1));
    htext = text(50,0.2,sprintf('best: %4.3f',0.0));
    xlabel('simulations');
    ylabel('rmse');
    hold off
    drawnow;
end
% --------------------------------

while sim <= maxItr && passV == 0
    sim = sim + 1;

    %% Training
    % randomize the training sets
    p = randperm(nTrSets);
    % train ANN
    if strcmp(tType,'Backpropagation')
        for i = 1 : nEvalRun
            ANN = EvaluateANN(trSet(p(i),:), ANN);
            ANN = Backpropagation(trSet(p(i),:),trOut(p(i),:),ANN, eta, alpha);
        end
    elseif strcmp(tType,'PSO')     
        
        [PSO, ANN] = PSO_MLP(PSO, ANN, trSet(p(1:nEvalRun),:),trOut(p(1:nEvalRun),:));                

    end
    % Quantify the number of evaluations
    eval = eval + nEvalRun;

    %% Validaion
    [apV, rmse(sim)] = FastTestANN(ANN,vSet,vOut);
    ANN.apV = apV;
    ANN.fV = rmse(sim);    

    % Save best bpANN so far
    if ANN.apV >= tempANN.apV && ANN.fV <= tempANN.fV 
        tempANN = ANN;  
    end

    % Stop training if fitness is less than 0.1 and no progress is observed
    if ANN.fV < 0.1
        if mean(rmse(sim-fix(sim/5):sim)) < mean(rmse(sim-fix(sim/15):sim))
        %if mean(rmse(sim-fix(sim/3):sim)) < mean(rmse(sim-fix(sim/15):sim))
        %if mean(rmse(sim-10:sim)) < mean(rmse(sim-5:sim)) % Not good for fast trainings
            passV = 1;
        end
    end
    
    % Stop training if rmse is les than 1 for both Tr and V
    % Validation of trSet
    %[apTr, rmseTr] = FastTestANN(ANN,trSet,trOut);
    %ANN.apTr = apTr;
    %ANN.fTr = rmseTr;
    %if ANN.fTr < 0.1 && ANN.fV < 0.1 
    %    passV = 1;
    %end

    % Reset Back P
    if sim >= 1 + nRepF * (resetFlag + 1)
        if mean(rmse(sim-fix(nRepF/4):sim)) <= mean(rmse(sim-10:sim))      % Consider the last 1/4 of the training to 
            if ANN.fTr < 0.1 && (min(rmse(sim-5)) < 0.1 || ANN.apV > 90)
                passV = 1;
            else
                %set(handles.t_msg,'String','Reset BP...');        
                disp('Reset training...');
                resetFlag = resetFlag + 1;
                %set(handles.t_bpRes,'String',num2str(resetFlag));
                ANN.w(1:max([nHn nIn nOn]),1:max([nHn nIn nOn]),1:length(nHn)+1) = -1 + rand(max([nHn nIn nOn]),max([nHn nIn nOn]),length(nHn)+1) .* 2;  % weight
                ANN.b(1:max(nHn),1:length(nHn)+1)                                = -1 + rand(max(nHn),length(nHn)+1) .* 2;        % bias
            end
        end
    end
    
    % 2D Graph
    if graph2d
        plotvector = get(hbestplot,'YData');
        plotvector(sim) = rmse(sim);
        set(hbestplot,'YData',plotvector);
        set(htext,'String',sprintf('best: %4.3f',tempANN.fV));
        drawnow;        
    end
end

% Accept training if the fitness of the validation set < 0.1 and acc > 95
if ANN.fV < 0.1 || ANN.apV > 95
    passV = 1;
end

% Full TEST of the ANNs
ANN = tempANN;
[apTr, fTr, aTr] = FullTestANN(ANN,trSet,trOut);
ANN.aTr  = aTr;
ANN.apTr = apTr;
ANN.fTr  = fTr;

[apV, fV, aV] = FullTestANN(ANN,vSet,vOut);
ANN.aV  = aV;
ANN.apV = apV;
ANN.fV  = fV;

% General info on training performance
ANN.eval = eval;
ANN.sim = sim;

% Return accuracy for the validation set
acc = apV;

% Messages

disp(['Simulations: ' num2str(sim)]);
disp(['General rmse: ' num2str(rmse(sim))]);
disp('RMES V: ');
disp(ANN.fV);
disp('Acc V: ');
disp(ANN.apV);


if passV
    disp('%%%%%%%%%%% ANN training completed %%%%%%%%%%%%%');
%    set(handles.t_msg,'String','ANNs training done');
else
%    set(handles.t_msg,'String','ANNs training not successful');
    disp('%%%%%%%%%%% ANN training failed %%%%%%%%%%%%%');
end

close(hfig);

