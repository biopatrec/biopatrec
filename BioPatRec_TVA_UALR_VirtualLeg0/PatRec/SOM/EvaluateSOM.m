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
% This function runs the selected training method then it's avoiding the overfitting
% learning by cross validation technique based on evaluation of RMSE.
%
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-06-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function [tempSOM accV]=EvaluateSOM(trSet, trOut, vSet, vOut,tType,algConf)

graph2d   = 1; %

maxSim=50;    %max simulation
 passV=0;
sim=0;
SOM=InitSOM(trSet,trOut,algConf); %

tempSOM=SOM;


if graph2d  % 2D Graph
    hfig = figure;
    hold on
    set(hfig, 'DoubleBuffer','on');
    axis([1 maxSim 0 .3]);
    hbestplot = plot(1:maxSim+1,zeros(1,maxSim+1));
    htext = text(20,0.2,sprintf('Best RMSE: %4.4f',0.0));
    
    xlabel('simulations');
    ylabel('rmse');
    hold off
    drawnow;
end


while sim <= maxSim 
    % Training
    sim = sim + 1;
    %Stochastic Training
    if strcmp(tType,'Stochastic')
        SOM=StochasticTraining(trSet,SOM);
        % Batch Trainig
    elseif strcmp(tType,'Batch')
        SOM=BatchTrainig(SOM,trSet,maxSim,sim);
        % error
    else
        disp('Select Training Method.');
        errordlg('Select Training Method.');
        error('Select Training Method.');
    end
    % add lable for each winnig neuron
    neuroLabel=GetNeuronLabel(trSet,SOM);
    % Save the neuron Label
    SOM.neuroLabel=neuroLabel;
    % test of the validation set
    [apV,rmse(sim)]=FastTestSOM(SOM,vOut,vSet);
    SOM.apV = apV;
    SOM.fV = rmse(sim);
    
    % Save the best so far
    if SOM.apV >= tempSOM.apV && SOM.fV <= tempSOM.fV
        tempSOM = SOM;
    end
    
    
    if graph2d  % 2D Graph
        plotvector = get(hbestplot,'YData');
        plotvector(sim) = rmse(sim);
        set(hbestplot,'YData',plotvector);
        set(htext,'String',sprintf('Best RMSE: %4.4f',tempSOM.fV));
        
        drawnow;
    end
    
end
if tempSOM.fV < 0.1 || tempSOM.apV > 95
    passV = 1;
end
[apV fV]=FullTestSOM(tempSOM,vOut,vSet);
accV=apV;
tempSOM.apV=apV;
tempSOM.fV=fV;
% Visualize U-matrix
if algConf.visualizeSOM
    ShowUDMatrix(tempSOM)
end

disp(['Simulations: ' num2str(sim)]);
disp(['General rmse: ' num2str(rmse(sim))]);
disp('RMES V: ');
disp(tempSOM.fV');
disp('Acc V: ');
disp(tempSOM.apV');


if passV
    disp('%%%%%%%%%%% SOM training completed %%%%%%%%%%%%%');
    
else
    
    disp('%%%%%%%%%%% SOM training failed %%%%%%%%%%%%%');
end

close(hfig);

