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

function varargout = GUI_SigTreatment(varargin)
% GUI_SIGTREATMENT M-file for GUI_SigTreatment.fig
%      GUI_SIGTREATMENT, by itself, creates a new GUI_SIGTREATMENT or raises the existing
%      singleton*.
%
%      H = GUI_SIGTREATMENT returns the handle to a new GUI_SIGTREATMENT or the handle to
%      the existing singleton*.
%
%      GUI_SIGTREATMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SIGTREATMENT.M with the given input arguments.
%
%      GUI_SIGTREATMENT('Property','Value',...) creates a new GUI_SIGTREATMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_SigTreatment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_SigTreatment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_SigTreatment

% Last Modified by GUIDE v2.5 03-Jan-2015 18:23:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_SigTreatment_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_SigTreatment_OutputFcn, ...
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


% --- Executes just before GUI_SigTreatment is made visible.
function GUI_SigTreatment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_SigTreatment (see VARARGIN)

backgroundImage2 = importdata('/../Img/BioPatRec.png');
%select the axes
axes(handles.axes1);
%place image onto the axes
image(backgroundImage2);
%remove the axis tick marks
axis off

% Choose default command line output for GUI_SigTreatment
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_SigTreatment wait for user response (see UIRESUME)
% uiwait(handles.GUI_SigTreatment);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_SigTreatment_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_treat.
function pb_treat_Callback(hObject, eventdata, handles)

    set(handles.t_msg,'String','Treating the data...');

    sigTreated = get(handles.t_sigTreated,'UserData');
        
    % Treat the Data ----------------------------------------------------
    sigTreated = TreatData(handles, sigTreated); % Treat Data
    
    % get sigFeatures ---------------------------------------------------
    set(handles.t_msg,'String','Extracting signal features');
    drawnow;
    sigFeatures = GetAllSigFeatures(handles, sigTreated);
    sigFeatures.sigSeperation=sigTreated.sigSeperation;
    % Get back in the parent GUI ----------------------------------------
    phandles = get(handles.t_mhandles,'UserData'); % get parent GUI handles    

    % Save the sigFeatures into a "text" object in the parent figure
    set(phandles.t_sigFeatures,'UserData',sigFeatures);    
    % Transfer the number of sets
    set(phandles.et_trSets,'String',num2str(sigFeatures.trSets));    
    set(phandles.et_vSets,'String',num2str(sigFeatures.vSets));    
    set(phandles.et_tSets,'String',num2str(sigFeatures.tSets));    
    
    %Fill the sig. features field
    allFeatures = fieldnames(sigFeatures.trFeatures);       
    set(phandles.lb_features,'String',allFeatures); 
    set(phandles.lb_features,'Value',1:length(allFeatures));
    
    % Fill the movements lb
    set(phandles.lb_movements,'String',sigFeatures.mov);
        
    %Completion message
    set(handles.t_msg,'String','Treating the data...');
    set(phandles.t_msg,'String','Data analyzed');
    disp(sigFeatures);
    close(GUI_SigTreatment);


% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
    close(GUI_SigTreatment);



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

    Tc = str2double(get(handles.et_cT,'String'));
    Psr = str2double(get(handles.et_cTp,'String'));
    Nr = str2double(get(handles.et_nR,'String'));
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
    lpath   = uigetdir([],'Select the directory with the recSession files');
    spath   = uigetdir(lpath, 'Select a directory to save the sigFeatures');

    % Setting the treatment parameters
    phandles = get(handles.t_mhandles,'UserData'); % get parent GUI handles    

    % Getting the rawdata and treating it
    for rn =1 : 100
        if exist([lpath '\' num2str(rn) '.mat'], 'file')
            % Load recSession
            load([lpath '\' num2str(rn) '.mat']);
            set(handles.t_recSession,'UserData',recSession);
            drawnow();
            % User message
            set(handles.t_msg,'String',['Treating file no:' num2str(rn)]);           
            % Pre-processing
            sigTreated = PreProcessing(handles);            
            % Treat the Data
            sigTreated = TreatData(handles, sigTreated);    
            % get sigFeatures 
            sigFeatures = GetAllSigFeatures(handles, sigTreated);
            % Save the sigFeatures
            save([spath '\' num2str(rn) 't.mat'],'sigFeatures');
        else
            break;
        end 
    end

    set(phandles.t_msg,'String','Folder analyzed');
    close(GUI_SigTreatment);



% --- Executes on button press in pb_preProcessing.
function pb_preProcessing_Callback(hObject, eventdata, handles)
% hObject    handle to pb_preProcessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    sigTreated = PreProcessing(handles);

    %Computer numer of sequencially avialable windows  --------------------
%     nw = fix(sigTreated.cT * sigTreated.cTp * sigTreated.nR / str2double(get(handles.et_tw,'String')));
%     set(handles.et_nw,'String',num2str(nw));
% 
%     trP = str2double(get(handles.et_trP,'String'));
%     trN = fix(trP * nw);
%     set(handles.et_trN,'String',num2str(trN));
% 
%     vP = str2double(get(handles.et_vP,'String'));
%     vN = fix( vP* nw);
%     set(handles.et_vN,'String',num2str(vN));
% 
%     tP = str2double(get(handles.et_tP,'String'));
%     tN = fix(tP * nw);
%     set(handles.et_tN,'String',num2str(tN));
%     set(handles.t_totN,'String',num2str(trN+vN+tN));
%     set(handles.t_totP,'String',num2str(trP+vP+tP));

    % Computer the number of windows using overlapping
    set(handles.et_wOverlap,'Enable','on');
    overlap = str2double(get(handles.et_wOverlap,'String'));

    tT = sigTreated.cT * sigTreated.cTp * sigTreated.nR;
    tw = str2double(get(handles.et_tw,'String'));
    offset = ceil(tw/overlap);
    nw = fix(tT / overlap) - offset;
    set(handles.et_nw,'String',num2str(nw));

    trP = str2double(get(handles.et_trP,'String'));
    trN = fix(trP * nw);
    set(handles.et_trN,'String',num2str(trN));

    vP = str2double(get(handles.et_vP,'String'));
    vN = fix( vP* nw);
    set(handles.et_vN,'String',num2str(vN));

    tP = str2double(get(handles.et_tP,'String'));
    tN = fix(tP * nw);
    %add test time windows so that it matches the total amount of
    %windows
    while trN+vN+tN < nw
        tN = tN + 1;
    end
    set(handles.et_tN,'String',num2str(tN));
    set(handles.t_totN,'String',num2str(trN+vN+tN));
    set(handles.t_totP,'String',num2str(trP+vP+tP));
    
    %Disable and enable bottons -------------------------------------------
    set(handles.lb_movements,'Enable','off');
    set(handles.lb_nCh,'Enable','off');
    set(handles.et_downsample,'Enable','off');
    set(handles.et_noise,'Enable','off');
    set(handles.et_nM,'Enable','off');
    set(handles.et_cTp,'Enable','off');
    set(handles.cb_rest,'Enable','off');
    set(handles.pm_scaling,'Enable','off');
    set(handles.pb_preProcessing,'Enable','off');
    set(handles.pb_treat,'Enable','on');
    set(handles.pb_treatFolder,'Enable','on');
    
    disp(sigTreated);


% --- Executes on selection change in lb_nCh.
function lb_nCh_Callback(hObject, eventdata, handles)
% hObject    handle to lb_nCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_nCh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_nCh


% --- Executes during object creation, after setting all properties.
function lb_nCh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_nCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in pm_frequencyFilters.
function pm_frequencyFilters_Callback(hObject, eventdata, handles)
% hObject    handle to pm_frequencyFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_frequencyFilters contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_frequencyFilters


% --- Executes during object creation, after setting all properties.
function pm_frequencyFilters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_frequencyFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_spatialFilters.
function pm_spatialFilters_Callback(hObject, eventdata, handles)
% hObject    handle to pm_spatialFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_spatialFilters contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_spatialFilters


% --- Executes during object creation, after setting all properties.
function pm_spatialFilters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_spatialFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_twSegMethod.
function pm_twSegMethod_Callback(hObject, eventdata, handles)
% hObject    handle to pm_twSegMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_twSegMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_twSegMethod

    sigTreated = get(handles.t_sigTreated,'UserData');
    sigTreated.eCt      = sigTreated.cT*sigTreated.cTp;      % Effective contraction time

    if get(hObject,'Value') == 1
        %Computer numer of sequencially avialable windows  --------------------
        nw = fix(sigTreated.cT * sigTreated.cTp * sigTreated.nR / str2double(get(handles.et_tw,'String')));
        set(handles.et_nw,'String',num2str(nw));

        trP = str2double(get(handles.et_trP,'String'));
        trN = fix(trP * nw);
        set(handles.et_trN,'String',num2str(trN));

        vP = str2double(get(handles.et_vP,'String'));
        vN = fix( vP* nw);
        set(handles.et_vN,'String',num2str(vN));

        tP = str2double(get(handles.et_tP,'String'));
        tN = fix(tP * nw);
        set(handles.et_tN,'String',num2str(tN));
        set(handles.t_totN,'String',num2str(trN+vN+tN));
        set(handles.t_totP,'String',num2str(trP+vP+tP));
        
    elseif get(hObject,'Value') == 2
        
        set(handles.et_wOverlap,'Enable','on');
        overlap = str2double(get(handles.et_wOverlap,'String'));
        
        tT = sigTreated.cT * sigTreated.cTp * sigTreated.nR;
        tw = str2double(get(handles.et_tw,'String'));
        offset = ceil(tw/overlap);
        nw = fix(tT / overlap) - offset;
        set(handles.et_nw,'String',num2str(nw));

        trP = str2double(get(handles.et_trP,'String'));
        trN = fix(trP * nw);
        set(handles.et_trN,'String',num2str(trN));

        vP = str2double(get(handles.et_vP,'String'));
        vN = fix( vP* nw);
        set(handles.et_vN,'String',num2str(vN));

        tP = str2double(get(handles.et_tP,'String'));
        tN = fix(tP * nw);
        %add test time windows so that it matches the total amount of
        %windows
        while trN+vN+tN < nw
            tN = tN + 1;
        end
        set(handles.et_tN,'String',num2str(tN));
        set(handles.t_totN,'String',num2str(trN+vN+tN));
        set(handles.t_totP,'String',num2str(trP+vP+tP));

        
    end



% --- Executes during object creation, after setting all properties.
function pm_twSegMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_twSegMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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

% selMov = get(handles.lb_movements,'Value');
% set(handles.et_nM,'String',length(selMov));


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


% --- Executes on button press in cb_rest.
function cb_rest_Callback(hObject, eventdata, handles)
% hObject    handle to cb_rest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_rest



function et_wOverlap_Callback(hObject, eventdata, handles)
% hObject    handle to et_wOverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_wOverlap as text
%        str2double(get(hObject,'String')) returns contents of et_wOverlap as a double


% --- Executes during object creation, after setting all properties.
function et_wOverlap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_wOverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_cTp_Callback(hObject, eventdata, handles)
% hObject    handle to et_cTp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_cTp as text
%        str2double(get(hObject,'String')) returns contents of et_cTp as a double


% --- Executes on selection change in pm_SignalSeparation.
function pm_SignalSeparation_Callback(hObject, eventdata, handles)
% hObject    handle to pm_SignalSeparation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_SignalSeparation contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_SignalSeparation


% --- Executes during object creation, after setting all properties.
function pm_SignalSeparation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_SignalSeparation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_downsample_Callback(hObject, eventdata, handles)
% hObject    handle to et_downsample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_downsample as text
%        str2double(get(hObject,'String')) returns contents of et_downsample as a double


% --- Executes during object creation, after setting all properties.
function et_downsample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_downsample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_scaling.
function pm_scaling_Callback(hObject, eventdata, handles)
% hObject    handle to pm_scaling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_scaling contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_scaling


% --- Executes during object creation, after setting all properties.
function pm_scaling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_scaling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_noise_Callback(hObject, eventdata, handles)
% hObject    handle to et_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_noise as text
%        str2double(get(hObject,'String')) returns contents of et_noise as a double


% --- Executes during object creation, after setting all properties.
function et_noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
