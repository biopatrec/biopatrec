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
% ------------------- Function Description ------------------
%   GUI to choose feature, thresholds and mapping for proportional control
%   It is launched from GUI_PatRec_Mov2Mov
%
% --------------------------Updates--------------------------
% [Contributors are welcome to add their email]
% 2012-10-26 / Joel Falk-Dahlin  / Creation
%
% 2012-11-06 / Joel Falk-Dahlin / Moved all proportionalControl variables
%                               to the patRec structure. Added text box to
%                               change the testing time.
% 2017-06-30 / Jake Gusman      / Revamped GUI to allow for the setting of
%                               individual thresholds for each movement
%                               class. Addition of 'logistic' function to
%                               list of speed maps. If ramp training done, 
%                               threshold edit boxes are automatically 
%                               populated by max and min contractions from
%                               that training.
%
% 20xx-xx-xx / Author     / Comment on update

function varargout = GUI_ProportionalControl(varargin)
%GUI_PROPORTIONALCONTROL M-file for GUI_ProportionalControl.fig
%      GUI_PROPORTIONALCONTROL, by itself, creates a new GUI_PROPORTIONALCONTROL or raises the existing
%      singleton*.
%
%      H = GUI_PROPORTIONALCONTROL returns the handle to a new GUI_PROPORTIONALCONTROL or the handle to
%      the existing singleton*.
%
%      GUI_PROPORTIONALCONTROL('Property','Value',...) creates a new GUI_PROPORTIONALCONTROL using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to GUI_ProportionalControl_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI_PROPORTIONALCONTROL('CALLBACK') and GUI_PROPORTIONALCONTROL('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI_PROPORTIONALCONTROL.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_ProportionalControl

% Last Modified by GUIDE v2.5 29-Jun-2017 16:42:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_ProportionalControl_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_ProportionalControl_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_ProportionalControl is made visible.
function GUI_ProportionalControl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for GUI_ProportionalControl
handles.output = hObject;

% Find if another GUI is passed
for i = 1:length(varargin)
    if isfield(varargin{i},'mainGUI')
        handles.mainGUI = varargin{i}.mainGUI;
    end
    if isfield(varargin{i},'patRec');
        handles.patRec = varargin{i}.patRec;
    end
end

% Save mainGUI to handles and update mainGUIHandles with proportional vars
if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    
    % Check if GUI handles has proportional control vars
    if isfield(handlesMainGUI.patRec.control.propControl,'propMaxThresh')
        set(handles.et_thresholdValue,'String',num2str(handlesMainGUI.patRec.control.propControl.propMaxThresh(1)));
    
        % set the rest of the threshold values for more than 1 movement trained
        % via ramp
        if length(handlesMainGUI.patRec.control.propControl.propMaxThresh) > 1
            for j = 2:length(handlesMainGUI.patRec.control.propControl.propMaxThresh)
                s = sprintf('et_thresholdValue%d',j);
                set(handles.(s),'String',num2str(handlesMainGUI.patRec.control.propControl.propMaxThresh(j)));
            end
        end
    end
    
    if isfield(handlesMainGUI.patRec.control.propControl,'propMinThresh')
        set(handles.et_minValue,'String',num2str(handlesMainGUI.patRec.control.propControl.propMinThresh(1)));
    
        % set the rest of the minimum values for more than 1 movement trained
        % via ramp
        if length(handlesMainGUI.patRec.control.propControl.propMaxThresh) > 1
            for j = 2:length(handlesMainGUI.patRec.control.propControl.propMaxThresh)
                s = sprintf('et_minValue%d',j);
                set(handles.(s),'String',num2str(handlesMainGUI.patRec.control.propControl.propMinThresh(j)));
            end
        end
    
    end    
    if isfield(handlesMainGUI.patRec.control.propControl,'propFeature')
        set(handles.pm_featureSelection,'Value',handlesMainGUI.patRec.control.propControl.propFeature);
    end
    if isfield(handlesMainGUI.patRec.control.propControl,'propSpeedMap')
        speedMapList = get( handles.pm_speedMap, 'String' );
        for i = 1:length( speedMapList )
            if strcmp(speedMapList{i}, handlesMainGUI.patRec.control.propControl.propSpeedMap )
                set(handles.pm_speedMap,'Value',i);
                break;
            end
        end
    end
    
    % Update mainGUIHandles to contain maxSpeedThresh and propFeature
%     handlesMainGUI.patRec.control.propControl.propMaxThresh = str2double(get(handles.et_thresholdValue,'String'));
    handlesMainGUI.patRec.control.propControl.propFeature = get(handles.pm_featureSelection,'Value');
    mapStr = get(handles.pm_speedMap,'String');
    selectedMap = mapStr( get(handles.pm_speedMap,'Value') );
    selectedMap = strtrim( selectedMap );
    handlesMainGUI.patRec.control.propControl.propSpeedMap = selectedMap;
    
if isfield(handlesMainGUI,'movList')       
    handles.movList = handlesMainGUI.movList;
    movements = [];
    for j = 1:length(handles.movList)
        movements = [movements; handles.movList(j).name];
    end

    % set drop down menus to trained movements
    for i = 1:length(handles.movList)
        s = sprintf('pm_move%d',i);
        set(handles.(s),'String',movements);
        set(handles.(s),'Value',i);
    end
    
    set(handles.pm_moveSelection,'String',movements);
end   
    
    % disable irrelevant lines
    for i = 2:12
        if i > length(handlesMainGUI.patRec.control.propControl.propMaxThresh)
            s = sprintf('pm_move%d',i);
            t = sprintf('et_minValue%d',i);
            u = sprintf('et_thresholdValue%d',i);
            set(handles.(s),'Enable','off');
            set(handles.(t),'Enable','off');
            set(handles.(u),'Enable','off');
        end
    end
        

            
        
    guidata(handles.mainGUI, handlesMainGUI);
    
    % Save patRec
    if isfield(handlesMainGUI,'patRec')
        handles.patRec = handlesMainGUI.patRec;
    end
end

% Save selected values to PropGUI handles
%handles.patRec.control.propControl.propMaxThresh = str2double(get(handles.et_thresholdValue,'String'));
handles.patRec.control.propControl.propFeature = get(handles.pm_featureSelection,'Value');

mapStr = get(handles.pm_speedMap,'String');
selectedMap = mapStr( get(handles.pm_speedMap,'Value') );
selectedMap = strtrim( selectedMap );
handles.patRec.control.propControl.propSpeedMap = selectedMap;

% Setup plot
ax = handles.speedAxes;
axes(ax);
set(ax,'XLim',[0 1], 'YLim',[0 100],'YTick',[0 25 50 75 100],'YTickMode','manual');
handles.speedPatch = patch([0 1 1 0],[0 0 0 0],'b');

ax = handles.featureAxes;
axes(ax);
set(ax,'XLim',[0 1]);
handles.featurePatch = patch([0 1 1 0],[0 0 0 0],'b');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_ProportionalControl wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_ProportionalControl_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function et_thresholdValue_Callback(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_thresholdValue as text
%        str2double(get(hObject,'String')) returns contents of et_thresholdValue as a double

% Save selected values to PropGUI handles
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMaxThresh(1) = str2double(get(handles.et_thresholdValue,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMaxThresh(1) = str2double(get(handles.et_thresholdValue,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end


% --- Executes during object creation, after setting all properties.
function et_thresholdValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_featureSelection.
function pm_featureSelection_Callback(hObject, eventdata, handles)
% hObject    handle to pm_featureSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_featureSelection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_featureSelection

set(handles.t_msg,'String','');
set(handles.featureAxes,'YLim',[0,1]);
set(handles.featurePatch,'YData',[0 0 0 0]);
set(handles.speedPatch,'YData',[0 0 0 0]);

% Save selected values to PropGUI handles
handles.patRec.control.propControl.propFeature = get(handles.pm_featureSelection,'Value');
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propFeature = get(handles.pm_featureSelection,'Value');
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function pm_featureSelection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_featureSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if isappdata(0,'selFeatures');
    selFeatures = getappdata(0,'selFeatures');
    set(hObject,'String',selFeatures);
    rmappdata(0,'selFeatures');
else
    set(hObject,'String','No Features Loaded');
end
guidata(hObject,handles);


% --- Executes on button press in pb_testThreshold.
function pb_testThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to pb_testThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Initialize if patRec is loaded
if isfield(handles,'patRec')
    set(handles.pb_testThreshold,'String','Running')
    set(handles.pb_testThreshold,'Enable','off');
    set(handles.t_msg,'String','Initialize...','ForegroundColor','g');
    drawnow;
    patRec = handles.patRec;
    testingTime = str2double( get(handles.et_testingTime,'String') );
    ComPortType         = handles.patRec.comm;
end
    
if strcmp (ComPortType, 'NI')
    
        chAI = zeros(1,8);  % 8 ch is the limit for the USB6009
        chAI(patRec.nCh) = 1; 
        %Init the SBI
        handles.s = InitSBI_NI(patRec.sF,testingTime,chAI);
        handles.s.NotifyWhenDataAvailableExceeds = (patRec.sF*0.05);

    % If DAQ in initialized
    if isfield(handles,'s')

        % Set messages
        set(handles.t_msg,'String','Running Test','ForegroundColor','g');
        drawnow;
        set(handles.featureAxes,'YLim',[0 1e-10]);

        % Remove any listener existing listeners
        if isfield(handles,'lh')
            delete(handles.lh);
            handles = rmfield(handles,'lh');
        end

        % Setup container to store sampled data from DAQ-card
        tempData = [];
        setappdata(hObject,'tempData',tempData);

        % get mainGUI handles, to be able to update predictions
        if isfield(handles,'mainGUI')
            handlesMainGUI = guidata(handles.mainGUI);
        else
            handlesMainGUI = [];
        end

        % create new listener
        handles.lh = handles.s.addlistener('DataAvailable', @(src,event) Test_ProportionalControl(src, event, hObject, handles, handlesMainGUI) );

        % Start test
        handles.s.startBackground();
        handles.s.wait();

        % Update Messages
        set(handles.pb_testThreshold,'String','Test');
        set(handles.pb_testThreshold,'Enable','on');
        set(handles.t_msg,'String','Test Done','ForegroundColor','g')

        % Delete listener and clear session
        delete(handles.lh);
        handles.s.stop();
        clear handles.s;
        handles = rmfield(handles,'s');

    % If DAQ in not initialized    
    else
        set(handles.t_msg,'String','No PatRec Loaded','ForegroundColor','r');
    end
else

        sF                  = patRec.sF;
        nCh                 = length(patRec.nCh);
        ComPortType         = patRec.comm;
        deviceName          = patRec.dev;
        sT                  = str2double( get(handles.et_testingTime,'String') );
        tW                  = patRec.tW;                                                  % Time window size
        iW                  = patRec.wOverlap;     % Increment window size
        pDiv                = tW/iW;        % Peeking devider
        tWs = tW*sF; 
        %iWs = iW*sF;
        
        % Prepare handles for next function calls
        handles.deviceName  = deviceName;
        handles.ComPortType = ComPortType;
        if strcmp (ComPortType, 'COM')
            handles.ComPortName = patRec.comn;
        end
        
        handles.sF          = sF;
        handles.sT          = sT;
        handles.nCh         = nCh;
        handles.sTall       = sT;

    if isfield(handles,'deviceName')
        
        % Set messages
        set(handles.t_msg,'String','Running Test','ForegroundColor','g');
        drawnow;
        set(handles.featureAxes,'YLim',[0 1e-10]);
        
        % Connect the chosen device, it returns the connection object
        obj = ConnectDevice(handles);

        % Set the selected device and Start the acquisition
        SetDeviceStartAcquisition(handles, obj);

        % Setup container to store sampled data from DAQ-card (???)
        tempData = [];
        setappdata(hObject,'tempData',tempData);

        % get mainGUI handles, to be able to update predictions
        if isfield(handles,'mainGUI')
            handlesMainGUI = guidata(handles.mainGUI);
        else
            handlesMainGUI = [];
        end
        
    %  cData = Acquire_tWs(deviceName, obj, nCh, tWs);
        for timeWindowNr = 1:sT/(tW/pDiv)
            cData = Acquire_tWs(deviceName, obj, nCh, tWs/pDiv);         % acquire a new time window of samples
            acquireEvent.Data = cData;
            Test_ProportionalControl(0,acquireEvent, hObject, handles, handlesMainGUI);
        end

        % Stop acquisition
        StopAcquisition(deviceName, obj);
        
            % Update Messages
            set(handles.pb_testThreshold,'String','Test');
            set(handles.pb_testThreshold,'Enable','on');
            set(handles.t_msg,'String','Test Done','ForegroundColor','g')
    end
end
% Save data
guidata(hObject,handles);

function Test_ProportionalControl(src,event, hObject, handles, handlesMainGUI)

% Read previously sampled data from testing session
tempData = getappdata(hObject,'tempData');

% Read patRec from handles
patRec = handles.patRec;

% Keep saving all recorded data
tempData = [tempData; event.Data];

% Only considered the data once it has at least the size of a time window
if size(tempData,1) >= (patRec.sF*patRec.tW)
    
    % Use only data size equal to the trained time window
    tData = tempData(end-patRec.sF*patRec.tW+1:end,:);
    
    % Signal processing, to calculate signal feature vector
    tSet = SignalProcessing_RealtimePatRec(tData, patRec);

    % Extract proportional Control variables from GUI textboxes
%     propMinThresh = str2double( get(handles.et_minValue,'String') );
%     propMaxThresh = str2double( get(handles.et_thresholdValue,'String') );
     propMinThresh = patRec.control.propControl.propMinThresh;
     propMaxThresh = patRec.control.propControl.propMaxThresh;
    propSpeedMap = patRec.control.propControl.propSpeedMap;
    
    % Extract tSet indicies
    nCh = length(patRec.nCh);
    selFeature = get(handles.pm_featureSelection,'Value');
    idx = nCh*(selFeature-1)+1:nCh*(selFeature-1)+nCh;
    
    % Calculate Feature value
    featureVal = abs( mean( tSet(idx) ) );
    
    % Map Feature value to speed percent
    speedPercent = CalculateDesiredSpeedPercent(featureVal, propMinThresh, ...
        propMaxThresh, propSpeedMap);
    
    % Get speedPercent for specific for the selected move
    selMove = get(handles.pm_moveSelection,'Value');
    speedPercent = speedPercent(selMove);
    
    % Plot speed and feature bars
    yLimVal = get(handles.featureAxes,'YLim');
    yLimVal = yLimVal(2);
    if featureVal > yLimVal
        set(handles.featureAxes,'YLim',[0 featureVal])
    end
    set(handles.featurePatch,'YData',[0 0 featureVal featureVal]);
    set(handles.speedPatch,'YData',[0 0 speedPercent speedPercent]);
    
    % If the main gui is open, predicted movement and update mainGUI
    if ~isempty(handlesMainGUI)
        
        % Signal processing
        tSet = SignalProcessing_RealtimePatRec(tData, handles.patRec);
        % One shoot PatRec
        outMov = OneShotPatRecClassifier(handles.patRec, tSet);
        
        % If no movement is predicted, predict rest
        if outMov == 0
            outMov = handles.patRec.nOuts;
        end
        
        % Draw predicted movement
        set(handlesMainGUI.lb_movements,'Value',outMov);
        drawnow;
    end
    
end

% Save the tempData back to the GUI so it can be used next time DAQ fires
% DataAvailable event
setappdata(hObject,'tempData',tempData);

% --- Executes during object creation, after setting all properties.
function t_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in pm_speedMap.
function pm_speedMap_Callback(hObject, eventdata, handles)
% hObject    handle to pm_speedMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_speedMap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_speedMap
speedMapList = get(hObject,'String');
val = get(hObject,'Value');
map = speedMapList{val};
map = strtrim( map );

handles.patRec.control.propControl.propSpeedMap = map;
guidata(hObject,handles);

% If MainGUI exists, save selected map to handlesMainGUI
if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propSpeedMap = map;
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function pm_speedMap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_speedMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_minValue_Callback(hObject, eventdata, handles)
% hObject    handle to et_minValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_minValue as text
%        str2double(get(hObject,'String')) returns contents of et_minValue as a double

% Save selected values to PropGUI handles
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMinThresh(1) = str2double(get(handles.et_minValue,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMinThresh(1) = str2double(get(handles.et_minValue,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_minValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_minValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_testingTime_Callback(hObject, eventdata, handles)
% hObject    handle to et_testingTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_testingTime as text
%        str2double(get(hObject,'String')) returns contents of et_testingTime as a double


% --- Executes during object creation, after setting all properties.
function et_testingTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_testingTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_move1.
function pm_move1_Callback(hObject, eventdata, handles)
% hObject    handle to pm_move1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_move1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_move1


% --- Executes during object creation, after setting all properties.
function pm_move1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_move1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_move2.
function pm_move2_Callback(hObject, eventdata, handles)
% hObject    handle to pm_move2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_move2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_move2


% --- Executes during object creation, after setting all properties.
function pm_move2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_move2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_move3.
function pm_move3_Callback(hObject, eventdata, handles)
% hObject    handle to pm_move3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_move3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_move3


% --- Executes during object creation, after setting all properties.
function pm_move3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_move3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_move4.
function pm_move4_Callback(hObject, eventdata, handles)
% hObject    handle to pm_move4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_move4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_move4


% --- Executes during object creation, after setting all properties.
function pm_move4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_move4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_move5.
function pm_move5_Callback(hObject, eventdata, handles)
% hObject    handle to pm_move5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_move5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_move5


% --- Executes during object creation, after setting all properties.
function pm_move5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_move5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_move6.
function pm_move6_Callback(hObject, eventdata, handles)
% hObject    handle to pm_move6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_move6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_move6


% --- Executes during object creation, after setting all properties.
function pm_move6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_move6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_move7.
function pm_move7_Callback(hObject, eventdata, handles)
% hObject    handle to pm_move7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_move7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_move7


% --- Executes during object creation, after setting all properties.
function pm_move7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_move7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_move8.
function pm_move8_Callback(hObject, eventdata, handles)
% hObject    handle to pm_move8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_move8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_move8


% --- Executes during object creation, after setting all properties.
function pm_move8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_move8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_move9.
function pm_move9_Callback(hObject, eventdata, handles)
% hObject    handle to pm_move9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_move9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_move9


% --- Executes during object creation, after setting all properties.
function pm_move9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_move9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_move10.
function pm_move10_Callback(hObject, eventdata, handles)
% hObject    handle to pm_move10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_move10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_move10


% --- Executes during object creation, after setting all properties.
function pm_move10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_move10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_move11.
function pm_move11_Callback(hObject, eventdata, handles)
% hObject    handle to pm_move11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_move11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_move11


% --- Executes during object creation, after setting all properties.
function pm_move11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_move11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_move12.
function pm_move12_Callback(hObject, eventdata, handles)
% hObject    handle to pm_move12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_move12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_move12


% --- Executes during object creation, after setting all properties.
function pm_move12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_move12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_thresholdValue2_Callback(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_thresholdValue2 as text
%        str2double(get(hObject,'String')) returns contents of et_thresholdValue2 as a double
% Save selected values to PropGUI handles
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMaxThresh(2) = str2double(get(handles.et_thresholdValue2,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMaxThresh(2) = str2double(get(handles.et_thresholdValue2,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end


% --- Executes during object creation, after setting all properties.
function et_thresholdValue2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_minValue2_Callback(hObject, eventdata, handles)
% hObject    handle to et_minValue2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_minValue2 as text
%        str2double(get(hObject,'String')) returns contents of et_minValue2 as a double

% Save selected values to PropGUI handles
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMinThresh(2) = str2double(get(handles.et_minValue2,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMinThresh(2) = str2double(get(handles.et_minValue2,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_minValue2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_minValue2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_thresholdValue3_Callback(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_thresholdValue3 as text
%        str2double(get(hObject,'String')) returns contents of et_thresholdValue3 as a double
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMaxThresh(3) = str2double(get(handles.et_thresholdValue3,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMaxThresh(3) = str2double(get(handles.et_thresholdValue3,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_thresholdValue3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_minValue3_Callback(hObject, eventdata, handles)
% hObject    handle to et_minValue3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_minValue3 as text
%        str2double(get(hObject,'String')) returns contents of et_minValue3 as a double

% Save selected values to PropGUI handles
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMinThresh(3) = str2double(get(handles.et_minValue3,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMinThresh(3) = str2double(get(handles.et_minValue3,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_minValue3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_minValue3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_thresholdValue4_Callback(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_thresholdValue4 as text
%        str2double(get(hObject,'String')) returns contents of et_thresholdValue4 as a double
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMaxThresh(4) = str2double(get(handles.et_thresholdValue4,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMaxThresh(4) = str2double(get(handles.et_thresholdValue4,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end


% --- Executes during object creation, after setting all properties.
function et_thresholdValue4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_minValue4_Callback(hObject, eventdata, handles)
% hObject    handle to et_minValue4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_minValue4 as text
%        str2double(get(hObject,'String')) returns contents of et_minValue4 as a double

% Save selected values to PropGUI handles
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMinThresh(4) = str2double(get(handles.et_minValue4,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMinThresh(4) = str2double(get(handles.et_minValue4,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_minValue4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_minValue4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_thresholdValue5_Callback(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_thresholdValue5 as text
%        str2double(get(hObject,'String')) returns contents of et_thresholdValue5 as a double
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMaxThresh(5) = str2double(get(handles.et_thresholdValue5,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMaxThresh(5) = str2double(get(handles.et_thresholdValue5,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_thresholdValue5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_minValue5_Callback(hObject, eventdata, handles)
% hObject    handle to et_minValue5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_minValue5 as text
%        str2double(get(hObject,'String')) returns contents of et_minValue5 as a double

% Save selected values to PropGUI handles
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMinThresh(5) = str2double(get(handles.et_minValue5,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMinThresh(5) = str2double(get(handles.et_minValue5,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_minValue5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_minValue5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_thresholdValue6_Callback(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_thresholdValue6 as text
%        str2double(get(hObject,'String')) returns contents of et_thresholdValue6 as a double
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMaxThresh(6) = str2double(get(handles.et_thresholdValue6,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMaxThresh(6) = str2double(get(handles.et_thresholdValue6,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_thresholdValue6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_minValue6_Callback(hObject, eventdata, handles)
% hObject    handle to et_minValue6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_minValue6 as text
%        str2double(get(hObject,'String')) returns contents of et_minValue6 as a double

% Save selected values to PropGUI handles
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMinThresh(6) = str2double(get(handles.et_minValue6,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMinThresh(6) = str2double(get(handles.et_minValue6,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_minValue6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_minValue6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_thresholdValue7_Callback(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_thresholdValue7 as text
%        str2double(get(hObject,'String')) returns contents of et_thresholdValue7 as a double
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMaxThresh(7) = str2double(get(handles.et_thresholdValue7,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMaxThresh(7) = str2double(get(handles.et_thresholdValue7,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_thresholdValue7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_minValue7_Callback(hObject, eventdata, handles)
% hObject    handle to et_minValue7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_minValue7 as text
%        str2double(get(hObject,'String')) returns contents of et_minValue7 as a double

% Save selected values to PropGUI handles
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMinThresh(7) = str2double(get(handles.et_minValue7,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMinThresh(7) = str2double(get(handles.et_minValue7,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_minValue7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_minValue7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_thresholdValue8_Callback(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_thresholdValue8 as text
%        str2double(get(hObject,'String')) returns contents of et_thresholdValue8 as a double
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMaxThresh(8) = str2double(get(handles.et_thresholdValue8,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMaxThresh(8) = str2double(get(handles.et_thresholdValue8,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_thresholdValue8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_minValue8_Callback(hObject, eventdata, handles)
% hObject    handle to et_minValue8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_minValue8 as text
%        str2double(get(hObject,'String')) returns contents of et_minValue8 as a double

% Save selected values to PropGUI handles
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMinThresh(8) = str2double(get(handles.et_minValue8,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMinThresh(8) = str2double(get(handles.et_minValue8,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_minValue8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_minValue8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_thresholdValue9_Callback(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_thresholdValue9 as text
%        str2double(get(hObject,'String')) returns contents of et_thresholdValue9 as a double
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMaxThresh(9) = str2double(get(handles.et_thresholdValue9,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMaxThresh(9) = str2double(get(handles.et_thresholdValue9,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_thresholdValue9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_minValue9_Callback(hObject, eventdata, handles)
% hObject    handle to et_minValue9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_minValue9 as text
%        str2double(get(hObject,'String')) returns contents of et_minValue9 as a double

% Save selected values to PropGUI handles
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMinThresh(9) = str2double(get(handles.et_minValue9,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMinThresh(9) = str2double(get(handles.et_minValue9,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_minValue9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_minValue9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_thresholdValue10_Callback(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_thresholdValue10 as text
%        str2double(get(hObject,'String')) returns contents of et_thresholdValue10 as a double
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMaxThresh(10) = str2double(get(handles.et_thresholdValue10,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMaxThresh(10) = str2double(get(handles.et_thresholdValue10,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_thresholdValue10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_minValue10_Callback(hObject, eventdata, handles)
% hObject    handle to et_minValue10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_minValue10 as text
%        str2double(get(hObject,'String')) returns contents of et_minValue10 as a double

% Save selected values to PropGUI handles
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMinThresh(10) = str2double(get(handles.et_minValue10,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMinThresh(10) = str2double(get(handles.et_minValue10,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_minValue10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_minValue10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_thresholdValue11_Callback(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_thresholdValue11 as text
%        str2double(get(hObject,'String')) returns contents of et_thresholdValue11 as a double
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMaxThresh(11) = str2double(get(handles.et_thresholdValue11,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMaxThresh(11) = str2double(get(handles.et_thresholdValue11,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_thresholdValue11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_minValue11_Callback(hObject, eventdata, handles)
% hObject    handle to et_minValue11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_minValue11 as text
%        str2double(get(hObject,'String')) returns contents of et_minValue11 as a double
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMinThresh(11) = str2double(get(handles.et_minValue11,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMinThresh(11) = str2double(get(handles.et_minValue11,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_minValue11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_minValue11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_thresholdValue12_Callback(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_thresholdValue12 as text
%        str2double(get(hObject,'String')) returns contents of et_thresholdValue12 as a double
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMaxThresh(12) = str2double(get(handles.et_thresholdValue12,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMaxThresh(12) = str2double(get(handles.et_thresholdValue12,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_thresholdValue12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_thresholdValue12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_minValue12_Callback(hObject, eventdata, handles)
% hObject    handle to et_minValue12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_minValue12 as text
%        str2double(get(hObject,'String')) returns contents of et_minValue12 as a double
% Save selected values to PropGUI handles
set(handles.t_msg,'String','');
handles.patRec.control.propControl.propMinThresh(12) = str2double(get(handles.et_minValue12,'String'));
guidata(hObject,handles);

if isfield(handles,'mainGUI')
    handlesMainGUI = guidata(handles.mainGUI);
    handlesMainGUI.patRec.control.propControl.propMinThresh(12) = str2double(get(handles.et_minValue12,'String'));
    guidata(handles.mainGUI, handlesMainGUI);
end

% --- Executes during object creation, after setting all properties.
function et_minValue12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_minValue12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_moveSelection.
function pm_moveSelection_Callback(hObject, eventdata, handles)
% hObject    handle to pm_moveSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_moveSelection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_moveSelection


% --- Executes during object creation, after setting all properties.
function pm_moveSelection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_moveSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
