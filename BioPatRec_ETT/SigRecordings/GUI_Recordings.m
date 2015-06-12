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
% 20xx-xx-xx / Max Ortiz / Creation
% 20xx-xx-xx / Author  / Comment on update

function varargout = GUI_Recordings(varargin)
% GUI_Recordings M-file for GUI_Recordings.fig
%      GUI_Recordings, by itself, creates a new GUI_Recordings or raises the existing
%      singleton*.
%
%      H = GUI_Recordings returns the handle to a new GUI_Recordings or the handle to
%      the existing singleton*.
%
%      GUI_Recordings('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_Recordings.M with the given input arguments.
%
%      GUI_Recordings('Property','Value',...) creates a new GUI_Recordings or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Recordings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Recordings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Recordings

% Last Modified by GUIDE v2.5 03-Jun-2012 19:04:56
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Recordings_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Recordings_OutputFcn, ...
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


% --- Executes just before GUI_Recordings is made visible.
function GUI_Recordings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Recordings (see VARARGIN)

%load the background image into Matlab
backgroundImage2 = importdata('/../Img/BioPatRec.png');
%select the axes
axes(handles.a_biopatrec);
%place image onto the axes
image(backgroundImage2);
%remove the axis tick marks
axis off

fID = LoadFeaturesIDs;
set(handles.pm_features,'String',['Select feature:'; fID]);

% Choose default command line output for GUI_Recordings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Recordings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Recordings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_StartRecording.
function pb_StartRecording_Callback(hObject, eventdata, handles)

    sF = str2double(get(handles.et_Fs,'String'));
    sT = str2double(get(handles.et_Ts,'String'));
    pT = str2double(get(handles.et_Tp,'String'));

    % Get chAI (String identifying each channel
    % the number of channels to record is selected automatically from the graphs
    sCh(1) = get(handles.cb_ch0,'Value');
    sCh(2) = get(handles.cb_ch1,'Value');
    sCh(3) = get(handles.cb_ch2,'Value');
    sCh(4) = get(handles.cb_ch3,'Value');
    sCh(5) = get(handles.cb_ch4,'Value');
    sCh(6) = get(handles.cb_ch5,'Value');
    sCh(7) = get(handles.cb_ch6,'Value');
    sCh(8) = get(handles.cb_ch7,'Value');

    % Legacy routines
    %[ai,chp] = Init_NI_AI(handles,sF,sT,8); & DAQ using legacy
    %cdata = NI_DataShow(handles,ai,chp,sF,sT,pT);

    cdata = DAQShow_SBI(handles,sCh,sF,sT,pT);

    save('cdata.mat','cdata','sF','sT');


function et_Fs_Callback(hObject, eventdata, handles)
% hObject    handle to et_Fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of et_Fs as text
%        str2double(get(hObject,'String')) returns contents of et_Fs as a double

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



function et_Ts_Callback(hObject, eventdata, handles)
% hObject    handle to et_Ts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_Ts as text
%        str2double(get(hObject,'String')) returns contents of et_Ts as a double
input = str2double(get(hObject,'String'));
if (isempty(input))
     set(hObject,'String','0')
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_Ts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Ts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Tp_Callback(hObject, eventdata, handles)
% hObject    handle to et_Tp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_Tp as text
%        str2double(get(hObject,'String')) returns contents of et_Tp as a double
input = str2double(get(hObject,'String'));
if (isempty(input))
     set(hObject,'String','0')
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_Tp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Tp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_initai.
function pb_initai_Callback(hObject, eventdata, handles)
% hObject    handle to pb_initai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get user input from GUI


% --- Executes on button press in cb_filter50hz.
function cb_filter50hz_Callback(hObject, eventdata, handles)
% hObject    handle to cb_filter50hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_filter50hz


% --- Executes on button press in cb_filterBP.
function cb_filterBP_Callback(hObject, eventdata, handles)
% hObject    handle to cb_filterBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_filterBP


% --- Executes on button press in cb_filter80Hz.
function cb_filter80Hz_Callback(hObject, eventdata, handles)
% hObject    handle to cb_filter80Hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_filter80Hz


% --- Executes on button press in cb_ch0.
function cb_ch0_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch0


% --- Executes on button press in cb_ch1.
function cb_ch1_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch1


% --- Executes on button press in cb_ch2.
function cb_ch2_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch2


% --- Executes on button press in cb_ch3.
function cb_ch3_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch3



function et_if0_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end

    xmax = str2double(get(handles.et_ff0,'String'));
    set(handles.a_f0,'XLim',[input xmax]);
    set(handles.a_f1,'XLim',[input xmax]);
    set(handles.a_f2,'XLim',[input xmax]);
    set(handles.a_f3,'XLim',[input xmax]);

    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_if0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_if0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_ff0_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end

    xmin = str2double(get(handles.et_if0,'String'));
    set(handles.a_f0,'XLim',[xmin input]);
    set(handles.a_f1,'XLim',[xmin input]);
    set(handles.a_f2,'XLim',[xmin input]);
    set(handles.a_f3,'XLim',[xmin input]);

    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_ff0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_ff0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_n_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_fc1_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_fc1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_fc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function et_fc2_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_fc2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_fc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in pb_ApplyButter.
function pb_ApplyButter_Callback(hObject, eventdata, handles)
    % Get parameters
    N = str2double(get(handles.et_n,'String'));
    cF1 = str2double(get(handles.et_fc1,'String'));
    cF2 = str2double(get(handles.et_fc2,'String'));
    % Load matrix
    load('cdata.mat');
    cdata = ApplyButterFilter(sF, N, cF1, cF2, cdata);
    DataShow(handles,cdata,sF,sT);
    save('cdata.mat','cdata','sF','sT');


function et_it0_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end

    xmax = str2double(get(handles.et_ft0,'String'));
    set(handles.a_t0,'XLim',[input xmax]);
    set(handles.a_t1,'XLim',[input xmax]);
    set(handles.a_t2,'XLim',[input xmax]);
    set(handles.a_t3,'XLim',[input xmax]);
    set(handles.a_t4,'XLim',[input xmax]);
    set(handles.a_t5,'XLim',[input xmax]);
    set(handles.a_t6,'XLim',[input xmax]);
    set(handles.a_t7,'XLim',[input xmax]);
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_it0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_it0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_ft0_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end

    xmin = str2double(get(handles.et_it0,'String'));
    set(handles.a_t0,'XLim',[xmin input]);
    set(handles.a_t1,'XLim',[xmin input]);
    set(handles.a_t2,'XLim',[xmin input]);
    set(handles.a_t3,'XLim',[xmin input]);
    set(handles.a_t4,'XLim',[xmin input]);
    set(handles.a_t5,'XLim',[xmin input]);
    set(handles.a_t6,'XLim',[xmin input]);
    set(handles.a_t7,'XLim',[xmin input]);
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_ft0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_ft0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function m_file_Callback(hObject, eventdata, handles)
% hObject    handle to m_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_load_Callback(hObject, eventdata, handles)
    t_load_ClickedCallback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function t_load_ClickedCallback(hObject, eventdata, handles)
% Callback function run when the Open menu item is selected
ss = [];
[file, path] = uigetfile('*.mat');
    if ~isequal(file, 0)
        load([path,file]);
        if(exist('sF','var')) == 1              % Load current data
            DataShow(handles,cdata,sF,sT);
            save('cdata.mat','cdata','sF','sT');
        elseif exist('recSession','var') || ... % Load session
               exist('ss','var')                  
            df = GUI_RecordingSessionShow();
            dfdata = guidata(df);
            if ~isempty(ss)
                recSession = Compatibility_recSession(ss);
            end
            set(dfdata.et_Fs,'String',num2str(recSession.sF));
            set(dfdata.et_Ne,'String',num2str(recSession.nM));
            set(dfdata.et_Nr,'String',num2str(recSession.nR));
            set(dfdata.et_Tc,'String',num2str(recSession.cT));
            set(dfdata.et_Tr,'String',num2str(recSession.rT));
            set(dfdata.et_msg,'String',recSession.mov);
            sNe = 1:recSession.nM;
            set(dfdata.pm_Ne,'String',num2str(sNe'));
            set(dfdata.pm_data,'UserData',recSession); % Save Struct in user data
            set(dfdata.t_mhandles,'UserData',handles); % Save this GUI handles
            if isfield(recSession,'cmt')
                set(dfdata.et_cmt,'String',recSession.cmt);
            else
                set(dfdata.et_cmt,'String','No Comment');
            end
            if isfield(recSession,'dev')
                set(dfdata.t_dev,'String',recSession.dev);
            else
                set(dfdata.t_dev,'String','Unknown');
            end
        end
    end


% --------------------------------------------------------------------
function t_save_ClickedCallback(hObject, eventdata, handles)    
% Callback function run when the Save menu item is selected
    [filename, pathname] = uiputfile({'*.mat','MAT-files (*.mat)'},'Save as', 'Untitled.mat');
    copyfile('cdata.mat',[pathname,filename],'f');


% --------------------------------------------------------------------
function m_record_Callback(hObject, eventdata, handles)
% hObject    handle to m_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Rstandardsession_Callback(hObject, eventdata, handles)
%Function that calls the standard recording session
    Fs = 10000; % Sampling Frequency
    Ne = 4;     % number of excersices or movements
    Nr = 10;    % number of excersice repetition
    Tc = 2;     % time that the contractions should last
    Tr = 3;     % relaxing time
    Psr = .5;   % Percentage of the escersice time to be consider for training
    msg = {'Open   Hand';
           'Close  Hand';
           'Flex   Hand';
           'Extend Hand'};
           %'Pronation  ';
           %'Supination '};

    cdata = recording_session(Fs,Ne,Nr,Tc,Tr,Psr,msg,handles);
    Ts = (Tc+Tr)*Nr;
    save('cdata.mat','cdata','Fs','Ts');


% --------------------------------------------------------------------
function m_Recordoneshot_Callback(hObject, eventdata, handles)
    pb_StartRecording_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function m_Rcustomizedsession_Callback(hObject, eventdata, handles)
    %Call the figure recording_Session_fig and pass this figure handles
    GUI_RecordingSession;


% --------------------------------------------------------------------
function m_filters_Callback(hObject, eventdata, handles)
% hObject    handle to m_filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Fcustomized_Callback(hObject, eventdata, handles)
% hObject    handle to m_Fcustomized (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Fbandstop_Callback(hObject, eventdata, handles)
% hObject    handle to m_Fbandstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Fplh_Callback(hObject, eventdata, handles)
    load('cdata.mat');
    cdata = BSbutterPLHarmonics(sF,cdata);
    data_show(handles,cdata,sF,sT);
    save('cdata.mat','cdata','sF','sT');


% --------------------------------------------------------------------
function m_FBSbutter_Callback(hObject, eventdata, handles)
% hObject    handle to m_FBSbutter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Pattern_Recognition_Callback(hObject, eventdata, handles)
    pattern_recognition_fig();

% --------------------------------------------------------------------
function m_PR_train_ANN_Callback(hObject, eventdata, handles)
% hObject    handle to m_PR_train_ANN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Control_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function m_signalanalysis_Callback(hObject, eventdata, handles)
    signalchrs_fig();


% --------------------------------------------------------------------
function m_onemotorTP_Callback(hObject, eventdata, handles)
    one_motro_test_panel_fig();


% --- Executes on button press in cb_ch4.
function cb_ch4_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch4


% --- Executes on button press in cb_ch5.
function cb_ch5_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch5


% --- Executes on button press in cb_ch6.
function cb_ch6_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch6


% --- Executes on button press in cb_ch7.
function cb_ch7_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch7


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_spatialFilterDDF_Callback(hObject, eventdata, handles)
% hObject    handle to m_spatialFilterDDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load('cdata.mat');
    cdata = SpatialFilterDDF(cdata);
    data_show(handles,cdata,sF,sT);
    save('cdata.mat','cdata','sF','sT');


% --------------------------------------------------------------------
function m_spatialFilterSDF_Callback(hObject, eventdata, handles)
% hObject    handle to m_spatialFilterSDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load('cdata.mat');
    cdata = SpatialFilterSDF(cdata);
    data_show(handles,cdata,sF,sT);
    save('cdata.mat','cdata','sF','sT');


% --------------------------------------------------------------------
function m_spatialFilterDDFAbs_Callback(hObject, eventdata, handles)
% hObject    handle to m_spatialFilterDDFAbs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load('cdata.mat');
    cdata = SpatialFilterDDFAbs(cdata);    
    data_show(handles,cdata,sF,sT);
    save('cdata.mat','cdata','sF','sT');


% --- Executes on selection change in pm_features.
function pm_features_Callback(hObject, eventdata, handles)
% hObject    handle to pm_features (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_features contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_features


% --- Executes during object creation, after setting all properties.
function pm_features_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_features (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_extract.
function pb_extract_Callback(hObject, eventdata, handles)
% hObject    handle to pb_extract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    allF = get(handles.pm_features,'String');
    fID  = char(allF(get(handles.pm_features,'Value')));    

    load('cdata.mat');
    cdata = ExtractSigFeature(cdata,sF,fID);
    DataShow(handles,cdata,sF,sT);
    save('cdata.mat','cdata','sF','sT');
