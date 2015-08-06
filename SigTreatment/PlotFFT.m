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
% Plot the FFT of a vector given in data. It has a routine to smooth the
% graphical representation using a sliding averaging window.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2013-08-01 / Max Ortiz / Creation
% 20xx-xx-xx / Author  / Comment on update


function PlotFFT(data, sF, color)

    nS  = length(data(:,1));        % It used to be sF*sT but due to change in lenght witht training data
    sT  = nS/sF;
    tt  = 0:1/sF:sT-1/sF;           % Create vector of time
    
    if size(tt,2) ~= size(data,1)
        nSd = size(data,1)- size(tt,2); 
        tt(1,end:end+nSd) = 0;
    end
    
    %Fast Fourier Transform
    NFFT = 2^nextpow2(nS);                 % Next power of 2 from number of samples
%    NFFT = 1024;
    dataf = fft(data,NFFT)/nS;    
    f = sF/2*linspace(0,1,NFFT/2+1);
    m = 2*abs(dataf(1:NFFT/2+1));
    m(1:2) = 0;
    
    % Smooth
    n = 3;
    nn = 2;
    for j = 1 :nn
        clear mT;
        for i = n+1: size(m,1)-n
            mT(i,1) = mean(m(i-n:i+n));
        end
        mT(end:end+n)=0;
        m = mT;        
    end

    % Normalize
    vMax = max(m);
    m = m ./vMax;
    
%    figure();
    plot(f,m,color);
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')