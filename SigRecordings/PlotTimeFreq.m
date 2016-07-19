% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec © which is open and free software under 
% the GNU Lesser General Public License (LGPL). See the file "LICENSE" for 
% the full license governing this code and copyrights.
%
% BioPatRec was initially developed by Max J. Ortiz C. at Integrum AB and 
% Chalmers University of Technology. All authors??? contributions must be kept
% acknowledged below in the section "Updates % Contributors". 
%
% Would you like to contribute to science and sum efforts to improve 
% amputees??? quality of life? Join this project! or, send your comments to:
% maxo@chalmers.se.
%
% The entire copyright notice must be kept in this or any source file 
% linked to BioPatRec. This will ensure communication with all authors and
% acknowledge contributions here and in the project web page (optional).
%
% -------------------------- Function Description -------------------------
% Plots time and frequency signal to external figure
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-02-01 / Julian Maier / Creation
% 20xx-xx-xx / Author  / Comment on update

function PlotTimeFreq()

% Load data
load('cdata.mat')
tt          = 0:1/sF:sT-1/sF;
nS          = length(cdata(:,1));
nCh         = size(tempdata,2);
if nCh > 1
   warndlg('Only one-channel data!')
   return
end

% Input for legendname
x = inputdlg('Enter name of current data:',...
    'Name data', [1 30]);
inputStr = x{1};

if size(tt,2) ~= size(cdata,1)
    nSd = size(cdata,1)- size(tt,2);
    tt(1,end:end+nSd) = 0;
end

%Fast Fourier Transform
NFFT = 2^nextpow2(nS);
f = sF/2*linspace(0,1,NFFT/2);
dataf = fft(tempdata(1:nS,:),NFFT)/nS;
m = 2*abs(dataf((1:NFFT/2),:));
mRel = m * max(m)^-1;

% Check for figures
if isempty(findall(0,'Type','Figure','Name','EMG time'))
    s1 = figure('name','EMG time','color',[1 1 1]);
    plot(tt(1:length(tempdata(:,1))),tempdata.*1e4);
    legend(inputStr);
    legend boxoff
    xlabel('Time [s]')
    ylabel('Potential [mV]')
else
    s1 = findall(0,'Type','Figure','Name','EMG time');
    figure(s1);
    hold on
    plot(tt(1:length(tempdata(:,1))),tempdata.*1e4);
    l = findobj(s1,'Type','legend');
    currStr = get(l,'String');
    legend({currStr{:}, inputStr});
    legend boxoff
end

if isempty(findall(0,'Type','Figure','Name','EMG spectrum'))
    s2 = figure('name','EMG spectrum','color',[1 1 1]);
    plot(f,mRel);
    legend(inputStr);
    legend boxoff
    xlim([0,sF/2]);
    xlabel('Frequency [Hz]')
    ylabel('Normalized magnitude')
else
    s1 = findall(0,'Type','Figure','Name','EMG spectrum');
    figure(s1);
    hold on
    plot(f,mRel);
    legend({currStr{:}, inputStr});
    legend boxoff
end
