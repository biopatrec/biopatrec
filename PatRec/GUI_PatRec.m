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
% 2011-11-25 / Max Ortiz     / Created new version from EMG_AQ 
% 2014-11-07 / Diep Khong    / Added SVM
% 2014-12-01 / Enzo Mastinu  / Added the handling part for the COM port number
                             % information into the parameters
% 2015-04-29 / Cosima P.     / Addition of NetLab
% 2016-11-30 / Niclas N.     / Addition of Feature Selection
% 2018-02-24 / Adam Naber    / Fixed bugs in loading PatRec, SigFeatures,
                             % and SigRecordings
% 20xx-xx-xx / Author       / Comment on update

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

% Last Modified by GUIDE v2.5 19-May-2017 16:56:56

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

backgroundImage2 = importdata('Img/BioPatRec.png');
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
    [file, path] = uigetfile({'*.mat';'*.csv'});
    % Check that the loaded file is a "ss" struct
    if ~isequal(file, 0)
        [pathstr,name,ext] = fileparts(file);
        if(strcmp(ext,'.mat'))
            load([path,file]);
            if (exist('recSession','var'))      % Send a recording session for data treatment

                Load_recSession(recSession, handles);
                %Enable algorithm selection
                set(handles.pm_SelectAlgorithm,'Enable','on');
                set(handles.rb_all,'Enable','on');
                set(handles.rb_top2,'Enable','on');
                set(handles.rb_top3,'Enable','on');
                set(handles.rb_top4,'Enable','on');
                
                set(handles.pm_normSets,'Enable','on'); 
                set(handles.pm_SelectTopology,'Enable','on'); 
                set(handles.pm_movMix,'Enable','on'); 
                set(handles.pm_normSets,'Enable','on');
                set(handles.pm_FeatureReduction,'Enable','on');
                set(handles.et_vSets,'Enable','on');
                set(handles.et_tSets,'Enable','on');
                set(handles.et_trSets,'Enable','on');    
                set(handles.pb_RealtimePatRecMov2Mov,'Enable','off');
                set(handles.pb_RunOfflineTraining,'Enable','on');
                
                
            elseif (exist('recSessionFeatures','var'))         % Get sig_Features
                Load_recSessionFeatures(recSessionFeatures, handles);            
                %Enable algorithm selection
                set(handles.pm_SelectAlgorithm,'Enable','on');
                set(handles.pb_RunOfflineTraining,'Enable','on');
                
                set(handles.pm_normSets,'Enable','on'); 
                set(handles.pm_SelectTopology,'Enable','on'); 
                set(handles.pm_movMix,'Enable','on'); 
                set(handles.pm_normSets,'Enable','on');
                set(handles.pm_FeatureReduction,'Enable','on');
                set(handles.et_vSets,'Enable','on');
                set(handles.et_tSets,'Enable','on');
                set(handles.et_trSets,'Enable','on');    
                set(handles.pb_RealtimePatRecMov2Mov,'Enable','off');
                set(handles.pb_RunOfflineTraining,'Enable','on');

            elseif (exist('sigFeatures','var'))         % Get sig_Features
                Load_sigFeatures(sigFeatures, handles);            
                %Enable algorithm selection
                set(handles.pm_SelectAlgorithm,'Enable','on');
                set(handles.rb_all,'Enable','on');
                set(handles.rb_top2,'Enable','on');
                set(handles.rb_top3,'Enable','on');
                set(handles.rb_top4,'Enable','on'); 
                set(handles.pb_RunOfflineTraining,'Enable','on');
                
                set(handles.pm_normSets,'Enable','on'); 
                set(handles.pm_SelectTopology,'Enable','on'); 
                set(handles.pm_movMix,'Enable','on'); 
                set(handles.pm_normSets,'Enable','on');
                set(handles.pm_FeatureReduction,'Enable','on');
                set(handles.et_vSets,'Enable','on');
                set(handles.et_tSets,'Enable','on');
                set(handles.et_trSets,'Enable','on');    
                set(handles.pb_RealtimePatRecMov2Mov,'Enable','off');
                set(handles.pb_RunOfflineTraining,'Enable','on');

            elseif (exist('treated_data','var'))         % Get sig_Features
                Load_sigFeatures(treated_data, handles);            
                %Enable algorithm selection
                set(handles.pm_SelectAlgorithm,'Enable','on');
                set(handles.rb_all,'Enable','on');
                set(handles.rb_top2,'Enable','on');
                set(handles.rb_top3,'Enable','on');
                set(handles.rb_top4,'Enable','on'); 
                
                set(handles.pm_normSets,'Enable','on'); 
                set(handles.pm_SelectTopology,'Enable','on'); 
                set(handles.pm_movMix,'Enable','on'); 
                set(handles.pm_normSets,'Enable','on');
                set(handles.pm_FeatureReduction,'Enable','on');
                set(handles.et_vSets,'Enable','on');
                set(handles.et_tSets,'Enable','on');
                set(handles.et_trSets,'Enable','on');    
                set(handles.pb_RealtimePatRecMov2Mov,'Enable','off');
                set(handles.pb_RunOfflineTraining,'Enable','on');

            elseif (exist('patRec','var'))              % Get patRec
                Load_patRec(patRec, 'GUI_PatRec',[]);
                set(handles.pm_normSets,'Enable','off'); 
                set(handles.pm_SelectTopology,'Enable','off'); 
                set(handles.pm_movMix,'Enable','off');
                set(handles.pm_FeatureReduction,'Enable','off');
                set(handles.pm_SelectTraining,'Enable','off');
                set(handles.pm_SelectAlgorithm,'Enable','off');
                set(handles.pb_RunOfflineTraining,'Enable','off');
                set(handles.et_vSets,'Enable','off');
                set(handles.et_tSets,'Enable','off');
                set(handles.et_trSets,'Enable','off');
    %           set(handles.pb_RealtimePatRec,'Enable','on');    
    %           set(handles.pb_motionTest,'Enable','on');        
                %Added to enable Mov2Mov-button after loading PatRec
                set(handles.pb_RealtimePatRecMov2Mov,'Enable','on');
                %Load all values from the patRec into the GUI.
                set(handles.et_accuracy,'String',num2str(patRec.performance.acc(end)));
                set(handles.lb_accuracy,'String',num2str(patRec.performance.acc(1:end-1)));
                set(handles.et_accTrue,'String',num2str(patRec.performance.accTrue(end)));
                set(handles.lb_accTrue,'String',num2str(patRec.performance.accTrue(1:end-1)));
                set(handles.et_specificity,'String',num2str(patRec.performance.specificity(end)));
                set(handles.lb_specificity,'String',num2str(patRec.performance.specificity(1:end-1)));
                set(handles.et_recall,'String',num2str(patRec.performance.recall(end)));
                set(handles.lb_recall,'String',num2str(patRec.performance.recall(1:end-1)));
                set(handles.et_precision,'String',num2str(patRec.performance.precision(end)));
                set(handles.lb_precision,'String',num2str(patRec.performance.precision(1:end-1)));
                set(handles.et_f1,'String',num2str(patRec.performance.f1(end)));
                set(handles.lb_f1,'String',num2str(patRec.performance.f1(1:end-1)));
                set(handles.et_npv,'String',num2str(patRec.performance.npv(end)));
                set(handles.lb_npv,'String',num2str(patRec.performance.npv(1:end-1)));
                set(handles.et_trTime,'String',num2str(patRec.trTime));
                set(handles.et_tTime,'String',num2str(patRec.tTime));
                disp('%%%%%%%%%%% patRec loaded %%%%%%%%%%%%%');
                set(handles.t_msg,'String','patRec loaded');            
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
        else
            %CSV / MCARE

            fid = fopen(file);
            fullDir = strcat(path,name,ext); % We get the path of the selected file
            fileDir = dir(fullDir); % We use this to get the size, which is a field of dir
            movText = fgetl(fid); % We read the first line
            if verLessThan('matlab','8.4')
                movText = textscan(movText, '%s', 'Delimiter', ',', 'BufSize', fileDir.bytes); %Scans for objects seperated with commas. We use the filesize as buffer
            else
                movText = textscan(movText, '%s', 'Delimiter', ',');
            end
            recSession.mov = movText{1}; %And load them into the recSession
            fclose(fid); %We need to close the file, before we can textscan it with other parameters
            fid = fopen(file);
            if verLessThan('matlab','8.4')
                C = textscan(fid, '%s', 'Delimiter', '\n', 'BufSize', fileDir.bytes); % Scans for objects seperated by line breaks            
            else
                movText = textscan(movText, '%s', 'Delimiter', ',');
            end
            recSession.date = C{1}{2};
            recSession.comm = C{1}{3};
            if strcmp(recSession.comm, 'COM')
                recSession.comn = C{1}{4};
            end
            recSession.sF = csvread(file,3,0,[3, 0, 3, 0]);
            recSession.nM = csvread(file,3,1,[3, 1, 3, 1]);
            recSession.sT = csvread(file, 3,2,[3,2,3,2]);
            recSession.cT = csvread(file, 3,3,[3,3,3,3]);
            recSession.rT = csvread(file, 3,4,[3,4,3,4]);
            recSession.nR = csvread(file, 3,5,[3,5,3,5]);
            recSession.nCh = csvread(file, 3,6,[3,6,3,6]);
            %Loading raw data
            rawData = csvread(file,4,0)';
            %Preallocate memory
            recSession.tdata = zeros(recSession.sF*recSession.cT*recSession.nR*2,recSession.nCh,recSession.nM); 
            %Sorts the data
            for movements = 1 : recSession.nM
                for channels = 1 : recSession.nCh 
                    % We iterate over the repititions, as data from MCARE is exported channel-wise (as a subset of each repitition) 
                    % The system is like this (for 3 repititions and 4
                    % channels)
                    %iterator =
                    % 1 5 9 -> First channel
                    % 2 6 10 -> Second Channel
                    % 3 7 11 -> Third Channel
                    % 4 8 12 -> Fourth Channel
                    % ^ "lines of data" E.g. "1" = first channel from first
                    % repition. "5" = first channel from second repitition.
                    % "2" = second channel from first repitition. 
                    iterator = channels+((movements-1)*(recSession.nCh*recSession.nR)); 
                    for repititions = 1 : recSession.nR
                        recSession.tdata(1+((repititions-1)*(recSession.sF*(recSession.cT+recSession.rT))):repititions*(recSession.sF*(recSession.cT+recSession.rT)),channels,movements) = rawData(:,iterator);
                        iterator = iterator + recSession.nCh;
                    end
                end
            end
            
            Load_recSession(recSession, handles);
            %Enable algorithm selection
            set(handles.pm_SelectAlgorithm,'Enable','on');
            set(handles.rb_all,'Enable','on');
            set(handles.rb_top2,'Enable','on');
            set(handles.rb_top3,'Enable','on');
            set(handles.rb_top4,'Enable','on'); 
        end
    end
    
    
