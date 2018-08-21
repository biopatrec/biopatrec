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
% ------------------- Function Description ------------------
% 
%
% The function is written in such a way that it requires the movement
% "rest" to run properly.
% --------------------------Updates--------------------------
% [Contributors are welcome to add their email]
%  2016-10-07 / Jake Gusman          / Creation                    
%  2016-12-13 / Jake Gusman          / Automatic update of 'repetitions' value upon modification of movement or target DOF
%  2016-6-27  / Jake Gusman          / Addition of Joystick Test
%
%  20xx-xx-xx / Author     / Comment on update  

function varargout = GUI_FittsLawTest(varargin)
%GUI_FITTSLAWTEST MATLAB code file for GUI_FittsLawTest.fig
%      GUI_FITTSLAWTEST, by itself, creates a new GUI_FITTSLAWTEST or raises the existing
%      singleton*.
%
%      H = GUI_FITTSLAWTEST returns the handle to a new GUI_FITTSLAWTEST or the handle to
%      the existing singleton*.
%
%      GUI_FITTSLAWTEST('Property','Value',...) creates a new GUI_FITTSLAWTEST using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to GUI_FittsLawTest_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI_FITTSLAWTEST('CALLBACK') and GUI_FITTSLAWTEST('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI_FITTSLAWTEST.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_FittsLawTest

% Last Modified by GUIDE v2.5 27-Jun-2017 18:51:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_FittsLawTest_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_FittsLawTest_OutputFcn, ...
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


% --- Executes just before GUI_FittsLawTest is made visible.
function GUI_FittsLawTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for GUI_FittsLawTest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_FittsLawTest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_FittsLawTest_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_start.
function pb_start_Callback(hObject, eventdata, handles)
% hObject    handle to pb_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update patRecHandles from mainGUI before starting test
handles.patRecHandles = guidata(handles.mainGUI);

    if(~isfield(handles.patRecHandles,'patRec'))
       set(handles.t_msg,'String','Nothing to see. No PatRec.');
       return;
    end
    if get(handles.pm_distance,'Value') == 1
        set(handles.t_msg,'String','Please select distance type.');
        return
    end
    if strcmp(get(handles.et_nR,'String'), 'N/A')
        set(handles.t_msg,'String','Target DOF exceeds movement DOFs');
        return
    end    
        
    patRec = handles.patRecHandles.patRec;
    
    if get(handles.tb_joystick,'Value') == 0   
        % Run fitts law test
        set(handles.t_msg,'String','Fitts Law Test started...');      
        drawnow;
        handles.fittsTest = FittsLawTest(patRec, handles);
        set(handles.t_msg,'String','Fitts Law Test completed');
    elseif get(handles.tb_joystick,'Value') == 1
        set(handles.t_msg,'String','Joystick Test started...');      
        drawnow;
        handles.joyStickTest = JoyStickTest(patRec, handles);
        set(handles.t_msg,'String','Joystick Test completed');
    end
    guidata(hObject,handles)


% --- Executes on button press in pb_viewResults.
function pb_viewResults_Callback(hObject, eventdata, handles)
% hObject    handle to pb_viewResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if(~isfield(handles,'fittsTest'))
       set(handles.t_msg,'String','Nothing to view. No fittsTest.');
       return;
    end
    
    % Show test results
    set(handles.t_msg,'String','Showing Results');      
    drawnow;
    FittsTestViewResults(handles.fittsTest);



% --- Executes on selection change in pm_expand.
function pm_expand_Callback(hObject, eventdata, handles)
% hObject    handle to pm_expand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_expand contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_expand

TargetNum_GUIUpdater(handles);

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pm_expand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_expand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_shrink.
function pm_shrink_Callback(hObject, eventdata, handles)
% hObject    handle to pm_shrink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_shrink contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_shrink
TargetNum_GUIUpdater(handles);

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pm_shrink_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_shrink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_right.
function pm_right_Callback(hObject, eventdata, handles)
% hObject    handle to pm_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_right contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_right
TargetNum_GUIUpdater(handles);

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pm_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_left.
function pm_left_Callback(hObject, eventdata, handles)
% hObject    handle to pm_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_left contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_left
TargetNum_GUIUpdater(handles);

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function pm_left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_up.
function pm_up_Callback(hObject, eventdata, handles)
% hObject    handle to pm_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_up contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_up
TargetNum_GUIUpdater(handles);

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pm_up_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_down.
function pm_down_Callback(hObject, eventdata, handles)
% hObject    handle to pm_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_down contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_down
TargetNum_GUIUpdater(handles);

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pm_down_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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



function et_dwellTime_Callback(hObject, eventdata, handles)
% hObject    handle to et_dwellTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_dwellTime as text
%        str2double(get(hObject,'String')) returns contents of et_dwellTime as a double


% --- Executes during object creation, after setting all properties.
function et_dwellTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_dwellTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_speed_Callback(hObject, eventdata, handles)
% hObject    handle to et_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_speed as text
%        str2double(get(hObject,'String')) returns contents of et_speed as a double


% --- Executes during object creation, after setting all properties.
function et_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function mb_load_Callback(hObject, eventdata, handles)
% hObject    handle to mb_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('%%%%%%%%%%% Loading Data %%%%%%%%%%%%%');
set(handles.t_msg,'String','Loading Data...');

[file, path] = uigetfile({'*.mat'});

if ~isequal(file, 0)
    [pathstr,name,ext] = fileparts(file);
    if(strcmp(ext,'.mat'))
        load([path,file]);
        if (exist('fittsTest','var'))
            
            disp('%%%%%%%%%%% fittsTest loaded %%%%%%%%%%%%%');
            set(handles.t_msg,'String','fittsTest loaded');
        else
            disp('That was not a valid data set');
            errordlg('That was not a valid data set','Error');
            return;
        end
    else
        disp('That was not a valid data set');
        errordlg('That was not a valid data set','Error');
        return;
    end
end
    handles.fittsTest = fittsTest;

    guidata(hObject,handles)        
            
            
% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in pm_distance.
function pm_distance_Callback(hObject, eventdata, handles)
% hObject    handle to pm_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_distance contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_distance

handles.patRecHandles = guidata(handles.mainGUI);

    if(~isfield(handles.patRecHandles,'patRec'))
       set(handles.t_msg,'String','Nothing to see. No PatRec.');
       return;
    end

    patRec = handles.patRecHandles.patRec;

set(handles.et_nR,'Enable','on');
% if distance type is "Per DOF", number of repetitions is dependent on
% number of targets, which is defined by the number of DOFs. 
TargetNum_GUIUpdater(handles);

guidata(hObject,handles)



function et_tDistances_Callback(hObject, eventdata, handles)
% hObject    handle to et_tDistances (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_tDistances as text
%        str2double(get(hObject,'String')) returns contents of et_tDistances as a double


% --- Executes during object creation, after setting all properties.
function et_tDistances_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_tDistances (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_tWidths_Callback(hObject, eventdata, handles)
% hObject    handle to et_tWidths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_tWidths as text
%        str2double(get(hObject,'String')) returns contents of et_tWidths as a double


% --- Executes during object creation, after setting all properties.
function et_tWidths_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_tWidths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_targetDOF.
function pm_targetDOF_Callback(hObject, eventdata, handles)
% hObject    handle to pm_targetDOF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_targetDOF contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_targetDOF
TargetNum_GUIUpdater(handles);

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pm_targetDOF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_targetDOF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tb_joystick.
function tb_joystick_Callback(hObject, eventdata, handles)
% hObject    handle to tb_joystick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tb_joystick

state = get(hObject,'Value');
if state == 1
    set(handles.t_title,'String','Joystick Test');
    set(handles.t_title,'ForegroundColor','red');
    set(handles.t_subTitle, 'Visible', 'on');
    set(handles.t_tDistUnit,'String','(%)');
    set(handles.t_tWidthUnit,'String','(%)');
%     set(handles.pm_distance, 'Enable','off');
elseif state == 0
    set(handles.t_title,'String','Fitts Law Test');
    set(handles.t_title,'ForegroundColor','black');
    set(handles.t_subTitle, 'Visible', 'off');
    set(handles.t_tDistUnit,'String','(deg)');
    set(handles.t_tWidthUnit,'String','(deg)');
%     set(handles.pm_distance,'Enable','on');   
end
guidata(hObject,handles)
