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
% This function classify the validation sets and returns the RMSE and accuracy
% for each mov.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-09-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function [accP rmse]=FullTestSOM(SOM,vOut,x)
neuroLabel=SOM.neuroLabel;
w=SOM.w;
mapCoordinates=SOM.mapCoordinates;
% Number of data sets.
nSets=size(x,1);

% Number of movements.
nM=size(SOM.trOut,2);
nSetPerMov = nSets/nM ;     % Number of sets per movement.
setIdx=1;
% loop over all validation data.
for i=1:nM
    
    % square Error.
    sqErr=0;
    cP=0;
    
    for j = 1 : nSetPerMov
        somOut=zeros(1,size(vOut,2));
        % finding the location of winning neuron i0(x) on the map.
        [i0 ~]=FindClosest(w,x(setIdx,:));
        % the Coordinate of the winning neuron i0.
        i0Coord=mapCoordinates(i0,:);
        % loop over all coordinates of labeled neuron  to find the closest .
        for k=1:nM
            %  all labeled neurons  of mov k.
            neuronLabelMovK=neuroLabel(:,k);
            % the index of labeled neurons movement k in neuron label matrix;
            neuronLabelIndx{k}=neuronLabelMovK(neuronLabelMovK~=0);
            %  all Coordinate of all neurons movement  k.
            neurLabledCoords=mapCoordinates(neuronLabelIndx{k},:);
            
            % finding the closest movement neuron i0.
            [labeldNeur(1,k) ,d]=FindClosest(neurLabledCoords,i0Coord);
            % save the min distans of movement k.
            disVec(1,k)=d;
        end
        
        % min distance over all mavement neurons
        minDis=min(disVec);
        % finding the label movement .
        [~,mov]=find(disVec==minDis);
        
        % loop to search if the closeste neuron belong to another movement also or not.
        for l=1:length(mov)
            % the index of the closest neuron in neuron label matrix
            neuronIndx(l)=neuronLabelIndx{mov(l)}(labeldNeur(mov(l)));
            % search that index in another movement
            [~,winMov]=find(neuroLabel==neuronIndx(l));
            outMov=unique(winMov);
            somOut(1,outMov)=1;
        end
        
        %correct Movement
        
        cM= length(find(sum(abs(somOut-vOut(setIdx,:)),2) >= 1));
        if cM==0
            correct=1;
        else
            correct=0;
        end
        cP = cP + correct;
        % sum of square Error.
        sqErr = sqErr + sum((somOut-vOut(setIdx,:)).^2);
        setIdx=setIdx+1;
    end
    accP(i) = cP / nSetPerMov;
    rmse(i) = sqrt(sqErr/(nSetPerMov*nM));
    
end
accP(end + 1) = mean(accP);
rmse(end + 1) = mean(rmse);






