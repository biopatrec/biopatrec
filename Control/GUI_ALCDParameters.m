function figureH = GUI_ALCDParameters(inObj,loadDefaults)

    lOffset = 20;                       % Left label offset
    eOffset = 150;                      % Left element offset
    hOffset = 30;                       % Height offset
    
    handles = guidata(inObj);
    
    % Load default values if none have been selected
    if ~isfield(handles,'patRec') || ~isfield(handles.patRec,'alcdParams')
        handles.patRec.alcdParams.dspEnable    = 1;
        handles.patRec.alcdParams.wLength      = 256;
        handles.patRec.alcdParams.wOverlap     = 192;
        handles.patRec.alcdParams.swtType      = 1;
        handles.patRec.alcdParams.loffEnable   = 0;
    end
    
    % This function may be called just to load the default parameters.
    % In that case, just save the alcdParams structure to the parent
    % data structure and return without opening up a GUI window.
    if exist('loadDefaults','var') && loadDefaults
        guidata(inObj,handles);
        return;
    end
    
    %%% UI Controls %%%
    
    values = handles.patRec.alcdParams;
    figureH = figure('Visible','off','Position',[360,500,245,320], ...
        'ToolBar','none','MenuBar','none');
    
    % Title Text
    uicontrol('Style','text','String','Parameters for ALC-D Processing', ...
        'Position',[20,hOffset*8,205,75],'FontWeight','bold','FontSize',16);
    
    % DSP Filters
    uicontrol('Style','text',...
        'String','DSP Filters:','Position',[lOffset,hOffset*7,150,20],...
        'HorizontalAlignment','left');
    controls.dspEnable = uicontrol('Style','checkbox',...
        'String','','Value',values.dspEnable,'Position',[eOffset,hOffset*7,20,20]);

    % Window Length
    uicontrol('Style','text',...
        'String','Window Length:','Position',[lOffset,hOffset*6,150,20],...
        'HorizontalAlignment','left');
    controls.wLength = uicontrol('Style','edit',...
        'String',num2str(values.wLength),'Position',[eOffset,hOffset*6,75,20]);

    % Window Overlap
    uicontrol('Style','text',...
        'String','Window Overlap:','Position',[lOffset,hOffset*5,150,20],...
        'HorizontalAlignment','left');
    controls.wOverlap = uicontrol('Style','edit',...
        'String',num2str(values.wOverlap),'Position',[eOffset,hOffset*5,75,20]);

    % SWT Processing
    uicontrol('Style','text',...
        'String','SWT Shrinkage:','Position',[lOffset,hOffset*4,150,20],...
        'HorizontalAlignment','left');
    controls.swtType = uicontrol('Style','popupmenu',...
        'String',{'None','Motion Only','Soft','Hard','Hyperbolic','Adaptive','Non-Negative'},...
        'Value',values.swtType,'Position',[eOffset,hOffset*4,75,20]);

    % Lead-Off Handling
    uicontrol('Style','text',...
        'String','Lead-Off Detection:','Position',[lOffset,hOffset*3,150,20],...
        'HorizontalAlignment','left');
    controls.loffEnable = uicontrol('Style','checkbox',...
        'String','','Value',values.loffEnable,'Position',[eOffset,hOffset*3,20,20]);

    % Load Defaults Button
    pb_defaults = uicontrol('Style','pushbutton','String','Defaults', ...
        'Position',[lOffset,20,75,30]);

    % OK/Close Dialog Button
    pb_ok = uicontrol('Style','pushbutton', 'String','OK', ...
        'Position',[150,20,75,30]);
    
    set(pb_ok,'Callback',{@ExitGUI,inObj,controls});
    set(pb_defaults,'Callback',{@LoadDefaults,inObj,controls});

    set(figureH,'Visible','on');
end

function CheckParams(inObj, controls)
% -------------- FUNCTION DESCRIPTION ----------------
%  Checks string parameters for validity. For invalid
%  inputs, loads the default values and updates the
%  status string describing the fault.
% ----------------------------------------------------

    handles = guidata(inObj);
    
    wLength  = str2double(get(controls.wLength,'String'));
    wOverlap = str2double(get(controls.wOverlap,'String'));
    swtType = get(controls.swtType,'Value');
    if ~isfinite(wLength) || ~isfinite(wOverlap) || wLength < wOverlap
        set(handles.t_msg,'String','Invalid window selection');
        set(controls.wLength,'String','256');
        set(controls.wOverlap,'String','192');
    elseif (swtType > 1) && (~IsPow2(wLength) || ~IsPow2(wLength-wOverlap))
        set(handles.t_msg,'String','SWT Window must be power of 2');
        set(controls.wLength,'String','256');
        set(controls.wOverlap,'String','192');
    end
    
    guidata(inObj,handles);
end

function SaveToGUI(inObj, controls)
% -------------- FUNCTION DESCRIPTION ----------------
%  Saves the control parameters selected in this GUI
%  to the parent data structure.
% ----------------------------------------------------

    handles = guidata(inObj);
    
    handles.patRec.alcdParams.dspEnable    = get(controls.dspEnable,'Value');
    handles.patRec.alcdParams.wLength      = str2double(get(controls.wLength,'String'));
    handles.patRec.alcdParams.wOverlap     = str2double(get(controls.wOverlap,'String'));
    handles.patRec.alcdParams.swtType      = get(controls.swtType,'Value');
    handles.patRec.alcdParams.loffEnable   = get(controls.loffEnable,'Value');
    
    guidata(inObj,handles)
end

function ExitGUI(~, ~, inObj, controls)
% -------------- FUNCTION DESCRIPTION ----------------
%  Activated when the OK button is pressed. Checks the
%  parameters for validity and loads them into the
%  parent data structure.
% ----------------------------------------------------
    
    CheckParams(inObj, controls);
    SaveToGUI(inObj, controls);
    close(clf);
end

function LoadDefaults(~, ~, inObj, controls)
% -------------- FUNCTION DESCRIPTION ----------------
%  Activated when the Defaults button is pressed.
%  Loads the default parameters into all fields and
%  saves values to the parent data structure.
% ----------------------------------------------------

    set(controls.dspEnable,'Value',1);
    set(controls.wLength,'String','256');
    set(controls.wOverlap,'String','192');
    set(controls.swtType,'Value',1);
    set(controls.loffEnable,'Value',0);
    SaveToGUI(inObj, controls);
end

function ret = IsPow2(num)
% -------------- FUNCTION DESCRIPTION ----------------
%  Determines whether or not a number is a power of 2.
% ----------------------------------------------------

    ret = isequal(fix(log2(num)),log2(num));
end
