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
% Band-pass filter
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-07-18 / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment on update
% 2016-03-01 /Eva Lendaro / Changed filter() to filtfilt() which is
%                           zero-phase and does not give trainsient in case
%                           of offset

function [dataf] = FilterBP (Fs, data, cF1, cF2)

N   = 4;     % Order

% Calculate the zpk values using the BUTTER function.
[z,p,k] = butter(N/2, [cF1 cF2]/(Fs/2));

[sos_var,g] = zp2sos(z, p, k);
%Hd          = dfilt.df2sos(sos_var, g);

dataf       = filtfilt(sos_var,g,data);



