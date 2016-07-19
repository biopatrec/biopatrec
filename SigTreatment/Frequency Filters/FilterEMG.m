% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec ?? which is open and free software under
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
% EMG zero-phase band-pass filter + notch filter.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-03-07 / Julian Maier  / Creation
% 2016-05-03 / Julian Maier  / Changed notch filter
% 20xx-xx-xx / Author  / Comment on update

function data = FilterEMG(sF, data, nBP, cF1, cF2)

%% Create filter coefficients

% High and Low Pass Filter
[b,a] = butter(nBP/2,[cF1, cF2]/(sF/2));
data = filtfilt(b,a,data); %zero-phase filtering

if cF1 < 50
    % 50 Hz Notch Filter
    wo = 50/(sF/2);  bw = wo/30;
    [b_n,a_n] = iirnotch(wo,bw);
    data = filtfilt(b_n,a_n,data);
end
