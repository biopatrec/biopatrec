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

function varargout = GUI_Test_PanTilt(varargin)
% GUI_TEST_PANTILT M-file for GUI_Test_PanTilt.fig
%      GUI_TEST_PANTILT, by itself, creates a new GUI_TEST_PANTILT or raises the existing
%      singleton*.
%
%      H = GUI_TEST_PANTILT returns the handle to a new GUI_TEST_PANTILT or the handle to
%      the existing singleton*.
%
%      GUI_TEST_PANTILT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TEST_PANTILT.M with the given input arguments.
%
%      GUI_TEST_PANTILT('Property','Value',...) creates a new GUI_TEST_PANTILT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Test_PanTilt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Test_PanTilt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Test_PanTilt

% Last Modified by GUIDE v2.5 04-May-2012 18:48:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Test_PanTilt_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Test_PanTilt_OutputFcn, ...
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


% --- Executes just before GUI_Test_PanTilt is made visible.
function GUI_Test_PanTilt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Test_PanTilt (see VARARGIN)

% Choose default command line output for GUI_Test_PanTilt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Test_PanTilt wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Test_PanTilt_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pb_pronate.
function pb_pronate_Callback(hObject, eventdata, handles)
% hObject    handle to pb_pronate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(hObject,'Enable','off');

    stepP = str2double(get(handles.et_step,'String'));
    pos   = str2double(get(handles.et_posPan,'String'));

    % Get info
    obj = handles.com;
    pwmID = 'K';    % Referes to DoF, not to PWM
    
    if get(handles.cb_pan,'Value')
        pwmPer = pos-stepP;
    else
        pwmPer = pos+stepP;
    end    
    
    % If no problems where encountered, the ALC must return 1            
    % Send PWM
    if UpdatePWMusingSCI_PanTilt(obj, pwmID, pwmPer)
        set(handles.t_msg,'String','Moved');
        set(handles.et_posPan,'String',num2str(pwmPer));
    else
        set(handles.t_msg,'String','Failed');
        fclose(handles.com.io);
    end

    set(hObject,'Enable','on');

% --- Executes on button press in pb_supinate.
function pb_supinate_Callback(hObject, eventdata, handles)
% hObject    handle to pb_supinate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Unable the botton
    set(hObject,'Enable','off');

    stepP = str2double(get(handles.et_step,'String'));
    pos   = str2double(get(handles.et_posPan,'String'));

    % Get info
    obj = handles.com;
    pwmID = 'K';    % Referes to DoF, not to PWM
    
    if get(handles.cb_pan,'Value')
        pwmPer = pos+stepP;
    else
        pwmPer = pos-stepP;
    end    
    
    % If no problems where encountered, the ALC must return 1            
    % Send PWM
    if UpdatePWMusingSCI_PanTilt(obj, pwmID, pwmPer)
        set(handles.t_msg,'String','Moved');
        set(handles.et_posPan,'String',num2str(pwmPer));
    else
        set(handles.t_msg,'String','Failed');
        fclose(handles.com.io);
    end

    set(hObject,'Enable','on');    

% --- Executes on button press in pb_flex.
function pb_flex_Callback(hObject, eventdata, handles)
% hObject    handle to pb_flex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Unable the botton
% Unable the botton
    set(hObject,'Enable','off');

    stepP = str2double(get(handles.et_step,'String'));
    pos   = str2double(get(handles.et_posTilt,'String'));

    % Get info
    obj = handles.com;
    pwmID = 'L';    % Referes to DoF, not to PWM
    
    if get(handles.cb_tilt,'Value')
        pwmPer = pos-stepP;
    else
        pwmPer = pos+stepP;
    end    
    
    % If no problems where encountered, the ALC must return 1            
    % Send PWM
    if UpdatePWMusingSCI_PanTilt(obj, pwmID, pwmPer)
        set(handles.t_msg,'String','Moved');
        set(handles.et_posTilt,'String',num2str(pwmPer));
    else
        set(handles.t_msg,'String','Failed');
        fclose(handles.com.io);
    end

    set(hObject,'Enable','on');
    
    
    
% --- Executes on button press in pb_extend.
function pb_extend_Callback(hObject, eventdata, handles)
% hObject    handle to pb_extend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(hObject,'Enable','off');

    stepP = str2double(get(handles.et_step,'String'));
    pos   = str2double(get(handles.et_posTilt,'String'));

    % Get info
    obj = handles.com;
    pwmID = 'L';    % Referes to DoF, not to PWM
    
    if get(handles.cb_tilt,'Value')
        pwmPer = pos+stepP;
    else
        pwmPer = pos-stepP;
    end    
    
    % If no problems where encountered, the ALC must return 1            
    % Send PWM
    if UpdatePWMusingSCI_PanTilt(obj, pwmID, pwmPer)
        set(handles.t_msg,'String','Moved');
        set(handles.et_posTilt,'String',num2str(pwmPer));
    else
        set(handles.t_msg,'String','Failed');
        fclose(handles.com.io);
    end

    set(hObject,'Enable','on');



function et_step_Callback(hObject, eventdata, handles)
% hObject    handle to et_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_step as text
%        str2double(get(hObject,'String')) returns contents of et_step as a double


% --- Executes during object creation, after setting all properties.
function et_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_pan.
function cb_pan_Callback(hObject, eventdata, handles)
% hObject    handle to cb_pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_pan


% --- Executes on button press in cb_tilt.
function cb_tilt_Callback(hObject, eventdata, handles)
% hObject    handle to cb_tilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_tilt


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


% --- Executes on button press in pb_panCenter.
function pb_panCenter_Callback(hObject, eventdata, handles)
% hObject    handle to pb_panCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(hObject,'Enable','off');

    % Get info
    obj = handles.com;
    pwmID = 'K';    % Referes to DoF, not to PWM
    pwmPer = 72;
    set(handles.et_posPan,'String','72');
       
    % If no problems where encountered, the ALC must return 1            
    % Send PWM
    if UpdatePWMusingSCI_PanTilt(obj, pwmID, pwmPer)
        set(handles.t_msg,'String','Moved');
    else
        set(handles.t_msg,'String','Failed');
        fclose(handles.com.io);
    end

    set(hObject,'Enable','on');




% --- Executes on button press in pb_tiltCenter.
function pb_tiltCenter_Callback(hObject, eventdata, handles)
% hObject    handle to pb_tiltCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(hObject,'Enable','off');

    % Get info
    obj = handles.com;
    pwmID = 'L';    % Referes to DoF, not to PWM
    pwmPer = 52;
    
    set(handles.et_posTilt,'String','52');
       
    % If no problems where encountered, the ALC must return 1            
    % Send PWM
    if UpdatePWMusingSCI_PanTilt(obj, pwmID, pwmPer)
        set(handles.t_msg,'String','Moved');
    else
        set(handles.t_msg,'String','Failed');
        fclose(handles.com.io);
    end

    set(hObject,'Enable','on');



function et_posPan_Callback(hObject, eventdata, handles)
% hObject    handle to et_posPan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_posPan as text
%        str2double(get(hObject,'String')) returns contents of et_posPan as a double


% --- Executes during object creation, after setting all properties.
function et_posPan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_posPan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_posTilt_Callback(hObject, eventdata, handles)
% hObject    handle to et_posTilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_posTilt as text
%        str2double(get(hObject,'String')) returns contents of et_posTilt as a double


% --- Executes during object creation, after setting all properties.
function et_posTilt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_posTilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
