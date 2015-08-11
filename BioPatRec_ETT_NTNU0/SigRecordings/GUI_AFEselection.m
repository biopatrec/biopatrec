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

function varargout = GUI_AFEselection(varargin)
% GUI_AFESELECTION MATLAB code for GUI_AFEselection.fig
%      GUI_AFESELECTION, by itself, creates a new GUI_AFESELECTION or raises the existing
%      singleton*.
%
%      H = GUI_AFESELECTION returns the handle to a new GUI_AFESELECTION or the handle to
%      the existing singleton*.
%
%      GUI_AFESELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_AFESELECTION.M with the given input arguments.
%
%      GUI_AFESELECTION('Property','Value',...) creates a new GUI_AFESELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_AFEselection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_AFEselection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_AFEselection

% Last Modified by GUIDE v2.5 05-Jun-2013 14:33:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_AFEselection_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_AFEselection_OutputFcn, ...
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


% --- Executes just before GUI_AFEselection is made visible.
function GUI_AFEselection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_AFEselection (see VARARGIN)
% handles

%load the background image into Matlab
backgroundImage2 = importdata('/../Img/BioPatRec.png');
%select the axes
axes(handles.axes1);
%place image onto the axes
image(backgroundImage2);
%remove the axis tick marks
axis off

handles.varargin = varargin;

% Choose default command line output for GUI_AFEselection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_AFEselection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_AFEselection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pb_record.
function pb_record_Callback(hObject, eventdata, handles)
% hObject    handle to pb_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get(handles.cb_active0,'Value')

% AFE_settings.active=[get(handles.cb_active0,'Value');get(handles.cb_active1,'Value');get(handles.cb_active2,'Value')];
% AFE_settings.active

%if the devices are powered down then if not deleted, they will trouble
if not(isempty(instrfind('Status','open')))
    fclose(instrfind('Status','open'))
    delete(instrfind)
end

% Which device is active
AFE_settings.ADS.active=get(handles.cb_active0,'Value');
% AFE_settings.ADS.active
AFE_settings.RHA.active=get(handles.cb_active1,'Value');
% AFE_settings.RHA.active
AFE_settings.DT.active=get(handles.cb_active2,'Value');
% AFE_settings.DT.active
AFE_settings.NI.active=get(handles.cb_active3,'Value'); 
% AFE_settings.NI.active


% Get devices name

AFE_settings.ADS.name=get(handles.et_name0,'String');
AFE_settings.RHA.name=get(handles.et_name1,'String');
AFE_settings.DT.name=get(handles.et_name2,'String');

dev = get(handles.pm_name3,'String');
selDev = get(handles.pm_name3,'Value');
AFE_settings.NI.name= dev(selDev);


%% Sampling frequencie 
% SR must be change to sF 
contents = cellstr(get(handles.pm_sampleRate0,'String'));
SR0=str2double(contents{get(handles.pm_sampleRate0,'Value')});

contents = cellstr(get(handles.pm_sampleRate1,'String'));
SR1=str2double(contents{get(handles.pm_sampleRate1,'Value')});

contents = cellstr(get(handles.pm_sampleRate2,'String'));
SR2=str2double(contents{get(handles.pm_sampleRate2,'Value')});

contents = cellstr(get(handles.pm_sampleRate3,'String'));
SR3=str2double(contents{get(handles.pm_sampleRate3,'Value')});

% AFE_settings.sampleRate=[SR0;SR1;SR2];
% AFE_settings.sampleRate
AFE_settings.ADS.sampleRate=SR0;
AFE_settings.RHA.sampleRate=SR1;
AFE_settings.DT.sampleRate=SR2;
AFE_settings.NI.sampleRate=SR3;

%% Number of channels
AFE_settings.ADS.channels = str2double(get(handles.et_chs0,'String'));
AFE_settings.RHA.channels = str2double(get(handles.et_chs1,'String'));
AFE_settings.DT.channels = str2double(get(handles.et_chs2,'String'));
AFE_settings.NI.channels = str2double(get(handles.et_chs3,'String'));


%%
% Communication Port

contents = cellstr(get(handles.ComPortType0,'String'));
CPT0=contents{get(handles.ComPortType0,'Value')};

contents = cellstr(get(handles.ComPortType1,'String'));
CPT1=contents{get(handles.ComPortType1,'Value')};

contents = cellstr(get(handles.ComPortType2,'String'));
CPT2=contents{get(handles.ComPortType2,'Value')};

contents = cellstr(get(handles.ComPortType3,'String'));
CPT3=contents{get(handles.ComPortType3,'Value')};

AFE_settings.ComPortType={CPT0;CPT1;CPT2;CPT3};
% AFE_settings.ComPortType

AFE_settings.ADS.ComPortType=CPT0;
AFE_settings.RHA.ComPortType=CPT1;
% AFE_settings.NI.ComPortType=CPT3;

