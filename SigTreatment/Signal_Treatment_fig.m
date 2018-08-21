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

function varargout = Signal_Treatment_fig(varargin)
% SIGNAL_TREATMENT_FIG M-file for Signal_Treatment_fig.fig
%      SIGNAL_TREATMENT_FIG, by itself, creates a new SIGNAL_TREATMENT_FIG or raises the existing
%      singleton*.
%
%      H = SIGNAL_TREATMENT_FIG returns the handle to a new SIGNAL_TREATMENT_FIG or the handle to
%      the existing singleton*.
%
%      SIGNAL_TREATMENT_FIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNAL_TREATMENT_FIG.M with the given input arguments.
%
%      SIGNAL_TREATMENT_FIG('Property','Value',...) creates a new SIGNAL_TREATMENT_FIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Signal_Treatment_fig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Signal_Treatment_fig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Signal_Treatment_fig

% Last Modified by GUIDE v2.5 11-Jun-2015 09:11:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Signal_Treatment_fig_OpeningFcn, ...
                   'gui_OutputFcn',  @Signal_Treatment_fig_OutputFcn, ...
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


% --- Executes just before Signal_Treatment_fig is made visible.
function Signal_Treatment_fig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Signal_Treatment_fig (see VARARGIN)

% Choose default command line output for Signal_Treatment_fig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Signal_Treatment_fig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Signal_Treatment_fig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_treat.
function pb_treat_Callback(hObject, eventdata, handles)

    phandles = get(handles.t_mhandles,'UserData'); % get parent GUI handles    
    Fs  = str2double(get(handles.et_Fs,'String'));
    Nr  = str2double(get(handles.et_Nr,'String'));
    Tc  = str2double(get(handles.et_Tc,'String'));
    Psr = str2double(get(handles.et_Psr,'String'));
    tw  = str2double(get(handles.et_tw,'String'));
    nw  = str2double(get(handles.et_nw,'String'));
    trN = str2double(get(handles.et_trN,'String'));
    vN  = str2double(get(handles.et_vN,'String'));
    tN  = str2double(get(handles.et_tN,'String'));
    filters.PLH = get(handles.cb_PLHf,'Value');
    filters.BP = get(handles.cb_BPf,'Value');
    rawdata = get(handles.t_rawdata,'UserData');
    method.nonOverlapped = get(handles.cb_nonoverlapped,'Value');
    method.OverlappedC = get(handles.cb_overlappedc,'Value');
    method.OverlappedR = get(handles.cb_overlappedr,'Value');
    
    treated_data = treat_Data(phandles, rawdata, Fs, Nr, Tc*Psr, tw, nw, trN, vN, tN, filters, method);           % Treat Data
    treated_data.msg = get(phandles.lb_msg,'String');
    set(phandles.t_treated_data,'UserData',treated_data);    
    set(phandles.et_trN,'String',num2str(treated_data.trN));    
    set(phandles.et_vN,'String',num2str(treated_data.vN));    
    set(phandles.et_tN,'String',num2str(treated_data.tN));    
    set(phandles.t_msg,'String','Data analyzed');
    close(Signal_Treatment_fig);


% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
    close(Signal_Treatment_fig);



function et_trP_Callback(hObject, eventdata, handles)
    nw = str2double(get(handles.et_nw,'String'));
    trP = str2double(get(handles.et_trP,'String'));
    trN = fix(trP * nw);
    set(handles.et_trN,'String',num2str(trN));
    vP = str2double(get(handles.et_vP,'String'));
    vN = fix(vP * nw);
    set(handles.et_vN,'String',num2str(vN));
    tP = str2double(get(handles.et_tP,'String'));
    tN = fix(tP * nw);
    set(handles.et_tN,'String',num2str(tN));

    set(handles.t_totN,'String',num2str(trN+vN+tN));
    set(handles.t_totP,'String',num2str(trP+vP+tP));


% --- Executes during object creation, after setting all properties.
function et_trP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_trP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_vP_Callback(hObject, eventdata, handles)
    nw = str2double(get(handles.et_nw,'String'));
    trP = str2double(get(handles.et_trP,'String'));
    trN = fix(trP * nw);
    set(handles.et_trN,'String',num2str(trN));
    vP = str2double(get(handles.et_vP,'String'));
    vN = fix(vP * nw);
    set(handles.et_vN,'String',num2str(vN));
    tP = str2double(get(handles.et_tP,'String'));
    tN = fix(tP * nw);
    set(handles.et_tN,'String',num2str(tN));

    set(handles.t_totN,'String',num2str(trN+vN+tN));
    set(handles.t_totP,'String',num2str(trP+vP+tP));


% --- Executes during object creation, after setting all properties.
function et_vP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_vP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_tP_Callback(hObject, eventdata, handles)

    nw = str2double(get(handles.et_nw,'String'));
    trP = str2double(get(handles.et_trP,'String'));
    trN = fix(trP * nw);
    set(handles.et_trN,'String',num2str(trN));
    vP = str2double(get(handles.et_vP,'String'));
    vN = fix(vP * nw);
    set(handles.et_vN,'String',num2str(vN));
    tP = str2double(get(handles.et_tP,'String'));
    tN = fix(tP * nw);
    set(handles.et_tN,'String',num2str(tN));

    set(handles.t_totN,'String',num2str(trN+vN+tN));
    set(handles.t_totP,'String',num2str(trP+vP+tP));
    

