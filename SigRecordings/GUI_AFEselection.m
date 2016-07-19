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
% 2013-08-23 / Morten Kristoffersen / Trimmed the interface down to one
% popup menu, reorganised the GUI_AFESelection data. 
% 2013-09-20 / Pontus Lövinger  / Added the option for ramp recording which
                        % calls the ramp recording functions
% 2014-11-10 / Enzo Mastinu / include the code for ADS1299 AFE, optimization of 
                        % ramp functions and their callings
% 2015-11-27 / Enzo Mastinu / It has been added the possibility to repeat 
                            % the same movement recording if you are not 
                            % happy with it.
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

% Last Modified by GUIDE v2.5 22-Apr-2015 15:16:20

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

global offsetDelete;
offsetDelete = get(handles.cb_offset,'Value');

% AFE_settings.active=[get(handles.cb_active0,'Value');get(handles.cb_active1,'Value');get(handles.cb_active2,'Value')];
% AFE_settings.active

%if the devices are powered down then if not deleted, they will trouble
if not(isempty(instrfind('Status','open')))
    fclose(instrfind('Status','open'))
    delete(instrfind)
end

% % Which device is active
% AFE_settings.ADS.active=get(handles.cb_active0,'Value');
% % AFE_settings.ADS.active
% AFE_settings.RHA.active=get(handles.cb_active1,'Value');
% % AFE_settings.RHA.active
% AFE_settings.NI.active=get(handles.cb_active2,'Value'); 
% % AFE_settings.NI.active


% Get devices name

% AFE_settings.ADS.name=get(handles.et_name0,'String');
% AFE_settings.RHA.name=get(handles.et_name1,'String');

dev = get(handles.pm_name,'String');
selDev = get(handles.pm_name,'Value');
AFE_settings.name = dev(selDev);
deviceName = AFE_settings.name;


%% Sampling frequency 
contents = cellstr(get(handles.pm_sampleRate, 'String'));
sF = str2double(contents{get(handles.pm_sampleRate,'Value')});

% AFE_settings.sampleRate=[SR0;SR1;SR2];
% AFE_settings.sampleRate

AFE_settings.sampleRate=sF;

%% Number of channels
AFE_settings.channels = str2double(get(handles.et_chs,'String'));
nCh = AFE_settings.channels;

%%
% Communication Port

contents = cellstr(get(handles.ComPortType,'String'));
ComPortType=contents{get(handles.ComPortType,'Value')};
AFE_settings.ComPortType=ComPortType;

if strcmp(AFE_settings.ComPortType,'COM')
    ComPortName = get(handles.ComPortName,'String');
%     AFE_settings.ComPortType=strcat(ComPortType,ComPortName);
    AFE_settings.ComPortName=strcat(ComPortType,ComPortName);
end

% AFE_settings.ComPortType

% AFE_settings.ADS.ComPortType=CPT0;
% AFE_settings.RHA.ComPortType=CPT1;
% % AFE_settings.NI.ComPortType=CPT2;

% AFE_settings.show=[get(handles.show0,'Value');get(handles.show1,'Value');get(handles.show2,'Value')];
% AFE_settings.show

% AFE_settings.ADS.show=get(handles.show0,'Value');
% % AFE_settings.ADS.show
% AFE_settings.RHA.show=get(handles.show1,'Value');
% % AFE_settings.RHA.show
% AFE_settings.NI.show=get(handles.show2,'Value');
% % AFE_settings.NI.show

AFE_settings.prepare      = get(handles.prepare,'Value');

% GUI_AFEselection(Fs,Ne,Nr,Tc,Tr,Psr,msg,EMG_AQhandle)
% cdata = recording_session(Fs,Ne,Nr,Tc,Tr,Psr,msg,EMG_AQhandle);

nM=handles.varargin{1};
nR=handles.varargin{2};
cT=handles.varargin{3};
rT=handles.varargin{4};
mov=handles.varargin{5};
hGUI_Rec=handles.varargin{6};
vreMovements = handles.varargin{7};
rampStatus = handles.varargin{8};
fast = handles.varargin{9};
if fast == 0
    movRepeatDlg = handles.varargin{10};
    useLeg = handles.varargin{11};
end
%useLeg = handles.varargin{11};

AFE_settings.recFeatures   = get(handles.cb_recFeatures,'Value');
if(AFE_settings.recFeatures)
    FeaturesRecordingSession(nM,nR,cT,rT,mov,hGUI_Rec,AFE_settings,get(handles.cb_trainVRE,'Value'),vreMovements,get(handles.cb_VRELeftHand,'Value'),rampStatus);
    close(GUI_AFEselection);
    close(GUI_RecordingSession);
    return
end

% for compatibility, delete previous temporary data
if(exist('cdata','var')) == 1
    delete(cdata);
end

