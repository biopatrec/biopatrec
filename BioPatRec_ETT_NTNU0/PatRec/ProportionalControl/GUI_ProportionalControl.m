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
% Function executing the GUI for the proportional control.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2013-04-03 / Alf Bjørnar Bertnum / Creation
% 20xx-xx-xx / Author  / Comment on update

function varargout = GUI_ProportionalControl(varargin)
% GUI_PROPORTIONALCONTROL MATLAB code for GUI_ProportionalControl.fig
%      GUI_PROPORTIONALCONTROL, by itself, creates a new GUI_PROPORTIONALCONTROL or raises the existing
%      singleton*.
%
%      H = GUI_PROPORTIONALCONTROL returns the handle to a new GUI_PROPORTIONALCONTROL or the handle to
%      the existing singleton*.
%
%      GUI_PROPORTIONALCONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PROPORTIONALCONTROL.M with the given input arguments.
%
%      GUI_PROPORTIONALCONTROL('Property','Value',...) creates a new GUI_PROPORTIONALCONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_ProportionalControl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_ProportionalControl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_ProportionalControl

% Last Modified by GUIDE v2.5 28-May-2013 14:06:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_ProportionalControl_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_ProportionalControl_OutputFcn, ...
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


% --- Executes just before GUI_ProportionalControl is made visible.
function GUI_ProportionalControl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_ProportionalControl (see VARARGIN)

clear persistent

%load the background image into Matlab
%if image is not in the same directory as the GUI files, you must use the 
%full path name of the iamge file
backgroundImage = importdata('/../Img/BioPatRec.png');
%select the axes
axes(handles.axes2);
%place image onto the axes
image(backgroundImage);
%remove the axis tick marks
axis off

% Choose default command line output for GUI_ProportionalControl
handles.output = hObject;


% Check if any inputs is made when calling the GUI
if ~isempty(varargin)
    handles.patRec = varargin{1};
end


%% Simultaneous area
xy_axis_length = 100;
handles.xy_axis_length = xy_axis_length;
axes(handles.axes1);
set(handles.axes1, 'XLim', [-xy_axis_length, xy_axis_length],...
    'YLim', [-xy_axis_length, xy_axis_length]);

hold on
plot([-xy_axis_length, xy_axis_length], [-xy_axis_length, xy_axis_length], ':',...
    'color', [0 0 0]);
plot([-xy_axis_length, xy_axis_length], [xy_axis_length, -xy_axis_length], ':',...
    'color', [0 0 0]);

%% Draw open/close area, change angles to adjust
open_close_angle = pi/180*str2double(get(handles.et_angleOpenClose,'String'));
pron_sup_angle = pi/180*str2double(get(handles.et_anglePronSup,'String'));
restThreshold = str2double(get(handles.et_restThreshold,'String'));
open_close_length = xy_axis_length*tan(open_close_angle);
pron_sup_length = xy_axis_length*tan(pron_sup_angle);

plot([-xy_axis_length, xy_axis_length], [-open_close_length, open_close_length],...
    'color', [0 0 0],...
    'tag', 'open_close_plot1');
plot([-xy_axis_length, xy_axis_length], [open_close_length, -open_close_length],...
    'color', [0 0 0],...
    'tag', 'open_close_plot2');
plot([-pron_sup_length, pron_sup_length], [xy_axis_length, -xy_axis_length],...
    'color', [0 0 0],...
    'tag', 'pron_sup_plot1');
plot([pron_sup_length, -pron_sup_length], [xy_axis_length, -xy_axis_length],...
    'color', [0 0 0],...
    'tag', 'pron_sup_plot2');

%% Draw rest circle
x = 0; y = 0;   % Center coordinates of the circle
ang = 0:0.01:2*pi;    % Angle step, higher value = faster drawn but less smooth circle
xp = restThreshold*cos(ang);
yp = restThreshold*sin(ang);
plot(x+xp,y+yp,...
    'color', [0 0 0],...
    'tag', 'rest_threshold');


