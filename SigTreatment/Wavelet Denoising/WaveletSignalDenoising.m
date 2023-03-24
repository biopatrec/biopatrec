% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec © which is open and free software under 
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
% Wavelet denoising (Denoho's Method).
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-04-01 / Julian Maier / Creation
% 20xx-xx-xx / Author  / Comment on update

function sigDenoised = WaveletSignalDenoising(sig,sigDenoising)

% Initialize Wavelet Denoising Params from sigDenoising-struct
wType       = sigDenoising.waveletType;
wLevel      = sigDenoising.waveletLevel;
thrCycSpin  = sigDenoising.thresholdCycSpin;
nCycSpin    = sigDenoising.thresholdCycSpinNo;
winExt      = sigDenoising.waveletExtWin;
winExtLength = sigDenoising.waveletExtLength;

% Get sig infos
[nSample,nCh] = size(sig);

% Set windows extension
if ~strcmp(winExt,'None')
    lExt = round(winExtLength * nSample * 0.01);
else
    lExt = 0;
    winExt = 'zpd';
end

% Scale to proper length for SWT (lExt_SWT >= lExt)
if ~strcmp(wType,'DWT')
    lExt = round((ceil((nSample+lExt*2)/(2^wLevel))*(2^wLevel)-nSample)/2);
end
if lExt ~= 0
    sig = wextend('addrow',winExt,sig,lExt);
end

% Circle spin
if thrCycSpin
    shiftVec = int64(linspace(-floor(nSample/2),floor(nSample/2),nCycSpin+1));
    shiftVec = shiftVec(2:end);
    sigDenoisedShift = zeros(nSample+lExt*2,nCh,nCycSpin);
    for nShift = 1:nCycSpin
        sigShift = circshift(sig,shiftVec(nShift),1);
        sigShift = WaveletDenoising(sigShift,sigDenoising,nSample);
        sigDenoisedShift(:,:,nShift) = circshift(sigShift,-shiftVec(nShift));
    end
    sigDenoised = mean(sigDenoisedShift,3);
else
    sigDenoised = WaveletDenoising(sig,sigDenoising,nSample);
end

% Crop data to cut winExt
sigDenoised = sigDenoised(lExt+1:end-lExt,:);


function sigDenoised = WaveletDenoising(sig,sigDenoising,nSample)

wName       = sigDenoising.waveletName;
wType       = sigDenoising.waveletType;
wLevel      = sigDenoising.waveletLevel;
thrShrink   = sigDenoising.thresholdShrink;
thrSel      = sigDenoising.thresholdSel;
thrSigma    = sigDenoising.thresholdSigma;
thrFac      = sigDenoising.thresholdFactor;
wienerFilt  = sigDenoising.wienerFilt;
keepApp     = sigDenoising.keepApp;

% Wavelet Decomp
dec = msWaveletDec(wType,sig,wLevel,wName);

% Select thresholds
[thrParams, sigma] = msWaveletThr(dec,thrSel,thrSigma,thrFac,nSample);

% Apply wavelet coefficients thresholding
decDenoised = dec;
for iD = 1:wLevel
    decDenoised.cD{iD} = msWaveletShrink(dec.cD{iD},thrShrink,thrParams(:,iD));
end
if ~keepApp
    decDenoised.cA = msWaveletShrink(dec.cA,thrShrink,thrParams(:,iD));
end

% Calculate and apply Wiener Correction Factor
if wienerFilt
    decRef = decDenoised;
    nSamples = size(decRef.cD{iD},2);
    for iD=1:wLevel
        wCF = (decRef.cD{iD}.^2) ./ (decRef.cD{iD}.^2 + repmat(sigma(:,iD).^2,1,nSamples));
        decDenoised.cD{iD} = wCF .* dec.cD{iD};
    end
    if ~keepApp
        wCF = (decRef.cA.^2) ./ (decRef.cA.^2 + repmat(sigma(:,iD+1).^2,1,nSamples));
        decDenoised.cA = wCF .* dec.cA;
    end
end

% Reconstruct Signal
sigDenoised = msWaveletRec(decDenoised)';
