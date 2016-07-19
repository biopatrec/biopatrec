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
% Function to pre-process bioelectric recordings. It's called from the
% treatment GUI and requires the handles.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-07-07 / Max Ortiz  / Moved out from the preProcessing botton 
% 2014-12-06 / Max Ortiz  / Added downsampling option
% 2014-12-28 / Max Ortiz  / Added scaling option 
% 2015-12-08 / Eva Lendaro / Fixed problem on "Remove channels" whne used 
                          % with more then 9 channels
% 20xx-xx-xx / Author     / Comment on update
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
    
    %Remove channels, if required %---------------------------------------
    chSel = get(handles.lb_nCh,'Value');        

    if length(recSession.nCh) ~= length(chSel)
        allCh = get(handles.lb_nCh,'String');    
        for i = 1 : length(chSel)
            channels(i) = str2double(allCh(chSel(i),:));
        end
        
        recSession = Split_recSession_Ch(channels, recSession);
        
    end    

    % Downsample, if required %---------------------------------------
    sF = str2double(get(handles.et_sF,'String'));        
    dS = str2double(get(handles.et_downsample,'String'));        
    if sF ~= dS
        if recSession.sF < dS
            errordlg('The downsample frequency is higher than the original sF','Error');
            set(handles.t_msg,'String','Error in downsample frequency');
            set(handles.et_downsample,'String',num2str(recSession.sF));
        else
            recSession = Downsample_recSession(recSession, dS);        
        end
    end

    % Add noise, if required %---------------------------------------
    pStd = str2double(get(handles.et_noise,'String'));        
    if pStd ~= 0    
        recSession = AddNoise_recSession(recSession, pStd);        
    end
    recSession.noise = pStd;
    
    % Scaling, if required %---------------------------------------
    scalingV = get(handles.pm_scaling,'Value');    
    scalingS = get(handles.pm_scaling,'String');    
    scalingBits  = str2double(scalingS{scalingV});
    if scalingV ~= 1    % If other than None
        recSession = Scale_recSession(recSession, scalingBits);
    end
    recSession.scaled = scalingBits;
    
    %% Change from recSession to sigTreated
    
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
    
