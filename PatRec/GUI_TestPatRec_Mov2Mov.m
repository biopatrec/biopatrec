% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec © which is open and free software under 
% the GNU Lesser General Public License (LGPL). See the file "LICENSE" for 
% the full license governing this code and copyrights.
%
% BioPatRec was initially developed by Max J. Ortiz C. at Integrum AB and 
% Chalmers University of Technology. All authors contributions must be kept
% acknowledged below in the section "Updates % Contributors". 
%
% Would you like to contribute to science and sum efforts to improve 
% amputees quality of life? Join this project! or, send your comments to:
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
% 2015-07-16 / Enzo Mastinu / Framework for movements and motors
%                             implemented, the SPC control does not need
%                             anymore the MoveMotorWifi or any dedicated
%                             SPC functions
% 2016-12-05 / Jake Gusman  / Addition of Fitts Law Test Initiation button
%
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

% Last Modified by GUIDE v2.5 05-Dec-2016 15:09:35

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
    
%     serialportlist = instrhwinfo('serial');
%     serialportlist = serialportlist.SerialPorts;
%     for i=1:size(serialportlist)
%         set(handles.popmenu16,'String',serialportlist(i));
%     end
    
end

% Logo image
backgroundImage2 = importdata('Img/BioPatRec.png');
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
% uiwait(handles.Gui1);
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
    
set(hObject, 'Enable', 'off');    
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

handles.mov.name
handles.movList.name

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
movIndex = get(hObject,'Value');
handles.movList(7) = handles.mov(movIndex);
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
    % Get the motors obj
    motors = handles.motors;
    % Get the communication obj
    Control_obj = handles.Control_obj;
    if ~strcmp(Control_obj.status,'open')
                fopen(Control_obj);
    end 
    
    %Activate the motor direction for a short moment.
    MotorsOn(Control_obj, movement, motors, movDeg);
    pause(1);
    MotorsOff(Control_obj, movement, motors);
    
    % Save data back
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
    % Get the motors obj
    motors = handles.motors;
    % Get the communication obj
    Control_obj = handles.Control_obj;
    if ~strcmp(Control_obj.status,'open')
        fopen(Control_obj);
    end 
    
    %Activate the motor direction for a short moment.
    MotorsOn(Control_obj, movement, motors, movDeg);
    pause(1);
    MotorsOff(Control_obj, movement, motors);
    
    % Save data back
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
    % Get the motors obj
    motors = handles.motors;
    % Get the communication obj
    Control_obj = handles.Control_obj;
    if ~strcmp(Control_obj.status,'open')
        fopen(Control_obj);
    end 
    
    %Activate the motor direction for a short moment.
    MotorsOn(Control_obj, movement, motors, movDeg);
    pause(1);
    MotorsOff(Control_obj, movement, motors);
    
    % Save data back
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
    % Get the motors obj
    motors = handles.motors;
    % Get the communication obj
    Control_obj = handles.Control_obj;
    if ~strcmp(Control_obj.status,'open')
    	fopen(Control_obj);
    end 
    
    %Activate the motor direction for a short moment.
    MotorsOn(Control_obj, movement, motors, movDeg);
    pause(1);
    MotorsOff(Control_obj, movement, motors);
    
    % Save data back
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
    % Get the motors obj
    motors = handles.motors;
    % Get the communication obj
    Control_obj = handles.Control_obj; 
    
    %Activate the motor direction for a short moment.
    MotorsOn(Control_obj, movement, motors, movDeg);
    pause(1);
    MotorsOff(Control_obj, movement, motors);
    
    % Save data back
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
    % Get the motors obj
    motors = handles.motors;
    % Get the communication obj
    Control_obj = handles.Control_obj; 
    
    %Activate the motor direction for a short moment.
    MotorsOn(Control_obj, movement, motors, movDeg);
    pause(1);
    MotorsOff(Control_obj, movement, motors);
    
    % Save data back
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
    % Get the motors obj
    motors = handles.motors;
    % Get the communication obj
    Control_obj = handles.Control_obj; 
    
    %Activate the motor direction for a short moment.
    MotorsOn(Control_obj, movement, motors, movDeg);
    pause(1);
    MotorsOff(Control_obj, movement, motors);
    
    % Save data back
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
    % Get the motors obj
    motors = handles.motors;
    % Get the communication obj
    Control_obj = handles.Control_obj; 
    
    %Activate the motor direction for a short moment.
    MotorsOn(Control_obj, movement, motors, movDeg);
    pause(1);
    MotorsOff(Control_obj, movement, motors);
    
    % Save data back
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
    % Get the motors obj
    motors = handles.motors;
    % Get the communication obj
    Control_obj = handles.Control_obj; 
    
    %Activate the motor direction for a short moment.
    MotorsOn(Control_obj, movement, motors, movDeg);
    pause(1);
    MotorsOff(Control_obj, movement, motors);
    
    % Save data back
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
    % Get the motors obj
    motors = handles.motors;
    % Get the communication obj
    Control_obj = handles.Control_obj;
    if ~strcmp(Control_obj.status,'open')
    	fopen(Control_obj);
    end 
    
    %Activate the motor direction for a short moment.
    MotorsOn(Control_obj, movement, motors, movDeg);
    pause(1);
    MotorsOff(Control_obj, movement, motors);
    
    % Save data back
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

