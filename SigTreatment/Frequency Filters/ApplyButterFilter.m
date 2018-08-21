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
% Apply the requested BW filter to data
%
% ------------------------- Updates & Contributors ------------------------
% 2009-04-16 / Max Ortiz / Creation
% 20xx-xx-xx / Author  / Comment
% 2016-03-01 /Eva Lendaro / Changed filter() to filtfilt() which is
%                           zero-phase and does not give trainsient in case
%                           of offset
% 2016-04-20 / Julian Maier / changed filter cofficient to a,b instead of
                            % z,p,k --> faster


function [dataf] = ApplyButterFilter(Fs,N,Fc1,Fc2,data)

[b,a]     = butter(N/2, [Fc1 Fc2]/(Fs/2));
dataf     = filtfilt(b,a,data);