% AFE_settings.show=[get(handles.show0,'Value');get(handles.show1,'Value');get(handles.show2,'Value')];
% AFE_settings.show

AFE_settings.ADS.show=get(handles.show0,'Value');
% AFE_settings.ADS.show
AFE_settings.RHA.show=get(handles.show1,'Value');
% AFE_settings.RHA.show
AFE_settings.DT.show=get(handles.show2,'Value');
% AFE_settings.DT.show
AFE_settings.NI.show=get(handles.show3,'Value');
% AFE_settings.NI.show

AFE_settings.prepare=get(handles.prepare,'Value');

% GUI_AFEselection(Fs,Ne,Nr,Tc,Tr,Psr,msg,EMG_AQhandle)
% cdata = recording_session(Fs,Ne,Nr,Tc,Tr,Psr,msg,EMG_AQhandle);

nM=handles.varargin{1};
nR=handles.varargin{2};
cT=handles.varargin{3};
rT=handles.varargin{4};
mov=handles.varargin{5};
hGUI_Rec=handles.varargin{6};
vreMovements = handles.varargin{7};

[cdata, sF] = RecordingSession(nM,nR,cT,rT,mov,hGUI_Rec,AFE_settings,get(handles.cb_trainVRE,'Value'),vreMovements);%Fs,Ne,Nr,Tc,Tr,Psr,msg,EMG_AQhandle);

% Fs=handles.varargin{1};
% Nr=handles.varargin{3};
% Tc=handles.varargin{4};
% Tr=handles.varargin{5};
%Moved from Recoding Session Fig
sT = (cT+rT)*nR;
save('cdata.mat','cdata','sF','sT');
close(GUI_AFEselection);
close(GUI_RecordingSession);

% close(recording_session_fig);

% close(get(hObject,'Parent'))

% --- Executes during object creation, after setting all properties.
function pb_record_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pb_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(get(hObject,'Parent'))

% --- Executes during object creation, after setting all properties.
function pb_cancel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pb_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in default.
function default_Callback(hObject, eventdata, handles)
% hObject    handle to default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function default_CreateFcn(hObject, eventdata, handles)
% hObject    handle to default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in pm_sampleRate2.
function pm_sampleRate2_Callback(hObject, eventdata, handles)
% hObject    handle to pm_sampleRate2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_sampleRate2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_sampleRate2


% --- Executes during object creation, after setting all properties.
function pm_sampleRate2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_sampleRate2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_sampleRate1.
function pm_sampleRate1_Callback(hObject, eventdata, handles)
% hObject    handle to pm_sampleRate1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_sampleRate1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_sampleRate1


% --- Executes during object creation, after setting all properties.
function pm_sampleRate1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_sampleRate1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_sampleRate0.
function pm_sampleRate0_Callback(hObject, eventdata, handles)
% hObject    handle to pm_sampleRate0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_sampleRate0 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_sampleRate0


% --- Executes during object creation, after setting all properties.
function pm_sampleRate0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_sampleRate0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in ComPortType0.
function ComPortType0_Callback(hObject, eventdata, handles)
% hObject    handle to ComPortType0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ComPortType0 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ComPortType0


% --- Executes during object creation, after setting all properties.
function ComPortType0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ComPortType0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


s=instrhwinfo('serial');
if not(isfield(s,'SerialPorts'))
    s.SerialPorts = {'Not Available'};
elseif isempty(s.SerialPorts)
    s.SerialPorts = {'Not Available'};
end
set(hObject,'String',[s.SerialPorts]);




% --- Executes on selection change in ComPortType1.
function ComPortType1_Callback(hObject, eventdata, handles)
% hObject    handle to ComPortType1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ComPortType1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ComPortType1


% --- Executes during object creation, after setting all properties.
function ComPortType1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ComPortType1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
s=instrhwinfo('serial');
if not(isfield(s,'SerialPorts'))
    s.SerialPorts = {'Not Available'};
elseif isempty(s.SerialPorts)
    s.SerialPorts = {'Not Available'};
end
set(hObject,'String',[s.SerialPorts]);


% --- Executes on selection change in tt.
function tt_Callback(hObject, eventdata, handles)
% hObject    handle to tt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tt


% --- Executes during object creation, after setting all properties.
function tt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% s=instrhwinfo('serial');
% if not(isfield(s,'SerialPorts'))
%     s.SerialPorts = {'Not Available'};
% end
% set(hObject,'String',[s.SerialPorts;{'NI'}]);
set(hObject,'String',{'NI'});
set(hObject,'Value',1)
% set(hObject,'Value',length(s.SerialPorts)+1)



function bytesSamples2_Callback(hObject, eventdata, handles)
% hObject    handle to bytesSamples2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bytesSamples2 as text
%        str2double(get(hObject,'String')) returns contents of bytesSamples2 as a double


