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
%  GUI Created to view simulations of the TAC-test. Can also be used to
%  view the results from the StateSpaceTracker used with the RealTime
%  TAC-test.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-11-23 / Joel Falk-Dahlin  / Creation
% 20xx-xx-xx / Author  / Comment on update

function varargout = GUI_SSPresentation(varargin)
% GUI_SSPRESENTATION MATLAB code for GUI_SSPresentation.fig
%      GUI_SSPRESENTATION, by itself, creates a new GUI_SSPRESENTATION or raises the existing
%      singleton*.
%
%      H = GUI_SSPRESENTATION returns the handle to a new GUI_SSPRESENTATION or the handle to
%      the existing singleton*.
%
%      GUI_SSPRESENTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SSPRESENTATION.M with the given input arguments.
%
%      GUI_SSPRESENTATION('Property','Value',...) creates a new GUI_SSPRESENTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_SSPresentation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_SSPresentation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_SSPresentation

% Last Modified by GUIDE v2.5 16-Nov-2012 13:41:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_SSPresentation_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_SSPresentation_OutputFcn, ...
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


% --- Executes just before GUI_SSPresentation is made visible.
function GUI_SSPresentation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_SSPresentation (see VARARGIN)

% Choose default command line output for GUI_SSPresentation
handles.output = hObject;

axes(handles.axes1)
handles.target1 = patch([0 1 1 0],[0 0 1 1],'g');
hold on;
handles.line1 = plot(handles.axes1,0,0);
handles.pos1 = plot(handles.axes1,0,0,'o','MarkerFaceColor','r');
grid on;
hold off;

axes(handles.axes2)
handles.target2 = patch([0 1 1 0],[0 0 1 1],'g');
hold on;
handles.line2 = plot(handles.axes2,0,0);
handles.pos2 = plot(handles.axes2,0,0,'o','MarkerFaceColor','r');
grid on;
hold off;

axes(handles.axes3)
handles.target3 = patch([0 1 1 0],[0 0 1 1],'g');
hold on;
handles.line3 = plot(handles.axes3,0,0);
handles.pos3 = plot(handles.axes3,0,0,'o','MarkerFaceColor','r');
grid on;
hold off;

xlim(handles.axes1,[-100 100]);
xlim(handles.axes2,[-100 100]);
xlim(handles.axes3,[-100 100]);
ylim(handles.axes1,[-100 100]);
ylim(handles.axes2,[-100 100]);
ylim(handles.axes3,[-100 100]);

axes(handles.axes4)
handles.line4 = plot3(handles.axes4,0,0,0);
hold on
handles.pos4 = plot3(handles.axes4,0,0,0,'o','MarkerFaceColor','r');
xlim([-100 100])
ylim([-100 100])
zlim([-100 100])
grid on
hold off;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_SSPresentation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_SSPresentation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
UpdatePlots(handles);

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in lb_classifier.
function lb_classifier_Callback(hObject, eventdata, handles)
% hObject    handle to lb_classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_classifier contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_classifier
tacSimulation = handles.tacSimulation;
iControl = get(handles.lb_controlAlg,'Value');
iControl = TranslateControlIndex(tacSimulation,iControl);
iClass = get(handles.lb_classifier,'Value');

set(handles.lb_classifier,'String',GetClassifiers(tacSimulation));
set(handles.lb_controlAlg,'String',GetControllers(tacSimulation));
set(handles.lb_parameters,'String',GetParameters(tacSimulation,iControl));
set(handles.lb_repetition,'String',GetRepetitions(tacSimulation));
set(handles.lb_movement,'String',GetMovements(tacSimulation,iClass,iControl,1));

SetFrameSlider(handles,'end');
UpdatePlots(handles);

% --- Executes during object creation, after setting all properties.
function lb_classifier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_classifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_controlAlg.
function lb_controlAlg_Callback(hObject, eventdata, handles)
% hObject    handle to lb_controlAlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_controlAlg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_controlAlg
tacSimulation = handles.tacSimulation;
iControl = get(handles.lb_controlAlg,'Value');
iControl = TranslateControlIndex(tacSimulation,iControl);
iClass = get(handles.lb_classifier,'Value');

