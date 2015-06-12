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
%  Function to generate different color and it return if there is more than 
%  mov. contribute in one and more neurons also it will return the spot
%  size of the neuron if that more than mov. contribute in one and more neurons. 
%
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-08-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function [color indx sizeSpotMat mixColorMat]=GetColor(SOM)

nMov=size(SOM.neuroLabel,2);

indx=[];
% the size of the neuron spot the default size is .5
sizeNeur=ones(SOM.mUnits,1).*.5;

% in case of Mix Mov (mixcolor).
mixColor=zeros(SOM.mUnits,size(SOM.neuroLabel,2));
for i=1:size(SOM.neuroLabel,1)
    
    neuron=SOM.neuroLabel(i,:);
    neuron=neuron(neuron~=0);
    neuron=unique(neuron);
    % check the neuron i belong to which mov.!
    [~, c]=find(SOM.neuroLabel==neuron);
    c=unique(c');
    
    ind=unique(SOM.neuroLabel(i,c));
    ind=ind(ind~=0);
    % set the mov. index of neuron i equal to 1.
    mixColor(ind,c)=1;
    % set the spot size of neuron i equal to .5 * number of mov.
    sizeNeur(ind)=size(c,2)*.5;
    
end


% generating  RGB colors
color(1,:)=[255,0,0];
color(2,:)=[0,0,255];
color(3,:)=[0,255,0];
color(4,:)=[255,0,255];
color(5,:)=[0,255,255];
color(6,:)=[255,255,0];
color(7,:)=[168,102,255];
color(8,:)=[122,15,226];
color(9,:)=[192,0,192];
color(10,:)=[0,128,0];
color(11,:)=[192,192,0];
color(12,:)=[203,117,25];
color(13,:)=[20,43,140];
color(14,:)=[255,176,99];
color(15,:)=[43,130,87];
color(16,:)=[179,255,0];
color(17,:)=[153,51,0];
color(18,:)=[148,99,99];
color(19,:)=[0,169,155];
color=color./255;
% number of minxing mov
nMixColor=max(sizeNeur)/.5;
mixColorMat=zeros(size(mixColor,1),nMixColor);
sizeSpotMat=zeros(size(mixColor,1),nMixColor);

for k=1:size(mixColor,1)
    [~, col]=find(mixColor(k,:)==1);
    if ~isempty(col)
        mixColorMat(k,1:size(col,2))=col;
    end
    nMixColor=sizeNeur(k,1)/.5;
    sizeSpotMat(k,1: nMixColor)=linspace(sizeNeur(k,1),.5,nMixColor);
end
for j=1:nMov
    
    i0=SOM.neuroLabel(:,j);
    i0=i0(i0~=0);
    % save the indx of the wining neuron
    indx=[indx
        i0];
    
end