if get(handles.rb_serial, 'Value')
    compath_idx = get(handles.pm_serialportipaddress,'Value');
    compath     = get(handles.pm_serialportipaddress,'string');
    compath     = compath(compath_idx);
    BaudRate    = str2double(get(handles.et_baudrateport,'String'));
    Control_obj = serial(compath, 'BaudRate', BaudRate);
elseif get(handles.rb_wifi, 'Value')
    ip = get(handles.pm_serialportipaddress,'String');
    port = str2double(get(handles.et_baudrateport,'String'));    
    Control_obj = tcpip(ip,port,'NetworkRole','client');   
end
fopen(Control_obj);
set(handles.t_msg,'String','Connection established!');

handles.Control_obj = Control_obj;
guidata(hObject,handles);   

set(handles.pb_testConnection,'Enable','on');
set(handles.pb_disconnect,'Enable','on');
set(handles.pb_move1,'Enable','on');
set(handles.pb_move2,'Enable','on');
set(handles.pb_move3,'Enable','on');
set(handles.pb_move4,'Enable','on');
set(handles.pb_move5,'Enable','on');
set(handles.pb_move6,'Enable','on');
set(handles.pb_move7,'Enable','on');
set(handles.pb_move8,'Enable','on');
set(handles.pb_move9,'Enable','on');
set(handles.pb_move10,'Enable','on');
if isfield(handles, 'sensors') && isobject(handles.sensors)
    set(handles.pb_sensors,'Enable','on');
end


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

fclose(handles.Control_obj)   
set(handles.t_msg,'String','Disconnected');
set(handles.pb_testConnection,'Enable','off');
set(handles.pb_disconnect,'Enable','off');
set(handles.pb_sensors,'Enable','off');

% --- Executes on button press in pb_testConnection.
function pb_testConnection_Callback(hObject, eventdata, handles)
% hObject    handle to pb_testConnection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.t_msg,'String','Testing connection...');

if TestConnection(handles.Control_obj)
    set(handles.t_msg,'String','Connection OK');
else
    set(handles.t_msg,'String','Wrong connection');
    fclose(handles.Control_obj);
end

% % obtained the ID of the selected device
%     device = get(handles.pm_prosthesis,'Value');
%     % run connecting routine accordingly
%     if device == 1 % Multifunctinal prosthesis with DC motors
%         if TestConnectionALC(handles.Control_obj)==1; %Write S to stop program
%             set(handles.t_msg,'String','Connection established');
%             guidata(hObject,handles);
%         else
%             set(handles.t_msg,'String','Wrong connection');
%             fclose(handles.Control_obj.io);
%         end
%     elseif device == 3  % Standard prosthetic units (wireless) 
%         if isfield(handles,'Control_obj')
%             Control_obj = handles.Control_obj;
%             disp(Control_obj);
%             fclose(Control_obj);
%         else
%             Control_obj = tcpip('192.168.100.10',65100,'NetworkRole','client');
%         end
%         % Open connection
%         fopen(Control_obj);
%         fwrite(Control_obj,'A','char');
%         fwrite(Control_obj,'C','char')
%         replay = char(fread(Control_obj,1,'char'));
%         if strcmp(replay,'C');
%             set(handles.t_msg,'String','Connection established!');
%         else
%             set(handles.t_msg,'String','Error');        
%         end
%         fclose(Control_obj);
%         handles.Control_obj = Control_obj;
%         guidata(hObject,handles);        
%     end



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
handles = ConnectVRE(handles,'Virtual Reality.exe');
guidata(hObject,handles);

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
if isfield(handles,'vre_leg')
handles = rmfield(handles,'vre_leg');
end
handles = DisconnectVRE(handles);
guidata(hObject,handles);


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
Control_obj = handles.vre_Com;
fwrite(Control_obj,sprintf('%c%c%c%c','c',char(5),char(0),char(0)));
fread(Control_obj,1);



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


