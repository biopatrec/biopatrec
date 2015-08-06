
% % ---------------------------- Copyright Notice ---------------------------
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
% This Function is the main algorithm perform Principal Component Analysis
% for Feature Reduction
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-08-01 / Tanuj Kumar Aluru  / Creation
% 20xx-xx-xx / Author  / Comment on update
%%-------------------------------------------------------------------------
function [PCAout eigVec] = PCAFeatureReduction(inputData,selFeatures)

recData = reshape(inputData,[],size(selFeatures,1));

% Computing Covariance and Eigen Decomposition
variance =  cov(recData);
[E D ]   =  eig(variance);

%Sort Eigen Values in Descending Order

[eigVal index] =  sort(diag(D),'descend');

% ---- Feature Reduction Step----------------------------------------------
% Chose first k Principal Components

eigVec = [];

Threshold = 0.99;

k= 0;

for i = 1:length(eigVal)
    Totalvar(i) = sum(eigVal(1:i))/sum(eigVal);
    if Totalvar(i) >= Threshold ;
        k = i;
        break
    end
end

% Consider K largest Eigen vectors with corrosepoding Eigen Values

eigVec =  [eigVec,E(:,index(1:k))];


% Project the Data on to EigenVectors

ProjectedData = (recData*eigVec);
PCAout = reshape(ProjectedData,size(inputData,1),[]);
end












