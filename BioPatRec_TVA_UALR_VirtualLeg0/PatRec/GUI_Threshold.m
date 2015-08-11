function varargout = GUI_Threshold(varargin)
% GUI_THRESHOLD MATLAB code for GUI_Threshold.fig
%      GUI_THRESHOLD, by itself, creates a new GUI_THRESHOLD or raises the existing
%      singleton*.
%
%      H = GUI_THRESHOLD returns the handle to a new GUI_THRESHOLD or the handle to
%      the existing singleton*.
%
%      GUI_THRESHOLD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_THRESHOLD.M with the given input arguments.
%
%      GUI_THRESHOLD('Property','Value',...) creates a new GUI_THRESHOLD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Threshold_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Threshold_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Threshold

% Last Modified by GUIDE v2.5 08-Aug-2012 15:51:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Threshold_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Threshold_OutputFcn, ...
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


% --- Executes just before GUI_Threshold is made visible.
function GUI_Threshold_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Threshold (see VARARGIN)

% Choose default command line output for GUI_Threshold
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Threshold wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Threshold_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function value0_Callback(hObject, eventdata, handles)
% hObject    handle to value0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value0 as text
%        str2double(get(hObject,'String')) returns contents of value0 as a double


% --- Executes during object creation, after setting all properties.
function value0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overrideButton0.
function overrideButton0_Callback(hObject, eventdata, handles)
% hObject    handle to overrideButton0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overrideButton0


% --- Executes on selection change in movementSelector0.
function movementSelector0_Callback(hObject, eventdata, handles)
% hObject    handle to movementSelector0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns movementSelector0 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from movementSelector0


% --- Executes during object creation, after setting all properties.
function movementSelector0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movementSelector0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function value1_Callback(hObject, eventdata, handles)
% hObject    handle to value1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value1 as text
%        str2double(get(hObject,'String')) returns contents of value1 as a double


% --- Executes during object creation, after setting all properties.
function value1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overrideButton1.
function overrideButton1_Callback(hObject, eventdata, handles)
% hObject    handle to overrideButton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overrideButton1


% --- Executes on selection change in movementSelector1.
function movementSelector1_Callback(hObject, eventdata, handles)
% hObject    handle to movementSelector1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns movementSelector1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from movementSelector1


% --- Executes during object creation, after setting all properties.
function movementSelector1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movementSelector1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function value2_Callback(hObject, eventdata, handles)
% hObject    handle to value2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value2 as text
%        str2double(get(hObject,'String')) returns contents of value2 as a double


% --- Executes during object creation, after setting all properties.
function value2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overrideButton2.
function overrideButton2_Callback(hObject, eventdata, handles)
% hObject    handle to overrideButton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overrideButton2


% --- Executes on selection change in movementSelector2.
function movementSelector2_Callback(hObject, eventdata, handles)
% hObject    handle to movementSelector2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns movementSelector2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from movementSelector2


% --- Executes during object creation, after setting all properties.
function movementSelector2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movementSelector2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function value3_Callback(hObject, eventdata, handles)
% hObject    handle to value3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value3 as text
%        str2double(get(hObject,'String')) returns contents of value3 as a double


% --- Executes during object creation, after setting all properties.
function value3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overrideButton3.
function overrideButton3_Callback(hObject, eventdata, handles)
% hObject    handle to overrideButton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overrideButton3


% --- Executes on selection change in movementSelector3.
function movementSelector3_Callback(hObject, eventdata, handles)
% hObject    handle to movementSelector3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns movementSelector3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from movementSelector3


% --- Executes during object creation, after setting all properties.
function movementSelector3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movementSelector3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function value4_Callback(hObject, eventdata, handles)
% hObject    handle to value4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value4 as text
%        str2double(get(hObject,'String')) returns contents of value4 as a double


% --- Executes during object creation, after setting all properties.
function value4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overrideButton4.
function overrideButton4_Callback(hObject, eventdata, handles)
% hObject    handle to overrideButton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overrideButton4


% --- Executes on selection change in movementSelector4.
function movementSelector4_Callback(hObject, eventdata, handles)
% hObject    handle to movementSelector4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns movementSelector4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from movementSelector4


% --- Executes during object creation, after setting all properties.
function movementSelector4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movementSelector4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function value5_Callback(hObject, eventdata, handles)
% hObject    handle to value5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value5 as text
%        str2double(get(hObject,'String')) returns contents of value5 as a double


% --- Executes during object creation, after setting all properties.
function value5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overrideButton5.
function overrideButton5_Callback(hObject, eventdata, handles)
% hObject    handle to overrideButton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overrideButton5


% --- Executes on selection change in movementSelector5.
function movementSelector5_Callback(hObject, eventdata, handles)
% hObject    handle to movementSelector5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns movementSelector5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from movementSelector5


% --- Executes during object creation, after setting all properties.
function movementSelector5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movementSelector5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function value6_Callback(hObject, eventdata, handles)
% hObject    handle to value6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value6 as text
%        str2double(get(hObject,'String')) returns contents of value6 as a double


% --- Executes during object creation, after setting all properties.
function value6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overrideButton6.
function overrideButton6_Callback(hObject, eventdata, handles)
% hObject    handle to overrideButton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overrideButton6


% --- Executes on selection change in movementSelector6.
function movementSelector6_Callback(hObject, eventdata, handles)
% hObject    handle to movementSelector6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns movementSelector6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from movementSelector6


% --- Executes during object creation, after setting all properties.
function movementSelector6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movementSelector6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function value7_Callback(hObject, eventdata, handles)
% hObject    handle to value7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value7 as text
%        str2double(get(hObject,'String')) returns contents of value7 as a double


% --- Executes during object creation, after setting all properties.
function value7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overrideButton7.
function overrideButton7_Callback(hObject, eventdata, handles)
% hObject    handle to overrideButton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overrideButton7


% --- Executes on selection change in movementSelector7.
function movementSelector7_Callback(hObject, eventdata, handles)
% hObject    handle to movementSelector7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns movementSelector7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from movementSelector7


% --- Executes during object creation, after setting all properties.
function movementSelector7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movementSelector7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
