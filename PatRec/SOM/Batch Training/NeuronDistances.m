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
% Function to find the distance between each neuron inside the grid
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-06-15 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update


function dis=NeuronDistances(msize,coords)

nNurons = prod(msize);
dis = zeros(nNurons,nNurons);

% calculate distance from each location to each other location

for i=1:(nNurons-1),
    indx = [(i+1):nNurons];
    
    dis(i,indx)=VectorDistance(coords(indx,:),coords(repmat([1]*i,nNurons-i,1),:))';
    
end

dis = dis + dis';