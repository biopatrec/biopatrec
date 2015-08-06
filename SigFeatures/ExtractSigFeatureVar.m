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
% The difference with GetSigFeatures is that this routines extracts a single
% feature from a complete time series. GetSigFeatures can extract several
% features for a single time window.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-06-03 / Max Ortiz / Creation 
% 2014-12-25 / Max Ortiz / Made twS and overlapS input variables 
% 20xx-xx-xx / Author    / Comment on update

function fData = ExtractSigFeatureVar(data,sF,fID,twS,overlapS)

tS = size(data,1);    % Total samples
%twS = 0.2 * sF;        % Time window samples, considering tw of 200 ms
%overlapS = 0.02*sF;    % Overlap samples considering 20 ms
fData = [];

for i = 1 : overlapS : tS-twS
    feature = GetSigFeatures(data(i:i+twS,:), sF, {fID});
    fData = [fData ; feature.(fID)];
end


