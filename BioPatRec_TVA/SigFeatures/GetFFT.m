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
% Routine based in matlab examples, further optimization is probabily
% possible
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% Max Ortiz 2009-04-29 Creation
% Max Ortiz 2011-07-28 Adapted to BioPatRec


function pF = GetFFT(pF)

    cF = 1000;
    
    % Fast Fourier Transform
    NFFT    = 2^nextpow2(pF.sp);                % Next power of 2 from number of samples
    dataf   = fft(pF.data,NFFT)/pF.sp;                % Gets the fast fourier transform
    pF.fftData = 2*abs(dataf((1:NFFT/2+1),:));  % Get the half of the data considering abs values,
                                                %   since it is simetric and we
                                                %   only look at the half, it is multiply for 2
    pF.fftData(1,:) = 0;                        % The first element is made 0 to reduce artifats of low fqs.

    pF.fftDataT = sum(pF.fftData);              % Sum of all frequency contributions
    
    pF.fV = pF.sF/2*linspace(0,1,NFFT/2+1);     % Creates the frequency vector
                                            
    % Cuff the matrix to Fc to analysis
    cS = round(cF * length(pF.fftData(:,1)) / (pF.sF/2));
    pF.fftData = pF.fftData(1:cS,:);
    pF.fV = pF.fV(1:cS);



