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
%  Funtion to load "trated_data" in GUI_PatRec
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-06-25 / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment on update%


function Load_treated_data(treated_data, handles)

    % Keep compatibility with previous files
    treated_data = Compatibility_treated_data(treated_data);

    % Load treated data
    set(handles.t_treated_data,'UserData',treated_data);            
    % Load information from treated data
    set(handles.et_trSets,'String',num2str(treated_data.trSets));    
    set(handles.et_vSets,'String',num2str(treated_data.vSets));    
    set(handles.et_tSets,'String',num2str(treated_data.tSets));    
    set(handles.lb_movements,'String',treated_data.mov);            

    allFeatures = fieldnames(treated_data.trdata);       
    set(handles.lb_features,'String',allFeatures); 
    set(handles.lb_features,'Value',1:length(allFeatures));

    % Enable controls
    set(handles.pm_SelectAlgorithm,'Enable','on');
    set(handles.rb_all,'Enable','on');
    set(handles.rb_top3,'Enable','on');
    set(handles.rb_top4,'Enable','on');   
    set(handles.rb_top4,'Value',1);
    set(handles.lb_features,'Value',[2 7 9 13]); % tmabs, twl, tzc, tslpch EH03, HZ09, SL09   

    % User message
    set(handles.t_msg,'String','Treated data loaded');
