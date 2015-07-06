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
%  Function to shwo Unified Distance Matrix (U-matrix).The implementation of  
%  visulising U-matrix is done according to Juha Vesanto, Johan Himberg, 
%  Esa Alhoniemi and Parhankangs,''SOM Toolbox'',Helsinki University of Technology
%  ,ISBN 951-22-4951-0.
%  
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-08-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function ShowUDMatrix(SOM)

figure
colormap(1-gray)
ax=newplot;
set(ax,'Visible','off');
set(get(ax,'Title'),'Visible','on');
set(ax,'XaxisLocation','Top');
% get the Unified Distance Matrix that is the distance between each two neighbors neuron
% in the map which is represente the intermediate spot between thos two neighbors in UDMat.
colorUDMat=CreateUDMat(SOM.w,SOM.mSize,SOM.shape);

% the size of the Unified Distance Matrix (UDMat).
UDMatSize=[2*SOM.mSize(1)-1 2*SOM.mSize(2)-1];
UDMatNeur=UDMatSize(1)*UDMatSize(2);
colorUDMat=colorUDMat(:);

% % the neuron of the original map will have white color (empty not relate to any mov.)
% [indxNeurMap ,~]=find(colorUDMat==0);

% the coordinats of each spot in UDMat.
coords=UDMatCoords(UDMatSize,SOM.shape,'Umat');

% show the spot of the UDMat without edges in different gray level.
PlotUDMatrix(SOM,colorUDMat','Umat',coords,UDMatNeur,.5)

% get different color for the winning neuron (active neuron);
[colorMat indx sizeNeurSpot mixColor]=GetColor(SOM);

% the coordinats of the only neurons in the map not in UDMat.
coords=UDMatCoords(SOM.mSize,SOM.shape,'Hit');

% % show the neuron spot of the original map with edges with white color. 
% plotUDMatrix(SOM,colorUDMat(indxNeurMap)','All',Coords,size(Coords,1),.5)

% the size of the neuron spot.
sizeNeurSpot=sizeNeurSpot(indx,:);

% the coordinats of only the winning neuron (active) in the map.
coords=coords(indx,:);

% the color of only the winning neuron (active) in the map.
mixColor=mixColor(indx,:);

for i=1:size(mixColor,2)
% the index of the wining neurons of mixColor i  
[ind,~]=find(sizeNeurSpot(:,i)~=0);

% the coordinate of the wining neurons of mixColor i  
coordsHit=coords(ind,:);

% the spot size of the wining neurons of mixColor i  
spotSize=sizeNeurSpot(ind,i);

% number of winning neurons
hitNeurons=size(coordsHit,1);

% the color of the mixcolor i.
color=colorMat(mixColor(ind,i),:);
color=reshape(color,[1 hitNeurons 3]);

% show the wining neuron spot of the map with edges with different color mov. 
PlotUDMatrix(SOM,color,'Hit',coordsHit,hitNeurons,spotSize)
end
