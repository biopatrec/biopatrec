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
% Function to keep the compatibility with recorded sessions in older versions of
% the BioPatRec, so the EMG_AQ
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-07-11 / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment on update

function recSession = Compatibility_recSession(ss)

    tempF = fieldnames(ss);
    if strcmp(tempF(1),'Fs')

        recSession.sF = ss.Fs;
        recSession.sT = ss.Ts;
        recSession.nM = ss.Ne;
        recSession.nR = ss.Nr;
        recSession.cT = ss.Tc;
        recSession.rT = ss.Tr;
        recSession.cTp = ss.Psr;
        recSession.date = ss.date;
        recSession.mov = ss.msg;

        recSession.tdata = ss.tdata;
        recSession.trdata = ss.trdata;

    end