% Clear value of msg
set(handles.t_msg,'Value',1);

% Welcome message
set(handles.t_msg,'String','Welcome to Proportional Control');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_ProportionalControl wait for user response (see UIRESUME)
% uiwait(handles.figure1);
movegui(hObject,'center');


% --- Outputs from this function are returned to the command line.
function varargout = GUI_ProportionalControl_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in et_update.
function et_update_Callback(hObject, eventdata, handles)
% hObject    handle to et_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open_close_plot1 = findobj('tag', 'open_close_plot1');
open_close_plot2 = findobj('tag', 'open_close_plot2');
pron_sup_plot1 = findobj('tag', 'pron_sup_plot1');
pron_sup_plot2 = findobj('tag', 'pron_sup_plot2');
rest_threshold = findobj('tag', 'rest_threshold');

%% Update open/close area plot, change angles to adjust
xy_axis_length = 100;
open_close_angle = pi/180*str2double(get(handles.et_angleOpenClose,'String'));
pron_sup_angle = pi/180*str2double(get(handles.et_anglePronSup,'String'));
restThreshold = str2double(get(handles.et_restThreshold,'String'));
open_close_length = xy_axis_length*tan(open_close_angle);
pron_sup_length = xy_axis_length*tan(pron_sup_angle);
y1 = [-open_close_length, open_close_length];
y2 = -y1;
x1 = [-pron_sup_length, pron_sup_length];
x2 = -x1;

%% Update rest circle plot
x = 0; y = 0;   % Center coordinates of the circle
ang = 0:0.01:2*pi;    % Angle step, higher value = faster drawn but less smooth circle
xp = restThreshold*cos(ang);
yp = restThreshold*sin(ang);


%% Set new values for the plot and refreshdata
set(open_close_plot1, 'YData',y1);
set(open_close_plot2, 'YData',y2);
set(pron_sup_plot1, 'XData',x1);
set(pron_sup_plot2, 'XData',x2);
set(rest_threshold, 'XData', x+xp, 'YData', y+yp);

refreshdata

% Status message
set(handles.t_msg,'String','Plot updated with new settings');


% --- Executes on button press in pb_run.
function pb_run_Callback(hObject, eventdata, handles)
% hObject    handle to pb_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global realTimeEMGData
%% === Implement here the start of the realtime-feed session of the EMG input-data
% There is no point updating this faster than the update-interval in the
% timer-object, which is currently set as 0.5
% Sende the information further as realTimeEMGData = "Realtime-feed"

%% Initialising the dot object plot
% Calculating the dimension size based on the A-matrix (F=Ax)
dimSizePlotInput = size(handles.patRec.patRecTrained.training,1);
dotObject = DotObjectInitialisation(dimSizePlotInput);
handles.dotObject = dotObject;

%% Changing the flag on run button to 'Run' or 'Stop'
plot = findobj('tag','open_close_plot1');
runButton = findobj('tag','pb_run');
stop_flag = get(plot,'userdata');
if ~isempty(stop_flag)
    if stop_flag == 0
        set(plot,'userdata',1)
        set(runButton,'string','Run');
        
        % Stopping and deleting the timer in ProportionalControlTimer
        timerObject = timerfind('Name', 'ProportionalControlCalculation');
        stop(timerObject);
        delete(timerObject);
        clear functions
        
        %% === Implement here the stop of there realtime-feed session of the EMG input-data
        
        clear realTimeEMGData
        % Updating message status
        set(handles.t_msg,'String','Proportional control stopped.');
    elseif stop_flag == 1
        set(plot,'userdata',0);
        set(runButton,'string','Stop');
        
        % Updating message status
        set(handles.t_msg,'String','Running proportional control...');
        
        ProportionalControlTimer ( realTimeEMGData, handles );        
    end
else
    set(plot,'userdata',0)
    set(runButton,'string','Stop');

    % Updating message status
    set(handles.t_msg,'String','Running proportional control...');

    ProportionalControlTimer ( realTimeEMGData, handles );
end
