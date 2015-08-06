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
% Function to add white noise to a rec_Session using random numbers with
% mean equal to the mean of the signal, and standard deviation (std) as
% perentage of the maximum std in all channels and all movements.
%
% input :   recSession  Recording session
%           pStd        Percentagle of standard deviation
%
% output: recSession
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2014-12-30 / Max Ortiz  / Creation 
% 20xx-xx-xx / Author     / Comment on update

function recSession = AddNoise_recSession(recSession, pStd)

% Parameters
cTp = 0.4;  % percentage of the contraction time to be considered from the raw signal
tW  = 0.2;  % time window length
tI  = 0.02; % time increment
sF  = recSession.sF;
cT  = recSession.cT;
rT  = recSession.rT;
nS  = recSession.sF * recSession.sT;
eRed = (1-cTp)/2; % effective reduction at the begining and at the end of contraction

%% Extract the portion of interest of the raw signal using the cTp
for mov = 1 : recSession.nM
    tempEMGData = [];
    tempRestData = [];
    for rep = 1 : recSession.nR
        % Samples of the exersice to be consider for training
        % (sF*cT*(cTp-1)) Number of the samples that wont be consider for training
        % (sF*cT*rep) Number of samples that takes a contraction
        % (sF*rT*rep) Number of samples that takes a relaxation
        % EMG
        is = fix((sF*cT*(1-cTp-eRed)) + (sF*cT*(rep-1)) + (sF*rT*(rep-1)) + 1);
        fs = fix((sF*cT*(cTp+eRed)) + (sF*cT*(rep-1)) + (sF*rT*(rep-1)));
        tempEMGData = [tempEMGData ; recSession.tdata(is:fs,:,mov)];
        % floor noise
        is = fix((sF*cT*rep) + (sF*rT*(1-cTp-eRed)) + (sF*rT*(rep-1)) + 1);
        fs = fix((sF*cT*rep) + (sF*rT*(cTp+eRed)) + (sF*rT*(rep-1)));        
        tempRestData = [tempRestData ; recSession.tdata(is:fs,:,mov)];        
    end
    emgData(:,:,mov) = tempEMGData;
    restData(:,:,mov) = tempRestData;
end

%% Extract standard deviation (EMG, and mean (floor noise)
twS = tW * sF;              % Time window samples
overlapS = tI*sF;           % Time increment samples 
for mov = 1 : recSession.nM
    emgDataMov         = emgData(:,:,mov);
    emgFeature(:,mov)  = mean(ExtractSigFeatureVar(emgDataMov,sF,'tstd',twS,overlapS));
    restDataMov        = restData(:,:,mov);
    restFeature(:,mov) = mean(ExtractSigFeatureVar(restDataMov,sF,'tmn',twS,overlapS));
end
% Get maximum variance for EMG and mean var for the rest/floor noise
maxEmgStd = max(max(emgFeature));
meanRest  = mean(mean(restFeature));

%% Generate white noise matrix
meanNoise = meanRest;
stdNoise  = pStd * maxEmgStd;
noiseMat = meanNoise + stdNoise .* randn(nS,size(recSession.nCh,2),recSession.nM);

%% Add noise to the recSession
recSession.tdata = recSession.tdata + noiseMat;

