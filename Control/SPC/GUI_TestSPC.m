function varargout = GUI_TestSPC(varargin)
% GUI_TESTSPC MATLAB code for GUI_TestSPC.fig
%      GUI_TESTSPC, by itself, creates a new GUI_TESTSPC or raises the existing
%      singleton*.
%
%      H = GUI_TESTSPC returns the handle to a new GUI_TESTSPC or the handle to
%      the existing singleton*.
%
%      GUI_TESTSPC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TESTSPC.M with the given input arguments.
%
%      GUI_TESTSPC('Property','Value',...) creates a new GUI_TESTSPC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_TestSPC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_TestSPC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_TestSPC

% Last Modified by GUIDE v2.5 06-Nov-2013 12:02:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_TestSPC_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_TestSPC_OutputFcn, ...
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


% --- Executes just before GUI_TestSPC is made visible.
function GUI_TestSPC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_TestSPC (see VARARGIN)

% Choose default command line output for GUI_TestSPC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_TestSPC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_TestSPC_OutputFcn(hObject, eventdata, handles) 
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


    if get(handles.rb_wifi,'Value')
        set(handles.t_msg,'String','Testing connection...');   
        if isfield(handles,'obj')
            obj = handles.obj;
            disp(obj);
            fclose(obj);
        else
            ip = get(handles.et_ip,'String');
            port = str2double(get(handles.et_port,'String'));
            obj = tcpip(ip,port,'NetworkRole','client');
%            obj = tcpip('192.168.100.10',65100,'NetworkRole','client');
        end        
    elseif get(handles.rb_serial,'Value')
        compath = get(handles.et_com,'String');
        %Find serial port objects with specified property values
        obj=instrfind('Status','open');
        if isempty(obj)
            obj = serial (compath, 'baudrate', 460800, 'databits', 8, 'byteorder', 'bigEndian'); 
%             obj=serial(compath, 'BaudRate', 115200);
            % Open io for read and write access
            set(obj,'InputBuffer',1024*64)
        end        
    end

    % open
    fopen(obj);
    pause(0.1);
    % Test connection
    fwrite(obj,'A','char');
    fwrite(obj,'C','char')
    replay = char(fread(obj,1,'char'));
    if strcmp(replay,'C');
        set(handles.t_msg,'String','Connection stablished!');
    else
        set(handles.t_msg,'String','Error');
    end
    fclose(obj);
    % close
    handles.obj = obj;
    handles.motors = InitMotors;
    handles.movements = InitMovements;
    guidata(hObject,handles);



% --- Executes on button press in pb_oh.
function pb_oh_Callback(hObject, eventdata, handles)
% hObject    handle to pb_oh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(hObject,'Enable','off');
    speed = str2double(get(handles.et_speed1,'String'));
    time = str2double(get(handles.et_time1,'String'));

    % Get connection object
    if isfield(handles,'obj')
        obj = handles.obj;
    else
        set(handles.t_msg,'String','No connection obj found');   
        return;
    end

    % Open connection
    if ~strcmp(obj.status,'open')
        fopen(obj);
    end   
    MotorsOn(obj, handles.movements(2), handles.motors, speed);
    pause(time);
    MotorsOff(obj, handles.movements(2), handles.motors);
    % Close connection
    fclose(obj);
    
    %ActivateSP_FixedTime(obj,'B',speed,time);
    set(hObject,'Enable','on');
    
function et_speed1_Callback(hObject, eventdata, handles)
% hObject    handle to et_speed1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_speed1 as text
%        str2double(get(hObject,'String')) returns contents of et_speed1 as a double


% --- Executes during object creation, after setting all properties.
function et_speed1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_speed1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_time1_Callback(hObject, eventdata, handles)
% hObject    handle to et_time1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_time1 as text
%        str2double(get(hObject,'String')) returns contents of et_time1 as a double


% --- Executes during object creation, after setting all properties.
function et_time1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_time1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_ch.
function pb_ch_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(hObject,'Enable','off');
    speed = str2double(get(handles.et_speed2,'String'));
    time = str2double(get(handles.et_time2,'String'));

    % Get connection object
    if isfield(handles,'obj')
        obj = handles.obj;
    else
        set(handles.t_msg,'String','No connection obj found');   
        return;
    end

    % Open connection
    if ~strcmp(obj.status,'open')
        fopen(obj);
    end   
    MotorsOn(obj, handles.movements(3), handles.motors, speed);
    pause(time);
    MotorsOff(obj, handles.movements(3), handles.motors);
    % Close connection
    fclose(obj);
    
    %ActivateSP_FixedTime(obj,'A',speed,time);
    set(hObject,'Enable','on');


