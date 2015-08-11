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

function varargout = GUI_Test_Hand(varargin)
% GUI_TEST_HAND M-file for GUI_Test_Hand.fig
%      GUI_TEST_HAND, by itself, creates a new GUI_TEST_HAND or raises the existing
%      singleton*.
%
%      H = GUI_TEST_HAND returns the handle to a new GUI_TEST_HAND or the handle to
%      the existing singleton*.
%
%      GUI_TEST_HAND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TEST_HAND.M with the given input arguments.
%
%      GUI_TEST_HAND('Property','Value',...) creates a new GUI_TEST_HAND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Test_Hand_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Test_Hand_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Test_Hand

% Last Modified by GUIDE v2.5 15-Aug-2012 12:07:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Test_Hand_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Test_Hand_OutputFcn, ...
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


% --- Executes just before GUI_Test_Hand is made visible.
function GUI_Test_Hand_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Test_Hand (see VARARGIN)

% Choose default command line output for GUI_Test_Hand
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Test_Hand wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Test_Hand_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_connect.
function pb_connect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
compath = get(handles.et_connection,'String');
handles.com = Connect_ALC(compath);
%handles.com = MasterModuleComm(compath);
if TestConnectionALC(handles.com)==1; %Write S to stop program
    set(handles.t_msg,'String','Connection established');
    guidata(hObject,handles);
else
    set(handles.t_msg,'String','Wrong connection');
    fclose(handles.com.io);
end


% --- Executes on button press in pb_testConnection.
function pb_testConnection_Callback(hObject, eventdata, handles)
% hObject    handle to pb_testConnection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.t_msg,'String','Testing connection...');
if TestConnectionALC(handles.com)==1; %Write S to stop program
    set(handles.t_msg,'String','Connection established');
    guidata(hObject,handles);
else
    set(handles.t_msg,'String','Wrong connection');
    fclose(handles.com.io);
end

% --- Executes on button press in pb_disconnect.
function pb_disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fclose(handles.com.io);
set(handles.t_msg,'String','Disconnected');



function et_connection_Callback(hObject, eventdata, handles)
% hObject    handle to et_connection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_connection as text
%        str2double(get(hObject,'String')) returns contents of et_connection as a double


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


% --- Executes on button press in pb_thumbOpen.
function pb_thumbOpen_Callback(hObject, eventdata, handles)
% hObject    handle to pb_thumbOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Unable the botton
set(handles.pb_thumbOpen,'Enable','off');

% Get info
obj = handles.com;
pwmID = 'A';    % Referes to DoF, not to PWM

if get(handles.cb_thumb,'Value')
    pwm1 = 0;       %Duty cycle
    pwm2 = str2double(get(handles.et_pwm,'String'));
else
    pwm2 = 0;       %Duty cycle
    pwm1 = str2double(get(handles.et_pwm,'String'));
end


% Send PWM
if Update2PWMusingSCI(obj, pwmID, pwm1, pwm2)
    % Wait for a little move to take place
    pause(str2double(get(handles.et_length,'String')));
    % Stop the movement
    Update2PWMusingSCI(obj, pwmID, 0, 0);
    set(handles.t_msg,'String','Moved');
else
    set(handles.t_msg,'String','Failed');
    fclose(handles.com.io);
end

set(handles.pb_thumbOpen,'Enable','on');


% --- Executes on button press in pb_indexOpen.
function pb_indexOpen_Callback(hObject, eventdata, handles)
% hObject    handle to pb_indexOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Unable the botton
set(handles.pb_indexOpen,'Enable','off');

% Get info
obj = handles.com;
pwmID = 'B';    % Referes to DoF, not to PWM

if get(handles.cb_index,'Value')
    pwm2 = 0;       %Duty cycle
    pwm1 = str2double(get(handles.et_pwm,'String'));
else
    pwm1 = 0;       %Duty cycle
    pwm2 = str2double(get(handles.et_pwm,'String'));
end


% Send PWM
if Update2PWMusingSCI(obj, pwmID, pwm1, pwm2)
    % Wait for a little move to take place
    pause(str2double(get(handles.et_length,'String')));
    % Stop the movement
    Update2PWMusingSCI(obj, pwmID, 0, 0);
    set(handles.t_msg,'String','Moved');
else
    set(handles.t_msg,'String','Failed');
    fclose(handles.com.io);
end

set(handles.pb_indexOpen,'Enable','on');

% --- Executes on button press in pb_middleOpen.
function pb_middleOpen_Callback(hObject, eventdata, handles)
% hObject    handle to pb_middleOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Unable the botton
set(handles.pb_middleOpen,'Enable','off');

