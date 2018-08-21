function varargout = GUI_PostProcessing(varargin)
% GUI_POSTPROCESSING MATLAB code for GUI_PostProcessing.fig
%      GUI_POSTPROCESSING, by itself, creates a new GUI_POSTPROCESSING or raises the existing
%      singleton*.
%
%      H = GUI_POSTPROCESSING returns the handle to a new GUI_POSTPROCESSING or the handle to
%      the existing singleton*.
%
%      GUI_POSTPROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_POSTPROCESSING.M with the given input arguments.
%
%      GUI_POSTPROCESSING('Property','Value',...) creates a new GUI_POSTPROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_PostProcessing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_PostProcessing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_PostProcessing

% Last Modified by GUIDE v2.5 26-Oct-2016 01:36:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_PostProcessing_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_PostProcessing_OutputFcn, ...
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


% --- Executes just before GUI_PostProcessing is made visible.
function GUI_PostProcessing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_PostProcessing (see VARARGIN)
%load the background image into Matlab
backgroundImage2 = importdata('Img/BioPatRec.png');
%select the axes
axes(handles.biopatrec_fig);
%place image onto the axes
image(backgroundImage2);
%remove the axis tick marks
axis off

handles.varargin = varargin;
%prr= handles.varargin{1};
% Choose default command line output for GUI_Recordings
handles.output = hObject;   
% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = GUI_PostProcessing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


varargout{1} = handles.output;


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%you should send commant to stop signal acquisition here

set(handles.varargin{1}.pb_preview,'Enable','on');
    set(handles.varargin{1}.pb_treat,'Enable','on');
    set(handles.varargin{1}.pb_treatFolder,'Enable','on');
set(handles.varargin{1}.t_msg,'String','sigTreated uploaded');
close(GUI_PostProcessing);



function et_rectime_Callback(hObject, eventdata, handles)
% hObject    handle to et_rectime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_rectime as text
%        str2double(get(hObject,'String')) returns contents of et_rectime as a double


% --- Executes during object creation, after setting all properties.
function et_rectime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_rectime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)
% hObject    handle to record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.record,'Enable','off');
set(handles.close,'Enable','off');
postProcessing_Rec(handles);
%postProcessing_Rec(handles,hTreatment,sigTreated);
%handles.post_plot=pp_plotdata.post_plot; %probably is to change if number of argument is otherwise needed in any other part



function t_msg_Callback(hObject, eventdata, handles)
% hObject    handle to t_msg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t_msg as text
%        str2double(get(hObject,'String')) returns contents of t_msg as a double


% --- Executes during object creation, after setting all properties.
function t_msg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_msg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
