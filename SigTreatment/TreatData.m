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
% Function to treat the raw data
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2009-07-20 / Max Ortiz  / Creation
% 2011-07-27 / Max Ortiz  / Update to coding standard
% 2011-07-27 / Max Ortiz  / Moved the "updated sigTreated" instructions out
%                           of the GUI push bottom
% 20xx-xx-xx / Author  / Comment on update

function sigTreated = TreatData(handles, sigTreated)

    %% Update sigTreated
    fFilters            = get(handles.pm_frequencyFilters,'String');    
    fFiltersSel         = get(handles.pm_frequencyFilters,'Value');    
    sigTreated.fFilter  = fFilters(fFiltersSel);
    
    sFilters            = get(handles.pm_spatialFilters,'String');    
    sFiltersSel         = get(handles.pm_spatialFilters,'Value');    
    sigTreated.sFilter  = sFilters(sFiltersSel);

    sigTreated.eCt      = sigTreated.cT * sigTreated.cTp;      % Effective contraction time
    sigTreated.wOverlap  = str2double(get(handles.et_wOverlap,'String'));
    sigTreated.tW       = str2double(get(handles.et_tw,'String'));
    sigTreated.nW       = str2double(get(handles.et_nw,'String'));
    sigTreated.trSets   = str2double(get(handles.et_trN,'String'));
    sigTreated.vSets    = str2double(get(handles.et_vN,'String'));
    sigTreated.tSets    = str2double(get(handles.et_tN,'String'));
        
    twSegMethods            = get(handles.pm_twSegMethod,'String');    
    twSegMethodsSel         = get(handles.pm_twSegMethod,'Value');    
    sigTreated.twSegMethod  = twSegMethods(twSegMethodsSel);
     
    allSigSeperaAlg             = get(handles.pm_SignalSeparation,'String');
    selSigSeperaAlg             = allSigSeperaAlg(get(handles.pm_SignalSeparation,'Value'));
    sigTreated.sigSeparation.Alg= selSigSeperaAlg;
    
    %% Filters
    set(handles.t_msg,'String','Applying filters...');
    sigTreated.trData = ApplyFilters(sigTreated, sigTreated.trData);
    set(handles.t_msg,'String','Filters applied');
    
    %% Signal Separation Alg - Compute
    
    set(handles.t_msg,'String','Computing SP...');
    sigTreated=ComputeSignalSeparation(sigTreated);
    set(handles.t_msg,'String','SP Computed');
     
  
    %% Split the data into the time windows
    set(handles.t_msg,'String','Segmenting data...');
    disp('Segmenting data...');
    [trData, vData, tData] = GetData(sigTreated);    
    %Remove raw trated data
    sigTreated = rmfield(sigTreated,'trData');                 
    set(handles.t_msg,'String','Data segmented');
    disp('Data segmented');

    %% Sig Separation Algortihms - Apply
    
    [trData vData tData]=ApplySignalSeparation(sigTreated,trData, vData, tData); 

    
    % add the new sets of tw for tr, v and t
    sigTreated.trData = trData;
    sigTreated.vData = vData;
    sigTreated.tData = tData;
    
end
