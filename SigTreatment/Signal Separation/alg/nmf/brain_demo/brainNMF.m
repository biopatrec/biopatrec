function varargout = brainNMF(varargin)
% brainNMF M-file for nmf2.fig
%      NMF2, by itself, creates a new brainNMF or raises the existing
%      singleton*.
%
%      H = brainNMF returns the handle to a new brainNMF or the handle to
%      the existing singleton*.
%
%      brainNMF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in brainNMF.M with the given input arguments.
%
%      brainNMF('Property','Value',...) creates a new brainNMF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before brainNMF_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to brainNMF_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help brainNMF

% Last Modified by Bartlomiej Wilkowski (bw@imm.dtu.dk) 06-Nov-2007, ver.
% 1.4

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @brainNMF_OpeningFcn, ...
                   'gui_OutputFcn',  @brainNMF_OutputFcn, ...
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


% --- Executes just before brainNMF is made visible.
function brainNMF_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to brainNMF (see VARARGIN)

% Choose default command line output for brainNMF
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
addpath('../.');
% UIWAIT makes brainNMF wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = brainNMF_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in plot_thresshold.
function plot_thresshold_Callback(hObject, eventdata, handles)
% hObject    handle to plot_thresshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'img')
    errordlg('Load file first','Error');
    return
end
img = handles.img;
figure(2),
thresshold(1) = str2double(get(handles.lowerThress,'String'));
thresshold(2) = str2double(get(handles.upperThress,'String'));
plotThresshold(img,thresshold)

% --- Executes on button press in plot_spatial.
function plot_spatial_Callback(hObject, eventdata, handles)
% hObject    handle to plot_spatial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'W')
    errordlg('Run NMF first','Error');
    return
end

W = handles.W;
indx = handles.indx;
%dim = size(handles.img);
plotSlices(W,indx,handles.imgSize)

% --- Executes on button press in rescale.
function rescale_Callback(hObject, eventdata, handles)
% hObject    handle to rescale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rescale