% --- Executes on button press in pb_socketConnect2.
function pb_socketConnect2_Callback(hObject, eventdata, handles)
% hObject    handle to pb_socketConnect2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ConnectVRE(handles,'Augmented Reality HAND.exe');
guidata(hObject,handles);

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


% --- Executes on button press in cb_proportionalControl.
function cb_proportionalControl_Callback(hObject, eventdata, handles)
% hObject    handle to cb_proportionalControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_proportionalControl

% If proportional control checkbox is checked
if get(hObject,'Value')
    % Create proportional control variables if patRec structure is loaded
    if isfield(handles,'patRec')
        % Increase maximum speed to 100
%         handles.patRec.control.maxDegPerMov = ones(size(handles.patRec.control.maxDegPerMov)).*100;
%         set(handles.et_allSpeed,'String',100);
%         et_allSpeed_Callback(handles.et_allSpeed,eventdata,handles);
        
        % Initialize proportional control
        handles.patRec = InitPropControl(handles.patRec);
        
        % Save guidata because it is used in GUI_ProportionalControl
        guidata(hObject,handles);

        % Open proportional GUI
        io.mainGUI = hObject;
        setappdata(0,'selFeatures',handles.patRec.selFeatures)
        GUI_ProportionalControl(io);
        
    % If no patRec is loaded in GUI, give message instead        
    else
        set(t_msg,'String','No PatRec Loaded');
    end
    
% If proportional control checkbox is unchecked
else
    % Decrease maximum speed to 5
    handles.patRec.control.maxDegPerMov = ones(size(handles.patRec.control.maxDegPerMov)).*5;
    set(handles.et_allSpeed,'String',5);
    et_allSpeed_Callback(handles.et_allSpeed,eventdata,handles);
    
    % Remove all proportional control fields in patRec
    if isfield(handles.patRec.control,'propControl')
        handles.patRec.control = rmfield(handles.patRec.control,'propControl');
    end
end

% Update GUI-handles
guidata(hObject,handles);

% --- Executes on button press in pb_propGUI.
function pb_propGUI_Callback(hObject, eventdata, handles)
% hObject    handle to pb_propGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If patRec is loaded, launch proportional Control GUI
if isfield(handles,'patRec')
    
    % If proportional control checkbox is unchecked, check it
    if ~get(handles.cb_proportionalControl,'Value')
        set(handles.cb_proportionalControl,'Value',1);
    end
    
    io.mainGUI = hObject;
    setappdata(0,'selFeatures',handles.patRec.selFeatures)
    GUI_ProportionalControl(io);
    
% If no patRec is loaded, give message    
else
    set(t_msg,'String','No PatRec Loaded');
end


% --- Executes on button press in pb_ActivateArm.
function pb_ActivateArm_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ActivateArm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Control_obj = handles.vre_Com;
fwrite(Control_obj,sprintf('%c%c%c%c%c','c',char(6),char(0),char(0),char(0)));
fread(Control_obj,1);


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


% --- Executes on button press in pb_ARarm.
function pb_ARarm_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ARarm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = ConnectVRE(handles,'Augmented Reality.exe');
% Flex the elbow with 90 degrees. 
VREActivation(handles.vre_Com,90,[],15,1,get(handles.cb_moveTAC,'Value'));
guidata(hObject,handles);


% --- Executes on selection change in pm_prosthesis.
function pm_prosthesis_Callback(hObject, eventdata, handles)
% hObject    handle to pm_prosthesis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_prosthesis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_prosthesis


% --- Executes during object creation, after setting all properties.
function pm_prosthesis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_prosthesis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_controls.
function cb_controls_Callback(hObject, eventdata, handles)
% hObject    handle to cb_controls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_controls


% --- Executes on button press in pb_enableRealTimePatRec.
function pb_enableRealTimePatRec_Callback(hObject, eventdata, handles)
% hObject    handle to pb_enableRealTimePatRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.pb_RealtimePatRec, 'Enable', 'on');  


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pb_ARarm.
function pb_ARarm_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pb_ARarm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_sensors.
function pb_sensors_Callback(hObject, eventdata, handles)
% hObject    handle to pb_sensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GUI_Sensors(hObject, eventdata, handles);


