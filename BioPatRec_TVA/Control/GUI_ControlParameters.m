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
%
%   GUI to get quick access to control algorithm parameters. Called from
%   GUI_TestPatRec_Mov2Mov when options-button is clicked.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-05 / Joel Falk-Dahlin  / Creation
% 2012-10-08 / Joel Falk-Dahlin  / Added correct buffer setting from
                                % internal property (.prop.bufferSize) and
                                % not only from parameter
                                % (.parameter.bufferSize) allowing for
                                % different types of controlAlgs.
% 2012-10-10 / Joel Falk-Dahlin  / Added check of previously init outBuffer
                                % This allows for external setting of
                                % outBuffer from InitFile. This way the
                                % outBuffer can be set to have any ammount
                                % of elements, not only patRec.nOuts
% 20xx-xx-xx / Author  / Comment on update

function figureH = GUI_ControlParameters(inObj)

% Read data from MainGUI
handles = guidata(inObj);

if isfield(handles,'patRec')
    if isfield(handles.patRec.control,'controlAlg')
        
        % Create GUI-window
        figureH = figure;
        
        % Set up Vars used by GUI-code
        patRec = handles.patRec;
        parameterNames = fieldnames(patRec.control.controlAlg.parameters);
        nParameters = size(parameterNames,1);
        
        paramValBoxes = zeros(1,nParameters);
        
        % Set up position and sizes for the different GUI-fields
        xPosNameBox = 20;
        yPosNameBox = 70;
        xSizeNameBox = 150;
        ySizeNameBox = 20;
        
        xPosValBox = xPosNameBox + xSizeNameBox + 10;
        yPosValBox = yPosNameBox;
        xSizeValBox = 150;
        ySizeValBox = ySizeNameBox;
        
        % Create UI objects for the parameters
        for i = 1:nParameters
            
            % Create UI-name boxes from the parameters
            uicontrol('Style', 'text', 'String', parameterNames{i},...
                    'Position', [xPosNameBox yPosNameBox+(i-1)*ySizeNameBox, ...
                    xSizeNameBox ySizeNameBox]);
            
            % Save value of the parameters
            parameterValue = patRec.control.controlAlg.parameters.(parameterNames{i});

            % Create UI-value boxes from the parameters
            paramValBoxes(i) = uicontrol('Style', 'edit', 'String', parameterValue,...
                                'Position', [xPosValBox yPosValBox+(i-1)*ySizeValBox, ...
                    xSizeValBox ySizeValBox],...
                                'Callback', {@SetParam,inObj}, ...
                                'Tag',parameterNames{i});
        end
        
        % Create a UI-title
        title = uicontrol('Style', 'text', 'String', ['Parameters for ', patRec.control.controlAlg.name{1}],...
                    'Position', [(xPosNameBox+xPosValBox)/2 yPosNameBox+(i+1)*ySizeNameBox, ...
                    250 80], ...
                    'Tag', 'Title');
                
        % Set title fontsize
        set(title,'FontSize',15);
        
        % Create OK-button
        uicontrol('Style', 'pushbutton', 'String', 'OK',...
            'Position', [xPosValBox+xSizeValBox+20 yPosValBox 50 40], ...
            'Callback', {@ExitGUI,inObj,paramValBoxes});
        
        % Create Default-button
        uicontrol('Style', 'pushbutton', 'String', 'Default',...
            'Position', [xPosValBox+xSizeValBox+20 yPosValBox+50 50 40], ...
            'Callback', {@SetDefault,inObj});
        
        % Resize the GUI-window
        figurePos = get(figureH,'Position');
        figurePos(3:4) = [xSizeNameBox+xSizeValBox+50+2*xPosNameBox+20,...
                          yPosNameBox+50+yPosNameBox+(i+1)*ySizeNameBox];
        set(figureH,'Position',figurePos,'MenuBar','none');
        
    else
        % If patRec does not contain any control algorithm print message
        set(handles.t_msg,'String','No Control Algorithm set');
        return
    end
else
    % If the MainGUI-data does not contain any patRec print message
    set(handles.t_msg,'String','No PatRec Loaded');
    return
end

end

% -------------- GUI CALLBACK FUNCTIONS ------------------

function SetParam(hObj, event, inObj)
% -------------- Function Description --------------------
%   Activated when enter press in any of the value fields, saves the value
%   in the field to the patRec and saves patrec to mainGUI data.
%---------------------------------------------------------
    handles = guidata(inObj);
    if ~isnan( str2double(get(hObj,'String') ) )
        handles.patRec.control.controlAlg.parameters.(get(hObj,'Tag')) = str2double(get(hObj,'String'));
    else
        handles.patRec.control.controlAlg.parameters.(get(hObj,'Tag')) = get(hObj,'String');
    end
    guidata(inObj,handles);
end

function ExitGUI(hObj, event, inObj,paramValBoxes)
% -------------- FUNCTION DESCRIPTION ----------------
%   Activated when OK-button is pressed. Sets values of valuefield and
%   exits GUI window.
% ----------------------------------------------------


    % Set Parameters to current value of valueboxes, precaution if
    % someone forgets to press ENTER when changing a value
    for i = 1:size(paramValBoxes,2)
        SetParam(paramValBoxes(i),[],inObj);
    end
    
    % Update the handles so they exists with current instance
    handles = guidata(inObj);
    
    % Update buffers using current parameters
    handles.patRec = ReInitControl(handles.patRec);
    
    % Save PatRec with updated buffer size
    guidata(inObj, handles);
    
    % Close the Parameter GUI
    close(clf);
end

function SetDefault(hObj,event,inObj)
% ---------------- Function Description --------------------------
%   Activates when Default-button is pressed, reinitilizes the controlAlg
%   from the definition file, saves to MainGUI and closes and reopen
%   parameter GUIwindow.
% -----------------------------------------------------------------
    handles = guidata(inObj);
    patRec = handles.patRec;
    handles.patRec = InitControl_new(patRec,patRec.control.controlAlg.name{1});
    guidata(inObj,handles);
    close(clf);
    GUI_ControlParameters(inObj);
end
