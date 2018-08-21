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
% [Give a short summary about the principle of your function here.]
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 20xx-xx-xx / Max Ortiz  / Creation
% 2017-03-06 / Simon Nilsson / Updated to work with lower Fs
% 20xx-xx-xx / Author  / Comment on update

function [data] = BSbutterPLHarmonics(Fs, data)

N   = 20;  % Order

fPl = 50;  % Power line frequency [Hz]
dF  = 1;   % Frequency delta for filtering
Nh  = 11;  % Number of harmonics to filter

% Maximum central frequency, limited by sampling frequency
Fmax = min(Fs/2 - dF,(Nh+1)*fPl);

for F = fPl : fPl : Fmax
    Fc1 = F - dF;  % First Cutoff Frequency
    Fc2 = F + dF;  % Second Cutoff Frequency

    [z,p,k] = butter(N/2, [Fc1 Fc2]/(Fs/2), 'stop');
    [sos_var,g] = zp2sos(z, p, k);
    Hd          = dfilt.df2sos(sos_var, g);
    data = filter(Hd,data);
end

