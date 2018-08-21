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
% This function recieves sigFeatures, type of selectioning algorithms,
% aditional settings and availble features. The ouput is the feature set
% predicted to be the best performing according to the selecting algorithm.
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2015-09-23 / Niclas Nilsson / Created Feature evaluation
% 20xx-xx-xx / Author  / Comment on update
function bestFeatures = GetBestFeatures(sigFeatures,type,handles,varargin)

if ~isempty(varargin)    
    fID = LoadFeaturesIDs();
else 
    fID = varargin{1};
end

% extracting allFeature struct from sigFeatures
allFeatures = GetAllFeaturesStruct(sigFeatures);

bestFeatures = feval(['GetBestFeatures_' type],allFeatures,handles,fID);

function bestFeatures = GetBestFeatures_bruteForce(allFeatures,handles,fID)

% Collecting Complexity Measures
cMS = get(handles.pm_algSet,'String');
cM = cMS{get(handles.pm_algSet,'Value')};

% Collecting Number of Features
nFS = get(handles.pm_nFeatures,'String');
nF = str2double(nFS{get(handles.pm_nFeatures,'Value')});

% Utilizing GUI settings
switch cM
    case 'Mahalanobis'
        cCEA = 'SI';
        par = 'Mahalanobis Modified';
    case 'Bhattacharyya'
        cCEA = 'SI';
        par = 'Bhattacharyya';
    case 'Nearest Neighbor Sep.'
        cCEA = 'NNS';
        par = inf;
end

tID = 1:length(fID);        % Array of indecies
ifID = combnk(tID,nF);      % Array of possible combinations
bestResult = 0;

w = waitbar(0,'Searching through feature combinations...');

[nS,nCh,nM] = size(allFeatures.(fID{1}));
nID = length(ifID(:,1));

% Brute force search through all possible combinations
for i = 1:nID
    data = zeros(nS,nCh*nF,nM);
    for j = 1:nF
        data(:,(1+(j-1)*nCh):(j*nCh),:) = allFeatures.(fID{ifID(i,j)});
    end
    result = eval(['mean(Get' cCEA '(data,par));']);
    if (result > bestResult)
        bestResult = result;
        iBest = i;
    end
    waitbar(i/nID);
end
close(w);
bestFeatures = ifID(iBest,:);

function bestFeatures = GetBestFeatures_sequential(allFeatures,handles,fID)

% Collecting Complexity Measures
cMS = get(handles.pm_algSet,'String');
cM = cMS{get(handles.pm_algSet,'Value')};

% Collecting Number of Features
nFS = get(handles.pm_nFeatures,'String');
nF = str2double(nFS{get(handles.pm_nFeatures,'Value')});

% Utilizing GUI settings
switch cM
    case 'Mahalanobis'
        cCEA = 'SI';
        par = 'Mahalanobis Modified';
    case 'Bhattacharyya'
        cCEA = 'SI';
        par = 'Bhattacharyya';
    case 'Nearest Neighbor Sep.'
        cCEA = 'NNS';
        par = inf;
end

ifID = 1:length(fID);   % Array of indecies

[~,nCh,~] = size(allFeatures.(fID{1}));
data = [];
iBest = zeros(nF,1);

% initializing waitbar
w = waitbar(0,'Searching through feature combinations...');
wMax = nF*length(fID)-sum(1:(nF-1));
wInd = 0;

% Searching through all features for repeteadly to add the most
% contributing one as the next member in the feature set.
for i = 1:nF
    tData = data;
    bestResult = 0;
    for j = ifID
        tData(:,(1+(i-1)*nCh):(i*nCh),:) = allFeatures.(fID{j});
        result = eval(['mean(Get' cCEA '(tData,par));']);
        if (result > bestResult)
            bestResult = result;
            iBest(i) = j;
            data = tData;
        end
        wInd = wInd + 1;
        waitbar(wInd/wMax);
    end
    ifID = ifID(ifID~=iBest(i));
end
close(w);
bestFeatures = iBest;