% --- Executes on button press in pb_RunOfflineTraining.
function pb_RunOfflineTraining_Callback(hObject, eventdata, handles)
% hObject    handle to pb_RunOfflineTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Close real-time testing
    % close(GUI_TestPatRec_Mov2Mov);

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

    % Select feature reduction algorithm
    allFeatReducAlg=get(handles.pm_FeatureReduction,'String');
    featReducAlg=char(allFeatReducAlg(get(handles.pm_FeatureReduction,'Value')));

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
    patRec = OfflinePatRec(sigFeatures, selFeatures, randFeatures, normSets, alg, tType, algConf, movMix, topology, confMatFlag, featReducAlg);
        
    % Save and show results
    handles.patRec = patRec;
    guidata(hObject,handles);

    % Save in GUI components to be used by statistics rutines
    % This has to be change 
    set(handles.lb_accuracy,'UserData',patRec.performance.acc);
%     set(handles.lb_precision,'UserData',patRec.performance.precision);
%     set(handles.lb_recall,'UserData',patRec.performance.recall);
%     set(handles.lb_f1,'UserData',patRec.performance.f1);
    set(handles.et_accuracy,'UserData',patRec);
    
    % Update GUI
    set(handles.et_accuracy,'String',num2str(patRec.performance.acc(end),'%.2f'));
    set(handles.lb_accuracy,'String',num2str(patRec.performance.acc(1:end-1),'%.2f'));
    set(handles.et_accTrue,'String',num2str(patRec.performance.accTrue(end),'%.2f'));
    set(handles.lb_accTrue,'String',num2str(patRec.performance.accTrue(1:end-1),'%.2f'));
    set(handles.et_precision,'String',num2str(patRec.performance.precision(end),'%.2f'));
    set(handles.lb_precision,'String',num2str(patRec.performance.precision(1:end-1),'%.2f'));
    set(handles.et_recall,'String',num2str(patRec.performance.recall(end),'%.2f'));
    set(handles.lb_recall,'String',num2str(patRec.performance.recall(1:end-1),'%.2f'));
    set(handles.et_f1,'String',num2str(patRec.performance.f1(end),'%.2f'));
    set(handles.lb_f1,'String',num2str(patRec.performance.f1(1:end-1),'%.2f'));
    set(handles.et_specificity,'String',num2str(patRec.performance.specificity(end),'%.2f'));
    set(handles.lb_specificity,'String',num2str(patRec.performance.specificity(1:end-1),'%.2f'));
    set(handles.et_npv,'String',num2str(patRec.performance.npv(end),'%.2f'));
    set(handles.lb_npv,'String',num2str(patRec.performance.npv(1:end-1),'%.2f'));
    
    set(handles.et_trTime,'String',num2str(patRec.trTime));
    set(handles.et_tTime,'String',num2str(patRec.tTime));
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
        tA = {'Select Training A.','Backpropagation', 'EA', 'PSO'};
        set(handles.pm_SelectTraining,'String',tA);
        set(handles.pb_RunOfflineTraining,'Enable','off');   
        set(handles.pm_normSets,'Value',4);

    elseif strcmp(alg,'Discriminant A.') || strcmp(alg,'DA + RFN')% for LDA
        set(handles.pm_SelectTraining,'Enable','on');
        tA = {'Select Training A.','linear', 'diaglinear', 'quadratic', 'diagquadratic','mahalanobis'};
        set(handles.pm_SelectTraining,'String',tA);
        set(handles.pb_RunOfflineTraining,'Enable','off');   
        set(handles.pm_normSets,'Value',1);

    elseif strcmp(alg,'RFN') % for LDA
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
        
    elseif strcmp(alg,'SVM'); % for SVM
        set(handles.pm_SelectTraining,'Enable','on');
        tA = {'Select Training A.','linear', 'quadratic', 'polynomial', 'rbf', 'mlp'};
        set(handles.pm_SelectTraining,'String',tA);
        set(handles.pm_SelectTraining,'Value',1);
        set(handles.pb_RunOfflineTraining,'Enable','on');
        set(handles.pm_normSets,'Value',4);         

    elseif strcmp(alg,'NetLab MLP') || ...    % for NetLab MLP       
           strcmp(alg,'NetLab GLM')           % for NetLab GLM
        set(handles.pm_SelectTraining,'Enable','on');
        tA = {'Select Out Func','softmax','linear','logistic','proportional','proportional logistic'};
        set(handles.pm_SelectTraining,'String',tA);
        set(handles.pb_RunOfflineTraining,'Enable','off');   
        set(handles.pm_normSets,'Value',4);    
    
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
    
    confMatFlag = get(handles.cb_confMat,'Value');
    
    % safety check
    if isempty(nRep)
        return;
    end
    if nRep < 1
        errordlg('Invalid number','Error')
        return;
    end

    % Init variables
    accCS       = zeros(nRep,nM+1);
    accTrue     = zeros(nRep,nM+1);
    precision   = zeros(nRep,nM+1);
    recall      = zeros(nRep,nM+1);
    f1          = zeros(nRep,nM+1);
    specificity = zeros(nRep,nM+1);
    npv         = zeros(nRep,nM+1);
    
    trTime = zeros(1,nRep);
    tTime = zeros(1,nRep);    
    tStd = inf;
    tAcc = 0;
    % run the training the given number of times
    for i = 1 : nRep
        pb_RunOfflineTraining_Callback(hObject, eventdata, handles);
        
        patRec = get(handles.et_accuracy,'UserData');
        tempPerformance = patRec.performance;
        
        if confMatFlag
            tempConfMat(:,:,i) = patRec.confMat;
        end
        
        accCS(i,:)      = tempPerformance.acc;
        accTrue(i,:)    = tempPerformance.accTrue;
        precision(i,:)  = tempPerformance.precision;
        recall(i,:)     = tempPerformance.recall;
        f1(i,:)         = tempPerformance.f1;
        specificity(i,:)= tempPerformance.specificity;
        npv(i,:)        = tempPerformance.npv;   
        trTime(i)       = patRec.trTime;
        tTime(i)        = patRec.tTime;

        set(handles.t_msg,'String',['Runing ' num2str(i)]);
        drawnow;
       
        % Save the best patRec
