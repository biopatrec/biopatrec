
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
% Funtion to initialize the Artificial Neural Network (Supervised SOM).
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-09-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function  SSOM=InitSSOM(trSet,trOut,algConf)


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



sizeSSOMOut=size(trOut,2);
% the grid (map) width
xUnits=ceil( (size(trSet,1)^0.5)*1.5); 
% the grid (map) length
yUnits=ceil( (size(trSet,1)^0.5)*1.5); 
%initial learning rate parameter
etaIni=.5;                      
% the initial width of the topologic neighborhood function
sigmaIni=ceil(xUnits/2);        
% time constant's decay of the learning parameter
tow2=3000;
% time constant's decay of the initial width of the topologic neighborhood function
tow1=tow2/log(sigmaIni);        
% the grid (map) size
mSize=[xUnits yUnits];          
% the total number of neuron
mUnits=prod(mSize);             
SSOMOut=zeros(mUnits,size(trSet,2));
% the coordinates of the neuron in the grid and that depends on the grid's shape here i used the hexa shape
mapCoordinates=NeuronCoordinates(mSize,shape);  
% number of data variables
dDim=size(trSet,2);            
% initial weigth for each neuron in the grid where each neuron has the same  number of data variable
w=RandomWeights(xUnits*yUnits,dDim,trSet); 
%%

% those parameters are for the batch training


% Unit Distance 
neuronDist = NeuronDistances(mSize,mapCoordinates);
% the initial width of the topologic neighborhood function
radiusIni =max(1,ceil(max(mSize)/2));
% the final width of the topologic neighborhood function
radiusFin=.01;                          

%%
SSOM.t=1;
SSOM.sigmaIni=sigmaIni;
SSOM.tow1=tow1;
SSOM.etaIni=etaIni;
SSOM.tow2=tow2;
SSOM.w=w;
SSOM.mapCoordinates=mapCoordinates;
SSOM.apV=0;
SSOM.fV=Inf;
SSOM.mSize=mSize;
SSOM.trOut=trOut;
SSOM.mUnits=mUnits;
SSOM.radiusIni=radiusIni;
SSOM.radiusFin=radiusFin;
SSOM.neuronDist=neuronDist;
SSOM.SSOMOut=SSOMOut;
SSOM.sizeSSOMOut=sizeSSOMOut;

SSOM.shape=shape;
SSOM.neighFunc=neigh;



