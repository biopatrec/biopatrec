% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec © which is open and free software under 
% the GNU Lesser General Public License (LGPL). See the file "LICENSE" for
% the full license governing this code and copyrights.
%
% BioPatRec was initially developed by Max J. Ortiz C. at Integrum AB and
% Chalmers University of Technology. All authors? contributions must be kept
% acknowledged below in the section "Updates % Contributors".
%
% Would you like to contribute to science and sum efforts to improve
% amputees? quality of life? Join this project! or, send your comments to:
% maxo@chalmers.se.
%
% The entire copyright notice must be kept in this or any source file
% linked to BioPatRec. This will ensure communication with all authors and
% acknowledge contributions here and in the project web page (optional).
%
% -------------------------- Function Description -------------------------
% GUI for wavelet denoising paramter selection.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-02-03 / Julian Maier  / Creation

function varargout = GUI_Denoising(varargin)
% GUI_DENOISING MATLAB code for GUI_Denoising.fig
%      GUI_DENOISING, by itself, creates a new GUI_DENOISING or raises the existing
%      singleton*.
%
%      H = GUI_DENOISING returns the handle to a new GUI_DENOISING or the handle to
%      the existing singleton*.
%
%      GUI_DENOISING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DENOISING.M with the given input arguments.
%
%      GUI_DENOISING('Property','Value',...) creates a new GUI_DENOISING or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Denoising_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Denoising_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Denoising

% Last Modified by GUIDE v2.5 19-Apr-2016 13:21:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Denoising_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Denoising_OutputFcn, ...
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

% --- Executes just before GUI_Denoising is made visible.
function GUI_Denoising_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Denoising (see VARARGIN)

% Choose default command line output for GUI_Denoising
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes GUI_Denoising wait for user response (see UIRESUME)
% uiwait(handles.GUI_Denoising);

movegui(hObject,'center');

% --- Outputs from this function are returned to the command line.
function varargout = GUI_Denoising_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function pm_waveletType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_wavelettype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pm_waveletType_Callback(hObject, eventdata, handles)
% hObject    handle to pm_wavelettype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pm_wavelettype as text
%        str2double(get(hObject,'String')) returns contents of pm_wavelettype as a double

% Save the new pm_wavelettype value
guidata(hObject,handles)
list = get(hObject,'String');
if strcmp(list(get(hObject,'Value')),'SWT')
    set(handles.cb_thresholdCycSpin,'Enable','off')
    set(handles.cb_thresholdCycSpin,'Value',0)
    set(handles.pm_thresholdCycSpinNo,'Enable','off')
    set(handles.pm_thresholdCycSpinNo,'Value',1)
else
    set(handles.cb_thresholdCycSpin,'Enable','on')
end


% --- Executes during object creation, after setting all properties.
function pm_waveletShape_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_waveletshape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pm_waveletShape_Callback(hObject, eventdata, handles)
% hObject    handle to pm_waveletshape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pm_waveletShape as text
%        str2double(get(hObject,'String')) returns contents of pm_wavelethape as a double

%str2double(get(hObject, 'String'));

% Save the new pm_waveletshape value
guidata(hObject,handles)


% --- Executes on button press in pb_waveletcancel.
function pb_WaveletCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_waveletcancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the pb_waveletcancel flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to pb_waveletcancel the data.


% Update handles structure
guidata(handles.GUI_Denoising, handles);


% --- Executes on selection change in pm_waveletlevel.
function pm_waveletLevel_Callback(hObject, eventdata, handles)
% hObject    handle to pm_waveletlevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_waveletlevel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_waveletlevel


% --- Executes during object creation, after setting all properties.
function pm_waveletLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_waveletlevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_thresholdsel.
function pm_thresholdSel_Callback(hObject, eventdata, handles)
% hObject    handle to pm_thresholdsel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_thresholdsel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_thresholdsel


% --- Executes during object creation, after setting all properties.
function pm_thresholdSel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_thresholdsel (see GCBO)
% eventdata  reserved - to be defin~ future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_thresholdshrink.
function pm_thresholdShrink_Callback(hObject, eventdata, handles)
% hObject    handle to pm_thresholdshrink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_thresholdshrink contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_thresholdshrink


% --- Executes during object creation, after setting all properties.
function pm_thresholdShrink_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_thresholdshrink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_thresholdnoise.
function pm_thresholdNoise_Callback(hObject, eventdata, handles)
% hObject    handle to pm_thresholdnoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_thresholdnoise contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_thresholdnoise