%        if std(tempAcc(1:end-1)) <= tStd && tempAcc(end) >= tAcc
        if tempPerformance.acc(end) >= tAcc
%            tStd = std(tempAcc(1:end-1));
            tAcc = tempPerformance.acc(end);
            tempPatRec = patRec;
        end
        
    end
    
    %Save best patRec
    patRec = tempPatRec;
    handles.patRec = patRec;
    guidata(hObject,handles);
    %Old way to transfer data between GUIs
    %set(handles.et_accuracy,'UserData',tempPatRec);    
    
    % Display results
    tAcc = mean(accCS);
    set(handles.et_accuracy,'String',num2str(tAcc(end),'%.2f'));
    set(handles.lb_accuracy,'String',num2str(tAcc(1:end-1)','%.2f'));     
    set(handles.et_trTime,'String',num2str(mean(trTime)));     
    set(handles.et_tTime,'String',num2str(mean(tTime)));     

    set(handles.et_accTrue,'String',num2str(mean(accTrue(:,end)),'%.2f'));
    set(handles.lb_accTrue,'String',num2str(mean(accTrue(:,1:end-1))','%.2f'));
    set(handles.et_precision,'String',num2str(mean(precision(:,end)),'%.2f'));
    set(handles.lb_precision,'String',num2str(mean(precision(:,1:end-1))','%.2f'));
    set(handles.et_recall,'String',num2str(mean(recall(:,end)),'%.2f'));
    set(handles.lb_recall,'String',num2str(mean(recall(:,1:end-1))','%.2f'));
    set(handles.et_f1,'String',num2str(mean(f1(:,end)),'%.2f'));
    set(handles.lb_f1,'String',num2str(mean(f1(:,1:end-1))','%.2f'));
    set(handles.et_specificity,'String',num2str(mean(specificity(:,end)),'%.2f'));
    set(handles.lb_specificity,'String',num2str(mean(specificity(:,1:end-1))','%.2f'));
    set(handles.et_npv,'String',num2str(mean(npv(:,end)),'%.2f'));
    set(handles.lb_npv,'String',num2str(mean(npv(:,1:end-1))','%.2f'));    
    
    
    % plot results
    figure();
    boxplot(accCS,'plotstyle','compact')
    hold on;
    plot(mean(accCS),'r*');
    xlabel('Movements');
    ylabel('Accuracy (class-specific)');

    figure();
    boxplot(accTrue,'plotstyle','compact')
    hold on;
    plot(mean(accTrue),'r*');
    xlabel('Movements');
    ylabel('Accuracy (Global)');
    
    figure();
    boxplot(recall,'plotstyle','compact')
    hold on;
    plot(mean(recall),'r*');
    xlabel('Movements');
    ylabel('Recall');
    
    figure();
    boxplot(precision,'plotstyle','compact')
    hold on;
    plot(mean(precision),'r*');
    xlabel('Movements');
    ylabel('Precision (PPV)');

    figure();
    boxplot(f1,'plotstyle','compact')
    hold on;
    plot(mean(f1),'r*');
    xlabel('Movements');
    ylabel('F1');
    
    figure();
    boxplot(specificity,'plotstyle','compact')
    hold on;
    plot(mean(specificity),'r*');
    xlabel('Movements');
    ylabel('Specificity');
    
    figure();
    boxplot(npv,'plotstyle','compact')
    hold on;
    plot(mean(npv),'r*');
    xlabel('Movements');
    ylabel('Negative Predicted Value (NPV)');
    
    
    
    % Confution matrix    
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

    stats.accCS         = accCS;
    stats.accCSmn       = mean(accCS)';
    stats.accCSstd      = std(accCS)';

    stats.accTrue       = accTrue;
    stats.accTruemn     = mean(accTrue)';
    stats.accTruestd    = std(accTrue)';
    
    stats.recall        = recall;
    stats.recallmn      = mean(recall)';
    stats.recallstd     = std(recall)';
    
    stats.precision     = precision;
    stats.precisionmn   = mean(precision)';
    stats.precisionstd  = std(precision)';
    
    stats.f1            = f1;
    stats.f1mn          = mean(f1)';
    stats.f1std         = std(f1)';
    
    stats.specificity   = specificity;
    stats.specificitymn = mean(specificity)';
    stats.specificitystd= std(specificity)';
    
    stats.npv           = npv;
    stats.npvmn         = mean(npv)';
    stats.npvstd        = std(npv)';
    
    if confMatFlag
        stats.confMat = confMat;    
    end
    stats.trTime    = trTime;
    stats.tTime     = tTime;
    stats.trTimeMean= mean(trTime);
    stats.tTimeMean = mean(tTime);
    
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
    accCS       = zeros(nRep,nM+1,nS);  
    accTrue     = zeros(nRep,nM+1,nS);
    precision   = zeros(nRep,nM+1,nS);
    recall      = zeros(nRep,nM+1,nS);
    f1          = zeros(nRep,nM+1,nS);
    specificity = zeros(nRep,nM+1,nS);
    npv         = zeros(nRep,nM+1,nS);    
    trTime = zeros(nRep,nS);
    tTime = zeros(nRep,nS);
    
    % temporal variable with subjects average
    tAccCS      = zeros(nS,nM+1);
    tAccTrue    = zeros(nS,nM+1);
    tRecall     = zeros(nS,nM+1);
    tPrecision  = zeros(nS,nM+1);
    tF1         = zeros(nS,nM+1);
    tSpecificity= zeros(nS,nM+1);
    tNPV        = zeros(nS,nM+1);
    
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
            pb_RunOfflineTraining_Callback(hObject, eventdata, handles);    
            patRec = get(handles.et_accuracy,'UserData');
            tempPerformance = patRec.performance;            
            
            accCS(j,:,i)      = tempPerformance.acc;
            accTrue(j,:,i)    = tempPerformance.accTrue;
            precision(j,:,i)  = tempPerformance.precision;
            recall(j,:,i)     = tempPerformance.recall;
            f1(j,:,i)         = tempPerformance.f1;
            specificity(j,:,i)= tempPerformance.specificity;
            npv(j,:,i)        = tempPerformance.npv;   
            
            trTime(j,i) = patRec.trTime;
            tTime(j,i)  = patRec.tTime;            
            
            drawnow;
        end        
    
        % save results
        tAccCS(i,:)     = mean(accCS(:,:,i));    
        tAccTrue(i,:)   = mean(accTrue(:,:,i));    
        tRecall(i,:)    = mean(recall(:,:,i));    
        tPrecision(i,:) = mean(precision(:,:,i));    
        tF1(i,:)        = mean(f1(:,:,i));    
        tSpecificity(i,:) = mean(specificity(:,:,i));    
        tNPV(i,:)       = mean(npv(:,:,i));    

        % plot
        figure();
        boxplot(accCS(:,:,i),'plotstyle','compact')
        hold on;
        plot(mean(accCS(:,:,i)),'r*');
        xlabel('Movements');
        ylabel('Accuracy (class-specific)');
    end

    set(handles.t_msg2,'String','');
    
    % plot per movement
    figure();
    boxplot(tAccCS,'plotstyle','compact')
    hold on;
    plot(mean(tAccCS),'r*');
    title('Pattern recognition accuracy, All subjects')
    xlabel('Movements');
    ylabel('Accuracy (class-specific)');
    
    % plots per subject
    figure();
    boxplot(tAccCS(:,1:end-1)','plotstyle','compact')
    hold on;
    plot(mean(tAccCS(:,1:end-1),2),'r*');
    title('Pattern recognition accuracy, All subjects')
    xlabel('Subjects');
    ylabel('Accuracy (class-specific)');
    
    % Signal features
    fIdx = get(handles.lb_features,'Value');
    features = get(handles.lb_features,'String');
    features = features(fIdx);
    
    % Save stats
    patRec          = get(handles.et_accuracy,'UserData');
    stats.nSubjects = nS;
    stats.nRep      = nRep;
    stats.nM        = nM;

    stats.features.features  = features;
    stats.features.trSets    = str2double(get(handles.et_trSets,'String'));
    stats.features.vSets     = str2double(get(handles.et_vSets,'String'));
    stats.features.tSets     = str2double(get(handles.et_tSets,'String'));    
    
    stats.algorithm  = patRec.patRecTrained(end).algorithm;
    stats.training   = patRec.patRecTrained(end).training;
    stats.topology   = patRec.topology;
    stats.norm       = patRec.normSets.type;    
    stats.lastPatRec = patRec;    
    
%     stats.meanSub    = mean(tAccCS(:,end));
%     stats.stdSub     = std(tAccCS(:,end));
%     stats.minSub     = min(tAccCS(:,end));
%     stats.maxSub     = max(tAccCS(:,end));    
%     stats.meanMov    = mean(mean(tAccCS(:,1:end-1)));
%     stats.stdMov     = std(std(tAccCS(:,1:end-1)));
%     stats.minMov     = min(min(tAccCS(:,1:end-1)));
%     stats.maxMov     = max(max(tAccCS(:,1:end-1)));    
% 
%     stats.meanXSub   = tAccCS(:,end);
%     stats.stdXSub    = std(tAccCS(:,1:end-1)')';
%     stats.minXSub    = min(tAccCS(:,1:end-1)')';
%     stats.maxXSub    = max(tAccCS(:,1:end-1)')';
% 
%     stats.meanXMov    = mean(tAccCS(:,1:end-1));
%     stats.stdXMov     = std(tAccCS(:,1:end-1));
%     stats.minXMov     = min(tAccCS(:,1:end-1));
%     stats.maxXMov     = max(tAccCS(:,1:end-1));  

    stats.accCS         = accCS;
    stats.accCSXSub     = tAccCS(:,1:end-1)';
    stats.accCSXMov     = tAccCS;

    stats.accTrue       = accTrue;
    stats.accTrueXSub   = tAccTrue(:,1:end-1)';
    stats.accTrueXMov   = tAccTrue;
    
    stats.recall        = recall;
    stats.recallXSub    = tRecall(:,1:end-1)';
    stats.recallXMov    = tRecall;

    stats.precision     = recall;
    stats.precisionXSub = tPrecision(:,1:end-1)';
    stats.precisionXMov = tPrecision;

    stats.f1            = f1;
    stats.f1XSub        = tF1(:,1:end-1)';
    stats.f1XMov        = tF1;

    stats.specificity     = specificity;
    stats.specificityXSub = tSpecificity(:,1:end-1)';
    stats.specificityXMov = tSpecificity;

    stats.npv           = npv;
    stats.npvXSub       = tNPV(:,1:end-1)';
    stats.npvXMov       = tNPV;

    stats.trTime    = trTime;
    stats.tTime     = tTime;
    
    disp(stats);
    save('stats.mat','stats');

    set(handles.et_accuracy,'String',num2str(mean(tAccCS(:,end)),'%.2f'));
    set(handles.lb_accuracy,'String',num2str(mean(tAccCS(:,1:end-1))','%.2f'));     

    set(handles.et_accTrue,'String',num2str(mean(tAccTrue(:,end)),'%.2f'));
    set(handles.lb_accTrue,'String',num2str(mean(tAccTrue(:,1:end-1))','%.2f'));
    set(handles.et_precision,'String',num2str(mean(tPrecision(:,end)),'%.2f'));
    set(handles.lb_precision,'String',num2str(mean(tPrecision(:,1:end-1))','%.2f'));
    set(handles.et_recall,'String',num2str(mean(tRecall(:,end)),'%.2f'));
    set(handles.lb_recall,'String',num2str(mean(tRecall(:,1:end-1))','%.2f'));
    set(handles.et_f1,'String',num2str(mean(tF1(:,end)),'%.2f'));
    set(handles.lb_f1,'String',num2str(mean(tF1(:,1:end-1))','%.2f'));
    set(handles.et_specificity,'String',num2str(mean(tSpecificity(:,end)),'%.2f'));
    set(handles.lb_specificity,'String',num2str(mean(tSpecificity(:,1:end-1))','%.2f'));
    set(handles.et_npv,'String',num2str(mean(tNPV(:,end)),'%.2f'));
    set(handles.lb_npv,'String',num2str(mean(tNPV(:,1:end-1))','%.2f'));     
    
    set(handles.et_trTime,'String',num2str(mean(mean(trTime,2))));     
    set(handles.et_tTime,'String',num2str(mean(mean(tTime,2))));     
    
    
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


% --- Executes on selection change in pm_FeatureReduction.
function pm_FeatureReduction_Callback(hObject, eventdata, handles)
% hObject    handle to pm_FeatureReduction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_FeatureReduction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_FeatureReduction
    allFeatures = cellstr(get(handles.lb_features,'String'));
    allFeatReducAlg=get(handles.pm_FeatureReduction,'String');
    selFeatReduc=char(allFeatReducAlg(get(handles.pm_FeatureReduction,'Value')));
    if strcmp(selFeatReduc,'PCA')
        set(handles.lb_features,'Value',1:length(allFeatures));
    end


% --- Executes during object creation, after setting all properties.
function pm_FeatureReduction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_FeatureReduction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_precision.
function lb_precision_Callback(hObject, eventdata, handles)
% hObject    handle to lb_precision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_precision contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_precision


% --- Executes during object creation, after setting all properties.
function lb_precision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_precision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox5


% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox6.
function listbox6_Callback(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox6


% --- Executes during object creation, after setting all properties.
function listbox6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on selection change in lb_recall.
function lb_recall_Callback(hObject, eventdata, handles)
% hObject    handle to lb_recall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_recall contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_recall


% --- Executes during object creation, after setting all properties.
function lb_recall_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_recall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_f1.
function lb_f1_Callback(hObject, eventdata, handles)
% hObject    handle to lb_f1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_f1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_f1


% --- Executes during object creation, after setting all properties.
function lb_f1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_f1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_precision_Callback(hObject, eventdata, handles)
% hObject    handle to et_precision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_precision as text
%        str2double(get(hObject,'String')) returns contents of et_precision as a double


% --- Executes during object creation, after setting all properties.
function et_precision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_precision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_f1_Callback(hObject, eventdata, handles)
% hObject    handle to et_f1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_f1 as text
%        str2double(get(hObject,'String')) returns contents of et_f1 as a double


% --- Executes during object creation, after setting all properties.
function et_f1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_f1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% % % %                                                                  
function et_recall_Callback(hObject, eventdata, handles)
% hObject    handle to et_recall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_recall as text
%        str2double(get(hObject,'String')) returns contents of et_recall as a double


% --- Executes during object creation, after setting all properties.
function et_recall_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_recall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_specificity.
function lb_specificity_Callback(hObject, eventdata, handles)
% hObject    handle to lb_specificity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_specificity contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_specificity


% --- Executes during object creation, after setting all properties.
function lb_specificity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_specificity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_specificity_Callback(hObject, eventdata, handles)
% hObject    handle to et_specificity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_specificity as text
%        str2double(get(hObject,'String')) returns contents of et_specificity as a double


% --- Executes during object creation, after setting all properties.
function et_specificity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_specificity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_npv.
function lb_npv_Callback(hObject, eventdata, handles)
% hObject    handle to lb_npv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_npv contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_npv


% --- Executes during object creation, after setting all properties.
function lb_npv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_npv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_npv_Callback(hObject, eventdata, handles)
% hObject    handle to et_npv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_npv as text
%        str2double(get(hObject,'String')) returns contents of et_npv as a double


% --- Executes during object creation, after setting all properties.
function et_npv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_npv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_accTrue.
function lb_accTrue_Callback(hObject, eventdata, handles)
% hObject    handle to lb_accTrue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_accTrue contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_accTrue


% --- Executes during object creation, after setting all properties.
function lb_accTrue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_accTrue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_accTrue_Callback(hObject, eventdata, handles)
% hObject    handle to et_accTrue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_accTrue as text
%        str2double(get(hObject,'String')) returns contents of et_accTrue as a double


% --- Executes during object creation, after setting all properties.
function et_accTrue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_accTrue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
