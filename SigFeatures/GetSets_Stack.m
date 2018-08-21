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
% % This function will create matrices of training, validation and test sets
% All movements will be STACK one over each other
%
% input:   trFeatures contains the splitted data, is a Nsplits x Nexercises structure matrix
%          vFeatures is similar to trFeatures 
%          features contains the name of the charactaristics to be used
% output:  trsets are the normalized training sets
%          vsets are the normalized validation sets
%          trOut contains the correspondet outputs
%          vOut contains the correspondet outputs
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2009-04-26 / Max Ortiz  / Creation
% 2009-07-21 / Max Ortiz  / To handle "treated_data" struct and selection of the number of set
% 2011-06-24 / Max Ortiz  / Update to new coding standard and name to stack             

function [trSet, trOut, vSet, vOut, tSet, tOut, movIdx, movOutIdx] = GetSets_Stack(sigFeatures, features)

%Variables
nM        = size(sigFeatures.mov,1);
nMm       = sum(cellfun(@(x) any(strfind(x,'+')), sigFeatures.mov));
nMi       = nM-nMm;
movIdx    = 1:size(sigFeatures.mov,1);
movIdxMix = zeros(1,nMm);
movOutIdx = cell(1,nM);

% Find the mixed movements by looking for "+"
% use of a temporal index to match the output, this assumes that the order
% of the output is the same as the order of the movements
indIdx = 1;
mixIdx = 1;
for i = 1 : size(sigFeatures.mov,1)
    if isempty(strfind(sigFeatures.mov{i},'+'))
        movOutIdx{i} = indIdx;  % Index for the output of each movement
        indIdx = indIdx + 1;
    else
        movIdxMix(mixIdx) = i;
        mixIdx = mixIdx + 1;
    end
end

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

Ntrset = trSets * nM;
Nvset  = vSets  * nM;
Ntset  = tSets  * nM;
trSet = zeros(Ntrset, length(features));
vSet  = zeros(Nvset , length(features));
tSet  = zeros(Ntset , length(features));
trOut = zeros(Ntrset, nM);
vOut  = zeros(Nvset , nM);
tOut  = zeros(Ntset , nM);

for e = 1 : nM
    % Training
    for r = 1 : trSets
        sidx = r + (trSets*(e-1));
        li = 1;
        for i = 1 : length(features)
            le = li - 1 + length(sigFeatures.trFeatures(r,e).(features{i}));
            trSet(sidx,li:le) = sigFeatures.trFeatures(r,e).(features{i});
            li = le + 1;
        end
        trOut(sidx,e) = 1;
    end
    % Validation
    for r = 1 : vSets
        sidx = r + (vSets*(e-1));
        li = 1;
        for i = 1 : length(features)
            le = li - 1 + length(sigFeatures.vFeatures(r,e).(features{i}));
            vSet(sidx,li:le) = sigFeatures.vFeatures(r,e).(features{i});
            li = le + 1;
        end
        vOut(sidx,e) = 1;
    end
    % Test
    for r = 1 : tSets
        sidx = r + (tSets*(e-1));
        li = 1;
        for i = 1 : length(features)
            le = li - 1 + length(sigFeatures.tFeatures(r,e).(features{i}));
            tSet(sidx,li:le) = sigFeatures.tFeatures(r,e).(features{i});
            li = le + 1;
        end
        tOut(sidx,e) = 1;
    end
end

% Extract information for mixed patterns
for j = 1 : nMm
    idxMix = zeros(1,nMi);
    e = movIdxMix(j);    % index of the movement
    %find mixed movements
    for i = 1 : (nMi-1)
        ii = movIdx(i);
        if isempty(strfind(sigFeatures.mov{e},sigFeatures.mov{ii}))
            idxMix(i) = 0;
        else
            idxMix(i) = 1;
        end
    end

    movOutIdx{e} = find(idxMix);

end
