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
% Function to run the batch training.The principle of updating weight vector
% step goes by replacing each map unit by the average of the data vectors that
% were in its neighborhood. The contribution, or activation, of data vectors
% in the mean can be varied with the neighborhood function. This activation
% is given by matrix neigh. So, for each map unit the new weight vector is
%        w(t+1) = sum(neigh(t)*S(t)) ./ sum(neigh(t)*A),
% wherw S sum of input vectors  corresponding to wining neuron i0  , 
% A is the number of sample corresponding to that wining neuron i0
%  and neigh is the neighborhood function.[1]
%
% Note: This function implemented in the same way of SOM toolbox Team[1]
% References
% [1]-Juha Vesanto, Johan Himberg, Esa Alhoniemi, and Parhankangs
%     SOM Toolbox Team ,Helsinki University of Technology.
%     http://www.cis.hut.fi/somtoolbox/package/papers/techrep.pdf
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-09-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update


function SSOM=SSOMBatchTrainig(SSOM,trSet,maxSim,sim)
radiusFin=SSOM.radiusFin;
radiusIni=SSOM.radiusIni;
w=SSOM.w;
sizeSSOMOut=SSOM.sizeSSOMOut;
% sample weights: each sample is weighted
weights=1;
% number of sets
nSet=size(trSet,1);
% the width of the neighbour function.
radius = radiusFin + ((maxSim-(sim-1))/maxSim) * (radiusIni - radiusFin);
radius(radius==0) = eps;


knownData = ones(size(trSet,1),size(trSet,2));
% winning neurons vector
i0 = zeros(1,nSet);
% loop over all data sets to find the winning neurons by measuring the min
% euclidean disttance
for i=1:nSet
    inVec=repmat(trSet(i,:),size(w,1),1);
    dist=VectorDistance(inVec,w);
    [~, i0(i)]=min(dist);
end


% neighborhood function

neigh = BatchNeighborFunction(SSOM,radius);
% a partition matrix p with elements p_ij=1 if the i0(winning neuron) of data vector j is i.
p = sparse(i0,[1:nSet],weights,SSOM.mUnits,nSet);
% neigh*sum of vectors corresponding to wining neuron i0 (in each Voronoi
% set)
s = neigh*(p*trSet);
% neigh*the number of vectors corresponding to wining neuron i0 (in Voronoi
% set)
a = neigh*(p*knownData);

nonZero  = find(a > 0); 
w(nonZero)=s(nonZero)./ a(nonZero);
% the classifier outpu represent by last columns of the w matrix which we
% added previously in SSOM_Mapping. 
SSOMOut=w(:,end-sizeSSOMOut+1:end);
SSOM.w=w;
SSOM.SSOMOut=SSOMOut;
