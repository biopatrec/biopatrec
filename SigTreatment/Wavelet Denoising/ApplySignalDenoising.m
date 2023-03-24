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
% This function applies WaveletDenoising techniques on each time window.
%
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-02-03 / Julian Maier  / Creation


function [trDataDenoised, vDataDenoised, tDataDenoised, stopFlag] = ApplySignalDenoising(sigTreated, trData, vData, tData)

disp('Apply Signal Denoising...')

% Initialize important numbers
nSample = size(trData,1);
nCh = size(trData,2);
nMov = size(trData,3);
ntrSets = sigTreated.trSets;
nvSets = sigTreated.vSets;
ntSets = sigTreated.tSets;
nW = sigTreated.nW;
nWinTot = nW * nMov;

% nSample x nCh x nWinTot
allData = cat(4,trData,vData,tData);
allDataDenoised = zeros(size(allData));

% Waitbar
h = waitbar(0,'Compute wavelet denoising...');

% Measure computation time
t = zeros(1,nW*nMov); n = 0;

% Loop over Movements and Sets
for iW = 1:nW
    waitbar(iW /nW)
    for iMov = 1:nMov
        tic; n=n+1;
        % Set 2D-Signal input
        sig = allData(:,:,iMov,iW);
        sigDenoised = WaveletSignalDenoising(sig,sigTreated.sigDenoising);
        %sigDenoised = WaveletLoop(sig,sigTreated.sigDenoising);
        allDataDenoised(:,:,iMov,iW) = sigDenoised;
        t(n) = toc;
    end
end
close(h)

% Measure computation time
time = t(10:end);
timeAvg = mean(time) * 1e3;
timeStd = std(time) * 1e3;
disp(['Average time: ' num2str(timeAvg) ' ' char(177) ' ' num2str(timeStd,3) ' ms'])

% Uncat Data
[trDataDenoised,vDataDenoised,tDataDenoised] = SplitCatData(allDataDenoised,sigTreated);

% Check wavelet denoising
if sigTreated.wOverlap == 0
    NonOverlap=sigTreated.sF*sigTreated.tW;
else
    NonOverlap=sigTreated.sF*sigTreated.wOverlap;
end
iMov = 1;

f = figure('Name',['Denoised Signal of Movement: ' sigTreated.mov{iMov}],...
    'Color',[1 1 1],'Units','normalized','Outerposition',[0.05 0.07 0.9 0.9]);
ax = cell(nCh,1);
nCol = 2;
nRow = ceil(nCh/2);
for iCh = 1:nCh
    yRaw = reshape(squeeze(trData(1:NonOverlap,iCh,iMov,:)),[],1);
    yDen = reshape(squeeze(trDataDenoised(1:NonOverlap,iCh,iMov,:)),[],1);
    x = [0:length(yRaw)-1]/sigTreated.sF;
    ax{iCh}=subplot(nRow,nCol,iCh);
    plot(x,yRaw,x,yDen)
    title(['Ch' num2str(iCh)])
    xlabel('[s]')
    if mod(iCh,2) ~= 0
        ylabel('[mV]')
    end
    if iCh == 1
        legend('Raw','Den','Location',[0.51 0.5 0.01 0.01]);
        legend('boxoff')
        
        t = annotation('textbox',[.08 0.04 1 .01],'String','Check wavelet denoising performance! Press any button to continue...');
        t.FontSize = 12;
        t.LineStyle = 'none';
        t.FitBoxToText = 'on';
    end
    xlim([0,x(end)])
end
linkaxes([ax{:}],'x')

if ~isfield(sigTreated,'spath') 
    disp('Check wavelet denoising performance. Press any button to continue.')
    pause
    button = questdlg('Satisfied with denoised Signal?','Check Denoise','Yes','No','Yes');
    switch button
        case 'Yes'
            stopFlag = 0;
            close(f)
        case 'No'
            stopFlag = 1;
            disp('Signal treatment aborded...')
            close(f)
            return
    end
else
    stopFlag = 0;
    str = clipboard('paste');
    path = [sigTreated.spath filesep 'fig' filesep];
    if ~exist(path)
        mkdir(sigTreated.spath,'fig');
    end
    savefig(f,[path num2str(sigTreated.rn) '.fig'],'compact');
    close(f)
end
