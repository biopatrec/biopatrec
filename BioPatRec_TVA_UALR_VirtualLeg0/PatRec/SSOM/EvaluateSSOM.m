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
% 2012-09-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function [tempSSOM accV]=EvaluateSSOM(trSet, trOut, vSet, vOut,tType,algConf)
graph2d   = 1; %
%graphUdMat   = 1;
maxSim=50;    %max simulation
passV = 0;     % Pass test of the validation test
sim=0;
SSOM=InitSSOM(trSet,trOut,algConf); %

tempSSOM=SSOM;


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
        SSOM=SSOMStochasticTraining(trSet,SSOM,trOut);
        % Batch Trainig
    elseif strcmp(tType,'Batch')
        SSOM=SSOMBatchTrainig(SSOM,trSet,maxSim,sim);
        % error
    else
        disp('Select Training Method.');
        errordlg('Select Training Method.');
        error('Select Training Method.');
        
    end
    % test of the validation set
    [apV,rmse(sim) ]=FastTestSSOM(SSOM,vOut,vSet);
    SSOM.apV = apV;
    SSOM.fV = rmse(sim);
    
    
    % Save the best so far
    if SSOM.apV >= tempSSOM.apV && SSOM.fV <= tempSSOM.fV
        tempSSOM = SSOM;
    end
    
   
    
    if graph2d  % 2D Graph
        plotvector = get(hbestplot,'YData');
        plotvector(sim) = rmse(sim);
        set(hbestplot,'YData',plotvector);
        set(htext,'String',sprintf('Best RMSE: %4.4f',tempSSOM.fV));
        
        drawnow;
    end
    
end

if tempSSOM.fV < 0.1 || tempSSOM.apV > 95
    passV = 1;
end

[apV fV]=FullTestSSOM(tempSSOM,vOut,vSet);
accV=apV;
tempSSOM.apV=apV;
tempSSOM.fV=fV;

% Visualize Som
if algConf.visualizeSOM
    tempSSOM.neuroLabel=GetNeuronLabel(trSet,tempSSOM);
    ShowUDMatrix(tempSSOM)
    
end

disp(['Simulations: ' num2str(sim)]);
disp(['General rmse: ' num2str(rmse(sim))]);
disp('RMES V: ');
disp(tempSSOM.fV');
disp('Acc V: ');
disp(tempSSOM.apV');

if passV
    disp('%%%%%%%%%%% Supervised SOM training completed %%%%%%%%%%%%%');
    
else
    
    disp('%%%%%%%%%%% Supervised SOM training failed %%%%%%%%%%%%%');
end


close(hfig);