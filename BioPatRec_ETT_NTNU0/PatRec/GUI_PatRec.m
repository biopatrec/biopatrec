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
% 2011-11-25 / Max Ortiz  / Created new version from EMG_AQ 
% 20xx-xx-xx / Author  / Comment on update

function varargout = GUI_PatRec(varargin)
% GUI_PATREC M-file for GUI_PatRec.fig
%      GUI_PATREC, by itself, creates a new GUI_PATREC or raises the existing
%      singleton*.
%
%      H = GUI_PATREC returns the handle to a new GUI_PATREC or the handle to
%      the existing singleton*.
%
%      GUI_PATREC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PATREC.M with the given input arguments.
%
%      GUI_PATREC('Property','Value',...) creates a new GUI_PATREC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_PatRec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_PatRec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_PatRec

% Last Modified by GUIDE v2.5 06-Nov-2012 11:48:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_PatRec_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_PatRec_OutputFcn, ...
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

% --- Executes just before GUI_PatRec is made visible.
function GUI_PatRec_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_PatRec (see VARARGIN)

set(handles.bg_featuresSelect,'SelectionChangeFcn',@bg_featuresSelect_SelectionChangeFcn);

backgroundImage2 = importdata('/../Img/BioPatRec.png');
%select the axes
axes(handles.axes1);
%place image onto the axes
image(backgroundImage2);
%remove the axis tick marks
axis off

% Choose default command line output for GUI_PatRec
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_PatRec wait for user response (see UIRESUME)
% uiwait(handles.figure1);
movegui(hObject,'center');

% --- Outputs from this function are returned to the command line.
function varargout = GUI_PatRec_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_GetFeatures.
function pb_GetFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to pb_GetFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('%%%%%%%%%%% Loading Data %%%%%%%%%%%%%');
    set(handles.t_msg,'String','Loading Data...');

    % ss needs to be initialized to avoid conflicts with the class ss of
    % matlab. However, this is only necessary for keeping compatibility
    % with EMG_AQ
    ss = [];
    
    % Dialog box to open a file
    [file, path] = uigetfile('*.mat');
    % Check that the loaded file is a "ss" struct
    if ~isequal(file, 0)
        load([path,file]);
        if (exist('recSession','var'))      % Send a recording session for data treatment

            Load_recSession(recSession, handles);
            %Enable algorithm selection
            set(handles.pm_SelectAlgorithm,'Enable','on');
            set(handles.rb_all,'Enable','on');
            set(handles.rb_top2,'Enable','on');
            set(handles.rb_top3,'Enable','on');
            set(handles.rb_top4,'Enable','on'); 
                
        elseif (exist('sigFeatures','var'))         % Get sig_Features
            Load_sigFeatures(sigFeatures, handles);            
            %Enable algorithm selection
            set(handles.pm_SelectAlgorithm,'Enable','on');
            set(handles.rb_all,'Enable','on');
            set(handles.rb_top2,'Enable','on');
            set(handles.rb_top3,'Enable','on');
            set(handles.rb_top4,'Enable','on'); 
            set(handles.pb_RunOfflineTraining,'Enable','on');
            
        elseif (exist('treated_data','var'))         % Get sig_Features
            Load_sigFeatures(treated_data, handles);            
            %Enable algorithm selection
            set(handles.pm_SelectAlgorithm,'Enable','on');
            set(handles.rb_all,'Enable','on');
            set(handles.rb_top2,'Enable','on');
            set(handles.rb_top3,'Enable','on');
            set(handles.rb_top4,'Enable','on'); 

        elseif (exist('patRec','var'))              % Get patRec
            Load_patRec(patRec, 'GUI_PatRec',[]);
            set(handles.pm_normSets,'Enable','off'); 
            set(handles.pm_SelectTopology,'Enable','off'); 
            set(handles.pm_movMix,'Enable','off'); 
            set(handles.pm_normSets,'Enable','off'); 
