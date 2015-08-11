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
% Function to pre-process bioelectric recordings. It's call from the
% treatment GUI and requires the handles.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-07-07 / Max Ortiz  / Moved out from the preProcessing botton 
% 20xx-xx-xx / Author     / Comment on update

function sigTreated = PreProcessing(handles)

    % Get the recSession
    set(handles.t_msg,'String','Loading recSession...');
    recSession = get(handles.t_recSession,'UserData');

    %Remove movements if required %---------------------------------------
    movSel = get(handles.lb_movements,'Value');        
    nM = str2double(get(handles.et_nM,'String'));        

    if nM ~= length(movSel)        
        recSession = Split_recSession_Mov(movSel, recSession);
    end                
    
    %Remove channels if required %---------------------------------------
    chSel = get(handles.lb_nCh,'Value');        

    if length(recSession.nCh) ~= length(chSel)
        allCh = get(handles.lb_nCh,'String');    
        for i = 1 : length(chSel)
            channels(i) = str2double(allCh(chSel(i)));
        end
        
        recSession = Split_recSession_Ch(channels, recSession);
        
    end    
    
    %Remove trasient %---------------------------------------------------
    cTp = str2double(get(handles.et_cTp,'String'));
    sigTreated = RemoveTransient_cTp(recSession, cTp);

    %Add rest as a movement data %---------------------------------------
    if get(handles.cb_rest,'Value')
        sigTreated = AddRestAsMovement(sigTreated, recSession);
        % It informs the user of the changes made, however it conflics when
        % a whole folder is treated
%        set(handles.et_nM,'String',num2str(sigTreated.nM));
%        set(handles.lb_movements,'Value',1:sigTreated.nM);
%        set(handles.lb_movements,'String',sigTreated.mov);

%         movSel = [movSel sigTreated.nM];
%         set(handles.lb_movements,'Value',movSel);
    end
    
    % Upload sigtreated to the GUI----------------------------------------
    set(handles.t_sigTreated,'UserData',sigTreated);
    set(handles.t_msg,'String','sigTreated uploaded');
    