set(handles.lb_parameters,'Value',1);
set(handles.lb_classifier,'String',GetClassifiers(tacSimulation));
set(handles.lb_controlAlg,'String',GetControllers(tacSimulation));
set(handles.lb_parameters,'String',GetParameters(tacSimulation,iControl));
set(handles.lb_repetition,'String',GetRepetitions(tacSimulation));
set(handles.lb_movement,'String',GetMovements(tacSimulation,iClass,iControl,1));

SetFrameSlider(handles,'end');
UpdatePlots(handles);

% --- Executes during object creation, after setting all properties.
function lb_controlAlg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_controlAlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_parameters.
function lb_parameters_Callback(hObject, eventdata, handles)
% hObject    handle to lb_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_parameters contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_parameters
SetFrameSlider(handles,'end');
UpdatePlots(handles);

% --- Executes during object creation, after setting all properties.
function lb_parameters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_movement.
function lb_movement_Callback(hObject, eventdata, handles)
% hObject    handle to lb_movement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_movement contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_movement
SetFrameSlider(handles,'end');
UpdatePlots(handles);

% --- Executes during object creation, after setting all properties.
function lb_movement_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_movement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_repetition.
function lb_repetition_Callback(hObject, eventdata, handles)
% hObject    handle to lb_repetition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_repetition contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_repetition
SetFrameSlider(handles,'end');
UpdatePlots(handles);

% --- Executes during object creation, after setting all properties.
function lb_repetition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_repetition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LoadData(hObject,eventdata,handles)

[file, path] = uigetfile('*.mat');

if ischar(file) && ischar(path)
    load([path file]);
    file = regexp(file,'.mat','split');
    file = file{1};
    set(handles.t_filename,'String',file);

    if exist('tacSimulation','var');
        handles.tacSimulation = tacSimulation;
        
    elseif exist('tacTest','var')
        tacSimulation = tacTest.ssTracker;
        tacSimulation.maxSpeed = mean(tacTest.patRec.control.maxDegPerMov);
        ssTrajectories = tacSimulation.ssTrajectories;
        ssTargets = tacSimulation.ssTargets;
        for i = 1:length(ssTrajectories)
            ssTrajectories(i) = {ssTrajectories(i)};
        end
        tacSimulation.ssTrajectories = {{{ssTrajectories}}};
        tacSimulation.ssTargets = {{{ssTargets}}};
        
        allPathLengths = [];
        tmpPathVec = [];
        for i = 1:size(tacTest.trialResult,1)
            for j = 1:size(tacTest.trialResult,2)
                for k = 1:size(tacTest.trialResult,3)
                    allPathLengths = [allPathLengths; {tacTest.trialResult(i,j,k).pathEfficiency}];
                    tmpPathVec = [tmpPathVec; tacTest.trialResult(i,j,k).pathEfficiency];
                end
            end
        end
        
        tacSimulation.allPathLengths = {{{allPathLengths}}};
        tacSimulation.meanPathLengthParam = {{ mean( tmpPathVec( ~isnan(tmpPathVec) ) ) }};
        
        
        handles.tacSimulation = tacSimulation;
        
        
    end

    iControl = TranslateControlIndex(tacSimulation,1);
    
    set(handles.lb_classifier,'Value',1);
    set(handles.lb_controlAlg,'Value',1);
    set(handles.lb_parameters,'Value',1);
    set(handles.lb_repetition,'Value',1);
    set(handles.lb_movement,'Value',1);
    
    set(handles.lb_classifier,'String',GetClassifiers(tacSimulation));
    set(handles.lb_controlAlg,'String',GetControllers(tacSimulation));
    set(handles.lb_parameters,'String',GetParameters(tacSimulation,iControl));
    set(handles.lb_repetition,'String',GetRepetitions(tacSimulation));
    set(handles.lb_movement,'String',GetMovements(tacSimulation,1,iControl,1));

    if isfield( tacSimulation, 'maxSpeed')
        set(handles.et_maxSpeed,'String',num2str(tacSimulation.maxSpeed) );
    end
    
    if isfield( tacSimulation, 'distance')
        set(handles.et_distance,'String',num2str(tacSimulation.distance) );
    end
    
    if isfield( tacSimulation, 'allowance')
        set(handles.et_allowance,'String',num2str(tacSimulation.allowance) );
    end
    
    if isfield( tacSimulation, 'nPredictionsPerSecond')
        set(handles.et_predPerSec,'String',num2str(tacSimulation.nPredictionsPerSecond) );
    end
    
    if isfield( tacSimulation, 'modelTransitions')
        
        str = '';
        switch tacSimulation.modelTransitions
            case 0
                str = 'OFF';
            case 1
                str = 'ON';
        end
        set(handles.et_modelTransitions,'String',str);
    end
    
    if isfield( tacSimulation, 'reactionTime')
        set(handles.et_reactionTime,'String',num2str(tacSimulation.reactionTime) );
    end
    
    SetFrameSlider(handles,'end');
    UpdatePlots(handles);

    guidata(hObject,handles);

