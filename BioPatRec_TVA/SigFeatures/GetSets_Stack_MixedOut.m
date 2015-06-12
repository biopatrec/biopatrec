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
% ------------- Function Description -------------
% This function creates matrices of training, validation and test sets,
% however, the number of outputs is reduced to the number of single
% movements. The mixed movementes are part of the training, validation and
% testing sets.
%
% - All movements will be STACK one over each other, this is, each set of
% movements (vector of features) will be a row.
% - The number of columbs is given by the nuber of channels times the features
% - The features in the first channel are follow by the features of the 
%   second channel and so on. 
%
% ------------- Updates -------------
% 2012-04-06 / Max Ortiz / Created
% 20xx-xx-xx / Author  / Comment on update

function [trSet, trOut, vSet, vOut, tSet, tOut, movIdx, movOutIdx] = GetSets_Stack_MixedOut(sigFeatures, features)

%Variables
movIdx    = [];     % Index of individual movements
movIdxMix = [];     % Index of mixed movements
nFeatures = size(features,1);

% Find the mixed movements by looking for "+"
% use of a temporal index to match the output, this assumes that the order
% of the output is the same as the order of the movements 
tempIdx = 1;
for i = 1 : size(sigFeatures.mov,1)
    if isempty(strfind(sigFeatures.mov{i},'+'))
        movIdx = [movIdx i];
        movOutIdx{i} = tempIdx;  % Index for the output of each movement
        tempIdx = tempIdx + 1;
    else
        movIdxMix = [movIdxMix i];
    end
end

nMi   = size(movIdx,2);           % Number of movements individuals
nMm   = size(movIdxMix,2);        % Number of movements mixed

trSets = sigFeatures.eTrSets;     % effective number of sets for trainning

if isempty(sigFeatures.vFeatures)
    vSets = 0;
else
    vSets  = sigFeatures.eVSets;      % Number of sets for valdiation
end

if isempty(sigFeatures.tFeatures)
    tSets = 0;
else
    tSets  = sigFeatures.eTSets;      % Number of sets for testing
end

Ntrset = trSets * nMi;
Nvset  = vSets  * nMi;
Ntset  = tSets  * nMi;

trSet = zeros(Ntrset, nFeatures);
vSet  = zeros(Nvset , nFeatures);
tSet  = zeros(Ntset , nFeatures);

trOut = zeros(Ntrset, nMi);
vOut  = zeros(Nvset , nMi);
tOut  = zeros(Ntset , nMi);

% Stack data sets for individual movements

for j = 1 : nMi;
    e = movIdx(j);
    % Training
    for r = 1 : trSets
        %sidx = r + (trSets*(j-1));
        sidx = r + (trSets*(e-1));   % Use e instead of j for test
        li = 1;
        for i = 1 : nFeatures
            le = li - 1 + length(sigFeatures.trFeatures(r,e).(features{i}));
            trSet(sidx,li:le) = sigFeatures.trFeatures(r,e).(features{i}); % Get each feature per channel
            li = le + 1;
        end
        trOut(sidx,j) = 1;
    end
    % Validation
    for r = 1 : vSets
        %sidx = r + (vSets*(j-1));
        sidx = r + (vSets*(e-1));   % Use e instead of j for test
        li = 1;
        for i = 1 : nFeatures
            le = li - 1 + length(sigFeatures.vFeatures(r,e).(features{i}));
            vSet(sidx,li:le) = sigFeatures.vFeatures(r,e).(features{i});
            li = le + 1;
        end
        vOut(sidx,j) = 1;
    end
    % Test
    for r = 1 : tSets
        sidx = r + (tSets*(e-1));   % Use e instead of j for test
        li = 1;
        for i = 1 : nFeatures
            le = li - 1 + length(sigFeatures.tFeatures(r,e).(features{i}));
            tSet(sidx,li:le) = sigFeatures.tFeatures(r,e).(features{i});
            li = le + 1;
        end
        tOut(sidx,j) = 1;
    end
end

% Extract information for mixed patterns
for j = 1 : nMm;    
    e = movIdxMix(j);    % index of the movement
    %find mixed movements
    for i = 1 : nMi
        ii = movIdx(i);
        if isempty(strfind(sigFeatures.mov{e},sigFeatures.mov{ii}))
            idxMix(i) = 0;
        else
            idxMix(i) = 1;            
        end
    end

    % Training
    for r = 1 : trSets
        sidx = r + (trSets*(e-1));
        li = 1;
        for i = 1 : nFeatures
            le = li - 1 + length(sigFeatures.trFeatures(r,e).(features{i}));
            trSet(sidx,li:le) = sigFeatures.trFeatures(r,e).(features{i});
            li = le + 1;
        end
        trOut(sidx,:) = idxMix;
    end
    
    % Validation
    for r = 1 : vSets
        sidx = r + (vSets*(e-1));
        li = 1;
        for i = 1 : nFeatures
            le = li - 1 + length(sigFeatures.vFeatures(r,e).(features{i}));
            vSet(sidx,li:le) = sigFeatures.vFeatures(r,e).(features{i});
            li = le + 1;
        end
        vOut(sidx,:) = idxMix;
    end
    
    % Test
    for r = 1 : tSets
        sidx = r + (tSets*(e-1));
        li = 1;
        for i = 1 : nFeatures
            le = li - 1 + length(sigFeatures.tFeatures(r,e).(features{i}));
            tSet(sidx,li:le) = sigFeatures.tFeatures(r,e).(features{i});
            li = le + 1;
        end
        tOut(sidx,:) = idxMix;
    end

    movOutIdx{e} = find(idxMix);
        
end




