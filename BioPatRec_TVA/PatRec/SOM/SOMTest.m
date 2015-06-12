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
% Function to classifies the testing sets.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-06-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function [outMov disVec]=SOMTest(patRecTrained,x)
% Check if there is any NaN value
tKnownNaN = ~isnan(x);
if ~isempty(find(tKnownNaN==0, 1))
    disp('You have NaN value in Testing sets');
    errordlg('You have NaN value in Testing sets');
    error('You have Complex number in Testing sets');
end
% Check if there is any Inf value
tKnownInf = ~isinf(x);
if ~isempty(find(tKnownInf==0, 1))
    disp('You have Inf value in Testing sets');
    errordlg('You have Inf value in Testing sets');
    error('You have Complex number in Testing sets');
end
% Check if there is any Complex number in Testing sets
tKnownComplex = ~isreal(x);
if ~isempty(find(tKnownComplex==1, 1))
    disp('You have Complex number in Testing sets');
    errordlg('You have Complex number in Testing sets');
    error('You have Complex number in Testing sets');
end


w=patRecTrained.SOM.w;
nMov=size(patRecTrained.SOM.trOut,2);
somOut=zeros(1,nMov);

neuroLabel=patRecTrained.SOM.neuroLabel;


% the Coordinate of all Neurons.
mapCoordinates=patRecTrained.SOM.mapCoordinates;

% finding the location of winning neuron i0(x) on the map.
[i0 ~]=FindClosest(w,x);
% the Coordinate of the winning neuron i0.
i0Coord=mapCoordinates(i0,:);
% loop over all coordinates of labeled neurons  to find the closest to i0(x).
for i=1:nMov
   %  all labeled neurons  of mov I
    neuronLabelMovI=neuroLabel(:,i);
    % the index of labeled neurons movement I in neuron label matrix;
    neuronLabelIndx{i}=neuronLabelMovI(neuronLabelMovI~=0);
    %  all Coordinate of all neurons movement I.
    neurLabledCoords=mapCoordinates(neuronLabelIndx{i},:);
    
    % finding the closest movement to neuron i0.
    [neuronMovI(1,i) ,d]=FindClosest(neurLabledCoords,i0Coord);
    % save the min distans to movement I.
    disVec(1,i)=d;
end
% min distance over all mavement neurons
minDis=min(disVec);
% finding the label movement.
[~,mov]=find(disVec==minDis);
% loop to search if the closeste neuron belong to another movement also or not.
for j=1:length(mov)
    % the index of the closest neuron in neuron label matrix
    neuronIndx(j)=neuronLabelIndx{mov(j)}(neuronMovI(mov(j)));
    % search that index in another movement
    [~,winMov]=find(neuroLabel==neuronIndx(j));
    
    
    somOut(1,unique(winMov))=1;
end
[~,outMov]=find(somOut==1);
% set the outMov has the highest prediction to let that works with different topologies.
disVec(disVec==0)=eps;
disVec=1./disVec;

