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
% GUI for analysis of data from recording session. 
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-02-12 / Niclas Nilsson  / Creation
% 20xx-xx-xx / Author  / Comment on update

function varargout = GUI_DataAnalysis(varargin)
% GUI_DATAANALYSIS MATLAB code for GUI_DataAnalysis.fig
%      GUI_DATAANALYSIS, by itself, creates a new GUI_DATAANALYSIS or raises the existing
%      singleton*.
%
%      H = GUI_DATAANALYSIS returns the handle to a new GUI_DATAANALYSIS or the handle to
%      the existing singleton*.
%
%      GUI_DATAANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DATAANALYSIS.M with the given input arguments.
%
%      GUI_DATAANALYSIS('Property','Value',...) creates a new GUI_DATAANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_DataAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_DataAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_DataAnalysis

% Last Modified by GUIDE v2.5 19-Oct-2016 11:59:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_DataAnalysis_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_DataAnalysis_OutputFcn, ...
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


% --- Executes just before GUI_DataAnalysis is made visible.
function GUI_DataAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_DataAnalysis (see VARARGIN)

% Choose default command line output for GUI_DataAnalysis
handles.output = hObject;

% Saving varargin in handles
handles.varargin = varargin;

if ~isempty(varargin)
    % check if in recordingSession
    analysis.inRecSes = false;
    if length(varargin)>1
        analysis.inRecSes = true;
        analysis.recVarargin = varargin{2};
    end
    
    % Initialization default values
    analysis.limit = 90;
    set(handles.f_main,'UserData',analysis);
    
    % Setting GUI
    childrens = get(handles.f_main,'Children');
    %set(childrens,'FontSize',10,'FontUnits','points');
    %set(handles.t_mahalanobis,'FontSize',9,'FontUnits','points');
