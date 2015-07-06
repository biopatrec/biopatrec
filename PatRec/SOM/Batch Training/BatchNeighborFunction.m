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
% Function for different Neighbor Function Bubble,Gaussian ,Cut Gaussian,
% Epanechikov and Butter worth 2nd order.
%
% Note: Bubble,Gaussian ,Cut Gaussian and Epanechikov implemented according to 
%  SOM toolbox Team[1]
%
% [1]-Juha Vesanto, Johan Himberg, Esa Alhoniemi, and Parhankangs
%     SOM Toolbox Team ,Helsinki University of Technology.
%     http://www.cis.hut.fi/somtoolbox/package/papers/techrep.pdf
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-09-07 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update


function neigh=BatchNeighborFunction(SOM,sigma)

neighborFunction=SOM.neighFunc;
% The euclidean distance Matrix between the coordinates of the winning neuron and  all
% others
neuronDist=SOM.neuronDist;


switch neighborFunction,
    case 'bubb'
        %neuronDist(neuronDist>sigma)=0;
        neigh=(neuronDist<=sigma);
    case 'gauss'
        neigh = exp(-(neuronDist.^2)./(2*sigma^2));
    case 'cutGauss'
        neigh = exp(-(neuronDist.^2)./(2*sigma^2)) .* (neuronDist<=sigma);
    case 'trai'
        neigh = (1-neuronDist./sigma) .* (neuronDist<=sigma);
    case 'butter'
        neigh =1./(1+(neuronDist./sigma).^4);
end