% Get info
obj = handles.com;
pwmID = 'C';    % Referes to DoF, not to PWM

if get(handles.cb_middle,'Value')
    pwm2 = 0;       %Duty cycle
    pwm1 = str2double(get(handles.et_pwm,'String'));
else
    pwm1 = 0;       %Duty cycle
    pwm2 = str2double(get(handles.et_pwm,'String'));
end


% Send PWM
if Update2PWMusingSCI(obj, pwmID, pwm1, pwm2)
    % Wait for a little move to take place
    pause(str2double(get(handles.et_length,'String')));
    % Stop the movement
    Update2PWMusingSCI(obj, pwmID, 0, 0);
    set(handles.t_msg,'String','Moved');
else
    set(handles.t_msg,'String','Failed');
    fclose(handles.com.io);
end

set(handles.pb_middleOpen,'Enable','on');

% --- Executes on button press in pb_ringOpen.
function pb_ringOpen_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ringOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Unable the botton
set(handles.pb_ringOpen,'Enable','off');

% Get info
obj = handles.com;
pwmID = 'D';    % Referes to DoF, not to PWM

if get(handles.cb_ring,'Value')
    pwm2 = 0;       %Duty cycle
    pwm1 = str2double(get(handles.et_pwm,'String'));
else
    pwm1 = 0;       %Duty cycle
    pwm2 = str2double(get(handles.et_pwm,'String'));
end


% Send PWM
if Update2PWMusingSCI(obj, pwmID, pwm1, pwm2)
    % Wait for a little move to take place
    pause(str2double(get(handles.et_length,'String')));
    % Stop the movement
    Update2PWMusingSCI(obj, pwmID, 0, 0);
    set(handles.t_msg,'String','Moved');
else
    set(handles.t_msg,'String','Failed');
    fclose(handles.com.io);
end

set(handles.pb_ringOpen,'Enable','on');

% --- Executes on button press in pb_littleOpen.
function pb_littleOpen_Callback(hObject, eventdata, handles)
% hObject    handle to pb_littleOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Unable the botton
set(handles.pb_littleOpen,'Enable','off');

% Get info
obj = handles.com;
pwmID = 'E';    % Referes to DoF, not to PWM

if get(handles.cb_little,'Value')
    pwm2 = 0;       %Duty cycle
    pwm1 = str2double(get(handles.et_pwm,'String'));
else
    pwm1 = 0;       %Duty cycle
    pwm2 = str2double(get(handles.et_pwm,'String'));
end


% Send PWM
if Update2PWMusingSCI(obj, pwmID, pwm1, pwm2)
    % Wait for a little move to take place
    pause(str2double(get(handles.et_length,'String')));
    % Stop the movement
    Update2PWMusingSCI(obj, pwmID, 0, 0);
    set(handles.t_msg,'String','Moved');
else
    set(handles.t_msg,'String','Failed');
    fclose(handles.com.io);
end

set(handles.pb_littleOpen,'Enable','on');

% --- Executes on button press in pb_thumbClose.
function pb_thumbClose_Callback(hObject, eventdata, handles)
% hObject    handle to pb_thumbClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Unable the botton
set(handles.pb_thumbClose,'Enable','off');

% Get info
obj = handles.com;
pwmID = 'A';    % Referes to DoF, not to PWM

if get(handles.cb_thumb,'Value')
    pwm2 = 0;       %Duty cycle
    pwm1 = str2double(get(handles.et_pwm,'String'));
else
    pwm1 = 0;       %Duty cycle
    pwm2 = str2double(get(handles.et_pwm,'String'));
end


% Send PWM
if Update2PWMusingSCI(obj, pwmID, pwm1, pwm2)
    % Wait for a little move to take place
    pause(str2double(get(handles.et_length,'String')));
    % Stop the movement
    Update2PWMusingSCI(obj, pwmID, 0, 0);
    set(handles.t_msg,'String','Moved');
else
    set(handles.t_msg,'String','Failed');
    fclose(handles.com.io);
end

set(handles.pb_thumbClose,'Enable','on');

% --- Executes on button press in pb_indexClose.
function pb_indexClose_Callback(hObject, eventdata, handles)
% hObject    handle to pb_indexClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pb_indexClose,'Enable','off');

% Get info
obj = handles.com;
pwmID = 'B';    % Referes to DoF, not to PWM

if get(handles.cb_thumb,'Value')
    pwm1 = 0;       %Duty cycle
    pwm2 = str2double(get(handles.et_pwm,'String'));
else
    pwm2 = 0;       %Duty cycle
    pwm1 = str2double(get(handles.et_pwm,'String'));
end


