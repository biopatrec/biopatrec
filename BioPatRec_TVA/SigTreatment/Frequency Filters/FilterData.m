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
% Funtion to filter the received data according to filtering option at the
% GUI
% Input = Data and GUI handles
% Output = Filtered data 
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2009-04-15 / Max Ortiz  / Creation
% 2012-11-25 / Max Ortiz  / Update to BioPatRec coding standard
% 20xx-xx-xx / Author  / Comment on update

function data = FilterData(data, handles, Fs)

    if get(handles.cb_filter50hz,'Value')
        data = Filter50hz(Fs, data);
    end

    if get(handles.cb_filterBP,'Value')
        data = FilterBP(Fs, data);
    end

    if get(handles.cb_filter80Hz,'Value')
        data = FilterHP80hz(Fs, data);
    end
