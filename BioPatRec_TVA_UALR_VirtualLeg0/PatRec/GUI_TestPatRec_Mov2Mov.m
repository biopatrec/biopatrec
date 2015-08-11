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
% 2012-10-05 / Joel Falk-Dahlin / Edited pm_controlAlg_CreateFcn to read
%                                 from ValidControlAlgs.txt to give an up
%                                 to date list of control algorithms.
%
%                                 Changed pm_controlAlg_Callback to perform
%                                 the initialization of selected controlAlg
%
%                                 Added pb_controlOptions that opens
%                                 GUI_ControlParameters for quick access to
%                                 controlAlg parameters.
%
%                                 Commented out the setting of
%                                 patRec.controlAlg in
%                                 pb_RealtimePatRec_Callback, pb_startTAC_Callback
%                                 since it is already set upon initialization when
%                                 selecting from pm_controlAlg
%
% 2012-10-05 / Joel Falk-Dahlin / Changed handles when calling GUI_TacTest
%                                 to be able to update from and to mainGUI while still using GUI_TacTest
%
% 2012-11-06 / Joel Falk-Dahlin / Moved all proportional control variables
%                                 to patRec structure so they can be saved
%                                 between trials.
%
% 2012-11-23 / Joel Falk-Dahlin / Moved all speeds from handles to the
%                                 patRec struct. Changed behavior of all
%                                 speed text boxes
%
% 2015-03-12 / Taimoor Afzal    / Added virtual leg
%
% 2015-xx-xx / Author  / Comment on update

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

% Last Modified by GUIDE v2.5 06-Sep-2014 10:24:59

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

% Check if any inputs is made when calling the GUI
if ~isempty(varargin)
    % Check if varargin{1} is a patRec
    if isfield(varargin{1},'topology')
        
        patRec = varargin{1};
        
        for i = 1:10
            textBox = ['et_speed',num2str(i)];
            if i <= length(patRec.control.maxDegPerMov)
                set(handles.(textBox),'String',patRec.control.maxDegPerMov(i));
            else
                set(handles.(textBox),'String','N/A');
            end
        end
    else
        
        for i = 1:10
            textBox = ['et_speed',num2str(i)];
            set(handles.(textBox),'String','N/A');
        end
        
    end
end

% Logo image
backgroundImage2 = importdata('/../Img/BioPatRec.png');
%select the axes
axes(handles.axes3);
%place image onto the axes
image(backgroundImage2);
%remove the axis tick marks
axis off

% Set the proportional control to be off at start up
handles.propControl = false;

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
    
%     if isfield(handles,'pm_controlAlg')
%         allControlAlg = get(handles.pm_controlAlg,'String');
%         controlAlg    = char(allControlAlg(get(handles.pm_controlAlg,'Value')));
%     else
%         controAlg     = 'None';
%     end
%     handles.patRec.controlAlg = controlAlg;

    % Run realtime patrec
    set(handles.t_msg,'String','Real time PatRec started...');      
    drawnow;
    
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
movIndex = get(hObject,'Value');
handles.movList(1) = handles.mov(movIndex);
guidata(hObject,handles);

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
if length( handles.patRec.control.maxDegPerMov ) >= 1
    handles.patRec.control.maxDegPerMov(1) = str2double(get(hObject,'String'));
else
    set(hObject,'String','N/A')
end
guidata(hObject,handles);

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
movIndex = get(hObject,'Value');
handles.movList(2) = handles.mov(movIndex);
guidata(hObject,handles);

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
if length( handles.patRec.control.maxDegPerMov ) >= 2
    handles.patRec.control.maxDegPerMov(2) = str2double(get(hObject,'String'));
else
    set(hObject,'String','N/A')
end
guidata(hObject,handles);

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
movIndex = get(hObject,'Value');
handles.movList(3) = handles.mov(movIndex);
guidata(hObject,handles);

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
if length( handles.patRec.control.maxDegPerMov ) >= 3
    handles.patRec.control.maxDegPerMov(3) = str2double(get(hObject,'String'));
else
    set(hObject,'String','N/A')
end
guidata(hObject,handles);

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
movIndex = get(hObject,'Value');
handles.movList(4) = handles.mov(movIndex);
guidata(hObject,handles);
handles.mov(1)
handles.mov(17)

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
if length( handles.patRec.control.maxDegPerMov ) >= 4
    handles.patRec.control.maxDegPerMov(4) = str2double(get(hObject,'String'));
else
    set(hObject,'String','N/A')
end
guidata(hObject,handles);

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
movIndex = get(hObject,'Value');
handles.movList(5) = handles.mov(movIndex);
guidata(hObject,handles);

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
if length( handles.patRec.control.maxDegPerMov ) >= 5
    handles.patRec.control.maxDegPerMov(5) = str2double(get(hObject,'String'));
else
    set(hObject,'String','N/A')
