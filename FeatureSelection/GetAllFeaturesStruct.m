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
% This function recieves sigFeatures and return all features from
% trFeatures, vFeatreus and tFeatures in a struct adecqute for 
% Classification Complexity Estimation.
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-07-24 / Niclas Nilsson  / Created
% information into the parameters
% 20xx-xx-xx / Author  / Comment on update

function allFeatures = GetAllFeatures(sigFeatures)
% allFeatures added to simplify feature analysis
fID = LoadFeaturesIDs();
for i = 1 : length(fID)
    sets = {'trFeatures', 'vFeatures', 'tFeatures'};
    oldFLength = 0;
    [nTrF, nM] = size(sigFeatures.(sets{1}));
    [nVF, nM] = size(sigFeatures.(sets{2}));
    [nTF, nM] = size(sigFeatures.(sets{3}));
    fLength = nTrF + nVF + nTF;
    chLength = length(sigFeatures.(sets{1})(1,1).(fID{1}));
    allFeatures.(fID{i}) = zeros(fLength,chLength,nM);
    % Restructuring data to fit features evaluation algorithms
    for s = 1:3
        [fLength, nM] = size(sigFeatures.(sets{s}));
        for m = 1:nM
            for f = 1:fLength
                allFeatures.(fID{i})(oldFLength+f,(1:chLength),m) = sigFeatures.(sets{s})(f,m).(fID{i});
            end
        end
        oldFLength = oldFLength + fLength;
    end
end
