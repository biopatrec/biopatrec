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
% Function recieving data and calculates the Separability Index for that
% data.
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2015-09-23 / Niclas Nilsson / Created
% 20xx-xx-xx / Author  / Comment on update
function [SI,NN] = GetSI(data,varargin)
if isempty(varargin)
    dist = 'Mahalanobis Modified';
else
    dist = varargin{1};
end
% Initialization
[~,~,nM] = size(data);
SI = zeros(nM,1);
NN = zeros(nM,1);
%iteration over all movements
for m = 1 : nM
    tM = 1:nM;
    tM = tM(tM ~= m);       % list of all movements except the taget movement
    tIndex = 1;
    SIs = zeros((nM-1),1);
    % Listing all distances in SIs
    for t = tM
        SIs(tIndex) = GetDist(data(:,:,m),data(:,:,t),dist);
        tIndex = 1 + tIndex;
    end
    [SI(m),iMin] = min(SIs); % The minimume value of tSIs is the distance to the closesed movement...
    NN(m) = tM(iMin);
end