%           set(handles.pb_RealtimePatRec,'Enable','on');    
%           set(handles.pb_motionTest,'Enable','on');        
            set(handles.pb_RealtimePatRecGUI,'Enable','on');
            %Added to enable Mov2Mov-button after loading PatRec
            set(handles.pb_RealtimePatRecMov2Mov,'Enable','on');
            %Load all values from the patRec into the GUI.
            set(handles.et_accuracy,'String',num2str(patRec.acc(end)));
            set(handles.lb_accuracy,'String',num2str(patRec.acc(1:end-1)));        
            set(handles.et_trTime,'String',num2str(patRec.trTime));
            set(handles.et_tTime,'String',num2str(patRec.tTime));
            
        elseif (exist('ss','var'))      % keep compatibility
            if ~isempty(ss)
                recSession.sF  = ss.Fs;
                recSession.sT  = ss.Ts;
                recSession.nM  = ss.Ne;
                recSession.nR  = ss.Nr;
                recSession.cT  = ss.Tc;
                recSession.rT  = ss.Tr;
                recSession.cTp = ss.Psr;
                recSession.mov = ss.msg;
                recSession.date   = ss.date;
                recSession.tdata  = ss.tdata;
                %recSession.trdata = ss.trdata;

                Load_recSession(recSession, handles);            
                %Enable algorithm selection
                set(handles.pm_SelectAlgorithm,'Enable','on');
                set(handles.rb_all,'Enable','on');
                set(handles.rb_top2,'Enable','on');
                set(handles.rb_top3,'Enable','on');
                set(handles.rb_top4,'Enable','on'); 
            else
                disp('That was not a valid training matrix');
                errordlg('That was not a valid training matrix','Error');
                return;                
            end           
        end
    end

   
    
    
% --- Executes on button press in pb_RunOfflineTraining.
function pb_RunOfflineTraining_Callback(hObject, eventdata, handles)
% hObject    handle to pb_RunOfflineTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Close real-time testing
    close(GUI_TestPatRec_Mov2Mov);

    set(handles.t_msg,'String','Offline PatRec Started...');
%    set(handles.pb_RunOfflineTraining,'Enable','Off');    
    drawnow;

    % Check that a topology has been selected
    if get(handles.pm_SelectTopology,'Value') == 1
        set(handles.t_msg,'String','Please select a classifier topology before continue');
        return;
    end
    
    % Check that a mix of movements has been selected
    if get(handles.pm_movMix,'Value') == 1
        set(handles.t_msg,'String','Please select the mix of movements to be used');
        return;
    end

    % Collet sigFeatures
    sigFeatures = get(handles.t_sigFeatures,'UserData');
    if isempty(sigFeatures)    
        set(handles.t_msg,'String','No treated data loaded!!!');
        return;
    end
    % Update to the effective number of set to be used
    sigFeatures.eTrSets = str2double(get(handles.et_trSets,'String'));
    sigFeatures.eVSets = str2double(get(handles.et_vSets,'String'));
    sigFeatures.eTSets = str2double(get(handles.et_tSets,'String'));    
    
    %Normalize
    allNormSets = get(handles.pm_normSets,'String');
    normSets    = char(allNormSets(get(handles.pm_normSets,'Value')));    

    % Movements mix or individual movements?
    allMovMixes = get(handles.pm_movMix,'String');
    movMix      = char(allMovMixes(get(handles.pm_movMix,'Value')));    

    %Randomize data
    randFeatures = get(handles.cb_randomizeSets,'Value');
    
    %Confusion matrix
    confMatFlag = get(handles.cb_confMat,'Value');
    
    % Signal features
    fIdx = get(handles.lb_features,'Value');
    features = get(handles.lb_features,'String');
    selFeatures = features(fIdx);   % Selected features        
    
    %Algorithm selection   
    allAlg      = get(handles.pm_SelectAlgorithm,'String');
    alg         = char(allAlg(get(handles.pm_SelectAlgorithm,'Value')));
    allTypes    = get(handles.pm_SelectTraining,'String');
    tType       = char(allTypes(get(handles.pm_SelectTraining,'Value')));
    if isfield(handles,'algConf')
        algConf = handles.algConf;
    else
        algConf = [];
    end

    %Select topology
    allTopologies = get(handles.pm_SelectTopology,'String');
    topology      = char(allTopologies(get(handles.pm_SelectTopology,'Value')));
    
    % Call rutine for offline pat rec
    patRec = OfflinePatRec(sigFeatures, selFeatures, randFeatures, normSets, alg, tType, algConf, movMix, topology, confMatFlag);
        
    % Save and show results
    handles.patRec = patRec;
    guidata(hObject,handles);

    % Save in GUI components to be used by statistics rutines
    % This has to be change 
    set(handles.lb_accuracy,'UserData',patRec.acc);
    set(handles.et_accuracy,'UserData',patRec);
    
    % Update GUI
    set(handles.et_accuracy,'String',num2str(patRec.acc(end)));
    set(handles.lb_accuracy,'String',num2str(patRec.acc(1:end-1)));        
    set(handles.et_trTime,'String',num2str(patRec.trTime));
    set(handles.et_tTime,'String',num2str(patRec.tTime));
    set(handles.pb_RealtimePatRecGUI,'Enable','on');   
    set(handles.pb_RealtimePatRecMov2Mov,'Enable','on');   
    set(handles.t_msg,'String','Off-line Training Completed');  
    disp(patRec);
