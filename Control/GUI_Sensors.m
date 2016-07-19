function varargout = GUI_Sensors(varargin)
% GUI_SENSORS MATLAB code for GUI_Sensors.fig
%      GUI_SENSORS, by itself, creates a new GUI_SENSORS or raises the existing
%      singleton*.
%
%      H = GUI_SENSORS returns the handle to a new GUI_SENSORS or the handle to
%      the existing singleton*.
%
%      GUI_SENSORS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SENSORS.M with the given input arguments.
%
%      GUI_SENSORS('Property','Value',...) creates a new GUI_SENSORS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Sensors_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Sensors_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Sensors

% Last Modified by GUIDE v2.5 12-Jun-2015 11:08:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Sensors_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Sensors_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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

% --- Executes just before GUI_Sensors is made visible.
function GUI_Sensors_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Sensors (see VARARGIN)

%handles = varargin{1};

% Choose default command line output for GUI_Sensors
handles.output = hObject;

% get the handle of Gui1
h = findobj('Tag','Gui1');
% if exists (not empty)
if ~isempty(h)
    % get handles and other user-defined data associated to Gui1
    g1data = guidata(h);
    handles.sensors = g1data.sensors;
    if isfield(g1data,'Control_obj')
        handles.com = g1data.Control_obj;
    else
        errordlg('Communication object not found. Connect with the device!','Error');
        return
    end
end

% if InitSensors found the "sensors.def" file
if isobject(handles.sensors)
    % Fetch the number of sensors   
    nrSensors = size(handles.sensors,2);
    handles.nrSensors = nrSensors;
    
    % list them in GUI_Sensors
    for k = 1 : nrSensors
        listboxItems(nrSensors-k+1) = handles.sensors(k).name;
    end
    set(handles.listbox,'string',listboxItems);

    % Set up the timer for sensors readings
    handles.guifig = gcf;
    handles.timerS = timer('TimerFcn', {@SensorRequest,handles.guifig},'ExecutionMode','fixedRate','Period', 0.05);
    guidata(handles.guifig,handles);
    guidata(hObject, handles);

    % Set up the plot
    handles.t = 1;
    handles.plotGain = 10000000;
    handles.data = zeros(200,nrSensors);
    h = plot(handles.axes1, handles.data);
    axis([0 200 0 5*nrSensors])
    % Shift the different plots to fit into the main figure
    global offVector;
    global ampPP;
    ampPP     = 5;
    offVector = 0:handles.nrSensors-1;
    offVector = offVector .* ampPP; 
    set(handles.axes1,'YTick',offVector);  
    set(handles.axes1,'YTickLabel',fliplr(listboxItems));   
    handles.p_t0 = h;
    
else % no "sensors.def" file was found
    % Disable start and stop buttons
    set(handles.pb_start,'Enable','off');
    set(handles.pb_stop,'Enable','off');
    
    % Empty the sensors list
    set(handles.listbox,'string','');
    
    % Set up the (empty) plot
    handles.data = zeros(200,1);
    h = plot(handles.axes1, handles.data);
    axis([0 200 0 5])
    handles.p_t0 = h;
end

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_Sensors_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pb_stop.
function pb_stop_Callback(hObject, eventdata, handles)
% hObject    handle to pb_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop(handles.timerS);


function et_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to et_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_frequency as text
%        str2double(get(hObject,'String')) returns contents of et_frequency as a double


% --- Executes during object creation, after setting all properties.
function et_frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_start.
function pb_start_Callback(hObject, eventdata, handles)
% hObject    handle to pb_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.t = 1;
guidata(hObject,handles);

start(handles.timerS);

function SensorRequest(src, event, handles)

    global offVector;
    global ampPP;
    handles = guidata(handles);       
    obj = handles.com;
    t = handles.t;
    
    data = handles.data;
    p_t0 = handles.p_t0;
    
    data(t,:)   = ReadSensors(obj, handles.sensors, handles.nrSensors);
    data(t+1,:) = NaN;
    data(t+2,:) = NaN;
    
    if(t+2 >= 200)
       handles.t = 1;
    else
       handles.t = t + 1;
    end

    handles.data = data;

%     plot(handles.axes1, data(:,1)); 
%     plot(handles.axes1, data(:,2)); 
%     plot(handles.axes1, data(:,3)); 
%     plot(handles.axes1, data(:,4));
    
    plotGain = handles.plotGain;

    K = ampPP/(2*(max(max(abs(data)))));
    if K < plotGain
        % if the signals in the different windows is getting bigger the gain
        % must be reduced consequently, the channels plots must always fit
        % the main plot
        plotGain = K;
    end
    % plot a new tWs sized window
    for j = 1 : handles.nrSensors
        set(p_t0(j),'YData',data(:,j)*plotGain + offVector(j));              % add offsets to plot channels in same graph
    end
    drawnow
    
    handles.plotGain = plotGain;
    guidata(handles.guifig, handles);


% --- Executes on selection change in listbox.
function listbox_Callback(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox


% --- Executes during object creation, after setting all properties.
function listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
