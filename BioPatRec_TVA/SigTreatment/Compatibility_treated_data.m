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
% Function to keep the compatibility with data treated in older versions of
% the software
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-06-30 / Max Ortiz / Creation
% 2012-05-17 / Max Ortiz / update to sigFeatures


function sigFeatures = Compatibility_treated_data(treated_data)

    tempF = fieldnames(treated_data);
    if strcmp(tempF(1),'Fs')

        sigFeatures.sF = treated_data.Fs;
        sigFeatures.tW = treated_data.tw;
        sigFeatures.nCh = 1:4;
        sigFeatures.dev = 'AD2/3';

%        sigFeatures.nR = treated_data.Nr;
%        sigFeatures.eTs = treated_data.eTs;
%        sigFeatures.nw = treated_data.nw;

       sigFeatures.fFilter = treated_data.filters;
       sigFeatures.sFilter = 1;


        sigFeatures.trSets = treated_data.trN;
        sigFeatures.vSets = treated_data.vN;
        sigFeatures.tSets = treated_data.tN;
        sigFeatures.trFeatures = treated_data.trdata;
        sigFeatures.vFeatures = treated_data.vdata;
        sigFeatures.tFeatures = treated_data.tdata;
        sigFeatures.mov = treated_data.msg;
            
    else
        sigFeatures = treated_data;
    end