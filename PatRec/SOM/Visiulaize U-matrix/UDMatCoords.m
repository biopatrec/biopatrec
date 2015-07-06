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
%  Function to create neurons coordinates
%
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-08-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function coords=UDMatCoords(mSize,shape,mode)
nNurons = prod(mSize);
xUnits=mSize(1);
yUnits=mSize(2);

switch mode
    case'Hit'% wining neuron (active neuron).
        % rectangular shape
        [coords(:,1) coords(:,2)]=ind2sub([xUnits yUnits], 1:nNurons);
        % hexa shape
        if strcmp(shape,'hexa')
            coords(:,[1 2]) = fliplr(coords(:,[1 2]));
            location=rem(coords(:,2),2) == 0;
            coords(location,1)=coords(location,1)+.5;
        end
    case'Umat' % Unified Distance Matrix
        % rectangular shape
        [coords(:,1) coords(:,2)]=ind2sub([xUnits yUnits], 1:nNurons);
        % hexa shape
        if strcmp(shape,'hexa')
            coords(:,[1 2]) = fliplr(coords(:,[1 2]));
            location=rem(coords(:,2),2) == 0;
            coords(location,1)=coords(location,1)+.5;
            location=rem(coords(:,2)+1,4) == 0;
            coords(location,1)=coords(location,1)+1;
        end
        coords=coords/2+.5;
        
end

