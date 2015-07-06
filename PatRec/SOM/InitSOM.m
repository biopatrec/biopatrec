
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
% Funtion to initialize the Artificial Neural Network (SOM).
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-06-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function  SOM=InitSOM(trSet,trOut,algConf)



switch algConf.shape
    case 'Hexagonal Grid'
        shape= 'hexa';
    case 'Rectangular Grid'
        shape='rect';
    case 'Select Shape.'
        
        disp('%%%%%%%%%%Select Shape.%%%%%%%%%%%');
        errordlg('Select Shape.');
        error('Select Shape.');
end
switch algConf.neighFunc
    case 'Bubble'
        neigh='bubb';
    case 'Gaussian'
        neigh='gauss';
    case 'Cutgaussian'
        neigh='cutGauss';
    case 'Triangular'
        neigh='trai';
    case 'Butterworth'
        neigh='butter';
    case 'Select Neighbor Function.'
        disp('%%%%%%%%%%%%%%% Select Neighbor Function.%%%%%%%%%%%%%%%%%');
        errordlg('Select Neighbor Function.');
        error('%%%%%%%%%%%%%%%% Select Neighbor Function.%%%%%%%%%%%%%%%%');
        
end



xUnits=ceil( (size(trSet,1)^0.5)*1.5);  % the grid (map) width
yUnits=ceil( (size(trSet,1)^0.5)*1.5);  % the grid (map) length
etaIni=.5;                      %initial learning rate parameter

sigmaIni=ceil(xUnits/2);        % the initial width of the topologic neighborhood function

tow2=3000;                      % time constant's decay of the learning parameter

tow1=tow2/log(sigmaIni);        % time constant's decay of the initial width of the topologic neighborhood function



mSize=[xUnits yUnits];          % the grid (map) size


mUnits=prod(mSize);             % the total number of neuron

mapCoordinates=NeuronCoordinates(mSize,shape);  % the coordinates of the neuron in the grid and that depends on the grid's shape


dDim=size(trSet,2);            % number of data variable

w=RandomWeights(xUnits*yUnits,dDim,trSet); % initial weigth for each neuron in the grid where each neuron has the same  number of data variable
% Unit Distance
neuronDist = NeuronDistances(mSize,mapCoordinates);

%%

% those parameters are for the batch training

%mask     = ones(dDim,1);

radiusIni =max(1,ceil(max(mSize)/2)); % the initial width of the topologic neighborhood function
radiusFin=.01;                          % the final width of the topologic neighborhood function

%%
SOM.t=1;
SOM.sigmaIni=sigmaIni;
SOM.tow1=tow1;
SOM.etaIni=etaIni;
SOM.tow2=tow2;
SOM.w=w;
SOM.mapCoordinates=mapCoordinates;
SOM.apV=0;
SOM.fV=Inf;
SOM.mSize=mSize;
SOM.trOut=trOut;
SOM.mUnits=mUnits;
SOM.radiusIni=radiusIni;
SOM.radiusFin=radiusFin;
SOM.neuronDist=neuronDist;
%SOM.mask=mask;
SOM.shape=shape;
SOM.neighFunc=neigh;




