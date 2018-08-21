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
% Function recieving data and calculates the Nearest Neighbor Seperability for that
% data.
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2015-09-23 / Niclas Nilsson / Created Feature evaluation
% 20xx-xx-xx / Author  / Comment on update
function [NNS,NN] = GetNNS(data,varargin)

%Initialization
[nS,nD,nM] = size(data);
dataR = zeros(nD, nM*nS);
findNN = false;
NNS = zeros(nM,1);          % Nearest Neighbor Separability
if nargout > 1
    NNs = zeros(nS*(nS-1),nM);  % Nearest Neighbors
    NN = zeros(nM,1);           % Nearest Neighbor
    ind = ones(nM,1);           % starts NNs
    findNN = true;
end

if ~isempty(varargin) && varargin{1} ~= inf
    k = varargin{1};
else
    k = nS - 1; % maximume number of nearest neighbors from the same class
end

weights = 1./(1:k); % vector of weights
normFactor = 1/sum(1./(1:k)); % used to normalize result to value between 0-1

%Reshaping data to fit purpuse
for m = 1:nM
    dataR(:,(((m-1)*nS+1):((m-1)*nS+nS))) = data(:,:,m)';
end

% Normalizing
dataR = normr(dataR);


%Iterating over feature data point
for p = 1:(nM*nS)
    %Producing distance vector
    pDist = sum((dataR(:,p)*ones(1,nM*nS)-dataR).^2).^(1/2);
    [~,pSort] = sort(pDist);
    % Saving value for point p for p's class
    mNN = ceil(pSort(2:k+1)./nS);
    m = ceil(p/nS);
    NNS(m) = NNS(m) + sum((mNN == m).*weights)*normFactor;
    if findNN
        NNs(ind(m):k+ind(m)-1,m) = mNN;
        ind(m) = ind(m) + k;
    end
end
NNS = NNS./nS;
if findNN
    wNN = repmat(weights',nM*nS,1); % weigth vector for all NNs
    [tNNs,indNN] = sort(NNs);       
    for m = 1:nM
        tWNN = wNN(indNN(:,m));          % weigths are connected to movement indecies
        [mem,inMem] = unique(tNNs(:,m),'last'); % finding limits for movement groups
        oldInd = 0;
        nMem = zeros(size(inMem));
        for i = 1:length(inMem)
            nMem(i) = sum(tWNN(oldInd+1:inMem(i))); % summing all weights for all movements
            oldInd = inMem(i);
        end
        nMem = nMem(mem ~= m);    % Removing movement that is being evaluated
        mem = mem(mem ~= m);
        if ~isempty(nMem)
            [~,mInd] = max(nMem);     % Movements with highest sum of weights is selected as NN
            NN(m) = mem(mInd);
        end
    end
end
return