end

function SetFrameSlider(handles,iFrame)
    tacSimulation = handles.tacSimulation;
    iClass = get(handles.lb_classifier,'Value');
    iControl = get(handles.lb_controlAlg,'Value');
    iControl = TranslateControlIndex(tacSimulation,iControl);
    iParam = get(handles.lb_parameters,'Value');
    iMov = get(handles.lb_movement,'Value');
    iRep = get(handles.lb_repetition,'Value');
    
    set(handles.slider,'Min',1);
    ssTrajectory = tacSimulation.ssTrajectories{iClass}{iControl}{iParam}{iMov}{iRep};
    max = size(ssTrajectory,1);
    set(handles.slider,'Max',max);
    
    if ischar(iFrame)
        if strcmp(iFrame,'end')
            set(handles.slider,'Value',max);
        end
    else
        set(handles.slider,'Value',iFrame);
    end

function outString = GetControllers(tacSimulation)
    controllers = tacSimulation.controllers;
    controlParams = tacSimulation.controlParams;
    outString = [];
    
    for i = 1:length(controllers)
        if ~isempty( controlParams{i} )
            outString = [outString, controllers(i)];
        end
    end

function outString = GetMovements(tacSimulation,iClass,iControl,iParam)
    outString = [];
    ssTrajectories = tacSimulation.ssTrajectories{iClass}{iControl}{iParam};
    
    nMoves = length(ssTrajectories);
    
    for i = 1:nMoves
        outString = [outString; {num2str(i)}];
    end

function controlIdx = TranslateControlIndex(tacSimulation,iControl)
    validIndicies = [];
    controlParams = tacSimulation.controlParams;
    
    for i = 1:length(controlParams)
        if ~isempty( controlParams{i} )
            validIndicies = [validIndicies i];
        end
    end
    
    controlIdx = validIndicies(iControl);
    
function outString = GetRepetitions(tacSimulation)
    nReps = tacSimulation.nReps;
    outString = [];
    for i = 1:nReps
        outString = [outString; {num2str(i)}];
    end

function outString = GetParameters(tacSimulation,i)
    controlParams = tacSimulation.controlParams{i};
    
    outString = [];
    if ~isempty( controlParams )
        for i = 1:length(controlParams)
            outString = [outString; {num2str(i)}];
        end
    end
    
function outString = GetClassifiers(tacSimulation)
    classifiers = tacSimulation.classifiers;
    
    outString = [];
    
    for i = 1:length(classifiers)
        outString = [outString; {classifiers{1}.topology}];
    end
    