%    GUI_PatRec;
    

% --- Executes on selection change in pm_SelectAlgorithm.
function pm_SelectAlgorithm_Callback(hObject, eventdata, handles)
% hObject    handle to pm_SelectAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_SelectAlgorithm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_SelectAlgorithm

    allAlg = get(handles.pm_SelectAlgorithm,'String');
    alg    = char(allAlg(get(handles.pm_SelectAlgorithm,'Value')));

%    alg = get(hObject,'Value'); %returns pm_SelectAlgorithm contents as cell array
    if strcmp(alg,'Select Algorithm') % No algorithm selected    
        set(handles.pm_SelectTraining,'Enable','off');
        set(handles.pb_RunOfflineTraining,'Enable','off');   
        set(handles.pm_SelectTraining,'Value',1);
        set(handles.pm_normSets,'Value',1);
        
    elseif strcmp(alg,'MLP') || ...  % for MLP
           strcmp(alg,'MLP + RFN') || ...
           strcmp(alg,'MLP thOut')
       
        set(handles.pm_SelectTraining,'Enable','on');
        tA = {'Select Training A.','Backpropagation', 'PSO'};
        set(handles.pm_SelectTraining,'String',tA);
        set(handles.pb_RunOfflineTraining,'Enable','off');   
        set(handles.pm_normSets,'Value',4);

    elseif strcmp(alg,'Discriminant A.') || strcmp(alg,'DA + RFN')% for LDA
        set(handles.pm_SelectTraining,'Enable','on');
        tA = {'Select Training A.','linear', 'diaglinear', 'quadratic', 'diagquadratic','mahalanobis'};
        set(handles.pm_SelectTraining,'String',tA);
        set(handles.pb_RunOfflineTraining,'Enable','off');   
        set(handles.pm_normSets,'Value',1);

    elseif strcmp(alg,'RFN')
        set(handles.pm_SelectTraining,'Enable','on');
        tA = {'Select Training A.','Mean','Mean + PSO','Exclusive Mean'};
        set(handles.pm_SelectTraining,'String',tA);
        set(handles.pb_RunOfflineTraining,'Enable','on');   
        set(handles.pm_SelectTraining,'Value',2);
        set(handles.pm_normSets,'Value',3);        

    elseif strcmp(alg,'SOM') || strcmp(alg,'SSOM') % for SOM and Supervised SOM
        GUI_SOM();        
        set(handles.pm_SelectTraining,'Enable','on');
        tA = {'Select Training A.','Stochastic', 'Batch'};
        set(handles.pm_SelectTraining,'String',tA);
        set(handles.pm_SelectTraining,'Value',1);
        set(handles.pb_RunOfflineTraining,'Enable','off');
        set(handles.pm_normSets,'Value',5);
    
    elseif strcmp(alg,'KNN') % for KNN
        set(handles.pm_SelectTraining,'Enable','on');
        tA = {'Select Training A.','Euclidean'};
        set(handles.pm_SelectTraining,'String',tA);
        set(handles.pm_SelectTraining,'Value',1);
        set(handles.pb_RunOfflineTraining,'Enable','off');
        set(handles.pm_normSets,'Value',5);        
        
    elseif strcmp(alg,'Proportional Control')
        set(handles.pm_SelectTraining,'Enable','on');
        tA = {'Select estimator A.', 'Normal linear estimator', ...
            'Decoupled linear estimator'};
        set(handles.pm_SelectTraining,'String',tA);
        set(handles.pm_SelectTraining,'Value',2);       % Default estimator
        set(handles.pm_normSets,'Value',1);