% --- Executes during object creation, after setting all properties.
function et_tP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_tP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_trN_Callback(hObject, eventdata, handles)
    trN = str2double(get(handles.et_trN,'String'));
    vN = str2double(get(handles.et_vN,'String'));
    tN = str2double(get(handles.et_tN,'String'));

    set(handles.t_totN,'String',num2str(trN+vN+tN));



% --- Executes during object creation, after setting all properties.
function et_trN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_trN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_vN_Callback(hObject, eventdata, handles)
    trN = str2double(get(handles.et_trN,'String'));
    vN = str2double(get(handles.et_vN,'String'));
    tN = str2double(get(handles.et_tN,'String'));

    set(handles.t_totN,'String',num2str(trN+vN+tN));

% --- Executes during object creation, after setting all properties.
function et_vN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_vN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_tN_Callback(hObject, eventdata, handles)
    trN = str2double(get(handles.et_trN,'String'));
    vN = str2double(get(handles.et_vN,'String'));
    tN = str2double(get(handles.et_tN,'String'));

    set(handles.t_totN,'String',num2str(trN+vN+tN));


% --- Executes during object creation, after setting all properties.
function et_tN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_tN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_nonoverlapped.
function cb_nonoverlapped_Callback(hObject, eventdata, handles)
% hObject    handle to cb_nonoverlapped (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_nonoverlapped


% --- Executes on button press in cb_overlappedc.
function cb_overlappedc_Callback(hObject, eventdata, handles)
% hObject    handle to cb_overlappedc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_overlappedc


% --- Executes on button press in cb_overlappedr.
function cb_overlappedr_Callback(hObject, eventdata, handles)
% hObject    handle to cb_overlappedr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_overlappedr



function et_tw_Callback(hObject, eventdata, handles)

    Tc = str2double(get(handles.et_Tc,'String'));
    Psr = str2double(get(handles.et_Psr,'String'));
    Nr = str2double(get(handles.et_Nr,'String'));
    nw = fix(Tc * Psr * Nr / str2double(get(handles.et_tw,'String')));
    set(handles.et_nw,'String',num2str(nw));
    et_nw_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function et_tw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_tw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_nw_Callback(hObject, eventdata, handles)
    nw = str2double(get(handles.et_nw,'String'));
    trN = fix(str2double(get(handles.et_trP,'String')) * nw);
    set(handles.et_trN,'String',num2str(trN));
    vN = fix(str2double(get(handles.et_vP,'String')) * nw);
    set(handles.et_vN,'String',num2str(vN));
    tN = fix(str2double(get(handles.et_tP,'String')) * nw);
    set(handles.et_tN,'String',num2str(tN));

    set(handles.t_totN,'String',num2str(trN+vN+tN));


% --- Executes during object creation, after setting all properties.
function et_nw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_nw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_PLHf.
function cb_PLHf_Callback(hObject, eventdata, handles)
% hObject    handle to cb_PLHf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_PLHf


% --- Executes on button press in cb_BPf.
function cb_BPf_Callback(hObject, eventdata, handles)
% hObject    handle to cb_BPf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_BPf


% --- Executes on button press in pb_treatFolder.
function pb_treatFolder_Callback(hObject, eventdata, handles)
    
    % get Paths
    lpath   = get(handles.t_path,'UserData');       % Path to location of the file    
    spath   = uigetdir(lpath, 'Select a directory to save treated data');

    % Setting the treatment parameters
    phandles = get(handles.t_mhandles,'UserData'); % get parent GUI handles    
    Fs  = str2double(get(handles.et_Fs,'String'));
    Nr  = str2double(get(handles.et_Nr,'String'));
    Tc  = str2double(get(handles.et_Tc,'String'));
    Psr = str2double(get(handles.et_Psr,'String'));
    tw  = str2double(get(handles.et_tw,'String'));
    nw  = str2double(get(handles.et_nw,'String'));
    trN = str2double(get(handles.et_trN,'String'));
    vN  = str2double(get(handles.et_vN,'String'));
    tN  = str2double(get(handles.et_tN,'String'));
    filters.PLH = get(handles.cb_PLHf,'Value');
    filters.BP = get(handles.cb_BPf,'Value');
    method.nonOverlapped = get(handles.cb_nonoverlapped,'Value');
    method.OverlappedC = get(handles.cb_overlappedc,'Value');
    method.OverlappedR = get(handles.cb_overlappedr,'Value');

    % Getting the rawdata and treating it
    for rn =1 : 100
        if exist([lpath num2str(rn) '.mat'],'file')
            load([lpath num2str(rn) '.mat']);
            set(handles.t_msg,'String',['Treating file no:' num2str(rn)]);
            rawdata = ss.trdata;
            treated_data = treat_Data(phandles, rawdata, Fs, Nr, Tc*Psr, tw, nw, trN, vN, tN, filters, method);           % Treat Data
            treated_data.msg = get(phandles.lb_msg,'String');
            save([spath '\' num2str(rn) 't.mat'],'treated_data');
        else
            break;
        end 
    end

    set(phandles.t_msg,'String','Folder analyzed');
    set(phandles.t_treated_data,'UserData',treated_data);    
    set(phandles.et_trN,'String',num2str(treated_data.trN));    
    set(phandles.et_vN,'String',num2str(treated_data.vN));    
    set(phandles.et_tN,'String',num2str(treated_data.tN));    
    close(Signal_Treatment_fig);