end
guidata(hObject,handles);

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
movIndex = get(hObject,'Value');
handles.movList(6) = handles.mov(movIndex);
guidata(hObject,handles);

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
if length( handles.patRec.control.maxDegPerMov ) >= 6
    handles.patRec.control.maxDegPerMov(6) = str2double(get(hObject,'String'));
else
    set(hObject,'String','N/A')
end
guidata(hObject,handles);

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
movIndex = get(hObject,'Value')
handles.movList(7) = handles.mov(movIndex)
guidata(hObject,handles);

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
if length( handles.patRec.control.maxDegPerMov ) >= 7
    handles.patRec.control.maxDegPerMov(7) = str2double(get(hObject,'String'));
else
    set(hObject,'String','N/A')
end
guidata(hObject,handles);

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
movIndex = get(hObject,'Value');
handles.movList(8) = handles.mov(movIndex);
guidata(hObject,handles);

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
if length( handles.patRec.control.maxDegPerMov ) >= 8
    handles.patRec.control.maxDegPerMov(8) = str2double(get(hObject,'String'));
else
    set(hObject,'String','N/A')
end
guidata(hObject,handles);

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
movIndex = get(hObject,'Value');
handles.movList(9) = handles.mov(movIndex);
guidata(hObject,handles);

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
if length( handles.patRec.control.maxDegPerMov ) >= 9
    handles.patRec.control.maxDegPerMov(9) = str2double(get(hObject,'String'));
else
    set(hObject,'String','N/A')
end
guidata(hObject,handles);

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
movIndex = get(hObject,'Value');
handles.movList(10) = handles.mov(movIndex);
guidata(hObject,handles);

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
if length( handles.patRec.control.maxDegPerMov ) >= 10
    handles.patRec.control.maxDegPerMov(10) = str2double(get(hObject,'String'));
else
    set(hObject,'String','N/A')    
end
guidata(hObject,handles);

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
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
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
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
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
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
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
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
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
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
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
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
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

%This is to try and send a string to the VRE.
message = 'This is the message';
fwrite(handles.vre_Com,sprintf('%c%c%s','s',length(message),message));
fread(handles.vre_Com,1);

%Check whether to use VRE
if isfield(handles,'vre_Com')
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
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
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
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
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
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
    global TAC
    %Calculate dof, since every 2nd value indicates which dof. (works for
    %now)
    %Moves the VRE some distance.
    if VREActivation(handles.vre_Com,movDeg,[],movement.idVRE,movement.vreDir,get(handles.cb_moveTAC,'Value'));
        %TAC is complete.
       disp('TAC Complete!');
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

    % validation of patRec loaded
%     if ~isfield(handles,'com')
%         set(handles.t_msg,'String','No connection, connect first!');  
%         set(hObject,'Value',0);
%         return
%     end


% --- Executes on button press in pb_socketConnect.
function pb_socketConnect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_socketConnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 % Dialog box to open a file
%[file, path] = uigetfile('*.exe');
% Check that the loaded file is a "ss" struct
%if ~isequal(file, 0)
%    startString = sprintf('start /D%s %s',path,file);
%    disp(startString);
%    [a,b] = system(startString);
%end

% This starts the VRE-environment. Add support for different paths?
varm=get(handles.cb_virtualarm,'Value');
vleg=get(handles.cb_virtualleg,'Value');
 if varm == 1
    
         open('Virtual Reality.exe');
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
set(handles.pb_ActivateArm,'Enable','on');
set(handles.pb_socketConnect,'Enable','off');
set(handles.cb_virtualleg,'Enable','off');

    
elseif vleg == 1
    
        open('Virtual Leg.exe');
        port = str2double(get(handles.et_port,'String'));

set(handles.t_msg,'String','Waiting for client connection.');
%guidata(hObject,handles);

obj = tcpip('127.0.0.1',port,'NetworkRole','server');

fopen(obj);
%%%%The fwrite command below when executed shows the virtual leg when
%%%%connected with matlab. If it is not send then the virtual leg does not show
%%%%up. It only shows when a command is send to the virtual environment. 
%fwrite(obj,sprintf('%c%c%c%c',1,16,1,0)); %Dummy command to wake up virtual environment. Else the virtual leg does not show up when connected.
fwrite(obj,sprintf('%c%c%c%c',1,16,0,0)); %Dummy command to wake up virtual environment.


set(handles.t_msg,'String',sprintf('Server established on port %d.',port));
handles.vre_Com = obj;
guidata(hObject,handles);

set(handles.pb_socketDisconnect,'Enable','on');
set(handles.pb_Camera,'Enable','off');
set(handles.pb_ActivateArm,'Enable','off');
set(handles.pb_socketConnect,'Enable','off');
set(handles.cb_virtualarm,'Enable','off');

        
else
    
    set(handles.t_msg,'String','Select virtual arm or virtual leg');    
   
 end
 
 