%         set(handles.pm_movMix,'Value',2);
        set(handles.pm_SelectTopology,'Value',2);
        set(handles.pb_RunOfflineTraining,'Enable','on');
        
       
    end
        



% --- Executes during object creation, after setting all properties.
function pm_SelectAlgorithm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_SelectAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_SelectTraining.
function pm_SelectTraining_Callback(hObject, eventdata, handles)
% hObject    handle to pm_SelectTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_SelectTraining contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_SelectTraining
            set(handles.pb_RunOfflineTraining,'Enable','on');   

% --- Executes during object creation, after setting all properties.
function pm_SelectTraining_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_SelectTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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


% --- Executes on selection change in lb_movements.
function lb_movements_Callback(hObject, eventdata, handles)
% hObject    handle to lb_movements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_movements contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_movements


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



function et_vSets_Callback(hObject, eventdata, handles)
% hObject    handle to et_vSets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_vSets as text
%        str2double(get(hObject,'String')) returns contents of et_vSets as a double


% --- Executes during object creation, after setting all properties.
function et_vSets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_vSets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_tSets_Callback(hObject, eventdata, handles)
% hObject    handle to et_tSets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_tSets as text
%        str2double(get(hObject,'String')) returns contents of et_tSets as a double


% --- Executes during object creation, after setting all properties.
function et_tSets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_tSets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_trSets_Callback(hObject, eventdata, handles)
% hObject    handle to et_trSets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_trSets as text
%        str2double(get(hObject,'String')) returns contents of et_trSets as a double


% --- Executes during object creation, after setting all properties.
function et_trSets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_trSets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function bg_featuresSelect_SelectionChangeFcn(hObject, eventdata)
 
%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 

set(handles.lb_features,'Enable','on');
allFeatures = cellstr(get(handles.lb_features,'String'));
selF = [];

switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'rb_all'
        set(handles.lb_features,'Value',1:length(allFeatures)); 
    case 'rb_top2'
        for i = 1 : size(allFeatures,1)
            if strcmp(allFeatures{i},'tstd')
                selF = [selF i];
            elseif strcmp(allFeatures{i},'twl')
                selF = [selF i];                
            end
        end
        set(handles.lb_features,'Value',selF);    % tmabs, twl, tzc 
    case 'rb_top3'
        for i = 1 : size(allFeatures,1)
            if strcmp(allFeatures{i},'tmabs')
                selF = [selF i];
            elseif strcmp(allFeatures{i},'twl')
                selF = [selF i];                
            elseif strcmp(allFeatures{i},'tzc')
                selF = [selF i];
            end
        end
        set(handles.lb_features,'Value',selF);    % tmabs, twl, tzc 
    case 'rb_top4'
        for i = 1 : size(allFeatures,1)
            if strcmp(allFeatures{i},'tmabs')
                selF = [selF i];
            elseif strcmp(allFeatures{i},'twl')
                selF = [selF i];                
            elseif strcmp(allFeatures{i},'tzc')
                selF = [selF i];
            elseif strcmp(allFeatures{i},'tslpch2')
                selF = [selF i];
            end
        end        
        set(handles.lb_features,'Value',selF); % tmabs, twl, tzc, tslpch EH03, HZ09, SL09   
    otherwise
       % Code for when there is no match.
 
end
%updates the handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function t_Open_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to t_Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cb_normalize.
function cb_normalize_Callback(hObject, eventdata, handles)
% hObject    handle to cb_normalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_normalize


