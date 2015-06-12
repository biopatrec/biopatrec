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
% Compute the overal all Accuracy of the patRec algorithm
%
% ------------------------- Updates & Contributors ------------------------
% 2011-12-07 / Max Ortiz  / Created new version from EMG_AQ 
% 20xx-xx-xx / Author  / Comment on update

function varargout = GUI_TestPatRec_Mov2Mov(varargin)
%GUI_TESTPATREC_MOV2MOV M-file for GUI_TestPatRec_Mov2Mov.fig
%      GUI_TESTPATREC_MOV2MOV, by itself, creates a new GUI_TESTPATREC_MOV2MOV or raises the existing
%      singleton*.
%
%      H = GUI_TESTPATREC_MOV2MOV returns the handle to a new GUI_TESTPATREC_MOV2MOV or the handle to
%      the existing singleton*.
%
%      GUI_TESTPATREC_MOV2MOV('Property','Value',...) creates a new GUI_TESTPATREC_MOV2MOV using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to GUI_TestPatRec_Mov2Mov_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI_TESTPATREC_MOV2MOV('CALLBACK') and GUI_TESTPATREC_MOV2MOV('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI_TESTPATREC_MOV2MOV.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_TestPatRec_Mov2Mov

% Last Modified by GUIDE v2.5 26-Jul-2012 13:33:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_TestPatRec_Mov2Mov_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_TestPatRec_Mov2Mov_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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



% --- Executes just before GUI_TestPatRec_Mov2Mov is made visible.
function GUI_TestPatRec_Mov2Mov_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for GUI_TestPatRec_Mov2Mov
handles.output = hObject;
global TAC

TAC.running = 0;
TAC.ackTimes = 0;

% Logo image
backgroundImage2 = importdata('/../Img/BioPatRec.png');
%select the axes
axes(handles.axes3);
%place image onto the axes
image(backgroundImage2);
%remove the axis tick marks
axis off


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_TestPatRec_Mov2Mov wait for user response (see UIRESUME)
% uiwait(handles.figure1);
movegui(hObject,'center');

% --- Outputs from this function are returned to the command line.
function varargout = GUI_TestPatRec_Mov2Mov_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function pm_SelectAlgorithm_Callback(hObject, eventdata, handles)
% hObject    handle to pm_SelectAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pm_SelectAlgorithm as text
%        str2double(get(hObject,'String')) returns contents of pm_SelectAlgorithm as a double


% --- Executes during object creation, after setting all properties.
function pm_SelectAlgorithm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_SelectAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pm_SelectTraining_Callback(hObject, eventdata, handles)
% hObject    handle to pm_SelectTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pm_SelectTraining as text
%        str2double(get(hObject,'String')) returns contents of pm_SelectTraining as a double


% --- Executes during object creation, after setting all properties.
function pm_SelectTraining_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_SelectTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_movements.
function lb_movements_Callback(hObject, eventdata, handles)
% hObject    handle to lb_movements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_movements contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_movements

disp(get(hObject,'Value'));



% --- Executes during object creation, after setting all properties.
function lb_movements_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_movements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_accuracy_Callback(hObject, eventdata, handles)
% hObject    handle to et_accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_accuracy as text
%        str2double(get(hObject,'String')) returns contents of et_accuracy as a double


% --- Executes during object creation, after setting all properties.
function et_accuracy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_accuracy.
function lb_accuracy_Callback(hObject, eventdata, handles)
% hObject    handle to lb_accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_accuracy contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_accuracy


% --- Executes during object creation, after setting all properties.
function lb_accuracy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_RealtimePatRec.
function pb_RealtimePatRec_Callback(hObject, eventdata, handles)
% hObject    handle to pb_RealtimePatRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
%set(hObject,'Enable','off');
    % validation of patRec loaded
    if ~isfield(handles,'patRec')
        set(handles.t_msg,'String','No patRec to test');        
        set(hObject,'Enable','on');
        return
    end
    
    if isfield(handles,'pm_controlAlg')
        allControlAlg = get(handles.pm_controlAlg,'String');
        controlAlg    = char(allControlAlg(get(handles.pm_controlAlg,'Value')));
    else
        controAlg     = 'None';
    end
    handles.patRec.controlAlg = controlAlg;
        
    % Run realtime patrec
    set(handles.t_msg,'String','Real time PatRec started...');      
    drawnow;
    %Here we need to save the list of current movements to the handles
    i = 1;
    dropdown = sprintf('pm_m%d',i);    
    while(isfield(handles,dropdown))
       movIndex = get(handles.(dropdown),'Value');
       movements(i) = handles.mov(movIndex);
       i = i+1;
       dropdown = sprintf('pm_m%d',i);
    end
    handles.movList = movements;
    handles = RealtimePatRec(handles.patRec, handles);
    set(handles.t_msg,'String','Real time PatRec finished');    

    % Save the handles back
    guidata(hObject,handles);

    
set(hObject,'Enable','on');


function et_testingT_Callback(hObject, eventdata, handles)
% hObject    handle to et_testingT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_testingT as text
%        str2double(get(hObject,'String')) returns contents of et_testingT as a double


% --- Executes during object creation, after setting all properties.
function et_testingT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_testingT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_trials_Callback(hObject, eventdata, handles)
% hObject    handle to et_trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_trials as text
%        str2double(get(hObject,'String')) returns contents of et_trials as a double


% --- Executes during object creation, after setting all properties.
function et_trials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_nR_Callback(hObject, eventdata, handles)
% hObject    handle to et_nR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_nR as text
%        str2double(get(hObject,'String')) returns contents of et_nR as a double


% --- Executes during object creation, after setting all properties.
function et_nR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_nR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_timeOut_Callback(hObject, eventdata, handles)
% hObject    handle to et_timeOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_timeOut as text
%        str2double(get(hObject,'String')) returns contents of et_timeOut as a double


% --- Executes during object creation, after setting all properties.
function et_timeOut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_timeOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_motionTest.
function pb_motionTest_Callback(hObject, eventdata, handles)
% hObject    handle to pb_motionTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    patRec = handles.patRec;
    
    % validation of patRec loaded
    if isempty(patRec)
        set(handles.t_msg,'String','No patRec to test');        
        return
    end
        
    % Run motion test
    set(handles.t_msg,'String','Motion Test started...');      
    drawnow;
    MotionTest(patRec, handles);
    set(handles.t_msg,'String','Motion Test finished'); 


function et_avgProcTime_Callback(hObject, eventdata, handles)
% hObject    handle to et_avgProcTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_avgProcTime as text
%        str2double(get(hObject,'String')) returns contents of et_avgProcTime as a double


% --- Executes during object creation, after setting all properties.
function et_avgProcTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_avgProcTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pm_normSets_Callback(hObject, eventdata, handles)
% hObject    handle to pm_normSets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pm_normSets as text
%        str2double(get(hObject,'String')) returns contents of pm_normSets as a double


% --- Executes during object creation, after setting all properties.
function pm_normSets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_normSets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_RealtimePatRecDev.
function pb_RealtimePatRecDev_Callback(hObject, eventdata, handles)
% hObject    handle to pb_RealtimePatRecDev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in lb_features.
function lb_features_Callback(hObject, eventdata, handles)
% hObject    handle to lb_features (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_features contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_features


% --- Executes during object creation, after setting all properties.
function lb_features_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_features (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function m_Data_Callback(hObject, eventdata, handles)
% hObject    handle to m_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Statistics_Callback(hObject, eventdata, handles)
% hObject    handle to m_Statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Stats_CurrentD_Callback(hObject, eventdata, handles)
% hObject    handle to m_Stats_CurrentD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Stats_Group_Callback(hObject, eventdata, handles)
% hObject    handle to m_Stats_Group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Open_Callback(hObject, eventdata, handles)
% hObject    handle to m_Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('%%%%%%%%%%% Loading Data %%%%%%%%%%%%%');
    set(handles.t_msg,'String','Loading Data...');

    % Dialog box to open a file
    [file, path] = uigetfile('*.mat');
    % Check that the loaded file is a "ss" struct
    if ~isequal(file, 0)
        load([path,file]);
        if (exist('patRec','var'))        % Get patRec
            Load_patRec(patRec, 'GUI_TestPatRec');
        else
            disp('That was not a valid training matrix');
            errordlg('That was not a valid training matrix','Error');
            return;
        end
    end


% --------------------------------------------------------------------
function m_Save_patRec_Callback(hObject, eventdata, handles)
% hObject    handle to m_Save_patRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in pm_m1.
function pm_m1_Callback(hObject, eventdata, handles)
% hObject    handle to pm_m1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_m1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_m1


% --- Executes during object creation, after setting all properties.
function pm_m1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_m1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on selection change in pm_m2.
function pm_m2_Callback(hObject, eventdata, handles)
% hObject    handle to pm_m2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_m2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_m2


% --- Executes during object creation, after setting all properties.
function pm_m2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_m2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on selection change in pm_m3.
function pm_m3_Callback(hObject, eventdata, handles)
% hObject    handle to pm_m3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_m3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_m3


% --- Executes during object creation, after setting all properties.
function pm_m3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_m3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on selection change in pm_m4.
function pm_m4_Callback(hObject, eventdata, handles)
% hObject    handle to pm_m4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_m4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_m4


% --- Executes during object creation, after setting all properties.
function pm_m4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_m4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on selection change in pm_m5.
function pm_m5_Callback(hObject, eventdata, handles)
% hObject    handle to pm_m5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_m5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_m5


% --- Executes during object creation, after setting all properties.
function pm_m5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_m5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on selection change in pm_m6.
function pm_m6_Callback(hObject, eventdata, handles)
% hObject    handle to pm_m6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_m6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_m6


% --- Executes during object creation, after setting all properties.
function pm_m6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_m6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on selection change in pm_m7.
function pm_m7_Callback(hObject, eventdata, handles)
% hObject    handle to pm_m7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_m7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_m7


% --- Executes during object creation, after setting all properties.
function pm_m7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_m7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_speed7_Callback(hObject, eventdata, handles)
% hObject    handle to et_speed7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_speed7 as text
%        str2double(get(hObject,'String')) returns contents of et_speed7 as a double


% --- Executes during object creation, after setting all properties.
function et_speed7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_speed7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_m8.
function pm_m8_Callback(hObject, eventdata, handles)
% hObject    handle to pm_m8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_m8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_m8


% --- Executes during object creation, after setting all properties.
function pm_m8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_m8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_speed8_Callback(hObject, eventdata, handles)
% hObject    handle to et_speed8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_speed8 as text
%        str2double(get(hObject,'String')) returns contents of et_speed8 as a double


% --- Executes during object creation, after setting all properties.
function et_speed8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_speed8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_m9.
function pm_m9_Callback(hObject, eventdata, handles)
% hObject    handle to pm_m9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_m9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_m9


% --- Executes during object creation, after setting all properties.
function pm_m9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_m9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_speed9_Callback(hObject, eventdata, handles)
% hObject    handle to et_speed9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_speed9 as text
%        str2double(get(hObject,'String')) returns contents of et_speed9 as a double


% --- Executes during object creation, after setting all properties.
function et_speed9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_speed9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_m10.
function pm_m10_Callback(hObject, eventdata, handles)
% hObject    handle to pm_m10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_m10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_m10


% --- Executes during object creation, after setting all properties.
function pm_m10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_m10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_speed10_Callback(hObject, eventdata, handles)
% hObject    handle to et_speed10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_speed10 as text
%        str2double(get(hObject,'String')) returns contents of et_speed10 as a double


% --- Executes during object creation, after setting all properties.
function et_speed10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_speed10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_move1.
function pb_move1_Callback(hObject, eventdata, handles)
% hObject    handle to pb_move1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Disable the button
set(hObject,'Enable','off');

% Get the selected movement ID
mov = get(handles.pm_m1,'Value');
% Get the movement object
movement = handles.mov(mov);

% Get the degrees to move
movDeg = str2double(get(handles.et_speed1,'String'));


%Check whether to use VRE
if isfield(handles,'vre_Com')
    if strcmp(handles.vre_Com.Status,'open')
        global TAC
        %Calculate dof, since every 2nd value indicates which dof. (works for
        %now)
        %Moves the VRE some distance.
        if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
            %TAC is complete.
           disp('TAC Complete!');
        end
    end
end
if get(handles.cb_motorCoupling,'Value')
    % Get the communication obj
    com = handles.com;
    motors = handles.motors;
    %Activate the motor direction for a short moment.
    [motors,movement] = MoveMotor(com, movement, movDeg, motors);
    
    handles.mov(mov) = movement;
    handles.motors = motors;
    guidata(hObject,handles);
end
%Enable the button
set(hObject,'Enable','on');

% --- Executes on button press in pb_move2.
function pb_move2_Callback(hObject, eventdata, handles)
% hObject    handle to pb_move2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Disable the button
set(hObject,'Enable','off');

% Get the selected movement ID
mov = get(handles.pm_m2,'Value');
% Get the movement object
movement = handles.mov(mov);

%Get speed (in percentage) from the corresponding textedit
movDeg = str2double(get(handles.et_speed2,'String'));

%Check whether to use VRE
if isfield(handles,'vre_Com')
    if strcmp(handles.vre_Com.Status,'open')
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
    end
    end
end
if get(handles.cb_motorCoupling,'Value')
    % Get the communication obj
    com = handles.com;
    motors = handles.motors;
    %Activate the motor direction for a short moment.
    [motors,movement] = MoveMotor(com, movement, movDeg, motors);
    
    handles.mov(mov) = movement;
    handles.motors = motors;
    guidata(hObject,handles);
end
%Enable the button
set(hObject,'Enable','on');

% --- Executes on button press in pb_move3.
function pb_move3_Callback(hObject, eventdata, handles)
% hObject    handle to pb_move3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Disable the button
set(hObject,'Enable','off');

% Get the selected movement ID
mov = get(handles.pm_m3,'Value');
% Get the movement object
movement = handles.mov(mov);

%Get speed (in percentage) from the corresponding textedit
movDeg = str2double(get(handles.et_speed3,'String'));

%Check whether to use VRE
if isfield(handles,'vre_Com')
    if strcmp(handles.vre_Com.Status,'open')
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
    end
    end
end
if get(handles.cb_motorCoupling,'Value')
    % Get the communication obj
    com = handles.com;
    motors = handles.motors;
    %Activate the motor direction for a short moment.
    [motors,movement] = MoveMotor(com, movement, movDeg, motors);
    
    handles.mov(mov) = movement;
    handles.motors = motors;
    guidata(hObject,handles);
end
%Enable the button
set(hObject,'Enable','on');

% --- Executes on button press in pb_move4.
function pb_move4_Callback(hObject, eventdata, handles)
% hObject    handle to pb_move4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Disable the button
set(hObject,'Enable','off');

% Get the selected movement ID
mov = get(handles.pm_m4,'Value');
% Get the movement object
movement = handles.mov(mov);

%Get speed (in percentage) from the corresponding textedit
movDeg = str2double(get(handles.et_speed4,'String'));

%Check whether to use VRE
if isfield(handles,'vre_Com')
    if strcmp(handles.vre_Com.Status,'open')
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
    end
    end
end
if get(handles.cb_motorCoupling,'Value')
    % Get the communication obj
    com = handles.com;
    motors = handles.motors;
    %Activate the motor direction for a short moment.
    [motors,movement] = MoveMotor(com, movement, movDeg, motors);
    
    handles.mov(mov) = movement;
    handles.motors = motors;
    guidata(hObject,handles);
end
%Enable the button
set(hObject,'Enable','on');

% --- Executes on button press in pb_move5.
function pb_move5_Callback(hObject, eventdata, handles)
% hObject    handle to pb_move5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Disable the button
set(hObject,'Enable','off');


% Get the selected movement ID
mov = get(handles.pm_m5,'Value');
% Get the movement object
movement = handles.mov(mov);

%Get speed (in percentage) from the corresponding textedit
movDeg = str2double(get(handles.et_speed5,'String'));

%Check whether to use VRE
if isfield(handles,'vre_Com')
    if strcmp(handles.vre_Com.Status,'open')
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
    end
    end
end
if get(handles.cb_motorCoupling,'Value')
    % Get the communication obj
    com = handles.com;
    motors = handles.motors;
    %Activate the motor direction for a short moment.
    [motors,movement] = MoveMotor(com, movement, movDeg, motors);
    
    handles.mov(mov) = movement;
    handles.motors = motors;
    guidata(hObject,handles);
end
%Enable the button
set(hObject,'Enable','on');

% --- Executes on button press in pb_move6.
function pb_move6_Callback(hObject, eventdata, handles)
% hObject    handle to pb_move6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Disable the button
set(hObject,'Enable','off');


% Get the selected movement ID
mov = get(handles.pm_m6,'Value');
% Get the movement object
movement = handles.mov(mov);

%Get speed (in percentage) from the corresponding textedit
movDeg = str2double(get(handles.et_speed6,'String'));

%Check whether to use VRE
if isfield(handles,'vre_Com')
    if strcmp(handles.vre_Com.Status,'open')
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
    end
    end
end
if get(handles.cb_motorCoupling,'Value')
    % Get the communication obj
    com = handles.com;
    motors = handles.motors;
    %Activate the motor direction for a short moment.
    [motors,movement] = MoveMotor(com, movement, movDeg, motors);
    
    handles.mov(mov) = movement;
    handles.motors = motors;
    guidata(hObject,handles);
end
%Enable the button
set(hObject,'Enable','on');

% --- Executes on button press in pb_move10.
function pb_move10_Callback(hObject, eventdata, handles)
% hObject    handle to pb_move10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Disable the button
set(hObject,'Enable','off');


% Get the selected movement ID
mov = get(handles.pm_m10,'Value');
% Get the movement object
movement = handles.mov(mov);

%Get speed (in percentage) from the corresponding textedit
movDeg = str2double(get(handles.et_speed10,'String'));

%Check whether to use VRE
if isfield(handles,'vre_Com')
    if strcmp(handles.vre_Com.Status,'open')
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
    end
    end
end
if get(handles.cb_motorCoupling,'Value')
    % Get the communication obj
    com = handles.com;
    motors = handles.motors;
    %Activate the motor direction for a short moment.
    [motors,movement] = MoveMotor(com, movement, movDeg, motors);
    
    handles.mov(mov) = movement;
    handles.motors = motors;
    guidata(hObject,handles);
end
%Enable the button
set(hObject,'Enable','on');

% --- Executes on button press in pb_move9.
function pb_move9_Callback(hObject, eventdata, handles)
% hObject    handle to pb_move9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Disable the button
set(hObject,'Enable','off');


% Get the selected movement ID
mov = get(handles.pm_m9,'Value');
% Get the movement object
movement = handles.mov(mov);

%Get speed (in percentage) from the corresponding textedit
movDeg = str2double(get(handles.et_speed9,'String'));

%Check whether to use VRE
if isfield(handles,'vre_Com')
    if strcmp(handles.vre_Com.Status,'open')
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
    end
    end
end
if get(handles.cb_motorCoupling,'Value')
    % Get the communication obj
    com = handles.com;
    motors = handles.motors;
    %Activate the motor direction for a short moment.
    [motors,movement] = MoveMotor(com, movement, movDeg, motors);
    
    handles.mov(mov) = movement;
    handles.motors = motors;
    guidata(hObject,handles);
end
%Enable the button
set(hObject,'Enable','on');

% --- Executes on button press in pb_move8.
function pb_move8_Callback(hObject, eventdata, handles)
% hObject    handle to pb_move8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Disable the button
set(hObject,'Enable','off');


% Get the selected movement ID
mov = get(handles.pm_m8,'Value');
% Get the movement object
movement = handles.mov(mov);

%Get speed (in percentage) from the corresponding textedit
movDeg = str2double(get(handles.et_speed8,'String'));

%Check whether to use VRE
if isfield(handles,'vre_Com')
    if strcmp(handles.vre_Com.Status,'open')
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
    end
    end
end
if get(handles.cb_motorCoupling,'Value')
    % Get the communication obj
    com = handles.com;
    motors = handles.motors;
    %Activate the motor direction for a short moment.
    [motors,movement] = MoveMotor(com, movement, movDeg, motors);
    
    handles.mov(mov) = movement;
    handles.motors = motors;
    guidata(hObject,handles);
end
%Enable the button
set(hObject,'Enable','on');

% --- Executes on button press in pb_move7.
function pb_move7_Callback(hObject, eventdata, handles)
% hObject    handle to pb_move7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Disable the button
set(hObject,'Enable','off');


% Get the selected movement ID
mov = get(handles.pm_m7,'Value');
% Get the movement object
movement = handles.mov(mov);

%Get speed (in percentage) from the corresponding textedit
movDeg = str2double(get(handles.et_speed7,'String'));

%Check whether to use VRE
if isfield(handles,'vre_Com')
    if strcmp(handles.vre_Com.Status,'open')
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
    end
    end
end
if get(handles.cb_motorCoupling,'Value')
    % Get the communication obj
    com = handles.com;
    motors = handles.motors;
    %Activate the motor direction for a short moment.
    [motors,movement] = MoveMotor(com, movement, movDeg, motors);
    
    handles.mov(mov) = movement;
    handles.motors = motors;
    guidata(hObject,handles);
end
%Enable the button
set(hObject,'Enable','on');

% --- Executes on button press in pb_connect.
function pb_connect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
compath = get(handles.et_connect,'String');
handles.com = Connect_ALC(compath);
%handles.com = MasterModuleComm(compath);
if TestConnectionALC(handles.com)==1; %Write S to stop program
    set(handles.t_msg,'String','Connection established');
    guidata(hObject,handles);
else
    set(handles.t_msg,'String','Wrong connection');
    fclose(handles.com.io);
end

set(handles.pb_testConnection,'Enable','on');
set(handles.pb_disconnect,'Enable','on');

function et_connect_Callback(hObject, eventdata, handles)
% hObject    handle to et_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_connect as text
%        str2double(get(hObject,'String')) returns contents of et_connect as a double


% --- Executes during object creation, after setting all properties.
function et_connect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_disconnect.
function pb_disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fclose(handles.com.io);
set(handles.t_msg,'String','Disconnected');
set(handles.pb_testConnection,'Enable','off');
set(handles.pb_disconnect,'Enable','off');

% --- Executes on button press in pb_testConnection.
function pb_testConnection_Callback(hObject, eventdata, handles)
% hObject    handle to pb_testConnection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.t_msg,'String','Testing connection...');
if TestConnectionALC(handles.com)==1; %Write S to stop program
    set(handles.t_msg,'String','Connection established');
    guidata(hObject,handles);
else
    set(handles.t_msg,'String','Wrong connection');
    fclose(handles.com.io);
end



function et_length1_Callback(hObject, eventdata, handles)
% hObject    handle to et_length1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_length1 as text
%        str2double(get(hObject,'String')) returns contents of et_length1 as a double


% --- Executes during object creation, after setting all properties.
function et_length1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_length1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_length2_Callback(hObject, eventdata, handles)
% hObject    handle to et_length2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_length2 as text
%        str2double(get(hObject,'String')) returns contents of et_length2 as a double


% --- Executes during object creation, after setting all properties.
function et_length2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_length2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_length3_Callback(hObject, eventdata, handles)
% hObject    handle to et_length3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_length3 as text
%        str2double(get(hObject,'String')) returns contents of et_length3 as a double


% --- Executes during object creation, after setting all properties.
function et_length3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_length3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_length4_Callback(hObject, eventdata, handles)
% hObject    handle to et_length4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_length4 as text
%        str2double(get(hObject,'String')) returns contents of et_length4 as a double


% --- Executes during object creation, after setting all properties.
function et_length4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_length4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_length6_Callback(hObject, eventdata, handles)
% hObject    handle to et_length6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_length6 as text
%        str2double(get(hObject,'String')) returns contents of et_length6 as a double


% --- Executes during object creation, after setting all properties.
function et_length6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_length6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_length5_Callback(hObject, eventdata, handles)
% hObject    handle to et_length5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_length5 as text
%        str2double(get(hObject,'String')) returns contents of et_length5 as a double


% --- Executes during object creation, after setting all properties.
function et_length5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_length5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_length7_Callback(hObject, eventdata, handles)
% hObject    handle to et_length7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_length7 as text
%        str2double(get(hObject,'String')) returns contents of et_length7 as a double


% --- Executes during object creation, after setting all properties.
function et_length7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_length7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_length8_Callback(hObject, eventdata, handles)
% hObject    handle to et_length8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_length8 as text
%        str2double(get(hObject,'String')) returns contents of et_length8 as a double


% --- Executes during object creation, after setting all properties.
function et_length8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_length8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_length9_Callback(hObject, eventdata, handles)
% hObject    handle to et_length9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_length9 as text
%        str2double(get(hObject,'String')) returns contents of et_length9 as a double


% --- Executes during object creation, after setting all properties.
function et_length9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_length9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_length10_Callback(hObject, eventdata, handles)
% hObject    handle to et_length10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_length10 as text
%        str2double(get(hObject,'String')) returns contents of et_length10 as a double


% --- Executes during object creation, after setting all properties.
function et_length10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_length10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_motorCoupling.
function cb_motorCoupling_Callback(hObject, eventdata, handles)
% hObject    handle to cb_motorCoupling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_motorCoupling


% --- Executes on button press in pb_socketConnect.
function pb_socketConnect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_socketConnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 set(handles.pb_socketConnect,'Enable','off');
 set(handles.pb_startTAC,'Enable','on');
 set(handles.cb_motorCoupling,'Value',0);
 % Dialog box to open a file
%[file, path] = uigetfile('*.exe');
% Check that the loaded file is a "ss" struct
%if ~isequal(file, 0)
%    startString = sprintf('start /D%s %s',path,file);
%    disp(startString);
%    [a,b] = system(startString);
%end

% This starts the VRE-environment. Add support for different paths?
open('Virtual Reality.exe');

%Retrieves specified port.
port = str2double(get(handles.et_port,'String'));

set(handles.t_msg,'String','Waiting for client connection.');
guidata(hObject,handles);

obj = tcpip('127.0.0.1',port,'NetworkRole','server');

fopen(obj);
set(handles.t_msg,'String',sprintf('Server established on port %d.',port));
handles.vre_Com = obj;
guidata(hObject,handles);

set(handles.pb_socketDisconnect,'Enable','on');
set(handles.pb_Camera,'Enable','on');

% --- Executes during object creation, after setting all properties.
function et_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pb_socketDisconnect.
function pb_socketDisconnect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_socketDisconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pb_socketDisconnect,'Enable','off');
set(handles.pb_Camera,'Enable','off');
obj = handles.vre_Com;
fclose(obj);
set(handles.t_msg,'String','Server disconnected.');
handles.vre_Com = obj;
 set(handles.pb_socketConnect,'Enable','on');


function et_port_Callback(hObject, eventdata, handles)
% hObject    handle to et_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_port as text
%        str2double(get(hObject,'String')) returns contents of et_port as a double


% --- Executes on button press in pb_startTAC.
function pb_startTAC_Callback(hObject, eventdata, handles)
% hObject    handle to pb_startTAC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if isfield(handles,'pm_controlAlg')
    allControlAlg = get(handles.pm_controlAlg,'String');
    controlAlg    = char(allControlAlg(get(handles.pm_controlAlg,'Value')));
else
    controlAlg     = 'None';
end
handles.patRec.controlAlg = controlAlg;

GUI = eval('GUI_TacTest');
TacHandles = guidata(GUI);

%Here we need to save the list of current movements to the handles
i = 1;
dropdown = sprintf('pm_m%d',i);    
while(isfield(handles,dropdown))
   movIndex = get(handles.(dropdown),'Value');
   movements(i) = handles.mov(movIndex);
   i = i+1;
   dropdown = sprintf('pm_m%d',i);
end
handles.movList = movements;

TacHandles.patRecHandles = handles;
guidata(GUI,TacHandles);


function callback(object, event, handles)
global TAC

if isfield(TAC,'ackTimes')
    if TAC.ackTimes > 0
        if ~MoveTAC(handles)
           stop(object); 
        else
            %This means that actions has been performed successfully. But
            %there are more actions to come.
            
        end
        TAC.running = 0;
        TAC.ackTimes = 0;
    end
    set(handles.t_timeTAC,'String',sprintf('Time:%0.3f s',toc));
    set(handles.pb_startTAC,'String','Start');
end

% Hint: get(hObject,'Value') returns toggle state of cb_showTAC


% --- Executes on button press in cb_moveTAC.
function cb_moveTAC_Callback(hObject, eventdata, handles)
% hObject    handle to cb_moveTAC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_moveTAC


% --- Executes on button press in pb_Camera.
function pb_Camera_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Camera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ( get(handles.pb_Camera,'String') == 'Camera 2')
    cam = 1;
    set(handles.pb_Camera,'String','Camera 1');
else
    cam = 0;
    set(handles.pb_Camera,'String','Camera 2');
end

if isfield(handles,'vre_Com')
    obj = handles.vre_Com;
    fwrite(obj,sprintf('%c%c%c%c','c',char(4),char(cam),char(0)));
    fread(obj,1)
end


% --- Executes on selection change in pm_controlAlg.
function pm_controlAlg_Callback(hObject, eventdata, handles)
% hObject    handle to pm_controlAlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_controlAlg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_controlAlg


% --- Executes during object creation, after setting all properties.
function pm_controlAlg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_controlAlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
