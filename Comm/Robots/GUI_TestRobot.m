function varargout = GUI_TestRobot(varargin)
% GUI_TESTROBOT MATLAB code for GUI_TestRobot.fig
%      GUI_TESTROBOT, by itself, creates a new GUI_TESTROBOT or raises the existing
%      singleton*.
%
%      H = GUI_TESTROBOT returns the handle to a new GUI_TESTROBOT or the handle to
%      the existing singleton*.
%
%      GUI_TESTROBOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TESTROBOT.M with the given input arguments.
%
%      GUI_TESTROBOT('Property','Value',...) creates a new GUI_TESTROBOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_TestRobot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_TestRobot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_TestRobot

% Last Modified by GUIDE v2.5 02-Aug-2013 14:33:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_TestRobot_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_TestRobot_OutputFcn, ...
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


% --- Executes just before GUI_TestRobot is made visible.
function GUI_TestRobot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_TestRobot (see VARARGIN)

% Choose default command line output for GUI_TestRobot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_TestRobot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_TestRobot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_f.
function pb_f_Callback(hObject, eventdata, handles)
% hObject    handle to pb_f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
device = digitalio('nidaq', 'Dev1');
addline(device,0:3,'out');
putvalue(device, [1 1 0 0]);
 

% --- Executes on button press in pb_b.
function pb_b_Callback(hObject, eventdata, handles)
% hObject    handle to pb_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
device = digitalio('nidaq', 'Dev1');
ch = addline(device,0:3,'out');
putvalue(device, [0 0 1 1]);


% --- Executes on button press in pb_fl.
function pb_fl_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
device = digitalio('nidaq', 'Dev1');
ch = addline(device,0:3,'out');
putvalue(device, [0 1 0 0]);


% --- Executes on button press in pb_fr.
function pb_fr_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
device = digitalio('nidaq', 'Dev1');
ch = addline(device,0:3,'out');
putvalue(device, [1 0 0 0]);


% --- Executes on button press in pb_br.
function pb_br_Callback(hObject, eventdata, handles)
% hObject    handle to pb_br (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
device = digitalio('nidaq', 'Dev1');
ch = addline(device,0:3,'out');
putvalue(device, [0 0 1 0]);

% --- Executes on button press in pb_bl.
function pb_bl_Callback(hObject, eventdata, handles)
% hObject    handle to pb_bl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 device = digitalio('nidaq', 'Dev1');
ch = addline(device,0:3,'out');
putvalue(device, [0 0 0 1]);


% --- Executes on button press in pb_stop.
function pb_stop_Callback(hObject, eventdata, handles)
% hObject    handle to pb_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 device = digitalio('nidaq', 'Dev1');
ch = addline(device,0:3,'out');
putvalue(device, [0 0 0 0]);