% --- Executes on button press in cb_randomizeSets.
function cb_randomizeSets_Callback(hObject, eventdata, handles)
% hObject    handle to cb_randomizeSets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_randomizeSets



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
function m_Open_Callback(hObject, eventdata, handles)
% hObject    handle to m_Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    pb_GetFeatures_Callback(hObject, eventdata, handles);
%     disp('%%%%%%%%%%% Loading Data %%%%%%%%%%%%%');
%     set(handles.t_msg,'String','Loading Data...');
% 
%     % Dialog box to open a file
%     [file, path] = uigetfile('*.mat');
%     % Check that the loaded file is a "ss" struct
%     if ~isequal(file, 0)
%         load([path,file]);
%         if (exist('recSession','var'))      % Send a recording session for data treatment
% 
%             Load_recSession(recSession, handles);
%             
%         elseif (exist('ss','var'))                  % keep compatibility
%             
%             recSession.sF  = ss.Fs;
%             recSession.sT  = ss.Ts;
%             recSession.nM  = ss.Ne;
%             recSession.nR  = ss.Nr;
%             recSession.cT  = ss.Tc;
%             recSession.rT  = ss.Tr;
%             recSession.cTp = ss.Psr;
%             recSession.mov = ss.msg;
%             recSession.date   = ss.date;
%             recSession.tdata  = ss.tdata;
%             recSession.trdata = ss.trdata;
%             
%             Load_recSession(recSession, handles);            
%     
%         elseif (exist('sigFeatures','var'))         % Get sigFeatures
% 
%             Load_sigFeatures(sigFeatures, handles);            
% 
%         elseif (exist('patRec','var'))              % Get patRec
% 
%             Load_patRec(patRec, 'GUI_PatRec');
%             set(handles.pb_RealtimePatRec,'Enable','on');    
%             set(handles.pb_motionTest,'Enable','on');        
%             set(handles.pb_RealtimePatRecGUI,'Enable','on'); 
% 
%         else
%             disp('That was not a valid training matrix');
%             errordlg('That was not a valid training matrix','Error');
%             return;
%         end
%     end

% --------------------------------------------------------------------
function m_Stats_CurrentD_Callback(hObject, eventdata, handles)
% hObject    handle to m_Stats_CurrentD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    nRep = str2double(inputdlg('Write the number of repetitions','Number of Runs'));
    nM   = size(get(handles.lb_movements,'String'),1);    
    
    confMatFlag = get(handles.cb_confMat,'Value')
    
    % safety check
    if isempty(nRep)
        return;
    end
    if nRep < 1
        errordlg('Invalid number','Error')
        return;
    end
    
    % run the training the given number of times
    acc = zeros(nRep,nM+1);
    trTime = zeros(1,nRep);
    tTime = zeros(1,nRep);
    
    tStd = inf;
    tAcc = 0;
    for i = 1 : nRep
        pb_RunOfflineTraining_Callback(hObject, eventdata, handles);
        
        patRec = get(handles.et_accuracy,'UserData');
        tempAcc = patRec.acc;
        %tempAcc = get(handles.lb_accuracy,'UserData');
        %tempAcc = handles.patRec.acc;   % Handles cannot be used because
        %once the training is done, the new "patRec" is not updated into
        %handles since the handles variable was recieved before calling
        %the training.
        
        if confMatFlag
            tempConfMat(:,:,i) = patRec.confMat;
        end
        
        acc(i,:) = tempAcc;
        trTime(i) = patRec.trTime;
        tTime(i) = patRec.tTime;

        set(handles.t_msg,'String',['Runing ' num2str(i)]);
        drawnow;
       
        % Save the best patRec
%        if std(tempAcc(1:end-1)) <= tStd && tempAcc(end) >= tAcc
        if tempAcc(end) >= tAcc