function UpdatePlots(handles)

    tacSimulation = handles.tacSimulation;
    frame = floor( get(handles.slider,'Value') );
    set(handles.edit1,'String',num2str(frame));
    iClass = get(handles.lb_classifier,'Value');
    iControl = get(handles.lb_controlAlg,'Value');
    iControl = TranslateControlIndex(tacSimulation,iControl);
    iParam = get(handles.lb_parameters,'Value');
    iMov = get(handles.lb_movement,'Value');
    iRep = get(handles.lb_repetition,'Value');
    controlParams = tacSimulation.controlParams{iControl}{iParam};
    
    if ~isempty(controlParams)
        str = [];
        for i = 1:size(controlParams,1)
            str = [str; {[controlParams{i,1},' : ',num2str(controlParams{i,2})]} ];
        end
        set(handles.lb_currentParameters,'String',str);
    else
        set(handles.lb_currentParameters,'String','');
    end
    
    if isfield( tacSimulation,'desiredMoves');
        desiredMov = tacSimulation.desiredMoves{iClass}{iControl}{iParam}{iMov}{iRep}{frame+1};
        set(handles.et_desiredMov,'String',desiredMov);
    end
    
    if isfield( tacSimulation,'allPathLengths')
        pathLength = tacSimulation.allPathLengths{iClass}{iControl}{iParam}{iMov}(iRep);
        set(handles.et_currentPathLength,'String',num2str(pathLength));
    end
    
    if isfield( tacSimulation,'meanPathLengthMov')
        pathLength = tacSimulation.meanPathLengthMov{iClass}{iControl}{iParam}(iMov);
        set(handles.et_meanPathLengthMov,'String',num2str(pathLength));
    end
    
    if isfield( tacSimulation,'meanPathLengthParam')
        pathLength = tacSimulation.meanPathLengthParam{iClass}{iControl}(iParam);
        set(handles.et_meanPathLengthParam,'String',num2str(pathLength));
    end
    
    if isfield( tacSimulation,'timeDataFile')
        file = tacSimulation.timeDataFile;
        set(handles.et_timeData,'String',file);
    end

    if isfield( tacSimulation,'classifierFiles')
        file = tacSimulation.classifierFiles{iClass};
        set(handles.et_patRecFile,'String',file);
    end
    
    ssTrajectory = tacSimulation.ssTrajectories{iClass}{iControl}{iParam}{iMov}{iRep};
    ssTarget = tacSimulation.ssTargets{iClass}{iControl}{iParam}{iMov};
    
    allowance = handles.tacSimulation.allowance;
    theta = linspace(0,2*pi,50);
    x = zeros(1,length(theta));
    y = zeros(1,length(theta));
    for i = 1:length(theta)
        x(i) = allowance*cos(theta(i));
        y(i) = allowance*sin(theta(i));
    end
    
    set(handles.target1,'XData',x+ssTarget(1),'YData',y+ssTarget(2))
    set(handles.line1,'XData', ssTrajectory(1:frame,1),'YData',ssTrajectory(1:frame,2));
    set(handles.pos1,'XData',ssTrajectory(frame,1),'YData',ssTrajectory(frame,2))

    set(handles.target2,'XData',x+ssTarget(2),'YData',y+ssTarget(3))
    set(handles.line2,'XData', ssTrajectory(1:frame,2),'YData',ssTrajectory(1:frame,3));
    set(handles.pos2,'XData',ssTrajectory(frame,2),'YData',ssTrajectory(frame,3))

    set(handles.target3,'XData',x+ssTarget(1),'YData',y+ssTarget(3))
    set(handles.line3,'XData', ssTrajectory(1:frame,1),'YData',ssTrajectory(1:frame,3));
    set(handles.pos3,'XData',ssTrajectory(frame,1),'YData',ssTrajectory(frame,3))
    
    set(handles.line4,'XData',ssTrajectory(1:frame,1),'YData',ssTrajectory(1:frame,2),'ZData',ssTrajectory(1:frame,3))
    set(handles.pos4,'XData',ssTrajectory(frame,1),'YData',ssTrajectory(frame,2),'ZData',ssTrajectory(frame,3))

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
iFrame = str2double(get(hObject,'String'));
set(handles.slider,'Value',iFrame)
UpdatePlots(handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pb_play.
function pb_play_Callback(hObject, eventdata, handles)
% hObject    handle to pb_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lastFrame = get(handles.slider,'Max');

for i = 1:lastFrame
    set(handles.slider,'Value',i);
    UpdatePlots(handles);
    pause(0.05);
end



function et_desiredMov_Callback(hObject, eventdata, handles)
% hObject    handle to et_desiredMov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_desiredMov as text
%        str2double(get(hObject,'String')) returns contents of et_desiredMov as a double


% --- Executes during object creation, after setting all properties.
function et_desiredMov_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_desiredMov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_currentParameters.
function lb_currentParameters_Callback(hObject, eventdata, handles)
% hObject    handle to lb_currentParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_currentParameters contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_currentParameters


% --- Executes during object creation, after setting all properties.
function lb_currentParameters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_currentParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_currentPathLength_Callback(hObject, eventdata, handles)
% hObject    handle to et_currentPathLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_currentPathLength as text
%        str2double(get(hObject,'String')) returns contents of et_currentPathLength as a double


% --- Executes during object creation, after setting all properties.
function et_currentPathLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_currentPathLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_meanPathLengthMov_Callback(hObject, eventdata, handles)
% hObject    handle to et_meanPathLengthMov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_meanPathLengthMov as text
%        str2double(get(hObject,'String')) returns contents of et_meanPathLengthMov as a double


% --- Executes during object creation, after setting all properties.
function et_meanPathLengthMov_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_meanPathLengthMov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_meanPathLengthParam_Callback(hObject, eventdata, handles)
% hObject    handle to et_meanPathLengthParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_meanPathLengthParam as text
%        str2double(get(hObject,'String')) returns contents of et_meanPathLengthParam as a double


% --- Executes during object creation, after setting all properties.
function et_meanPathLengthParam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_meanPathLengthParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_patRecFile_Callback(hObject, eventdata, handles)
% hObject    handle to et_patRecFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_patRecFile as text
%        str2double(get(hObject,'String')) returns contents of et_patRecFile as a double


% --- Executes during object creation, after setting all properties.
function et_patRecFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_patRecFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_timeData_Callback(hObject, eventdata, handles)
% hObject    handle to et_timeData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_timeData as text
%        str2double(get(hObject,'String')) returns contents of et_timeData as a double


% --- Executes during object creation, after setting all properties.
function et_timeData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_timeData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_predPerSec_Callback(hObject, eventdata, handles)
% hObject    handle to et_predPerSec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_predPerSec as text
%        str2double(get(hObject,'String')) returns contents of et_predPerSec as a double


% --- Executes during object creation, after setting all properties.
function et_predPerSec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_predPerSec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_maxSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to et_maxSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_maxSpeed as text
%        str2double(get(hObject,'String')) returns contents of et_maxSpeed as a double


% --- Executes during object creation, after setting all properties.
function et_maxSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_maxSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_modelTransitions_Callback(hObject, eventdata, handles)
% hObject    handle to et_modelTransitions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_modelTransitions as text
%        str2double(get(hObject,'String')) returns contents of et_modelTransitions as a double


% --- Executes during object creation, after setting all properties.
function et_modelTransitions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_modelTransitions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_reactionTime_Callback(hObject, eventdata, handles)
% hObject    handle to et_reactionTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_reactionTime as text
%        str2double(get(hObject,'String')) returns contents of et_reactionTime as a double


% --- Executes during object creation, after setting all properties.
function et_reactionTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_reactionTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_allowance_Callback(hObject, eventdata, handles)
% hObject    handle to et_allowance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_allowance as text
%        str2double(get(hObject,'String')) returns contents of et_allowance as a double


% --- Executes during object creation, after setting all properties.
function et_allowance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_allowance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_distance_Callback(hObject, eventdata, handles)
% hObject    handle to et_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_distance as text
%        str2double(get(hObject,'String')) returns contents of et_distance as a double


% --- Executes during object creation, after setting all properties.
function et_distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_increaseFrame.
function pb_increaseFrame_Callback(hObject, eventdata, handles)
% hObject    handle to pb_increaseFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
max = get(handles.slider,'Max');
curr = get(handles.slider,'Value');

if curr < max
    set( handles.slider,'Value', curr+1 )
    set( handles.edit1,'String',num2str( curr+1 ) );
    UpdatePlots(handles);
end

% --- Executes on button press in pb_decreaseFrame.
function pb_decreaseFrame_Callback(hObject, eventdata, handles)
% hObject    handle to pb_decreaseFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
min = get(handles.slider,'Min');
curr = get(handles.slider,'Value');

if curr > min
    set( handles.slider,'Value', curr-1 )
    set( handles.edit1,'String',num2str( curr-1 ) );
    UpdatePlots(handles);
end
