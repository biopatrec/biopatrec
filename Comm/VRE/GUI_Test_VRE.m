function varargout = GUI_Test_VRE(varargin)
% GUI_TEST_VRE M-file for GUI_Test_VRE.fig
%      GUI_TEST_VRE, by itself, creates a new GUI_TEST_VRE or raises the existing
%      singleton*.
%
%      H = GUI_TEST_VRE returns the handle to a new GUI_TEST_VRE or the handle to
%      the existing singleton*.
%
%      GUI_TEST_VRE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TEST_VRE.M with the given input arguments.
%
%      GUI_TEST_VRE('Property','Value',...) creates a new GUI_TEST_VRE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Test_VRE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Test_VRE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Test_VRE

% Last Modified by GUIDE v2.5 20-Sep-2016 11:11:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Test_VRE_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Test_VRE_OutputFcn, ...
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


% --- Executes just before GUI_Test_VRE is made visible.
function GUI_Test_VRE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Test_VRE (see VARARGIN)

% Choose default command line output for GUI_Test_VRE
handles.output = hObject;
handles.returnValues = 1;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Test_VRE wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Test_VRE_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_startVRE.
function pb_startVRE_Callback(hObject, eventdata, handles)
% hObject    handle to pb_startVRE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% % if(strcmp(get(handles.pb_startVRE,'String'),'Connect'))
% %     port = str2double(get(handles.et_connection,'String'));
% %     set(handles.t_msg,'String','Waiting for client connection.');
% %     obj = tcpip('127.0.0.1',port,'NetworkRole','server');
% %     fopen(obj);
% %     set(handles.t_msg,'String','Server established on port');
% %     set(handles.pb_startVRE,'String','Disconnect');
% %     handles.com = obj;
% % else
% %     fclose(handles.com);
% %     set(handles.t_msg,'String','Disconnected');
% %     set(handles.pb_startVRE,'String','Connect');
% % end
if isfield(handles,'vre_leg')
handles = rmfield(handles,'vre_leg');
end
handles = ConnectVRE(handles,'virtual reality.exe');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function et_connection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_connection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_startARE.
function pb_startARE_Callback(hObject, eventdata, handles)
% hObject    handle to pb_startARE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ConnectVRE(handles,'Augmented Reality HAND.exe');
guidata(hObject,handles);

% --- Executes on button press in pb_sendValues.
function pb_sendValues_Callback(hObject, eventdata, handles)
% hObject    handle to pb_sendValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = handles.vre_Com;
one = get(handles.tb_value1,'String');
two = get(handles.tb_value2,'String');
three = get(handles.tb_value3,'String');
four = get(handles.tb_value4,'String');
five = get(handles.tb_value5,'String');
pause on;
% VREActivation(obj,four,[],two, three, 0);
fwrite(obj,sprintf('%c%c%c%c%c',checkValues(one),checkValues(two),checkValues(three),checkValues(four), checkValues(five)));
fread(obj,1);



function val = checkValues(string)
    if all(ismember(string,'0123456789'))
       val = char(str2double(string)); 
    else
       val = string;
    end


function tb_value1_Callback(hObject, eventdata, handles)
% hObject    handle to tb_value1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_value1 as text
%        str2double(get(hObject,'String')) returns contents of tb_value1 as a double


% --- Executes during object creation, after setting all properties.
function tb_value1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_value1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tb_value2_Callback(hObject, eventdata, handles)
% hObject    handle to tb_value2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_value2 as text
%        str2double(get(hObject,'String')) returns contents of tb_value2 as a double


% --- Executes during object creation, after setting all properties.
function tb_value2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_value2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tb_value3_Callback(hObject, eventdata, handles)
% hObject    handle to tb_value3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_value3 as text
%        str2double(get(hObject,'String')) returns contents of tb_value3 as a double


% --- Executes during object creation, after setting all properties.
function tb_value3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_value3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tb_value4_Callback(hObject, eventdata, handles)
% hObject    handle to tb_value4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_value4 as text
%        str2double(get(hObject,'String')) returns contents of tb_value4 as a double


% --- Executes during object creation, after setting all properties.
function tb_value4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_value4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tb_value5_Callback(hObject, eventdata, handles)
% hObject    handle to tb_value5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_value5 as text
%        str2double(get(hObject,'String')) returns contents of tb_value5 as a double


% --- Executes during object creation, after setting all properties.
function tb_value5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_value5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_send100.
function pb_send100_Callback(hObject, eventdata, handles)
% hObject    handle to pb_send100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = handles.vre_Com;
one = get(handles.tb_value1,'String');
two = get(handles.tb_value2,'String');
three = get(handles.tb_value3,'String');
four = get(handles.tb_value4,'String');
five = get(handles.tb_value5,'String');
pause on;
% VREActivation(obj,four,[],two, three, 0);
tic;
for i = 1:100
    fwrite(obj,sprintf('%c%c%c%c%c',checkValues(one),checkValues(two),checkValues(three),checkValues(four), checkValues(five)));
    if handles.returnValues
        fread(obj,1);   
    end
end
set(handles.txt_Time,'String',toc);


% --- Executes on button press in pb_return.
function pb_return_Callback(hObject, eventdata, handles)
% hObject    handle to pb_return (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% % if handles.returnValues
% %     fwrite(handles.com,sprintf('%c%c%c%c%c','c',char(7),char(0),char(0),char(0)));
% %     handles.returnValues = 0;
% % else
% %     fwrite(handles.com,sprintf('%c%c%c%c%c','c',char(7),char(1),char(0),char(0)));
% %     handles.returnValues = 1;
% % end
handles = DisconnectVRE(handles);
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pb_startARE.
function pb_startARE_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pb_startARE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ConnectVRE(handles,'Augmented Reality.exe');
guidata(hObject,handles);

% --- Executes on button press in pb_startAREARM.
function pb_startAREARM_Callback(hObject, eventdata, handles)
% hObject    handle to pb_startAREARM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ConnectVRE(handles,'Augmented Reality ARM.exe');
guidata(hObject,handles);


% --- Executes on button press in pb_startVRELEG.
function pb_startVRELEG_Callback(hObject, eventdata, handles)
% hObject    handle to pb_startVRELEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vre_leg = 1;
handles = ConnectVRE(handles,'virtual reality.exe');
guidata(hObject,handles);


% --- Executes on button press in pb_startARELEG.
function pb_startARELEG_Callback(hObject, eventdata, handles)
% hObject    handle to pb_startARELEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vre_leg = 1;
handles = ConnectVRE(handles,'Augmented Reality.exe');
guidata(hObject,handles);
