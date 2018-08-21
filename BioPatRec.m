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
% BioPatRec is a research platform for testing and development of
% algorithms for prosthetic control. This function call the main GUI.
% For more information and documention visit:
% http://code.google.com/p/biopatrec/
%
% ------------------------- Updates & Contributors ------------------------
% 2009-04-02 / Max Ortiz  / Creation of EMG_AQ
% 2011-22-06 / Max Ortiz  / Software name changed from EMG_AQ to BioPatRec
% 2018-09-07 / Andreas Eiler / change current folder due to writing permissions of cdata
% YYYY-DD-MM / Author / Update
close all;
clear all;

%EMG_AQ
GUI_BioPatRec;

%% Function finds the Folder where BPR is stored and cuts the Path by the filename
% Current Folder has to be changed to this folder due to writing
% permissions for the cdata.m file
 BPR_Path = which('BioPatRec.m'); %find location of BPR and cut the path to the folder
 BPR_cut = 0;
 leng_BPR_Path = length(BPR_Path);
 
 while ~BPR_cut %cut the Path to the folder
     if BPR_Path(leng_BPR_Path) ~= '\'
         BPR_Path(leng_BPR_Path) = [];
         leng_BPR_Path = leng_BPR_Path - 1;
     else
         BPR_Path(leng_BPR_Path) = [];
         BPR_cut = 1;
     end
 end
 
 cd (BPR_Path)