function et_speed2_Callback(hObject, eventdata, handles)
% hObject    handle to et_speed2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_speed2 as text
%        str2double(get(hObject,'String')) returns contents of et_speed2 as a double


% --- Executes during object creation, after setting all properties.
function et_speed2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_speed2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_time2_Callback(hObject, eventdata, handles)
% hObject    handle to et_time2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_time2 as text
%        str2double(get(hObject,'String')) returns contents of et_time2 as a double


% --- Executes during object creation, after setting all properties.
function et_time2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_time2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_pro.
function pb_pro_Callback(hObject, eventdata, handles)
% hObject    handle to pb_pro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(hObject,'Enable','off');

    speed = str2double(get(handles.et_speed3,'String'));
    time = str2double(get(handles.et_time3,'String'));

    % Get connection object
    if isfield(handles,'obj')
        obj = handles.obj;
    else
        set(handles.t_msg,'String','No connection obj found');   
        return;
    end

    % Open connection
    if ~strcmp(obj.status,'open')
        fopen(obj);
    end   
    MotorsOn(obj, handles.movements(6), handles.motors, speed);
    pause(time);
    MotorsOff(obj, handles.movements(6), handles.motors);
    % Close connection
    fclose(obj);
    
    %ActivateSP_FixedTime(obj,'C',speed,time);
    set(hObject,'Enable','on');    

function et_speed3_Callback(hObject, eventdata, handles)
% hObject    handle to et_speed3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_speed3 as text
%        str2double(get(hObject,'String')) returns contents of et_speed3 as a double


% --- Executes during object creation, after setting all properties.
function et_speed3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_speed3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_time3_Callback(hObject, eventdata, handles)
% hObject    handle to et_time3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_time3 as text
%        str2double(get(hObject,'String')) returns contents of et_time3 as a double


% --- Executes during object creation, after setting all properties.
function et_time3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_time3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_sup.
function pb_sup_Callback(hObject, eventdata, handles)
% hObject    handle to pb_sup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(hObject,'Enable','off');
    speed = str2double(get(handles.et_speed4,'String'));
    time = str2double(get(handles.et_time4,'String'));

    % Get connection object
    if isfield(handles,'obj')
        obj = handles.obj;
    else
        set(handles.t_msg,'String','No connection obj found');   
        return;
    end

    % Open connection
    if ~strcmp(obj.status,'open')
        fopen(obj);
    end   
    MotorsOn(obj, handles.movements(7), handles.motors, speed);
    pause(time);
    MotorsOff(obj, handles.movements(7), handles.motors);
    % Close connection
    fclose(obj);
    
    %ActivateSP_FixedTime(obj,'D',speed,time);
    set(hObject,'Enable','on');
    
    
function et_speed4_Callback(hObject, eventdata, handles)
% hObject    handle to et_speed4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_speed4 as text
%        str2double(get(hObject,'String')) returns contents of et_speed4 as a double


% --- Executes during object creation, after setting all properties.
function et_speed4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_speed4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_time4_Callback(hObject, eventdata, handles)
% hObject    handle to et_time4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_time4 as text
%        str2double(get(hObject,'String')) returns contents of et_time4 as a double


% --- Executes during object creation, after setting all properties.
function et_time4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_time4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_fe.
function pb_fe_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(hObject,'Enable','off');
    speed = str2double(get(handles.et_speed5,'String'));
    time = str2double(get(handles.et_time5,'String'));

    % Get connection object
    if isfield(handles,'obj')
        obj = handles.obj;
    else
        set(handles.t_msg,'String','No connection obj found');   
        return;
    end

    % Open connection
    if ~strcmp(obj.status,'open')
        fopen(obj);
    end   
    MotorsOn(obj, handles.movements(16), handles.motors, speed);
    pause(time);
    MotorsOff(obj, handles.movements(16), handles.motors);
    % Close connection
    fclose(obj);
    
    %ActivateSP_FixedTime(obj,'F',speed,time);
    set(hObject,'Enable','on');
    

function et_speed5_Callback(hObject, eventdata, handles)
% hObject    handle to et_speed5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_speed5 as text
%        str2double(get(hObject,'String')) returns contents of et_speed5 as a double


% --- Executes during object creation, after setting all properties.
function et_speed5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_speed5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_time5_Callback(hObject, eventdata, handles)
% hObject    handle to et_time5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_time5 as text
%        str2double(get(hObject,'String')) returns contents of et_time5 as a double


