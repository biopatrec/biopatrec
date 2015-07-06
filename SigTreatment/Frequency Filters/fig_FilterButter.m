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

function varargout = fig_FilterButter(varargin)
% FIG_FILTERBUTTER M-file for fig_FilterButter.fig
%      FIG_FILTERBUTTER, by itself, creates a new FIG_FILTERBUTTER or raises the existing
%      singleton*.
%
%      H = FIG_FILTERBUTTER returns the handle to a new FIG_FILTERBUTTER or the handle to
%      the existing singleton*.
%
%      FIG_FILTERBUTTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIG_FILTERBUTTER.M with the given input arguments.
%
%      FIG_FILTERBUTTER('Property','Value',...) creates a new FIG_FILTERBUTTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fig_FilterButter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fig_FilterButter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fig_FilterButter

% Last Modified by GUIDE v2.5 21-Apr-2009 00:30:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fig_FilterButter_OpeningFcn, ...
                   'gui_OutputFcn',  @fig_FilterButter_OutputFcn, ...
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


% --- Executes just before fig_FilterButter is made visible.
function fig_FilterButter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fig_FilterButter (see VARARGIN)

% Choose default command line output for fig_FilterButter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fig_FilterButter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fig_FilterButter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function et_N_Callback(hObject, eventdata, handles)
% hObject    handle to et_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_N as text
%        str2double(get(hObject,'String')) returns contents of et_N as a double


% --- Executes during object creation, after setting all properties.
function et_N_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Fc1_Callback(hObject, eventdata, handles)
% hObject    handle to et_Fc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_Fc1 as text
%        str2double(get(hObject,'String')) returns contents of et_Fc1 as a double


% --- Executes during object creation, after setting all properties.
function et_Fc1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Fc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Fc2_Callback(hObject, eventdata, handles)
% hObject    handle to et_Fc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_Fc2 as text
%        str2double(get(hObject,'String')) returns contents of et_Fc2 as a double


% --- Executes during object creation, after setting all properties.
function et_Fc2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Fc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_Apply.
function pb_Apply_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in pm_type.
function pm_type_Callback(hObject, eventdata, handles)
% hObject    handle to pm_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pm_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_type


% --- Executes during object creation, after setting all properties.
function pm_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