if(fast)
    
    % Fast recording session
    [cdata, sF, sT] = FastRecordingSession(hGUI_Rec,AFE_settings);
    tempdata = cdata;                                                      % variable useful for offline data processing
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');
else

    % If ramp training has been selected in GUI_RecordingSession the ramp
    % parameters should be obtained and the rampRecordingSession file is run
    if rampStatus
        [rampMin, minData] = ObtainRampMin(hGUI_Rec,AFE_settings,get(handles.cb_trainVRE,'Value'));%Fs,Ne,Nr,Tc,Tr,Psr,msg,EMG_AQhandle
        [rampMax, maxData] = ObtainRampMax(nM,mov,hGUI_Rec,AFE_settings,get(handles.cb_trainVRE,'Value'),vreMovements, get(handles.cb_VRELeftHand,'Value'));%Fs,Ne,Nr,Tc,Tr,Psr,msg,EMG_AQhandle
        rampParams =  {rampMin rampMax minData maxData};
        [cdata, sF] = RecordingSession(nM,nR,cT,rT,mov,hGUI_Rec,AFE_settings,get(handles.cb_trainVRE,'Value'),vreMovements,get(handles.cb_VRELeftHand,'Value'),movRepeatDlg,useLeg,rampStatus,rampParams);%Fs,Ne,Nr,Tc,Tr,Psr,msg,EMG_AQhandle,rampParams);
    else
        [cdata, sF] = RecordingSession(nM,nR,cT,rT,mov,hGUI_Rec,AFE_settings,get(handles.cb_trainVRE,'Value'),vreMovements,get(handles.cb_VRELeftHand,'Value'),movRepeatDlg,useLeg,rampStatus);%Fs,Ne,Nr,Tc,Tr,Psr,msg,EMG_AQhandle);
    end
    % Fs=handles.varargin{1};
    % Nr=handles.varargin{3};
    % Tc=handles.varargin{4};
    % Tr=handles.varargin{5};
    %Moved from Recoding Session Fig
    
    sT = (cT+rT)*nR;
    cdata = cdata(:,:,size(cdata,3));
    tempdata = cdata;
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');
    %close(GUI_AFEselection);
    close(GUI_RecordingSession);

    % close(recording_session_fig);

    % close(get(hObject,'Parent'))
end

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


% --- Executes on selection change in pm_sampleRate.
function pm_sampleRate_Callback(hObject, eventdata, handles)
% hObject    handle to pm_sampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_sampleRate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_sampleRate


% --- Executes during object creation, after setting all properties.
function pm_sampleRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_sampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%The function below detects the available COM porst, I just leave it there
%%for now in case that we need it. 
% --- Executes on selection change in ComPortType0.
%function ComPortType0_Callback(hObject, eventdata, handles)
% hObject    handle to ComPortType0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ComPortType0 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ComPortType0


% % --- Executes during object creation, after setting all properties.
% function ComPortType0_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to ComPortType0 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% s=instrhwinfo('serial');
% if not(isfield(s,'SerialPorts'))
%     s.SerialPorts = {'Not Available'};
% elseif isempty(s.SerialPorts)
%     s.SerialPorts = {'Not Available'};
% end
% set(hObject,'String',[s.SerialPorts]);


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


function pm_name_Callback(hObject, eventdata, handles)
% hObject    handle to pm_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pm_name as text
%        str2double(get(hObject,'String')) returns contents of pm_name as a double
contents = cellstr(get(handles.pm_name,'String'));
deviceName = contents{get(handles.pm_name,'Value')};
if strcmp(deviceName,'ADS1299_DSP')
    set(handles.cb_recFeatures,'Visible', 'on');
else
    set(handles.cb_recFeatures,'Visible', 'off');
end

% --- Executes during object creation, after setting all properties.
function pm_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

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

function et_chs_Callback(hObject, eventdata, handles)
% hObject    handle to et_chs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_chs as text
%        str2double(get(hObject,'String')) returns contents of et_chs as a double

% --- Executes during object creation, after setting all properties.
function et_chs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_chs (see GCBO)
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

set(handles.cb_VRELeftHand,'Enable', 'on');

% --- Executes on selection change in ComPortType.
function ComPortType_Callback(hObject, eventdata, handles)
% hObject    handle to ComPortType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ComPortType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ComPortType

contents = cellstr(get(handles.ComPortType,'String'));
ComPortType = contents{get(handles.ComPortType,'Value')};
if strcmp(ComPortType,'COM')
    set(handles.ComPortName,'Enable', 'on');
else
    set(handles.ComPortName,'Enable', 'off');
end

% --- Executes during object creation, after setting all properties.
function ComPortType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ComPortType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_VRELeftHand.
function cb_VRELeftHand_Callback(hObject, eventdata, handles)
% hObject    handle to cb_VRELeftHand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_VRELeftHand



function ComPortName_Callback(hObject, eventdata, handles)
% hObject    handle to ComPortName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ComPortName as text
%        str2double(get(hObject,'String')) returns contents of ComPortName as a double


% --- Executes during object creation, after setting all properties.
function ComPortName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ComPortName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_offset.
function cb_offset_Callback(hObject, eventdata, handles)
% hObject    handle to cb_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_offset


% --- Executes on button press in cb_recFeatures.
function cb_recFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to cb_recFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_recFeatures