% Send PWM
if Update2PWMusingSCI(obj, pwmID, pwm1, pwm2)
    % Wait for a little move to take place
    pause(str2double(get(handles.et_length,'String')));
    % Stop the movement
    Update2PWMusingSCI(obj, pwmID, 0, 0);
    set(handles.t_msg,'String','Moved');
else
    set(handles.t_msg,'String','Failed');
    fclose(handles.com.io);
end

set(handles.pb_indexClose,'Enable','on');

% --- Executes on button press in pb_middleClose.
function pb_middleClose_Callback(hObject, eventdata, handles)
% hObject    handle to pb_middleClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pb_middleClose,'Enable','off');

% Get info
obj = handles.com;
pwmID = 'C';    % Referes to DoF, not to PWM

if get(handles.cb_thumb,'Value')
    pwm1 = 0;       %Duty cycle
    pwm2 = str2double(get(handles.et_pwm,'String'));
else
    pwm2 = 0;       %Duty cycle
    pwm1 = str2double(get(handles.et_pwm,'String'));
end


% Send PWM
if Update2PWMusingSCI(obj, pwmID, pwm1, pwm2)
    % Wait for a little move to take place
    pause(str2double(get(handles.et_length,'String')));
    % Stop the movement
    Update2PWMusingSCI(obj, pwmID, 0, 0);
    set(handles.t_msg,'String','Moved');
else
    set(handles.t_msg,'String','Failed');
    fclose(handles.com.io);
end

set(handles.pb_middleClose,'Enable','on');

% --- Executes on button press in pb_ringClose.
function pb_ringClose_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ringClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pb_ringClose,'Enable','off');

% Get info
obj = handles.com;
pwmID = 'D';    % Referes to DoF, not to PWM

if get(handles.cb_thumb,'Value')
    pwm1 = 0;       %Duty cycle
    pwm2 = str2double(get(handles.et_pwm,'String'));
else
    pwm2 = 0;       %Duty cycle
    pwm1 = str2double(get(handles.et_pwm,'String'));
end


% Send PWM
if Update2PWMusingSCI(obj, pwmID, pwm1, pwm2)
    % Wait for a little move to take place
    pause(str2double(get(handles.et_length,'String')));
    % Stop the movement
    Update2PWMusingSCI(obj, pwmID, 0, 0);
    set(handles.t_msg,'String','Moved');
else
    set(handles.t_msg,'String','Failed');
    fclose(handles.com.io);
end

set(handles.pb_ringClose,'Enable','on');

% --- Executes on button press in pb_littleClose.
function pb_littleClose_Callback(hObject, eventdata, handles)
% hObject    handle to pb_littleClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pb_littleClose,'Enable','off');

% Get info
obj = handles.com;
pwmID = 'E';    % Referes to DoF, not to PWM

if get(handles.cb_thumb,'Value')
    pwm1 = 0;       %Duty cycle
    pwm2 = str2double(get(handles.et_pwm,'String'));
else
    pwm2 = 0;       %Duty cycle
    pwm1 = str2double(get(handles.et_pwm,'String'));
end


% Send PWM
if Update2PWMusingSCI(obj, pwmID, pwm1, pwm2)
    % Wait for a little move to take place
    pause(str2double(get(handles.et_length,'String')));
    % Stop the movement
    Update2PWMusingSCI(obj, pwmID, 0, 0);
    set(handles.t_msg,'String','Moved');
else
    set(handles.t_msg,'String','Failed');
    fclose(handles.com.io);
end

set(handles.pb_littleClose,'Enable','on');


function et_pwm_Callback(hObject, eventdata, handles)
% hObject    handle to et_pwm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_pwm as text
%        str2double(get(hObject,'String')) returns contents of et_pwm as a double


% --- Executes during object creation, after setting all properties.
function et_pwm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_pwm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_thumb.
function cb_thumb_Callback(hObject, eventdata, handles)
% hObject    handle to cb_thumb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_thumb


% --- Executes on button press in cb_index.
function cb_index_Callback(hObject, eventdata, handles)
% hObject    handle to cb_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_index


% --- Executes on button press in cb_middle.
function cb_middle_Callback(hObject, eventdata, handles)
% hObject    handle to cb_middle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_middle


% --- Executes on button press in cb_ring.
function cb_ring_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ring


% --- Executes on button press in cb_little.
function cb_little_Callback(hObject, eventdata, handles)
% hObject    handle to cb_little (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_little



function et_length_Callback(hObject, eventdata, handles)
% hObject    handle to et_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_length as text
%        str2double(get(hObject,'String')) returns contents of et_length as a double


% --- Executes during object creation, after setting all properties.
function et_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