% --- Executes during object creation, after setting all properties.
function pm_thresholdNoise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_thresholdnoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_waveletwica.
function cb_waveletWICA_Callback(hObject, eventdata, handles)
% hObject    handle to cb_waveletwica (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_waveletwica


% --- Executes on button press in pb_waveletAccept.
function pb_waveletAccept_Callback(hObject, eventdata, handles)
% hObject    handle to pb_waveletAccept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sigDenoise = GetDenoiseParams(handles);
disp('%%%%%%%%%%% Wavelet Denoise Params %%%%%%%%%%%%%');

sthandles = get(handles.t_sthandles,'UserData'); % get parent GUI handles
set(sthandles.t_denoiseParams,'UserData',sigDenoise); % Save params to parent GUI handle

name = WaveletName(sigDenoise); disp(name)

close(GUI_Denoising);


% --- Executes on button press in pb_waveletCancel.
function pb_waveletCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_waveletCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Wavelet denoise.params cleared.')

sthandles = get(handles.t_sthandles,'UserData'); % get parent GUI handles
set(sthandles.t_denoiseParams,'UserData',[]); % Save [] params to parent GUI handle

close(GUI_Denoising);
    
% --- Executes on button press in cb_waveletExtWin.
function cb_waveletExtWin_Callback(hObject, eventdata, handles)
% hObject    handle to cb_waveletExtWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_waveletExtWin

% --- Executes on selection change in pm_waveletExtWin.
function pm_waveletExtWin_Callback(hObject, eventdata, handles)
% hObject    handle to pm_waveletExtWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_waveletExtWin contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_waveletExtWin
activateExtLength = get(hObject,'Value');
if activateExtLength ~= 1
    set(handles.ed_waveletExtLength,'Enable','on')
else
    set(handles.ed_waveletExtLength,'Enable','off')
end

% --- Executes during object creation, after setting all properties.
function pm_waveletExtWin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_waveletExtWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_waveletExtLength_Callback(hObject, eventdata, handles)
% hObject    handle to ed_waveletExtLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_waveletExtLength as text
%        str2double(get(hObject,'String')) returns contents of ed_waveletExtLength as a double


% --- Executes during object creation, after setting all properties.
function ed_waveletExtLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_waveletExtLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_thresholdFactor_Callback(hObject, eventdata, handles)
% hObject    handle to ed_thresholdFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_thresholdFactor as text
%        str2double(get(hObject,'String')) returns contents of ed_thresholdFactor as a double


% --- Executes during object creation, after setting all properties.
function ed_thresholdFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_thresholdFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_thresholdSigma.
function pm_thresholdSigma_Callback(hObject, eventdata, handles)
% hObject    handle to pm_thresholdSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_thresholdSigma contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_thresholdSigma
contents = cellstr(get(hObject,'String'));
selThr = contents{get(hObject,'Value')};
if strcmp(selThr,'ALCD')
    set(handles.pm_waveletShape,'Value',2);
    set(handles.pm_waveletType,'Value',2);
    set(handles.pm_waveletLevel,'Value',3);
    set(handles.pm_waveletExtWin,'Value',1);
    set(handles.cb_thresholdCycSpin,'Value',0);
    set(handles.pm_thresholdSel,'Value',4);
    set(handles.ed_thresholdFactor,'String','1.0');
    set(handles.cb_keepApp,'Value',0);
    set(handles.cb_wienerFilt,'Value',1);
    
    set(handles.pm_waveletType,'Enable','off');
    set(handles.pm_waveletShape,'Enable','off');
    set(handles.pm_waveletLevel,'Enable','off');
    set(handles.pm_waveletExtWin,'Enable','off');
    set(handles.cb_thresholdCycSpin,'Enable','off');
    set(handles.pm_thresholdSel,'Enable','off');
    set(handles.ed_thresholdFactor,'Enable','off');
    set(handles.cb_keepApp,'Enable','off');
    set(handles.cb_wienerFilt,'Enable','off');
else
    set(handles.pm_waveletType,'Enable','on');
    set(handles.pm_waveletShape,'Enable','on');
    set(handles.pm_waveletLevel,'Enable','on');
    set(handles.pm_waveletExtWin,'Enable','on');
    set(handles.cb_thresholdCycSpin,'Enable','on');
    set(handles.pm_thresholdSel,'Enable','on');
    set(handles.ed_thresholdFactor,'Enable','on');
    set(handles.cb_keepApp,'Enable','on');
    set(handles.cb_wienerFilt,'Enable','on');
end


% --- Executes during object creation, after setting all properties.
function pm_thresholdSigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_thresholdSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_thresholdCycSpin.
function cb_thresholdCycSpin_Callback(hObject, eventdata, handles)
% hObject    handle to cb_thresholdCycSpin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_thresholdCycSpin
if get(hObject,'Value')
    set(handles.pm_thresholdCycSpinNo,'Enable','on')
else
    set(handles.pm_thresholdCycSpinNo,'Enable','off')
    set(handles.pm_thresholdCycSpinNo,'Value',1)
end

% --- Executes on slider movement.
function pm_thresholdCycSpinNo_Callback(hObject, eventdata, handles)
% hObject    handle to pm_thresholdCycSpinNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function pm_thresholdCycSpinNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_thresholdCycSpinNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in cb_wienerFilt.
function cb_wienerFilt_Callback(hObject, eventdata, handles)
% hObject    handle to cb_wienerFilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_wienerFilt


% --- Executes on button press in cb_keepApp.
function cb_keepApp_Callback(hObject, eventdata, handles)
% hObject    handle to cb_keepApp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_keepApp