%Retrieves specified port.

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
varm=get(handles.cb_virtualarm,'Value');
vleg=get(handles.cb_virtualleg,'Value');
set(handles.pb_socketDisconnect,'Enable','off');
set(handles.pb_Camera,'Enable','off');
set(handles.pb_ActivateArm,'Enable','off');

obj = handles.vre_Com;
if(vleg==1)
    fwrite(obj,sprintf('%c%c%c%c',25,char(5),char(0),char(0)));
    
end

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

% Save mainGUI handle to guidata of GUI_TacTest
GUI = eval('GUI_TacTest');
TacHandles = guidata(GUI);

TacHandles.mainGUI = hObject;
guidata(GUI,TacHandles);



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
%if isfield(handles,'vre_Com')
obj = handles.vre_Com;
fwrite(obj,sprintf('%c%c%c%c','c',char(5),char(0),char(0)));
fread(obj,1);
%end


% --- Executes on selection change in pm_controlAlg.
function pm_controlAlg_Callback(hObject, eventdata, handles)
% hObject    handle to pm_controlAlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_controlAlg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_controlAlg

% Initialize control from popup-menu if patRec exists in GUI

if isfield(handles,'patRec')
    popMenuStrings = get(hObject,'String');
    handles.patRec = InitControl_new(handles.patRec, ...
                           strtrim(popMenuStrings(get(hObject,'Value'),:)));
    % Save patRec in Object handles
    guidata(hObject,handles);
    
    % Update Message
    set(handles.t_msg,'String','')
else
    set(handles.t_msg,'String','No PatRec Loaded');
end

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

controlAlg = ReadValidControlAlgs;

names = controlAlg{1}.name{1};
for i = 2:size(controlAlg,2)
    names = [names,'|',controlAlg{i}.name{1}];
end

set(hObject,'String',names);

% --- Executes on button press in cb_keys.
function cb_keys_Callback(hObject, eventdata, handles)
% hObject    handle to cb_keys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_keys


% --- Executes on button press in pb_controlOptions.
function pb_controlOptions_Callback(hObject, eventdata, handles)
% hObject    handle to pb_controlOptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_ControlParameters(hObject);



function et_allSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to et_allSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_allSpeed as text
%        str2double(get(hObject,'String')) returns contents of et_allSpeed as a double

value = get(hObject,'String');
for i = 1:10
    currentSpeedBox = ['et_speed',num2str(i)];
    if i <= length(handles.patRec.control.maxDegPerMov)
        set(handles.(currentSpeedBox),'String', value);
    else
        set(handles.(currentSpeedBox),'String','N/A');
    end
end

value = str2double(value);
handles.patRec.control.maxDegPerMov = value * ones(size(handles.patRec.control.maxDegPerMov)) ;

guidata(hObject,handles);
    

% --- Executes during object creation, after setting all properties.
function et_allSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_allSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in pb_ActivateArm.
function pb_ActivateArm_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ActivateArm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = handles.vre_Com;
fwrite(obj,sprintf('%c%c%c%c%c','c',char(6),char(0),char(0),char(0)));
fread(obj,1);


% --- Executes on button press in pb_SetKeys.
function pb_SetKeys_Callback(hObject, eventdata, handles)
% hObject    handle to pb_SetKeys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_SendKeys(hObject);


% --- Executes on button press in cb_motionTestVRE.
function cb_motionTestVRE_Callback(hObject, eventdata, handles)
% hObject    handle to cb_motionTestVRE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_motionTestVRE



function et_retval_Callback(hObject, eventdata, handles)
% hObject    handle to et_retval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_retval as text
%        str2double(get(hObject,'String')) returns contents of et_retval as a double


% --- Executes during object creation, after setting all properties.
function et_retval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_retval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in cb_virtualarm.
function cb_virtualarm_Callback(hObject, eventdata, handles)
% hObject    handle to cb_virtualarm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_virtualarm
varm=get(handles.cb_virtualarm,'Value');
if varm==1
     set(handles.cb_virtualleg,'Enable','off');
     set(handles.t_msg,'String','Virtual Arm selected');
else
      set(handles.cb_virtualleg,'Enable','on'); 
end
 
 



% --- Executes during object creation, after setting all properties.
function cb_virtualarm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cb_virtualarm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes on button press in cb_virtualleg.


function cb_virtualleg_Callback(hObject, eventdata, handles)
% hObject    handle to cb_virtualleg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_virtualleg
vleg=get(handles.cb_virtualleg,'Value');
if vleg==1
     set(handles.cb_virtualarm,'Enable','off');
     set(handles.t_msg,'String','Virtual Leg selected');
else
      set(handles.cb_virtualarm,'Enable','on'); 
end

% --- Executes during object creation, after setting all properties.
function cb_virtualleg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cb_virtualleg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
