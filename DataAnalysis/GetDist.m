% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec ? which is open and free software under
% the GNU Lesser General Public License (LGPL). See the file "LICENSE" for
% the full license governing this code and copyrights.
%
% BioPatRec was initially developed by Max J. Ortiz C. at Integrum AB and
% Chalmers University of Technology. All authors? contributions must be kept
% acknowledged below in the section "Updates % Contributors".
%
% Would you like to contribute to science and sum efforts to improve
% amputees? quality of life? Join this project! or, send your comments to:
% maxo@chalmers.se.
%
% The entire copyright notice must be kept in this or any source file
% linked to BioPatRec. This will ensure communication with all authors and
% acknowledge contributions here and in the project web page (optional).
%
% -------------------------- Function Description -------------------------
% This function recieves dataM and dataC form two movements and returns 
% the distance between the movements according to the statistical 
% similarity measure recieves as def.
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2015-09-23 / Niclas Nilsson / Created Feature evaluation
% 20xx-xx-xx / Author  / Comment on update
function dist = GetDist(dataM, dataC, def)
load('offsets');
nD = size(dataM,2); %number of dimensions
switch def
    case 'Bhattacharyya'
        % Shown to be highly correlated with MLP-accuracy. 
        tMeans = mean(dataM)-mean(dataC);
        tCov = (cov(dataM)+cov(dataC))./2;
        dist = sqrt(tMeans/tCov*tMeans'./8 + log(det(tCov)/sqrt(det(cov(dataM))*det(cov(dataC))))/2)-sum(Bhattacharyya(1:nD-1));
    case 'Mahalanobis Modified' 
        % Shown to be highly correlated with LDA-accuracy.
        tMeans = mean(dataM)-mean(dataC);
        tCov = (cov(dataM)+cov(dataC))./2;
        dist = sqrt(tMeans/tCov*tMeans')/2-sum(MahalanobisModified(1:nD-1));
    case 'Kullback-Leibler'                         
        % Not found very usefull
        tMeans = mean(dataM)-mean(dataC);
        dist = (trace(cov(dataC)\cov(dataM))+tMeans/cov(dataC)*tMeans'-length(dataM(1,:)+log(det(cov(dataC))/det(cov(dataM)))))/2;
    case 'Hellinger'                                
        % Shown to be highly correlated with MLP-accuracy.
        % Not compensated for dimenesional dependency.
        % Usefull when comparing data with equal dimensionality.
        tCov = (cov(dataM)+cov(dataC))./2;
        tMeans = mean(dataM)-mean(dataC);
        dist = 1-det(cov(dataM))^(1/4)*det(cov(dataC))^(1/4)/(det(tCov)^(1/2))*exp(-(tMeans/tCov*tMeans')/8);
    case 'Mahalanobis'
        % -0.02 is compensation for dimenesional dependency.
        tMeans = mean(dataM)-mean(dataC);
        dist = sqrt(tMeans/cov(dataM)*tMeans')/2;
    case 'Mutual Information'
         dist = log((2*pi*exp(1))^nD*det(cov(dataM)))/2 + log((2*pi*exp(1))^nD*det(cov(dataC)))/2 - log((2*pi*exp(1))^(nD*2)*det(cov([dataM dataC])))/2;
end