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
% A Graphical User Interface (GUI) used to initialise and control the TAC
% test. All necessary data is loaded into the handles upon creation of the
% GUI.
% 
% --------------------------Updates--------------------------
% 2012-05-25 / Nichlas Sander  / Creation
% 2012-10-12 / Joel Falk-Dahlin  / Changed from using "patRecHandles" to
                                % storing a handle to mainGUI in
                                % GUI_TacTest guidata. This way the
                                % patRecHandles are always updated when
                                % pressing the start button.
% 2012-11-13 / Joel Falk-Dahlin / Removed speed from handles because it is now stored inside the patRec struct 
% 2016-12-16 / Jake Gusman      / Modifications for greater target
                                % randomization. Ability to input multiple
                                % allowance values and distance values.
                                % This GUI now allows for the use of multiple allowance and distance combinations.
                                % Values should be input into the appropriate text boxes separated
                                % by commas. E.g. to initiate a test with four different allowance/distance
                                % combinations, one can put the following in the Allowance text box:
                                % 5,5,10,10. And the following in the Distance text box: 25,50,25,50. This 
                                % results in the following 4 difficulty combinations which will be randomized
                                % along with the movement presention. Note that this also results in 4
                                % times the number of tasks presented.
                                % Also, if multiple difficulties are used,
                                % the number of Repetitions must match the
                                % number of difficulties (e.g. in the above
                                % example the number 4 must be input in the
                                % "Repetitions" box or else an error will
                                % result. The Distance and Allowance box
                                % must contain the same number of elements
                                % or else error will result.
                                % 
% 20xx-xx-xx / Author  / Comment on update

function varargout = GUI_TacTest(varargin)
% GUI_TACTEST MATLAB code for GUI_TacTest.fig
%      GUI_TACTEST, by itself, creates a new GUI_TACTEST or raises the existing
%      singleton*.
%
%      H = GUI_TACTEST returns the handle to a new GUI_TACTEST or the handle to
%      the existing singleton*.
%
%      GUI_TACTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TACTEST.M with the given input arguments.
%
%      GUI_TACTEST('Property','Value',...) creates a new GUI_TACTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_TacTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_TacTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_TacTest

% Last Modified by GUIDE v2.5 23-Feb-2017 16:35:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_TacTest_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_TacTest_OutputFcn, ...
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


% --- Executes just before GUI_TacTest is made visible.
function GUI_TacTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_TacTest (see VARARGIN)

% Choose default command line output for GUI_TacTest
handles.output = hObject;

% SMC test support variables
handles.SMCtestEnabled = 0;
if isfield(handles,'cb_enableSMCtest')
    handles.SMCtestSerial  = [];
    handles.SMCTargetStep  = 10; % step between targets
    handles.SMCMaxVibIdx   = 13;
    handles.SMCMaxVibInt   = 15;
    handles.SMCVibduration = 20; % ms/10
    handles.SMCposition    = 0;
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_TacTest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_TacTest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function tb_trials_Callback(hObject, eventdata, handles)
% hObject    handle to tb_trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_trials as text
%        str2double(get(hObject,'String')) returns contents of tb_trials as a double


% --- Executes during object creation, after setting all properties.
function tb_trials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tb_executeTime_Callback(hObject, eventdata, handles)
% hObject    handle to tb_executeTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_executeTime as text
%        str2double(get(hObject,'String')) returns contents of tb_executeTime as a double


% --- Executes during object creation, after setting all properties.
function tb_executeTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_executeTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_movement.
function pm_movement_Callback(hObject, eventdata, handles)
% hObject    handle to pm_movement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_movement contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_movement


% --- Executes during object creation, after setting all properties.
function pm_movement_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_movement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tb_repetitions_Callback(hObject, eventdata, handles)
% hObject    handle to tb_repetitions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_repetitions as text
%        str2double(get(hObject,'String')) returns contents of tb_repetitions as a double


% --- Executes during object creation, after setting all properties.
function tb_repetitions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_repetitions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tb_amountDOF_Callback(hObject, eventdata, handles)
% hObject    handle to tb_amountDOF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_amountDOF as text
%        str2double(get(hObject,'String')) returns contents of tb_amountDOF as a double


% --- Executes during object creation, after setting all properties.
function tb_amountDOF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_amountDOF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag')
    case 'rb_1dof'
        handles.dofs = 1;
    case 'rb_2dof'
        handles.dofs = 2;
    case 'rb_3dof'
        handles.dofs = 3;
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function pb_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pb_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pb_start.
function pb_start_Callback(hObject, eventdata, handles)
% hObject    handle to pb_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update patRecHandles from mainGUI before starting TAC-test
handles.patRecHandles = guidata(handles.mainGUI);

if(~isfield(handles.patRecHandles,'patRec'))
   set(handles.txt_status,'String','Nothing to see. No PatRec.');
   return;
end
if(~isfield(handles.patRecHandles,'vre_Com'))
   set(handles.txt_status,'String','Nothing to see. No VRE.');
   return;
end
if ~isfield(handles,'dofs')
    handles.dofs = 1; 
end

patRec = handles.patRecHandles.patRec;
handles.vre_Com = handles.patRecHandles.vre_Com;
handles.movList = handles.patRecHandles.movList;
set(handles.txt_status,'String','Starting TAC');
if isfield(handles.patRecHandles,'cb_ALCD')
    if get(handles.patRecHandles.cb_ALCD,'Value') == 1
        TACTestALCD(patRec, handles);
    else
        TACTest(patRec,handles);
    end
else
    TACTest(patRec,handles);
end
set(handles.txt_status,'String','Finished TAC');

function tb_allowance_Callback(hObject, eventdata, handles)
% hObject    handle to tb_allowance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_allowance as text
%        str2double(get(hObject,'String')) returns contents of tb_allowance as a double

% --- Executes during object creation, after setting all properties.
function tb_allowance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_allowance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tb_time_Callback(hObject, eventdata, handles)
% hObject    handle to tb_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_time as text
%        str2double(get(hObject,'String')) returns contents of tb_time as a double


% --- Executes during object creation, after setting all properties.
function tb_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pm_serialsel.
function pm_SMCselectserial_Callback(hObject, eventdata, handles)
% hObject    handle to pm_serialsel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_serialsel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_serialsel
COMportIdx = get(hObject,'Value');
COMport  = get(hObject,'String');
COMport  = COMport{COMportIdx};
BitsN    = 8;
SBits    = 1;
Parity   = 'none';
TimeOut  = 0.5;
BaudRate = 19200;
InputBufferSize  = 1000;
OutputBufferSize = 500;

% Open serial port
if ~isempty(handles.SMCtestSerial) % if already opened, close it
    fclose(handles.SMCtestSerial);
    delete(handles.SMCtestSerial);
    handles.SMCtestSerial = [];
end
handles.SMCtestSerial = serial(COMport,'BaudRate', BaudRate,...
                                 'DataBits', BitsN, 'StopBits', SBits, 'Parity', Parity,...
                                 'Timeout', TimeOut, 'InputBufferSize', InputBufferSize,...
                                 'OutputBufferSize', OutputBufferSize);

fopen(handles.SMCtestSerial);
set(handles.pb_start,'Enable','on');

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function cb_enableSMCtest_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to pm_serialsel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_serialsel.
function cb_enableSMCtest_Callback(hObject, eventdata, handles)
% hObject    handle to pm_serialsel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_serialsel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_serialsel

if(get(hObject,'Value'))
    set(handles.pm_SMCselectserial,'Enable','on');
    handles.SMCtestEnabled = 1;
    if isempty(handles.SMCtestSerial)
        set(handles.pb_start,'Enable','off');
    else
        set(handles.pb_start,'Enable','on');
    end
else
    set(handles.pm_SMCselectserial,'Enable','off');
    set(handles.pb_start,'Enable','on');
    handles.SMCtestEnabled = 0;
end

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pm_SMCselectserial_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to pm_serialsel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% list all serial ports available
Serial = instrhwinfo('serial');
if ~isempty(Serial.AvailableSerialPorts)
    serialportlist = Serial.SerialPorts;
    set(hObject,'String',serialportlist);
else
    set(hObject,'String','None Available');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if ~isempty(handles.SMCtestSerial)
    fclose(handles.SMCtestSerial);
    delete(handles.SMCtestSerial);
    handles.SMCtestSerial = [];
end

% Hint: delete(hObject) closes the figure
delete(hObject);

function tb_distance_Callback(hObject, eventdata, handles)
% hObject    handle to tb_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_distance as text
%        str2double(get(hObject,'String')) returns contents of tb_distance as a double


% --- Executes during object creation, after setting all properties.
function tb_distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function figure1_DeleteFcn(hObject, eventdata, handles)
