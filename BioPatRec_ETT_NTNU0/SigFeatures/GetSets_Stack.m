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
% 2009-07-21 / Max Ortiz  / To hanlde "treated_data" struct and selection of the number of set
% 2011-06-24 / Max Ortiz  / Update to new coding standard and name to stack             

function [trSet, trOut, vSet, vOut, tSet, tOut] = GetSets_Stack(sigFeatures, features)

nM   = length(sigFeatures.trFeatures(1,:));     % Number of movements
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

for e = 1 : nM;
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


