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
% [Give a short summary about the principle of your function here.]
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 20xx-xx-xx / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment on update

function varargout = GUI_TestPWMs(varargin)
% GUI_TESTPWMS M-file for GUI_TestPWMs.fig
%      GUI_TESTPWMS, by itself, creates a new GUI_TESTPWMS or raises the existing
%      singleton*.
%
%      H = GUI_TESTPWMS returns the handle to a new GUI_TESTPWMS or the handle to
%      the existing singleton*.
%
%      GUI_TESTPWMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TESTPWMS.M with the given input arguments.
%
%      GUI_TESTPWMS('Property','Value',...) creates a new GUI_TESTPWMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_TestPWMs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_TestPWMs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_TestPWMs

% Last Modified by GUIDE v2.5 07-Nov-2011 17:59:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_TestPWMs_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_TestPWMs_OutputFcn, ...
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


% --- Executes just before GUI_TestPWMs is made visible.
function GUI_TestPWMs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_TestPWMs (see VARARGIN)

% Choose default command line output for GUI_TestPWMs
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_TestPWMs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_TestPWMs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function et_pwm1a_Callback(hObject, eventdata, handles)
% hObject    handle to et_pwm1a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_pwm1a as text
%        str2double(get(hObject,'String')) returns contents of et_pwm1a as a double


% --- Executes during object creation, after setting all properties.
function et_pwm1a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_pwm1a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_pwm1b_Callback(hObject, eventdata, handles)
% hObject    handle to et_pwm1b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_pwm1b as text
%        str2double(get(hObject,'String')) returns contents of et_pwm1b as a double


% --- Executes during object creation, after setting all properties.
function et_pwm1b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_pwm1b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_pwm2a_Callback(hObject, eventdata, handles)
% hObject    handle to et_pwm2a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_pwm2a as text
%        str2double(get(hObject,'String')) returns contents of et_pwm2a as a double


% --- Executes during object creation, after setting all properties.
function et_pwm2a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_pwm2a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_pwm2b_Callback(hObject, eventdata, handles)
% hObject    handle to et_pwm2b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_pwm2b as text
%        str2double(get(hObject,'String')) returns contents of et_pwm2b as a double


% --- Executes during object creation, after setting all properties.
function et_pwm2b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_pwm2b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_pwm3a_Callback(hObject, eventdata, handles)
% hObject    handle to et_pwm3a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_pwm3a as text
%        str2double(get(hObject,'String')) returns contents of et_pwm3a as a double


% --- Executes during object creation, after setting all properties.
function et_pwm3a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_pwm3a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_Connect.
function pb_Connect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

compath = get(handles.et_com,'String');
handles.com = Connect_ALC(compath);
%handles.com = MasterModuleComm(compath);
if TestConnectionALC(handles.com)==1; %Write S to stop program
    set(handles.t_msg,'String','Connection established');
    guidata(hObject,handles);
else
    set(handles.t_msg,'String','Wrong connection');
    fclose(handles.com);
end



% --- Executes on button press in pb_UpdatePWMs.
function pb_UpdatePWMs_Callback(hObject, eventdata, handles)
% hObject    handle to pb_UpdatePWMs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

com = handles.com;  % Get the communication object

pwms = [];
pwms1 = [pwms 100 - str2double(get(handles.et_pwm1a,'String'))];
pwms2 = [pwms 100 - str2double(get(handles.et_pwm1b,'String'))];
pwms3 = [pwms 100 - str2double(get(handles.et_pwm2a,'String'))];
pwms4 = [pwms 100 - str2double(get(handles.et_pwm2b,'String'))];
pwms5 = [pwms 100 - str2double(get(handles.et_pwm3a,'String'))];
pwms6 = [pwms 100 - str2double(get(handles.et_pwm3b,'String'))];
pwms7 = [pwms 100 - str2double(get(handles.et_pwm4a,'String'))];
pwms8 = [pwms 100 - str2double(get(handles.et_pwm4b,'String'))];
pwms9 = [pwms 100 - str2double(get(handles.et_pwm5a,'String'))];
pwms10 = [pwms 100 - str2double(get(handles.et_pwm5b,'String'))];
pwms11 = [pwms 100 - str2double(get(handles.et_pwm6a,'String'))];
pwms12 = [pwms 100 - str2double(get(handles.et_pwm6b,'String'))];
pwms = [pwms1, pwms2, pwms3, pwms4, pwms5, pwms6, pwms7, pwms8, pwms9, pwms10, pwms11, pwms12];


set(handles.t_msg,'String','Update started');
if UpdateAllPWMusingSCI(com, pwms) == 1
    set(handles.t_msg,'String','Update succesful');
else
    set(handles.t_msg,'String','Update Bad :(');
end


function et_com_Callback(hObject, eventdata, handles)
% hObject    handle to et_com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_com as text
%        str2double(get(hObject,'String')) returns contents of et_com as a double


% --- Executes during object creation, after setting all properties.
function et_com_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_Disconnect.
function pb_Disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fclose(handles.com.io);
set(handles.t_msg,'String','Disconnected');


% --- Executes on button press in pb_CyclePWM.
function pb_CyclePWM_Callback(hObject, eventdata, handles)
% hObject    handle to pb_CyclePWM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

obj = handles.com;

set(handles.t_msg,'String','Cycling started');
if TestPWMusingSCIbyCycling(obj)
    set(handles.t_msg,'String','Good');
else
    set(handles.t_msg,'String','Bad :(');
end



function et_pwm3b_Callback(hObject, eventdata, handles)
% hObject    handle to et_pwm3b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_pwm3b as text
%        str2double(get(hObject,'String')) returns contents of et_pwm3b as a double


% --- Executes during object creation, after setting all properties.
function et_pwm3b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_pwm3b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_pwm4a_Callback(hObject, eventdata, handles)
% hObject    handle to et_pwm4a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_pwm4a as text
%        str2double(get(hObject,'String')) returns contents of et_pwm4a as a double


% --- Executes during object creation, after setting all properties.
function et_pwm4a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_pwm4a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_pwm4b_Callback(hObject, eventdata, handles)
% hObject    handle to et_pwm4b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_pwm4b as text
%        str2double(get(hObject,'String')) returns contents of et_pwm4b as a double


% --- Executes during object creation, after setting all properties.
function et_pwm4b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_pwm4b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_pwm5a_Callback(hObject, eventdata, handles)
% hObject    handle to et_pwm5a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_pwm5a as text
%        str2double(get(hObject,'String')) returns contents of et_pwm5a as a double


% --- Executes during object creation, after setting all properties.
function et_pwm5a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_pwm5a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_pwm5b_Callback(hObject, eventdata, handles)
% hObject    handle to et_pwm5b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_pwm5b as text
%        str2double(get(hObject,'String')) returns contents of et_pwm5b as a double


% --- Executes during object creation, after setting all properties.
function et_pwm5b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_pwm5b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function et_pwm6a_Callback(hObject, eventdata, handles)
% hObject    handle to et_pwm6a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_pwm6a as text
%        str2double(get(hObject,'String')) returns contents of et_pwm6a as a double


% --- Executes during object creation, after setting all properties.
function et_pwm6a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_pwm6a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_pwm6b_Callback(hObject, eventdata, handles)
% hObject    handle to et_pwm6b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_pwm6b as text
%        str2double(get(hObject,'String')) returns contents of et_pwm6b as a double


% --- Executes during object creation, after setting all properties.
function et_pwm6b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_pwm6b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
