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
% recSession, contraction time presentage (cTp) and a cell array of feature
% names.
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-02-18 / Niclas Nilsson / Creation nilsson007@gmail.com
% 20xx-xx-xx / Author    / Comment on update

function anDataM = GetAnalysisFeatures(recSession,fID,cTp)
% Setting parameters

sF       = recSession.sF;
cT       = recSession.cT;
rT       = recSession.rT;
nR       = recSession.nR;
nCh      = recSession.nCh;
mov      = recSession.mov;
allData  = recSession.tdata;
nM       = recSession.nM;

nS = size(allData,1);                                   % number of samples
tWS = round(0.2 * sF);                                  % Time window samples, considering tw of 200 ms
overlapS = round(0.05 * sF);                            % Overlap samples considering 50 ms
randTW = false;                                         % Random time windows
rSR = 0.3;                                              % Random samples ratio
%% Extracting contraction data
margin = 1 + round((1-cTp)/2*cT*sF);
nonRest = [];
for r = 1:nR
    nonRest = [nonRest round(((r-1)*(cT+rT)*sF+margin)):round(((r-1)*(cT+rT)*sF+(cT*sF-margin)))];
end
trData = allData(nonRest,:,:);
%% Adding rest
tmpTreated.trData = trData;
tmpTreated.nM = nM-1;
tmpSession = recSession;
tmpSession.nM = nM-1;
tmpTreated.mov = mov(1:end-1);
tmpTreated = AddRestAsMovement(tmpTreated, tmpSession);
trData = tmpTreated.trData;
%% Extracting Features
tWStarts  = 1 : overlapS : size(trData,1)-tWS; 
if randTW
    % random windows are selected
    nRS = floor(length(tWStarts)*rSR);
    rS = randi(length(tWStarts),nRS);
    tWStarts = tWStarts(rS);
end
tS = length(tWStarts);
% Starting waitbar -------------------------------------%
h=waitbar(0,'Extracting Features');
w = 1;
maxW = nM * tS * length(fID) + nCh;
% Movement Analysis Data--------------------------------%
anDataM = zeros(tS,length(fID)*nCh,nM);
%-------------------------------------------------------%
for m = 1:nM
    ind = 1;
    for i = tWStarts
        tmpTreated = GetSigFeatures(trData(i:i+tWS-1,:,m), sF, fID);
        for f = 1:length(fID)
            tmpF = tmpTreated.(fID{f});
            anDataM(ind,(f-1)*nCh+1:(f-1)*nCh+nCh,m) = tmpF;
            waitbar(w/maxW);
            w = w + 1;
        end
        ind = ind + 1;
    end
end
close(h);