% --- Executes during object creation, after setting all properties.
function et_time5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_time5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_ee.
function pb_ee_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ee (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(hObject,'Enable','off');
    speed = str2double(get(handles.et_speed6,'String'));
    time = str2double(get(handles.et_time6,'String'));

    % Get connection object
    if isfield(handles,'obj')
        obj = handles.obj;
    else
        set(handles.t_msg,'String','No connection obj found');   
        return;
    end
    
    % Open connection
    if ~strcmp(obj.status,'open')
        fopen(obj);
    end   
    MotorsOn(obj, handles.movements(17), handles.motors, speed);
    pause(time);
    MotorsOff(obj, handles.movements(17), handles.motors);
    % Close connection
    fclose(obj);

    %ActivateSP_FixedTime(obj,'E',speed,time);
    set(hObject,'Enable','on');

function et_speed6_Callback(hObject, eventdata, handles)
% hObject    handle to et_speed6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_speed6 as text
%        str2double(get(hObject,'String')) returns contents of et_speed6 as a double


% --- Executes during object creation, after setting all properties.
function et_speed6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_speed6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_time6_Callback(hObject, eventdata, handles)
% hObject    handle to et_time6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_time6 as text
%        str2double(get(hObject,'String')) returns contents of et_time6 as a double


% --- Executes during object creation, after setting all properties.
function et_time6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_time6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_ea.
function pb_ea_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get connection object
    if isfield(handles,'obj')
        obj = handles.obj;
    else
        set(handles.t_msg,'String','No connection obj found');   
        return;
    end

    % Open connection
    if strcmp(obj.status,'open')
        fclose(obj);        
        fopen(obj);
    else
        fopen(obj);
    end  
    
    fwrite(obj,'S','char');    
    fwrite(obj,'Z','char');

    % Close connection
    fclose(obj); 
    
    
    
% --- Executes on button press in pb_da.
function pb_da_Callback(hObject, eventdata, handles)
% hObject    handle to pb_da (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get connection object
    if isfield(handles,'obj')
        obj = handles.obj;
    else
        set(handles.t_msg,'String','No connection obj found');   
        return;
    end

    % Open connection
    if strcmp(obj.status,'open')
        fclose(obj);        
        fopen(obj);
    else
        fopen(obj);
    end  
    
    fwrite(obj,'Q','char');    
    fwrite(obj,'Z','char');

    % Close connection
    fclose(obj); 
    


% --- Executes on button press in pb_start.
function pb_start_Callback(hObject, eventdata, handles)
% hObject    handle to pb_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(hObject,'Enable','off');

    time1=3;
    speed = str2double(get(handles.et_speed1,'String'));
    time = str2double(get(handles.et_time1,'String'));

    % Get connection object
    if isfield(handles,'obj')
        obj = handles.obj;
    else
        set(handles.t_msg,'String','No connection obj found');
        return;
    end

    ActivateSP_FixedTime(obj,'B',speed,time);

    pause(time1);

    speed = str2double(get(handles.et_speed2,'String'));
    time = str2double(get(handles.et_time2,'String'));



    ActivateSP_FixedTime(obj,'A',speed,time);

    pause(time1);

    speed = str2double(get(handles.et_speed3,'String'));
    time = str2double(get(handles.et_time3,'String'));


    ActivateSP_FixedTime(obj,'C',speed,time);

    pause(time1);

    speed = str2double(get(handles.et_speed4,'String'));
    time = str2double(get(handles.et_time4,'String'));



    ActivateSP_FixedTime(obj,'D',speed,time);

    pause(time1);
    speed = str2double(get(handles.et_speed5,'String'));
    time = str2double(get(handles.et_time5,'String'));



    ActivateSP_FixedTime(obj,'F',speed,time);

    pause(time1);

    speed = str2double(get(handles.et_speed6,'String'));
    time = str2double(get(handles.et_time6,'String'));



    ActivateSP_FixedTime(obj,'E',speed,time);

    set(hObject,'Enable','off');
    
    
    
    
    
    


% --- Executes on button press in rb_wifi.
function rb_wifi_Callback(hObject, eventdata, handles)
% hObject    handle to rb_wifi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_wifi


% --- Executes on button press in rb_serial.
function rb_serial_Callback(hObject, eventdata, handles)
% hObject    handle to rb_serial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_serial



function et_ip_Callback(hObject, eventdata, handles)
% hObject    handle to et_ip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_ip as text
%        str2double(get(hObject,'String')) returns contents of et_ip as a double


% --- Executes during object creation, after setting all properties.
function et_ip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_ip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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



function et_port_Callback(hObject, eventdata, handles)
% hObject    handle to et_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_port as text
%        str2double(get(hObject,'String')) returns contents of et_port as a double


% --- Executes during object creation, after setting all properties.
function et_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