%            tStd = std(tempAcc(1:end-1));
            tAcc = tempAcc(end);
            tempPatRec = patRec;
        end
        
    end
    
    %Save best patRec
    patRec = tempPatRec;
    handles.patRec = patRec;
    guidata(hObject,handles);
    %Old way to transfer data between GUIs
    %set(handles.et_accuracy,'UserData',tempPatRec);    
    
    % show results
    tAcc = mean(acc);
    set(handles.et_accuracy,'String',num2str(tAcc(end)));
    set(handles.lb_accuracy,'String',num2str(tAcc(1:end-1)'));     
    set(handles.et_trTime,'String',num2str(mean(trTime)));     
    set(handles.et_tTime,'String',num2str(mean(tTime)));     
    
    % plot results
    figure();
    boxplot(acc,'plotstyle','compact')
    hold on;
    plot(mean(acc),'r*');
    title('Pattern recognition accuracy')
    xlabel('Movements');
    ylabel('Accuracy');
    
    if confMatFlag
        figure();
        confMat = mean(tempConfMat,3);
        imagesc(confMat);    
        title('Confusion Matrix')
        xlabel('Movements');
        ylabel('Movements');
    end
   
    
    %% Save results
    % Signal features
    fIdx = get(handles.lb_features,'Value');
    features = get(handles.lb_features,'String');
    features = features(fIdx);
    
    % Save stats
    stats.nPatients = 1;
    stats.nRep      = nRep;
    stats.nM        = nM;
    stats.features  = features;
    stats.topology  = patRec.topology;    
    stats.patRecTrained    = patRec.patRecTrained;
    stats.norm      = patRec.normSets;    
    stats.mean      = tAcc;
    stats.std       = std(acc);
    stats.min       = min(acc);
    stats.max       = max(acc);
    stats.acc       = acc;
    if confMatFlag
        stats.confMat   = confMat;    
    end
    stats.trTime   = trTime;
    stats.tTime    = tTime;
    stats.trTimeMean   = mean(trTime);
    stats.tTimeMean    = mean(tTime);
    
    disp(stats);
    save('stats.mat','stats');

    set(handles.t_msg,'String','Statistics completed and saved in "stast.mat" file. Best patRec kept in the GUI');


% --------------------------------------------------------------------
function m_Stats_Group_Callback(hObject, eventdata, handles)
% hObject    handle to m_Stats_Group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    nRep = str2double(inputdlg('Write the number of repetitions','Number of Runs'));
    
    % safety check
    if isempty(nRep)
        return;
    end
    if nRep < 1
        errordlg('Invalid number','Error')
        return;
    end

    % Number of sesions/subjects to analyze
    % automatic detection of number of subjects to analyze
    % they should be in the same folder and have the name "Xt.mat"
    [file path] = uigetfile('*.mat');
    % safety check
    if file == 0
        return;
    end
    for rn =1 : 1000
        if exist([path num2str(rn) 't.mat'],'file')
            nS = rn;    %Number of subjects or sessions
        else
            break;
        end 
    end
    
    % Load the first file to obtain number of movements
    load([path '1t' '.mat']);
    %Load_treated_data(treated_data, handles);
    if exist('sigFeatures','var')
        % do nothing
    elseif exist('treated_data','var')
        sigFeatures = treated_data;
    else
        errordlg('no sigFeatures found','Error')
        return;
    end
    
    nM   = size(get(handles.lb_movements,'String'),1);
    acc  = zeros(nRep,nM+1,nS);  
    trTime = zeros(nRep,nS);
    tTime = zeros(nRep,nS);
    tAcc = zeros(nS,nM+1);
    
    for i = 1 : nS
        % load data
        load([path num2str(i) 't' '.mat']);
        if exist('sigFeatures','var')
            % do nothing
        elseif exist('treated_data','var')
            sigFeatures = treated_data;
        else
            errordlg('no sigFeatures found','Error')
            return;
        end
        % Load the sigFeatures
        set(handles.t_sigFeatures,'UserData',sigFeatures);            
%        Load_sigFeatures(sigFeatures, handles);

        % run the training the given number of times
        for j = 1 : nRep
            set(handles.t_msg2,'String',['Statistics Rep: ' num2str(j) ' from subject: ' num2str(i)]);

            pb_RunOfflineTraining_Callback(hObject, eventdata, handles)
            patRec = get(handles.et_accuracy,'UserData');
            acc(j,:,i) = get(handles.lb_accuracy,'UserData');
            trTime(j,i) = patRec.trTime;
            tTime(j,i) = patRec.tTime;
            
            drawnow;
        end        
    
        % show results
        tAcc(i,:) = mean(acc(:,:,i));
        set(handles.et_accuracy,'String',num2str(tAcc(i,end)));
        set(handles.lb_accuracy,'String',num2str(tAcc(i,1:end-1)'));     

        % plot
        figure();
        boxplot(acc(:,:,i),'plotstyle','compact')
        hold on;
        plot(mean(acc(:,:,i)),'r*');
        title(['Pattern recognition accuracy: #' num2str(i)]);
        xlabel('Movements');
        ylabel('Accuracy');
    end

    set(handles.t_msg2,'String','');
    
    % plot per movement
    figure();
    boxplot(tAcc,'plotstyle','compact')
    hold on;
    plot(mean(tAcc),'r*');
    title('Pattern recognition accuracy, All subjects')
    xlabel('Movements');
    ylabel('Accuracy');
    
    % plots per subject
    figure();
    boxplot(tAcc(:,1:end-1)','plotstyle','compact')
    hold on;
    plot(mean(tAcc(:,1:end-1),2),'r*');
    title('Pattern recognition accuracy, All subjects')
    xlabel('Subjects');
    ylabel('Accuracy');
    
    % Signal features
    fIdx = get(handles.lb_features,'Value');
    features = get(handles.lb_features,'String');
    features = features(fIdx);
    
    % Save stats
    patRec = get(handles.et_accuracy,'UserData');
    stats.nSubjects = nS;
    stats.nRep      = nRep;
    stats.nM        = nM;
    stats.features  = features;
    stats.algorithm = patRec.patRecTrained(end).algorithm;
    stats.training  = patRec.patRecTrained(end).training;
    stats.topology  = patRec.topology;
    stats.norm      = patRec.normSets.type;    
    stats.meanSub    = mean(tAcc(:,end));
    stats.stdSub     = std(tAcc(:,end));
    stats.minSub     = min(tAcc(:,end));
    stats.maxSub     = max(tAcc(:,end));    
    stats.meanMov    = mean(mean(tAcc(:,1:end-1)));
    stats.stdMov     = std(std(tAcc(:,1:end-1)));
    stats.minMov     = min(min(tAcc(:,1:end-1)));
    stats.maxMov     = max(max(tAcc(:,1:end-1)));    

    stats.meanXSub   = tAcc(:,end);
    stats.stdXSub    = std(tAcc(:,1:end-1)')';
    stats.minXSub    = min(tAcc(:,1:end-1)')';
    stats.maxXSub    = max(tAcc(:,1:end-1)')';

    stats.meanXMov    = mean(tAcc(:,1:end-1));
    stats.stdXMov     = std(tAcc(:,1:end-1));
    stats.minXMov     = min(tAcc(:,1:end-1));
    stats.maxXMov     = max(tAcc(:,1:end-1));  

    stats.accXSub    = tAcc(:,1:end-1)';
    stats.accXMov    = tAcc;
    stats.accAll     = acc;

    stats.trTime    = trTime;
    stats.tTime    = tTime;
    
    disp(stats);
    save('stats.mat','stats');

    set(handles.et_accuracy,'String',num2str(stats.meanMov));
    set(handles.lb_accuracy,'String',num2str(stats.meanXMov'));     

    set(handles.t_msg,'String','Statistics completed and saved in the "stast.mat" file');


% --------------------------------------------------------------------
function m_Save_sigFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to m_Save_recSession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    sigFeatures = get(handles.t_sigFeatures,'UserData');

    if ~isempty(sigFeatures)
        [filename, pathname] = uiputfile({'*.mat','MAT-files (*.mat)'},'Save as', 'Untitled.mat');
        save([pathname,filename],'sigFeatures');
        set(handles.t_msg,'String','sigFeatures saved');
    else
        set(handles.t_msg,'String','No data to save!');    
    end

% --------------------------------------------------------------------
function m_Save_patRec_Callback(hObject, eventdata, handles)
% hObject    handle to m_Save_patRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    patRec = handles.patRec;

    if ~isempty(patRec)
        [filename, pathname] = uiputfile({'*.mat','MAT-files (*.mat)'},'Save as', 'Untitled.mat');
        save([pathname,filename],'patRec');
        set(handles.t_msg,'String','patRec saved');
    else
        set(handles.t_msg,'String','No patRec found. No data saved');    
    end


% --- Executes on button press in pb_RealtimePatRec.
function pb_RealtimePatRec_Callback(hObject, eventdata, handles)
% hObject    handle to pb_RealtimePatRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%    patRec = get(handles.et_accuracy,'UserData');
    patRec = handles.patRec;
    
    % validation of patRec loaded
    if isempty(patRec)
        set(handles.t_msg,'String','No patRec to test');        
        return
    end
    
%     %update sigfeatures lb
%     if get(handles.lb_features,'Value') == 0
%         set(handles.lb_features,'Value',1:length(patRec.selFeatures));
%         set(handles.lb_features,'String',patRec.selFeatures); 
%     else
%         set(handles.lb_features,'Enable','off');
%     end
    
    % Run realtime patrec
    set(handles.t_msg,'String','Real time PatRec started...');      
    drawnow;
    RealtimePatRec(patRec, handles);
    set(handles.t_msg,'String','Real time PatRec finished');      




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

    patRec = get(handles.et_accuracy,'UserData');
    
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


% --- Executes on button press in cb_indvMov.
function cb_indvMov_Callback(hObject, eventdata, handles)
% hObject    handle to cb_indvMov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_indvMov


% --- Executes on selection change in pm_normSets.
function pm_normSets_Callback(hObject, eventdata, handles)
% hObject    handle to pm_normSets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_normSets contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_normSets


% --- Executes during object creation, after setting all properties.
function pm_normSets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_normSets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_RealtimePatRecGUI.
function pb_RealtimePatRecGUI_Callback(hObject, eventdata, handles)
% hObject    handle to pb_RealtimePatRecGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % validation of patRec loaded
    if ~isfield(handles,'patRec')
        set(handles.t_msg,'String','No patRec to test');        
        return
    end
        
    % Run motion test
    Load_patRec(handles.patRec, 'GUI_TestPatRec',[]);


% --- Executes on selection change in pm_SelectTopology.
function pm_SelectTopology_Callback(hObject, eventdata, handles)
% hObject    handle to pm_SelectTopology (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_SelectTopology contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_SelectTopology


% --- Executes during object creation, after setting all properties.
function pm_SelectTopology_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_SelectTopology (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_movMix.
function pm_movMix_Callback(hObject, eventdata, handles)
% hObject    handle to pm_movMix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_movMix contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_movMix


% --- Executes during object creation, after setting all properties.
function pm_movMix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_movMix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_RealtimePatRecMov2Mov.
function pb_RealtimePatRecMov2Mov_Callback(hObject, eventdata, handles)
% hObject    handle to pb_RealtimePatRecMov2Mov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % validation of patRec loaded
    if ~isfield(handles,'patRec')
        set(handles.t_msg,'String','No patRec to test');        
        return
    end
        
    % Load GUI
    Load_patRec(handles.patRec, 'GUI_TestPatRec_Mov2Mov',1);

% --- Executes on button press in cb_confMat.
function cb_confMat_Callback(hObject, eventdata, handles)
% hObject    handle to cb_confMat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_confMat



function et_trTime_Callback(hObject, eventdata, handles)
% hObject    handle to et_trTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_trTime as text
%        str2double(get(hObject,'String')) returns contents of et_trTime as a double


% --- Executes during object creation, after setting all properties.
function et_trTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_trTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_tTime_Callback(hObject, eventdata, handles)
% hObject    handle to et_tTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_tTime as text
%        str2double(get(hObject,'String')) returns contents of et_tTime as a double


% --- Executes during object creation, after setting all properties.
function et_tTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_tTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_floorNoise.
function cb_floorNoise_Callback(hObject, eventdata, handles)
% hObject    handle to cb_floorNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_floorNoise
