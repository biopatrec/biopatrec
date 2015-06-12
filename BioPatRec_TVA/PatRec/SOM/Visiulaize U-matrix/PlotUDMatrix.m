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
%  Function to plot the U-matrix. 
%
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-08-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function PlotUDMatrix(SOM,color,mode,coords,UDMatNeuron,xSpotSize)

%the spot vertices
neurSyntax=SyntaxNeuron(SOM.shape);
if size(xSpotSize,1)>1
    xSpotSize=repmat(xSpotSize',size(neurSyntax,1),1);
    ySpotSize=xSpotSize;
else
    ySpotSize=xSpotSize;
end
x=repmat(coords(:,1)',size(neurSyntax,1),1);
y=repmat(coords(:,2)',size(neurSyntax,1),1);

xNeurSyntax=repmat(neurSyntax(:,1),1,UDMatNeuron);
yNeurSyntax=repmat(neurSyntax(:,2),1,UDMatNeuron);

xNeurSyntax=(x./xSpotSize+xNeurSyntax).*xSpotSize;
yNeurSyntax=(y./ySpotSize+yNeurSyntax).*ySpotSize;

map=patch(xNeurSyntax,yNeurSyntax,color);
if strcmp(mode,'Umat')
    
    set(map,'EdgeColor','none');
end
colorbar('vert')
