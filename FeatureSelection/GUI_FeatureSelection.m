function varargout = GUI_FeatureSelection(varargin)
% GUI_FEATURESELECTION MATLAB code for GUI_FeatureSelection.fig
%      GUI_FEATURESELECTION, by itself, creates a new GUI_FEATURESELECTION or raises the existing
%      singleton*.
%
%      H = GUI_FEATURESELECTION returns the handle to a new GUI_FEATURESELECTION or the handle to
%      the existing singleton*.
%
%      GUI_FEATURESELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FEATURESELECTION.M with the given input arguments.
%
%      GUI_FEATURESELECTION('Property','Value',...) creates a new GUI_FEATURESELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_FeatureSelection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_FeatureSelection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_FeatureSelection

% Last Modified by GUIDE v2.5 25-Jul-2016 17:00:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_FeatureSelection_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_FeatureSelection_OutputFcn, ...
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


% --- Executes just before GUI_FeatureSelection is made visible.
function GUI_FeatureSelection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_FeatureSelection (see VARARGIN)

% Choose default command line output for GUI_FeatureSelection
handles.output = hObject;

% Save current sigFeatures version
if ~isempty(varargin)
    handles.sigFeatures = varargin{1};
end

% Update handles structure
guidata(hObject, handles);

% Move GUI to middle of screen
movegui(hObject,'center');

% UIWAIT makes GUI_FeatureSelection wait for user response (see UIRESUME)
% uiwait(handles.f_main);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_FeatureSelection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_selectFeatures.
function pb_selectFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to pb_selectFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Collecting input and sigFeatures from parent handles
pHandles = get(handles.f_main,'UserData');
fID = get(pHandles.lb_features,'String');
sigFeatures = handles.sigFeatures;

% Collecting Feature Selection Algorithm
algS = get(handles.pm_selAlg,'String');
alg = algS{get(handles.pm_selAlg,'Value')};

switch alg
    case 'Brute Force'
        bestSet = GetBestFeatures(sigFeatures,'bruteForce',handles,fID);
    case 'Sequential'
        bestSet = GetBestFeatures(sigFeatures,'sequential',handles,fID);
end
pHandles = get(handles.f_main,'UserData');
set(pHandles.lb_features,'Value',bestSet);
close(GUI_FeatureSelection)



% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(GUI_FeatureSelection);

% --- Executes on selection change in pm_selAlg.
function pm_selAlg_Callback(hObject, eventdata, handles)
% hObject    handle to pm_selAlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_selAlg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_selAlg


% --- Executes during object creation, after setting all properties.
function pm_selAlg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_selAlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_algSet.
function pm_algSet_Callback(hObject, eventdata, handles)
% hObject    handle to pm_algSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_algSet contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_algSet


% --- Executes during object creation, after setting all properties.
function pm_algSet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_algSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_nFeatures.
function pm_nFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to pm_nFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_nFeatures contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_nFeatures


% --- Executes during object creation, after setting all properties.
function pm_nFeatures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_nFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