% --- Executes during object creation, after setting all properties.
function bytesSamples2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bytesSamples2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bytesSamples1_Callback(hObject, eventdata, handles)
% hObject    handle to bytesSamples1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bytesSamples1 as text
%        str2double(get(hObject,'String')) returns contents of bytesSamples1 as a double


% --- Executes during object creation, after setting all properties.
function bytesSamples1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bytesSamples1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bytesSamples0_Callback(hObject, eventdata, handles)
% hObject    handle to bytesSamples0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bytesSamples0 as text
%        str2double(get(hObject,'String')) returns contents of bytesSamples0 as a double


% --- Executes during object creation, after setting all properties.
function bytesSamples0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bytesSamples0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_name0_Callback(hObject, eventdata, handles)
% hObject    handle to et_name0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_name0 as text
%        str2double(get(hObject,'String')) returns contents of et_name0 as a double


% --- Executes during object creation, after setting all properties.
function et_name0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_name0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_name1_Callback(hObject, eventdata, handles)
% hObject    handle to et_name1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_name1 as text
%        str2double(get(hObject,'String')) returns contents of et_name1 as a double


% --- Executes during object creation, after setting all properties.
function et_name1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_name1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pm_name3_Callback(hObject, eventdata, handles)
% hObject    handle to pm_name3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pm_name3 as text
%        str2double(get(hObject,'String')) returns contents of pm_name3 as a double


% --- Executes during object creation, after setting all properties.
function pm_name3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_name3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_active0.
function cb_active0_Callback(hObject, eventdata, handles)
% hObject    handle to cb_active0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_active0


% --- Executes on button press in cb_active1.
function cb_active1_Callback(hObject, eventdata, handles)
% hObject    handle to cb_active1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_active1


% --- Executes on button press in cb_active2.
function cb_active2_Callback(hObject, eventdata, handles)
% hObject    handle to cb_active2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_active2






% 
% set(hObject,'String',{'8000';'4000';'2000';'1000';'500'})


% --- Executes during object creation, after setting all properties.
function uipanel3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in prepare.
function prepare_Callback(hObject, eventdata, handles)
% hObject    handle to prepare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prepare


% --- Executes on button press in edit13.
function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of edit13


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_chs0_Callback(hObject, eventdata, handles)
% hObject    handle to et_chs0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_chs0 as text
%        str2double(get(hObject,'String')) returns contents of et_chs0 as a double


% --- Executes during object creation, after setting all properties.
function et_chs0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_chs0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_chs1_Callback(hObject, eventdata, handles)
% hObject    handle to et_chs1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_chs1 as text
%        str2double(get(hObject,'String')) returns contents of et_chs1 as a double


% --- Executes during object creation, after setting all properties.
function et_chs1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_chs1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_chs2_Callback(hObject, eventdata, handles)
% hObject    handle to et_chs2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_chs2 as text
%        str2double(get(hObject,'String')) returns contents of et_chs2 as a double
if str2double(get(hObject,'String')) == 8
    set(handles.pm_sampleRate2,'Value',2)
elseif str2double(get(hObject,'String')) == 6
    set(handles.pm_sampleRate2,'Value',1)    
end

% --- Executes during object creation, after setting all properties.
function et_chs2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_chs2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_trainVRE.
function cb_trainVRE_Callback(hObject, eventdata, handles)
% hObject    handle to cb_trainVRE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_trainVRE



function et_chs3_Callback(hObject, eventdata, handles)
% hObject    handle to et_chs3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_chs3 as text
%        str2double(get(hObject,'String')) returns contents of et_chs3 as a double


% --- Executes during object creation, after setting all properties.
function et_chs3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_chs3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_sampleRate3.
function pm_sampleRate3_Callback(hObject, eventdata, handles)
% hObject    handle to pm_sampleRate3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_sampleRate3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_sampleRate3


% --- Executes during object creation, after setting all properties.
function pm_sampleRate3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_sampleRate3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ComPortType3.
function ComPortType3_Callback(hObject, eventdata, handles)
% hObject    handle to ComPortType3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ComPortType3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ComPortType3


% --- Executes during object creation, after setting all properties.
function ComPortType3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ComPortType3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_name2_Callback(hObject, eventdata, handles)
% hObject    handle to et_name2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_name2 as text
%        str2double(get(hObject,'String')) returns contents of et_name2 as a double


% --- Executes during object creation, after setting all properties.
function et_name2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_name2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_active3.
function cb_active3_Callback(hObject, eventdata, handles)
% hObject    handle to cb_active3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('entered');
% Hint: get(hObject,'Value') returns toggle state of cb_active3
set(handles.cb_active3, 'Value', 0);


% --- Executes on selection change in ComPortType2.
function ComPortType2_Callback(hObject, eventdata, handles)
% hObject    handle to ComPortType2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ComPortType2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ComPortType2


% --- Executes during object creation, after setting all properties.
function ComPortType2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ComPortType2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