function et_COM_Callback(hObject, eventdata, handles)
% hObject    handle to et_COM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_COM as text
%        str2double(get(hObject,'String')) returns contents of et_COM as a double


% --- Executes during object creation, after setting all properties.
function et_COM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_COM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double


% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_baudrateport_Callback(hObject, eventdata, handles)
% hObject    handle to et_baudrateport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_baudrateport as text
%        str2double(get(hObject,'String')) returns contents of et_baudrateport as a double


% --- Executes during object creation, after setting all properties.
function et_baudrateport_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_baudrateport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_serialportipaddress.
function pm_serialportipaddress_Callback(hObject, eventdata, handles)
% hObject    handle to pm_serialportipaddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_serialportipaddress contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_serialportipaddress


% --- Executes during object creation, after setting all properties.
function pm_serialportipaddress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_serialportipaddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% list all serial ports available
serialportlist = instrhwinfo('serial');
if ~isempty(serialportlist.AvailableSerialPorts)
    serialportlist = serialportlist.SerialPorts;
    set(hObject,'String',serialportlist);
else
    set(hObject,'String','None Available');
end

% --- Executes on button press in rb_serial.
function rb_serial_Callback(hObject, eventdata, handles)
% hObject    handle to rb_serial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_serial
set(handles.rb_wifi,'Value',0);
set(handles.pm_serialportipaddress,'Style','popupmenu');
% list all serial ports available
serialportlist = instrhwinfo('serial');
if ~isempty(serialportlist.AvailableSerialPorts)
    serialportlist = serialportlist.SerialPorts;
    set(handles.pm_serialportipaddress,'String',serialportlist);
else
    set(handles.pm_serialportipaddress,'String','None Available');
end
set(handles.et_baudrateport,'String','BaudRate');

% --- Executes on button press in rb_wifi.
function rb_wifi_Callback(hObject, eventdata, handles)
% hObject    handle to rb_wifi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_wifi
set(handles.rb_serial,'Value',0);
set(handles.pm_serialportipaddress,'Style','edit');
set(handles.pm_serialportipaddress,'String','192.168.100.10'); % IP
set(handles.et_baudrateport,'String','65100');                 % Port


% --- Executes on button press in pb_selectctrlfolder.
function pb_selectctrlfolder_Callback(hObject, eventdata, handles)
% hObject    handle to pb_selectctrlfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ctrl_dir = uigetdir;
if ctrl_dir
    [~,handles.prostheticDeviceName,~] = fileparts(ctrl_dir);
    handles.motors = InitMotors(ctrl_dir);
    handles.mov = InitMovements(ctrl_dir);
    listOfFile = dir(ctrl_dir);
    for i=1:size(listOfFile,1)
        if strcmp(listOfFile(i).name,'sensors.def')
            handles.sensors = InitSensors(ctrl_dir);
            set(handles.pb_sensors,'Enable','on');
        end
    end
    % Update list of possible movements accordingly to the new loaded
    % definition files. It compares the recorded list of movement with the
    % movement available for the particular robotic device selected. Only the
    % matching movements will be available in the list. 
    recordedMovs = handles.patRec.mov;
    k = 1;
    for i = 2:length(handles.mov)   % Avoid Rest from the list, so start from 2 
        if(~isempty(intersect(recordedMovs,handles.mov(i).name)))
            availableMovs(k,1) = handles.mov(i);
            k = k+1;
        end   
    end   
    for i = 1:10
        set(eval(strcat('handles.pm_m',num2str(i))),'Value',1);
        set(eval(strcat('handles.et_speed',num2str(i))),'String',num2str(1));
    end
    for i = 1:length(availableMovs)
        set(eval(strcat('handles.pm_m',num2str(i))),'Value',availableMovs(i).id+1);
        speed = handles.motors(availableMovs(i).motor(1)).pct;
        set(eval(strcat('handles.et_speed',num2str(i))),'String',num2str(speed));
    end
