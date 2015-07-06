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
% This function classify the validation sets.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-06-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function [accP rmse]=FastTestSOM(SOM,vOut,x)



neuroLabel=SOM.neuroLabel;
w=SOM.w;

% The output vector.
somOut=zeros(size(vOut,1),size(vOut,2));
% Number of data sets.
nSets=size(x,1);
% square Error.
sqErr=0;
% Number of movements.
nM=size(SOM.trOut,2);
% the Coordinate of all Neurons.
mapCoordinates=SOM.mapCoordinates;

% loop over all validation data.
for i=1:nSets
    % finding the location of winning neuron i0(x) on the map.
    [i0 ,~]=FindClosest(w,x(i,:));
    % the Coordinate of the winning neuron i0.
    i0Coord=mapCoordinates(i0,:);
    
    % loop over all coordinates of labeled neurons  to find the closest .
    for j=1:nM
        %  all labeled neurons  of mov J
        neuronLabelMovJ=neuroLabel(:,j);
        % the index of labeled neurons movement J in neuron label matrix;
        neuronLabelIndx{j}=neuronLabelMovJ(neuronLabelMovJ~=0);
        %  all Coordinate of all neurons movement j.
        neurLabledCoords=mapCoordinates(neuronLabelIndx{j},:);
        % finding the closest movement to neuron i0.
        [neuronMovJ(1,j) ,d]=FindClosest(neurLabledCoords,i0Coord);
        % save the min distans to movement j.
        disVec(1,j)=d;
    end
    % min distance over all mavement neurons
    minDis=min(disVec);
    % finding the label movement.
    [~,mov]=find(disVec==minDis);
    % loop to search if the closeste neuron belong to another movement also or not.
    for k=1:length(mov)
        % the index of the closest neuron in neuron label matrix
        neuronIndx(k)=neuronLabelIndx{mov(k)}(neuronMovJ(mov(k)));
        % search that index in another movement
        [~,winMov]=find(neuroLabel==neuronIndx(k));
        
        outMov=unique(winMov);
        
        somOut(i,outMov)=1;
    end
    
    
    
    % sum of square Error.
    sqErr = sqErr + sum((somOut(i,:)-vOut(i,:)).^2);
end

% error.
er   = find(sum(abs(somOut-vOut),2) >= 1);
% accuracy.
accP = (1 - (length(er)/nSets)) * 100;
% root mean square error.
rmse = sqrt(sqErr/(nSets*nM));




