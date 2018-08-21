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
function varargout = GUI_RecordingSessionShow(varargin)
% GUI_RECORDINGSESSIONSHOW M-file for GUI_RecordingSessionShow.fig
%      GUI_RECORDINGSESSIONSHOW, by itself, creates a new GUI_RECORDINGSESSIONSHOW or raises the existing
%      singleton*.
%
%      H = GUI_RECORDINGSESSIONSHOW returns the handle to a new GUI_RECORDINGSESSIONSHOW or the handle to
%      the existing singleton*.
%
%      GUI_RECORDINGSESSIONSHOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_RECORDINGSESSIONSHOW.M with the given input arguments.
%
%      GUI_RECORDINGSESSIONSHOW('Property','Value',...) creates a new GUI_RECORDINGSESSIONSHOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_RecordingSessionShow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_RecordingSessionShow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_RecordingSessionShow

% Last Modified by GUIDE v2.5 11-May-2016 16:25:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_RecordingSessionShow_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_RecordingSessionShow_OutputFcn, ...
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


% --- Executes just before GUI_RecordingSessionShow is made visible.
function GUI_RecordingSessionShow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_RecordingSessionShow (see VARARGIN)

backgroundImage2 = importdata('Img/BioPatRec.png');
%select the axes
axes(handles.axes2);
%place image onto the axes
image(backgroundImage2);
%remove the axis tick marks
axis off

%load the background image into Matlab
%if image is not in the same directory as the GUI files, you must use the 
%full path name of the iamge file
backgroundImage = importdata('Img/relax.jpg');
%select the axes
axes(handles.axes1);
%place image onto the axes
image(backgroundImage);
%remove the axis tick marks
axis off


% Choose default command line output for GUI_RecordingSessionShow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_RecordingSessionShow wait for user response (see UIRESUME)


% --- Outputs from this function are returned to the command line.
function varargout = GUI_RecordingSessionShow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function et_Fs_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_Fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Ne_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_Ne_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Ne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Nr_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_Nr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Nr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Tc_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_Tc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Tc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Tr_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_Tr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Tr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Psr_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_cmt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_cmt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function et_msg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_msg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function et_msg_Callback(hObject, eventdata, handles)

    movS = get(handles.et_msg,'String');
    movN = get(handles.et_msg,'Value');
    
    mov = movS(movN(1));

    if exist(['Img/' char(mov) '.JPG'],'file')
        %backgroundImage = importdata(['Img/mov' num2str(num) '.JPG']);
        backgroundImage = importdata(['Img/' char(mov) '.JPG']);
        image(backgroundImage);
        axis off
    end
  
    set(handles.pm_nM,'Value',movN);    
%    num = get(handles.et_msg,'value');
%    backgroundImage = importdata(['Img/mov' num2str(num) '.JPG']);
%    image(backgroundImage);
%    axis off


% --- Executes on button press in pb_load.
function pb_load_Callback(hObject, eventdata, handles)
    % get the EMG_AQ Handles
    %h1 = get(handles.t_mhandles,'UserData'); 
    %EMG_AQhandle = guidata(h1);
    EMG_AQhandle = get(handles.t_mhandles,'UserData');

    sF = str2double(get(handles.et_Fs,'String')); % Sampling Frequency
    nM = get(handles.pm_nM,'Value');              % number of excersices or movements
    recSession = get(handles.pm_data,'UserData');
    sT = recSession.sT;
    EMG_AQhandle.nCh = recSession.nCh;
    EMG_AQhandle.deviceName = recSession.dev;
    nCh = recSession.nCh;
    deviceName = recSession.dev;
    cdata = recSession.tdata(:,:,nM);
    if isfield(recSession,'comm')
        EMG_AQhandle.ComPortType = recSession.comm;
        ComPortType = recSession.comm;
    else
        EMG_AQhandle.ComPortType = 'NI';
        ComPortType = 'NI';
    end
    %if get(handles.pm_data,'Value') == 1
    %    cdata = recSession.tdata(:,:,nM);
    %else
    %    cdata = recSession.trdata(:,:,nM);
    %end
    DataShow(EMG_AQhandle,cdata,sF,sT);
    tempdata = cdata;
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');


% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
    close(GUI_RecordingSessionShow);


% --- Executes on selection change in pm_data.
function pm_data_Callback(hObject, eventdata, handles)
% hObject    handle to pm_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pm_data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_data


% --- Executes during object creation, after setting all properties.
function pm_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_nM.
function pm_nM_Callback(hObject, eventdata, handles)
% hObject    handle to pm_nM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pm_nM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_nM

    nM = get(handles.pm_nM,'Value');              % number of excersices or movements
    set(handles.et_msg,'Value',nM);


% --- Executes during object creation, after setting all properties.
function pm_nM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_nM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_analyze.
function pb_analyze_Callback(hObject, eventdata, handles)
% hObject    handle to pb_analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_DataAnalysis(get(handles.pm_data,'UserData'));