else
    handles.motors = InitMotors();
    handles.mov = InitMovements();
    handles.prostheticDeviceName = 'VRE';
    % Update list of possible movements accordingly to the standard VRE
    % definition file.
    for i = 1:10
        set(eval(strcat('handles.pm_m',num2str(i))),'Value',i);
        set(eval(strcat('handles.et_speed',num2str(i))),'String',num2str(1));
    end
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pb_VRleg.
function pb_VRleg_Callback(hObject, eventdata, handles)
% hObject    handle to pb_VRleg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vre_leg = 1;
handles = ConnectVRE(handles,'Virtual Reality.exe');
guidata(hObject,handles);


% --- Executes on button press in cb_addArtifacts.
function cb_addArtifacts_Callback(hObject, eventdata, handles)
% hObject    handle to cb_addArtifacts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_addArtifacts

% ADD ARTIFACT PROMPT
if get(handles.cb_addArtifacts,'Value')
    addArtifact = ChoiceArtifact(handles.patRec);
    if isempty(addArtifact)
        set(handles.cb_addArtifacts,'Value',0)
    else
        disp(addArtifact)
        % Save the handles back
        handles.patRec.addArtifact = addArtifact;
        guidata(hObject,handles);
    end
else
    if isfield(handles.patRec,'addArtifact')
        handles.patRec = rmfield(handles.patRec,'addArtifact');
        guidata(hObject,handles);
    end
    disp('Artifact options discarded.')
end


% --- Executes on button press in pb_ARleg.
function pb_ARleg_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ARleg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vre_leg = 1;
handles = ConnectVRE(handles,'Augmented Reality.exe');
guidata(hObject,handles);

function et_Unity_ip_Callback(hObject, eventdata, handles)
% hObject    handle to et_Unity_ip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_Unity_ip as text
%        str2double(get(hObject,'String')) returns contents of et_Unity_ip as a double


% --- Executes during object creation, after setting all properties.
function et_Unity_ip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Unity_ip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Unity_port_Callback(hObject, eventdata, handles)
% hObject    handle to et_Unity_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_Unity_port as text
%        str2double(get(hObject,'String')) returns contents of et_Unity_port as a double


% --- Executes during object creation, after setting all properties.
function et_Unity_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Unity_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_Unity_connect_disconnect.
function pb_Unity_connect_disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Unity_connect_disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%CK: I bet togglebutton would be the better choice for this button, but for
%now this shall work though.
if strcmp(get(handles.pb_Unity_connect_disconnect, 'String'), 'Connect')
    ip = str2num(get(handles.et_Unity_port, 'String'));
    obj = tcpip(get(handles.et_Unity_ip, 'String'), ip(1) );
    try
        fopen(obj);
        set(handles.t_msg,'String','Connected to TCP Socket');
        set(handles.pb_Camera,'Enable','on') %CK: I have no idea why/if this is neccessary
        set(handles.pb_Unity_connect_disconnect, 'String','Disconnect')
    catch
        set(handles.t_msg,'String','Connection failed...');
    end
    handles.vre_Com = obj;
    handles.vre_Heatmap =1;
else
    obj = handles.vre_Com;
    fclose(obj);
    handles.vre_Com = obj;
    set(handles.t_msg,'String','Disconnected');
    set(handles.pb_Unity_connect_disconnect, 'String', 'Connect');
end
guidata(hObject,handles);


% --- Executes on button press in pb_fittsLawTest.
function pb_fittsLawTest_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fittsLawTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save mainGUI handle to guidata of GUI_FittsLawTest
GUI = eval('GUI_FittsLawTest');
FittsHandles = guidata(GUI);
   
    % set pop-up menu options to movements that are available in PatRec
    armMovements = handles.patRec.mov;
    armMovements(end) = {'None'};                     % replace 'Rest' with 'None'
    set(FittsHandles.pm_expand,'String',armMovements);
    set(FittsHandles.pm_shrink,'String',armMovements);
    set(FittsHandles.pm_right,'String',armMovements);
    set(FittsHandles.pm_left,'String',armMovements);
    set(FittsHandles.pm_up,'String',armMovements);
    set(FittsHandles.pm_down,'String',armMovements);
    
    % set initial pop-up menu values to "None"
    nM = handles.patRec.nM;nM = handles.patRec.nM;
    set(FittsHandles.pm_expand,'Value',nM);
    set(FittsHandles.pm_shrink,'Value',nM);
    set(FittsHandles.pm_right,'Value',nM);
    set(FittsHandles.pm_left,'Value',nM);
    set(FittsHandles.pm_up,'Value',nM);
    set(FittsHandles.pm_down,'Value',nM);

FittsHandles.mainGUI = hObject;
guidata(GUI,FittsHandles); 