end
% Setting enables
set(handles.pm_classifier,'Enable','off');
set(handles.pm_method,'Enable','off');
set(handles.pb_setLimit,'Enable','off');
set(handles.et_accLimit,'Enable','off');
set(handles.pb_save,'Enable','off');
set(handles.pb_undo,'Enable','off');
set(handles.pb_delete,'Enable','off');
set(handles.pb_replace,'Enable','off');
set(handles.pb_extractFeatures,'Enable','off');
set(handles.pb_featureSelection,'Enable','off');
set(handles.pb_hudgins,'Enable','off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_DataAnalysis wait for user response (see UIRESUME)
% uiwait(handles.f_main);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_DataAnalysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_extractFeatures.
function pb_extractFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to pb_extractFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

analysis = get(handles.f_main,'UserData');

analysis.anDataM = GetAnalysisFeatures(handles);
analysis.method = '';  % To make sure CCEs are updated
set(handles.f_main,'UserData',analysis);

handles = updateGUI(handles);
handles = updateCCE(handles);
handles = updatePred(handles);
tmpObj = findobj(handles.am_distances(1));
am_distances_ButtonDownFcn(tmpObj(1), eventdata, handles, 1);

% Enable GUI
set(handles.pm_classifier,'Enable','on');
set(handles.pm_method,'Enable','on');
set(handles.pb_setLimit,'Enable','on');
set(handles.et_accLimit,'Enable','on');
set(handles.pb_save,'Enable','on');
set(handles.pb_undo,'Enable','on');
set(handles.pb_delete,'Enable','on');
if analysis.inRecSes
    set(handles.pb_replace,'Enable','on');
end
guidata(hObject, handles);

% --- Executes on selection change in pm_method.
function pm_method_Callback(hObject, eventdata, handles)
% hObject    handle to pm_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_method
handles = updateCCE(handles);
analysis = get(handles.f_main,'UserData');
tmpObj = findobj(handles.am_distances(analysis.selectedMov));
am_distances_ButtonDownFcn(tmpObj(1), eventdata, handles, analysis.selectedMov);
handles = updatePred(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pm_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on mouse press over axes background.
function am_distances_ButtonDownFcn(hObject, eventdata, handles, m)
% hObject    handle to am_distances (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

analysis = get(handles.f_main,'UserData');
if m ~= analysis.selectedMov
    % Updating marker
    set(handles.am_distances(m),'LineWidth',3)
    set(handles.am_distances(analysis.selectedMov),'LineWidth',1)
    
    % Collecting object m
    sigFeatures = analysis.sigFeatures;
    className = sigFeatures.mov{m};
    
    % Updating big plot
    cla(handles.a_distance);
    copyobj(get(handles.am_distances(m),'Children'),handles.a_distance);
    axis(handles.a_distance,[get(handles.am_distances(m),'XLim') get(handles.am_distances(m),'YLim')]);
    children = get(handles.a_distance,'Children');
    set(children(1),'MarkerSize',20);
    set(children(2),'MarkerSize',5,'Marker','o');
    hold(handles.a_distance,'on');
    plot(handles.a_distance,[mean(get(children(1),'XData')) mean(get(children(2),'XData'))],[mean(get(children(1),'YData')) mean(get(children(2),'YData'))],'x-','Color',[0 0 0],'MarkerSize',8,'Linewidth',1.5);
    legend(handles.a_distance,{[className ' (Conserned Movement)'],[analysis.neighborName{m} ' (Closest Neighbor)'], [analysis.method ' : ' num2str(analysis.mCCE(m),2)]});
    set(handles.a_distance,'Visible','on','Box','on','XTick',[],'YTick',[]);
    
    % Updating prediction plot
    if isfield(analysis,'predObj');
        delete(analysis.predObj);
    end
    h = plot(handles.a_prediction,[analysis.mCCE(m) analysis.mCCE(m)],[0 100],'r--');
    % Updating selected movement
    [exInLb,sM] = ismember(sigFeatures.mov{m},get(handles.lb_movements,'String'));
    if exInLb
        set(handles.lb_movements,'Value',sM);
    end
    analysis.selectedMov = m;
    analysis.predObj = h;
    set(handles.f_main,'UserData',analysis);
    guidata(handles.am_distances(m), handles);
end


% --- Executes on selection change in pm_classifier.
function pm_classifier_Callback(hObject, eventdata, handles)
% hObject    handle to pm_classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_classifier contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_classifier
handles = updatePred(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pm_classifier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function a_prediction_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to a_prediction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure;
a = axes;
copyobj(hObject.Children,a);
axis(a,[hObject.XLim hObject.YLim]);
xlabel(a,'Classification Complexity');
ylabel(a,'Predicted Accuracy');
legend(a.Children([5 2 1]),{'Measured Data' 'Line Fitted to Measured Data' 'Classification Complexity of the Selected Movement'});

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


% --- Executes on button press in pb_replace.
function pb_replace_Callback(hObject, eventdata, handles)
% hObject    handle to pb_replace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
analysis = get(handles.f_main,'UserData');
repMovV = get(handles.lb_movements,'Value');
repMovS = get(handles.lb_movements,'String');

% Editing varargin to re-record selected movments
analysis.recVarargin{1} = length(repMovV);
analysis.recVarargin{5} = repMovS(repMovV);
analysis.recVarargin{end+1} = 'replace';
recSession = handles.varargin{1};

% Updating recSsession
[~,pos] = ismember(repMovS(repMovV),recSession.mov);
recSession.tdata(:,:,pos) = RecordingSession(analysis.recVarargin{:});
figure(handles.f_main);
handles.varargin{1} = recSession;

% Updating GUI
pb_GetFeatures_Callback(hObject, eventdata, handles);

guidata(hObject, handles);


% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mov = get(handles.lb_movements,'String');
mov = mov(1:end);
dlgTitle    = 'Select Format';
dlgQuestion = 'Select your desired format:';
choice = questdlg(dlgQuestion,dlgTitle,'recSession','sigFeatures', 'sigFeatures');
if strcmp(choice,'recSession')
    recSession = handles.varargin{1};
    [~,pos] = ismember(mov,recSession.mov);
    pos = pos(pos~=0);
    recSession.tdata = recSession.tdata(:,:,pos);
    recSession.mov = recSession.mov(pos);
    recSession.nM = length(pos);
else
    sigFeatures = get(handles.t_sigFeatures,'UserData');
    sigFeatures.nM = length(mov);
    [~,pos] = ismember(mov,sigFeatures.mov);
    sigFeatures.trFeatures = sigFeatures.trFeatures(:,pos);
    sigFeatures.vFeatures = sigFeatures.vFeatures(:,pos);
    sigFeatures.tFeatures = sigFeatures.tFeatures(:,pos);
    sigFeatures.mov = mov;
end
[filename, pathname] = uiputfile({'*.mat','MAT-files (*.mat)'},'Save as', 'Untitled.mat');
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
else
    disp(['User selected ', fullfile(pathname, filename)])
    save([pathname,filename],choice);
end
disp(eval(choice));


% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(GUI_DataAnalysis);


% --- Executes on button press in pb_delete.
function pb_delete_Callback(hObject, eventdata, handles)
% hObject    handle to pb_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected = get(handles.lb_movements,'Value');
mov = get(handles.lb_movements,'String');
movInd = 1:length(mov);
if selected(end) == movInd(end)
    selected = selected(1:end-1);
end
movInd = movInd(~ismember(movInd,selected));
set(handles.lb_movements,'String',mov(movInd));
set(handles.lb_movements,'Value',1);


% --- Executes on button press in pb_undo.
function pb_undo_Callback(hObject, eventdata, handles)
% hObject    handle to pb_undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sigFeatures = get(handles.t_sigFeatures,'UserData');
set(handles.lb_movements,'String',sigFeatures.mov);


% --- Executes on selection change in lb_features.
function lb_features_Callback(hObject, eventdata, handles)
% hObject    handle to lb_features (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_features contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_features
features = get(hObject,'Value');
if length(features)*length(get(handles.lb_channels,'Value')) < 2 
    if features == 1
        set(hObject,'Value',[features 2]);
    else
        set(hObject,'Value',[features 1]);
    end
end


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

function et_accLimit_Callback(hObject, eventdata, handles)
% hObject    handle to et_accLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_accLimit as text
%        str2double(get(hObject,'String')) returns contents of et_accLimit as a double
analysis = get(handles.f_main,'UserData');
limit = str2double(get(hObject,'String'));
if ~isnan(limit) && isreal(limit) && limit >= 0 && limit <= 100
    analysis = get(handles.f_main,'UserData');
    analysis.limit = limit;
    set(handles.f_main,'UserData',analysis);
    handles = updatePred(handles);
    guidata(hObject, handles);
else
    set(hObject,'String',num2str(analysis.limit));
end



% --- Executes during object creation, after setting all properties.
function et_accLimit_CreateFcn(hObject, eventdata, ~)
% hObject    handle to et_accLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_setLimit.
function pb_setLimit_Callback(hObject, eventdata, handles)
% hObject    handle to pb_setLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
et_accLimit_Callback(handles.et_accLimit, eventdata, handles)


% --- Executes on selection change in lb_channels.
function lb_channels_Callback(hObject, eventdata, handles)
% hObject    handle to lb_channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_channels contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_channels
ch = get(hObject,'Value');
if length(ch)*length(get(handles.lb_features,'Value')) < 2 
    if ch == 1
        set(hObject,'Value',[ch 2]);
    else
        set(hObject,'Value',[ch 1]);
    end
end

% --- Executes during object creation, after setting all properties.
function lb_channels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function handles = updatePred(handles)
% updating plots of a_prediction acording to the selected methods
load('preData')

% Settings from GUI
classifierV = get(handles.pm_classifier,'Value');
classifierS = get(handles.pm_classifier,'String');
classifier = classifierS{classifierV};
classifier(classifier == ' ') = '_';
methodS = get(handles.pm_method,'String');
method = methodS(get(handles.pm_method,'Value'));
if strcmp(method,'Nearest Neighbor Sep.')
    def = 'NNS';
elseif strcmp(method,'Mahalanobis*')
    def = 'Mahalanobis_Modified';
elseif strcmp(method,'Bhattacharyya')
    def = 'Bhattacharyya';
end

% Getting data from preData
x = preData.(classifier).(def).values;
y = preData.(classifier).acc;
func = preData.(classifier).(def).func;
exclude = isinf(x) | isnan(x);
x = x(~exclude);
y = y(~exclude);
xlim = min(mean(x)+2*std(x),max(x));

% Updating a_prediction
cla(handles.a_prediction);
hold(handles.a_prediction, 'on');
plot(handles.a_prediction,x,y,'.','color',[0.9 0.9 0.9]);
axis(handles.a_prediction,[0 xlim 0 100]);
legend(handles.a_prediction,'hide');
xlabel(handles.a_prediction,'');
ylabel(handles.a_prediction,'');
set(handles.a_prediction,'XTickLabel',{''},'YTickLabel',{''},'XTick',[],'YTick',[],'layer','top');
analysis = get(handles.f_main,'UserData');
m = analysis.selectedMov;
v = 0:xlim/100:xlim;
target = analysis.limit;
accPre = eval(func);
accPre = unique(accPre);
vUnique = v(1:length(accPre));
limit = interp1(accPre,vUnique,target);
if isnan(limit)
    limit = max(x)+v(2);
end
lim = plot(handles.a_prediction,[limit limit],[0 100],'-.','color',[1 0.8 0.8]);
plot(handles.a_prediction,[0 xlim],[target target],'-.','color',[1 0.8 0.8]);
plot(handles.a_prediction,v,eval(func),'r');
pre = plot(handles.a_prediction,[analysis.mCCE(m) analysis.mCCE(m)],[0 100],'r--');
analysis.predObj = pre;
analysis.limitObj = lim;
set(handles.am_distances(analysis.mCCE < limit),'XColor',[0.8 0 0],'YColor',[0.8 0 0],'Color',[1 0.7 0.7])
set(handles.am_distances(~(analysis.mCCE < limit)),'XColor',[0 0 0],'YColor',[0 0 0],'Color',[1 1 1])
set(handles.f_main,'UserData',analysis);
return

function handles = updateCCE(handles)
% updating the CCEs acording to the selected methods

% Check if update is needed
analysis = get(handles.f_main,'UserData');
methodStr = get(handles.pm_method,'String');
method = methodStr{get(handles.pm_method,'Value')};
if ~strcmp(analysis.method,method);
    % Initialization
    m = analysis.selectedMov;
    sigFeatures = analysis.sigFeatures;
    className = sigFeatures.mov{m};
    dPm = handles.am_distances;
    data = analysis.anDataM;
    [~,nD,nM] = size(data);
    neighborCount = zeros(nM,1);
    mov = sigFeatures.mov;
    chComb = combnk(1:nD,2);   % All combinations of 2 channels
    chDist = zeros(size(chComb,1),1);
    
    % finding neighbor class for all movements and classification
    % complexity estimations
    switch method
        case 'Mahalanobis*'
            [mCCE,NN] = GetSI(analysis.anDataM);
        case 'Bhattacharyya'
            [mCCE,NN] = GetSI(analysis.anDataM,'Bhattacharyya');
        case 'Nearest Neighbor Sep.'
            [mCCE,NN] = GetNNS(analysis.anDataM);
    end
    
    for m = 1:nM
        % Finding most separating channel combination
        if NN(m) == 0
            set(dPm(m),'ButtonDownFcn','disp(''no nearest neighbor'')');
            cla(dPm(m));
        else
            for ch = 1:size(chComb,1)
                switch method
                    case 'Mahalanobis*'
                        chDist(ch) = GetDist(data(:,chComb(ch,:),m), data(:,chComb(ch,:),NN(m)),'Mahalanobis Modified');
                    case 'Bhattacharyya'
                        chDist(ch) = GetDist(data(:,chComb(ch,:),m), data(:,chComb(ch,:),NN(m)),'Bhattacharyya');
                    case 'Nearest Neighbor Sep.'
                        chDist(ch) = mean(GetNNS(data(:,chComb(ch,:),[m,NN(m)])));
                end
            end
            [~,chSort] = sort(chDist);
            ch1 = chComb(chSort(end),1);
            ch2 = chComb(chSort(end),2);
            
            %Counting number of conflicts
            neighborCount(m) = sum(NN == m);
            
            %ploting
            cla(dPm(m));
            hold(dPm(m),'on');
            plot(dPm(m),data(:,ch1,m),data(:,ch2,m),'r.');
            plot(dPm(m),data(:,ch1,NN(m)),data(:,ch2,NN(m)),'b.');
            children = allchild(dPm(m));
            set(dPm(m),'ButtonDownFcn',@(hObject,eventdata)GUI_DataAnalysis('am_distances_ButtonDownFcn',hObject,eventdata,guidata(hObject),m));
            set(children,'ButtonDownFcn',get(dPm(m),'ButtonDownFcn'));
            drawnow;
        end
    end
    
    % Saving data in handles
    NN(NN == 0) = 1;                        % Fix for situations with no NN
    analysis.neighborName = mov(NN);
    analysis.neighborCount = neighborCount;
    analysis.utContent(:,2) = num2cell(neighborCount);
    set(handles.f_main,'UserData',analysis);
    analysis.mCCE = mCCE;
    analysis.method = method;
    
    %updating conflict table
    analysis.utContent(:,3) = num2cell(mCCE);
    [~,nSort] = sort(analysis.neighborCount,'descend');
    set(handles.ut_conflict,'Data',analysis.utContent(nSort,:));
    set(handles.ut_conflict,'RowName',nSort);
    legend(handles.a_distance,{[className ' (Conserned Movement)'],[analysis.neighborName{m} ' (Closest Neighbor)'], [method ' : ' num2str(analysis.mCCE(m),2)]});
    set(handles.f_main,'UserData',analysis);
end
return

function handles = updateGUI(handles)

% Clearing old Data Analysis
if isfield(handles,'am_distances')
    try
        delete(handles.am_distances(:));
    catch
        disp('am_distances is already deleted');
    end
    handles = rmfield(handles,'am_distances');
end
cla(handles.a_prediction);
cla(handles.a_distance);
set(handles.a_distance,'Visible','off');
delete(findall(handles.f_main,'Tag','legend'))

% initilazing
sigFeatures = get(handles.t_sigFeatures,'UserData');
analysis = get(handles.f_main,'UserData');
if ~isempty(sigFeatures)
    % Adapting sigFeatures to the selected movements
    [~,sM] = ismember(get(handles.lb_movements,'String'),sigFeatures.mov);
    sigFeatures.mov = sigFeatures.mov(sM);
    nM = length(sigFeatures.mov);
    analysis.selectedMov = nM;
    if isfield(analysis,'predObj')
        analysis = rmfield(analysis,'predObj');
    end
    analysis.sigFeatures = sigFeatures;
    
    % Create movement axes matrix
    dim2 = ceil(sqrt(nM));
    dim1 = ceil(nM/dim2);
    dPm = tight_subplot_inObject(dim1,dim2,[.01 .01],[.01 .01],[.01 .01],handles.up_distances);
    delete(dPm(nM+1:end));
    for m = 1:nM
        set(dPm(m),'XTick',[],'YTick',[],'Box','on','ButtonDownFcn',@(hObject,eventdata)GUI_DataAnalysis('am_distances_ButtonDownFcn',hObject,eventdata,guidata(hObject),m));
        handles.am_distances(m) = dPm(m);
    end
    utContent = cell(nM,3);
    utContent(1:nM,1) = sigFeatures.mov;
    analysis.utContent = utContent;
    set(handles.ut_conflict,'Data',utContent);
    set(handles.ut_conflict,'RowName',1:nM);
    set(handles.f_main,'UserData',analysis);
end
return

% --- Executes on button press in pb_GetFeatures.
function pb_GetFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to pb_GetFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles.varargin{1},'tdata')      % Send a recording session for data treatment
    recSession = handles.varargin{1};
    
    % Open Fig and load information
    st = GUI_SigTreatment();
    stdata = guidata(st);
    set(stdata.et_sF,'String',num2str(recSession.sF));
    set(stdata.et_downsample,'String',num2str(recSession.sF));
    set(stdata.et_nM,'String',num2str(recSession.nM));
    set(stdata.et_nR,'String',num2str(recSession.nR));
    set(stdata.et_cT,'String',num2str(recSession.cT));
    set(stdata.et_rT,'String',num2str(recSession.rT));
    set(stdata.lb_movements,'String',recSession.mov);
    set(stdata.lb_movements,'Value',1:recSession.nM);
    set(stdata.lb_movements,'Enable','off');
    
    if isfield(recSession,'dev')
        set(stdata.t_dev,'String',recSession.dev);
    else
        set(stdata.t_dev,'String','Unknown');
    end
    
    if isfield(recSession,'nCh')
        nCh = recSession.nCh;
        if length(recSession.nCh) == 1
            recSession.nCh = 1:recSession.nCh;
            nCh = recSession.nCh;
        end
        if length(recSession.nCh) ~= length(recSession.tdata(1,:,1))
            set(stdata.t_msg,'String','Error in the number of channels');
            set(handles.t_msg,'String','Error in the number of channels');
        end
    else
        nCh = 1:length(recSession.tdata(1,:,1));
        recSession.nCh = nCh;
    end
    set(stdata.lb_nCh,'String',num2str(nCh'));
    set(stdata.lb_nCh,'Value',nCh);
    set(stdata.lb_nCh,'Enable','off');
    
    set(stdata.pb_treatFolder,'Visible','off');
    
    % Load the whole recSession
    set(stdata.t_recSession,'UserData',recSession);
    % Save this GUI handles
    set(stdata.t_mhandles,'UserData',handles);
    
    % Update data analysis GUI
    set(handles.lb_channels,'String',recSession.nCh);
    set(handles.lb_channels,'Value',recSession.nCh);
    set(handles.pb_extractFeatures,'Enable','on');
    set(handles.pb_featureSelection,'Enable','on');
    set(handles.pb_hudgins,'Enable','on');
    
    sigFeatures = get(handles.t_sigFeatures,'UserData'); %bugg fix for not deleting am_distance insets twice
    if isfield('mov',sigFeatures)
        set(handles.lb_movements,'String',sigFeatures.mov);
    end
    analysis = get(handles.f_main,'UserData');
    analysis.sigFeatures = sigFeatures;
    set(handles.f_main,'UserData',analysis);
    
    handles = updateGUI(handles);
    set(handles.pm_classifier,'Enable','off');
    set(handles.pm_method,'Enable','off');
    set(handles.pb_setLimit,'Enable','off');
    set(handles.et_accLimit,'Enable','off');
    set(handles.pb_save,'Enable','off');
    set(handles.pb_undo,'Enable','off');
    set(handles.pb_delete,'Enable','off');
    set(handles.pb_replace,'Enable','off');
    guidata(hObject, handles);
else
    disp('First argument needs to be a recSession');
end


% --- Executes on button press in pb_hudgins.
function pb_hudgins_Callback(hObject, eventdata, handles)
% hObject    handle to pb_hudgins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~,hF] = ismember({'tmabs' 'twl' 'tzc' 'tslpch2'},get(handles.lb_features,'String'));
set(handles.lb_features,'Value',hF);

% --- Executes on button press in pb_featureSelection.
function pb_featureSelection_Callback(hObject, eventdata, handles)
% hObject    handle to pb_featureSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
analysis = get(handles.f_main,'UserData');
if isempty(analysis.sigFeatures)
    analysis.sigFeatures = get(handles.t_sigFeatures,'UserData');
    sigFeatures = analysis.sigFeatures;
else
    [~,sM] = ismember(get(handles.lb_movements,'String'),analysis.sigFeatures.mov);
    sigFeatures.trFeatures = analysis.sigFeatures.trFeatures(:,sM);
    sigFeatures.tFeatures = analysis.sigFeatures.tFeatures(:,sM);
    sigFeatures.vFeatures = analysis.sigFeatures.vFeatures(:,sM);
end
fsd = GUI_FeatureSelection(sigFeatures); %Open Features Selection GUI
fsddata = guidata(fsd);
set(fsddata.f_main,'UserData',handles); %transfer parent handles to child GUI
