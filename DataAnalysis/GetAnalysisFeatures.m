% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec ? which is open and free software under
% the GNU Lesser General Public License (LGPL). See the file "LICENSE" for
% the full license governing this code and copyrights.
%
% BioPatRec was initially developed by Max J. Ortiz C. at Integrum AB and
% Chalmers University of Technology. All authors contributions must be kept
% acknowledged below in the section "Updates & Contributors".
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
% Returns a data package of feature vectors ready for GUI_DataAnalysis given a
% recSession, contraction time presentage (cTp), a cell array of feature
% names and a filter configuration.
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-02-18 / Niclas Nilsson / Creation nilsson007@gmail.com
% 20xx-xx-xx / Author    / Comment on update

function anDataM = GetAnalysisFeatures(handles)
% Setting parameters
sigFeatures = get(handles.t_sigFeatures,'UserData');
allFeatures  = GetAllFeaturesStruct(sigFeatures);
features = get(handles.lb_features,'String');
fID = features(get(handles.lb_features,'Value'));
sCh = get(handles.lb_channels,'Value');
[~,sM] = ismember(get(handles.lb_movements,'String'),sigFeatures.mov);
%% Selecting Features
% Movement Analysis Data--------------------------------%
nCh = length(sCh);
anDataM = zeros(size(allFeatures.(fID{1}),1),length(fID)*nCh,length(sM));
%-------------------------------------------------------%
for f = 1:length(fID)
    tAF = allFeatures.(fID{f});
    anDataM(:,(f-1)*nCh+1:(f-1)*nCh+nCh,:) = tAF(:,sCh,sM);
end