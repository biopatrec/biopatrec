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
% Function to update the Weight matrix
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-06-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function newW=UpdateWeights(i0,x,w,eta,sigma,SOM)

dim=size(w,2);
% nummber of neurons.
nNeurons=size(w,1);
% Repeat the input vector to avoid the iterations
inVecMat=repmat(x,nNeurons,1);

% Different neighborhood's functions
neigh=StochasticNeighborFunction(SOM,sigma,i0);

% Repeat the colum of neighborhood function to avoid the loop
neigh=repmat(neigh,1,dim);
% the learning rate should not be less than 0.02
if eta<0.02
    eta=0.02;
end
% each ray of neighborhood function * the learning rate
neigh=neigh.*eta;

deltaW=(inVecMat-w).*neigh;


newW=w+deltaW;


