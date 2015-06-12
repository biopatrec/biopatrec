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
% Function to create the map grid, it's used to create  hexagonal and rectangular
% grid
% Note: The Hexagonal shape implemented in the same way of SOM toolbox Team[1]
%
% [1]-Juha Vesanto, Johan Himberg, Esa Alhoniemi, and Parhankangs
%     SOM Toolbox Team ,Helsinki University of Technology.
%     http://www.cis.hut.fi/somtoolbox/package/papers/techrep.pdf
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-06-15 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function coords=NeuronCoordinates(mSize,shape)


nNurons = prod(mSize);
xUnits=mSize(1);
yUnits=mSize(2);
coords = zeros(nNurons,2);

if strcmp(shape,'hexa')
[coords(:,1) coords(:,2)]=ind2sub([xUnits yUnits], 1:nNurons);
coords(:,[1 2]) = fliplr(coords(:,[1 2]));
rowIndx = (cumsum(repmat([1],yUnits,1))-1)*xUnits;
for i=2:2:xUnits,
    coords(i+rowIndx,1) = coords(i+rowIndx,1) + 0.5;
end

elseif strcmp(shape,'rect')
    [coords(:,1) coords(:,2)]=ind2sub([xUnits yUnits], 1:nNurons);
end

