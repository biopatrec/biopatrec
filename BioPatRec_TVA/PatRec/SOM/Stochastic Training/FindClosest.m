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
% Function to find the closest neuron 
% 
% ------------------------- Updates & Contributors ------------------------ 
% [Contributors are welcome to add their email] 
% 2012-06-01 / Ali Fouad  / Creation 
% 20xx-xx-xx / Author  / Comment on update 

function [closestIdx minDist]=FindClosest(w,inpVec)
nNeuron=size(w,1);
%Repeat the input vector to avoid the iterations
inpVec = repmat(inpVec, nNeuron, 1);
%The euclidean distance between inpVec and all neurons
d=sqrt(sum((inpVec-w).^2, 2));
%find the minimum distance and the index
[minDist  closestIdx]=min(d);


