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
% Function of GUI_SOM it is  for selecting  different configurations for SOM
% such as the Grid Shape, Neighbor Functions and Visualizing Map for SOM
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function varargout = GUI_SOM(varargin)
% GUI_SOM MATLAB code for GUI_SOM.fig
%      GUI_SOM, by itself, creates a new GUI_SOM or raises the existing
%      singleton*.
%
%      H = GUI_SOM returns the handle to a new GUI_SOM or the handle to
%      the existing singleton*.
%
%      GUI_SOM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SOM.M with the given input arguments.
%
%      GUI_SOM('Property','Value',...) creates a new GUI_SOM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_SOM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_SOM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_SOM

% Last Modified by GUIDE v2.5 28-Sep-2012 21:22:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_SOM_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_SOM_OutputFcn, ...
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


% --- Executes just before GUI_SOM is made visible.
function GUI_SOM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_SOM (see VARARGIN)

% Choose default command line output for GUI_SOM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

guidata(hObject, handles);

guiID = GUI_PatRec();
handles_PatRec=guidata(guiID);
allAlg = get( handles_PatRec.pm_SelectAlgorithm,'String');
alg    = char(allAlg(get( handles_PatRec.pm_SelectAlgorithm,'Value')));


if strcmp(alg,'SOM')
    set(handles.pm_SelectShape,'Value',2);
    set(handles.pm_SelectNeighborFunction,'Value',6);
elseif strcmp(alg,'SSOM')
    set(handles.pm_SelectShape,'Value',3);
    set(handles.pm_SelectNeighborFunction,'Value',3);
end

% UIWAIT makes GUI_SOM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_SOM_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in pm_SelectShape.
function pm_SelectShape_Callback(hObject, eventdata, handles)
% hObject    handle to pm_SelectShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_SelectShape contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_SelectShape


% --- Executes during object creation, after setting all properties.
function pm_SelectShape_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_SelectShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_SelectNeighborFunction.
function pm_SelectNeighborFunction_Callback(hObject, eventdata, handles)
% hObject    handle to pm_SelectNeighborFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_SelectNeighborFunction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_SelectNeighborFunction


% --- Executes during object creation, after setting all properties.
function pm_SelectNeighborFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_SelectNeighborFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_visualizeSOM.
function cb_visualizeSOM_Callback(hObject, eventdata, handles)
% hObject    handle to cb_visualizeSOM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_visualizeSOM


% --- Executes on button press in pm_configure.
function pm_configure_Callback(hObject, eventdata, handles)
% hObject    handle to pm_configure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get GUI handles
guiID = GUI_PatRec();
handles_PatRec=guidata(guiID);

% Get config
allShape = get(handles.pm_SelectShape,'String');
shape=char(allShape(get(handles.pm_SelectShape,'Value')));

allNeighFunc= get(handles.pm_SelectNeighborFunction,'String');
neighFunc=char(allNeighFunc(get(handles.pm_SelectNeighborFunction,'Value')));

visualizeSOM=get(handles.cb_visualizeSOM,'Value');

% Save config
algConf.shape=shape;
algConf.neighFunc=neighFunc;
algConf.visualizeSOM=visualizeSOM;
handles_PatRec.algConf = algConf;

guidata(GUI_PatRec(),handles_PatRec)

close(GUI_SOM);