function set_sources_Callback(hObject, eventdata, handles)
% hObject    handle to set_sources (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of set_sources as text
%        str2double(get(hObject,'String')) returns contents of set_sources as a double

k = str2double(get(hObject,'String'));

if k<2 || isnan(k)
    errordlg('Not valid number','Error');
    set(handles.set_sources,'String',3);
    return
end

% --- Executes during object creation, after setting all properties.
function set_sources_CreateFcn(hObject, eventdata, handles)
% hObject    handle to set_sources (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function set_iterations_Callback(hObject, eventdata, handles)
% hObject    handle to set_iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of set_iterations as text
%        str2double(get(hObject,'String')) returns contents of set_iterations as a double
iter = str2double(get(hObject,'String'));

if iter<1 || isnan(iter)
    errordlg('Not valid number','Error');
    set(handles.set_iterations,'String',1000);
    return
end

% --- Executes during object creation, after setting all properties.
function set_iterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to set_iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_data.
function load_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%checks if there exist earlier H and W matrices, plotErr and rescaledFlag in <handles> taken from the
%previous NMF calculation. If yes, it removes them.

[fn,pn]=uigetfile('*.img','Analyze file');
if fn~=0
    if isfield(handles, 'W')
        handles = rmfield(handles, 'W');
    end
    if isfield(handles, 'H')
        handles = rmfield(handles, 'H');
    end
    if isfield(handles, 'plotErr')
        handles = rmfield(handles, 'plotErr');
    end
    if isfield(handles, 'rescaledFlag')
        handles = rmfield(handles, 'rescaledFlag');
    end

    set(handles.rescale, 'Value', get(handles.rescale, 'Min'));

    set(handles.plot_samples,'Enable', 'on');
    set(handles.plot_thresshold,'Enable', 'on');
    set(handles.run_nmf,'Enable', 'on');
    set(handles.plot_spatial,'Enable', 'off');
    set(handles.plot_error,'Enable', 'off');
    
    %load([pn fn]);
    [img hdr] = ReadAnalyzeImg([pn fn]);
    img = reshape((img - hdr.offset).*hdr.scale,hdr.dim');
    handles.img = img;
    handles.imgSize = size(img);
    %set(choose_file,[pn fn])
    set(handles.info_text, 'String', 'DATA LOADED for image:');
    set(handles.Choose_file, 'String', [pn fn]);

    %Also read in .tim file to get frames
    [timFileExist]=fileattrib([pn fn(1:end-3) 'tim']);
    if timFileExist
        [time tmp] = textread([pn fn(1:end-3) 'tim']);
        xAxisLabel = 'Time';
    else
        time = 1:hdr.dim(4);
        xAxisLabel = 'Frame';
    end

    imgMean = mean(img,4);
    set(handles.minMean,'String',num2str(min(imgMean(:))));
    set(handles.maxMean,'String',num2str(max(imgMean(:))));
    set(handles.lowerThress,'String',num2str(min(imgMean(:))));
    set(handles.upperThress,'String',num2str(max(imgMean(:))));
    handles.time = time;
    handles.scanName = hdr.name;
    handles.xAxisLabel = xAxisLabel;

    % save the structure
    guidata(hObject, handles);
end

% --- Executes on button press in plot_samples.
function plot_samples_Callback(hObject, eventdata, handles)
% hObject    handle to plot_samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles, 'img')
    errordlg('Load file first','Error');
    return
end
img = handles.img;
time = handles.time;
xAxisLabel = handles.xAxisLabel;
[x y slice frame] = size(img);
img = reshape(img,x*y*slice,frame);
figure(1),plot(time,img(1:1000:end,:)');
xlabel(xAxisLabel), ylabel('Activity'), title('Sample of time curves')

% --- Executes on button press in run_nmf.
function run_nmf_Callback(hObject, eventdata, handles)
% hObject    handle to run_nmf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'img')
    errordlg('Load file first','Error');
    return
end

img = handles.img;
time = handles.time;
xAxisLabel = handles.xAxisLabel;
[x y slice frame] = size(img);
meanImg = reshape(mean(img,4),x*y,slice);
thresshold(1) = str2double(get(handles.lowerThress,'String'));
thresshold(2) = str2double(get(handles.upperThress,'String'));
indx = find(meanImg > thresshold(1) & meanImg < thresshold(2));
img = reshape(img,x*y*slice,frame);
img = img(indx,:);
K = str2double(get(handles.set_sources,'String'));
iterations = str2double(get(handles.set_iterations,'String'));%Not used yet

switch get(handles.choose_alg,'Value')
    case {1}
        alg = 'mm';
    case {2}
        alg = 'prob';
    case {3}
        alg = 'cjlin';
    case {4}
        alg = 'als';
    case {5}
        alg = 'alsobs';
end

[W H] = nmf(abs(img),K,alg,iterations,0);
if (get(handles.rescale,'Value') == get(handles.rescale,'Max'));
    [W H] = rescale(W,H);
    fprintf('Rescaled \n')
end
handles.rescaledFlag = get(handles.rescale,'Value');
figure
plot(time,H'), xlabel(xAxisLabel), ylabel('Activity')

handles.indx = indx;%Save indx's for plotting
handles.H = H;
handles.W = W;

set(handles.plot_spatial,'Enable', 'on');
set(handles.plot_error,'Enable', 'on');

guidata(hObject, handles);%save structure

% --- Executes on button press in plot_error.
function plot_error_Callback(hObject, eventdata, handles)
% hObject    handle to plot_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'H')
    errordlg('Run NMF first','Error');
    return
end
if isfield(handles,'plotErr')
    err = calculatePlotError(handles,1,0);    
else
    err = calculatePlotError(handles,1,1);
    handles.plotErr = err;
end

% function calculates the plot error. If flag plot is set to zero, the
% error plot is not shown. For other positive number, it will be also
% plotted out.
function err = calculatePlotError(handles,plot,calc)

indx = handles.indx;
H = handles.H;
W = handles.W;
x = handles.imgSize(1);
y = handles.imgSize(2);
slice = handles.imgSize(3);
frame = handles.imgSize(4);

if(calc == 0)
    if(plot)
        plotError(handles.plotErr,indx,[x y slice frame]);   
    end
    err = handles.plotErr;
    return
end
img = handles.img;

img = reshape(img,x*y*slice,frame);
img = img(indx,:);%2D with only activ voxels

err = abs(mean(img-W*H,2));
size(err)
if(plot)
    plotError(err,indx,[x y slice frame]);
end

% --- Executes on button press in save_results.
function save_results_Callback(hObject, eventdata, handles)
% hObject    handle to save_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'H')
    errordlg('Run NMF first','Error');
    return
end
W = handles.W;
H = handles.H;
time = handles.time;
scanName = handles.scanName;

thresshold(1) = str2double(get(handles.lowerThress,'String'));
thresshold(2) = str2double(get(handles.upperThress,'String'));
indx = handles.indx;
iterations = str2double(get(handles.set_iterations,'String'));
imgSize = handles.imgSize;
rescaledFlag = handles.rescaledFlag;

if isfield(handles,'plotErr')
    plotErr = calculatePlotError(handles,0,0);    
else
    plotErr = calculatePlotError(handles,0,1);    
end

[file,path] = uiputfile('*.mat','Save Results As');

if file~=0
save([path file],'W','H','thresshold','indx','iterations','time','scanName','imgSize','plotErr','rescaledFlag');
end


function lowerThress_Callback(hObject, eventdata, handles)
% hObject    handle to lowerThress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lowerThress as text
%        str2double(get(hObject,'String')) returns contents of lowerThress as a double

if ~isfield(handles, 'img')
    errordlg('Load file first','Error');
    return
end

value = str2double(get(hObject,'String'));
if value<str2double(get(handles.minMean,'String')) || isnan(value) || value>=str2double(get(handles.upperThress,'String'));
    errordlg('Not valid number','Error');
    set(handles.lowerThress,'String',get(handles.minMean,'String'));
    return
end


% --- Executes during object creation, after setting all properties.
function lowerThress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowerThress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upperThress_Callback(hObject, eventdata, handles)
% hObject    handle to upperThress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upperThress as text
%        str2double(get(hObject,'String')) returns contents of upperThress as a double

if ~isfield(handles, 'img')
    errordlg('Load file first','Error');
    return
end

value = str2double(get(hObject,'String'));
if value>str2double(get(handles.maxMean,'String')) || isnan(value) || value<=str2double(get(handles.lowerThress,'String'));
    errordlg('Not valid number','Error');
    set(handles.upperThress,'String',get(handles.maxMean,'String'));
    return
end

% --- Executes during object creation, after setting all properties.
function upperThress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upperThress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in choose_alg.
function choose_alg_Callback(hObject, eventdata, handles)
% hObject    handle to choose_alg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns choose_alg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choose_alg


% --- Executes during object creation, after setting all properties.
function choose_alg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choose_alg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadResults.
function loadResults_Callback(hObject, eventdata, handles)
% hObject    handle to loadResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fn2,pn2]=uigetfile('*.mat','Load results');
if(fn2~=0)
    if isfield(handles, 'img')
        handles = rmfield(handles, 'img');
    end
    try
    load([pn2 fn2]);
    handles.W = W;
    size(handles.W)
    handles.H = H;
    handles.indx = indx;
    set(handles.set_iterations,'String', num2str(iterations));
    set(handles.set_sources,'String',num2str(size(handles.H,1)));
    set(handles.lowerThress,'String',num2str(thresshold(1)));
    set(handles.upperThress,'String',num2str(thresshold(2)));
    handles.time = time;
    handles.scanName = scanName;
    handles.imgSize = imgSize;
    handles.plotErr = plotErr;
    handles.rescaledFlag = rescaledFlag;
    set(handles.rescale, 'Value', handles.rescaledFlag);
    
    set(handles.info_text, 'String', 'ONLY RESULTS LOADED for image:');
    set(handles.Choose_file, 'String', handles.scanName);
    
    set(handles.plot_samples,'Enable', 'off');
    set(handles.plot_thresshold,'Enable', 'off');
    set(handles.run_nmf,'Enable', 'off');
    set(handles.plot_spatial,'Enable', 'on');
    set(handles.plot_error,'Enable', 'on');
    
    guidata(hObject, handles);%save structure
       
    catch
        errordlg('Incorrect format of the MAT file!','Error');
        return
    end
end
  
