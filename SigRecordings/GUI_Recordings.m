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
% [Give a short summary about the principle of your function here.]
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 20xx-xx-xx / Max Ortiz / Creation
% 20xx-09-19 / Pontus Lvinger / Added plot and text for ramp recording recording
% 2015-01-23 / Pontus Lvinger / New recording session GUI: it has been added the 
                            % possibility to plot more then 8 channels (for both time
                            % and frequency plots)
% 2015-01-26 / Enzo Mastinu / A new GUI_Recordings has been developed for the
                            % BioPatRec_TRE release. Now it is possible to
                            % plot more then 8 channels at the same moment for 
                            % time and frequency plots both. It is faster and
                            % perfectly compatible with the ramp recording 
                            % session. At the end of the recording session it 
                            % is possible to check all channels individually, 
                            % apply offlinedata  process as feature extraction or filter etc.
% 2016-04-01 / Julian Maier / Added Crop option, signal separation, noise
                            % adding, motion filtering, wavelet filering
% 2017-09-25 / Simon Nilsson  / Added virtual reference filtering option



function varargout = GUI_Recordings(varargin)
% GUI_Recordings M-file for GUI_Recordings.fig
%      GUI_Recordings, by itself, creates a new GUI_Recordings or raises the existing
%      singleton*.
%
%      H = GUI_Recordings returns the handle to a new GUI_Recordings or the handle to
%      the existing singleton*.
%
%      GUI_Recordings('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_Recordings.M with the given input arguments.
%
%      GUI_Recordings('Property','Value',...) creates a new GUI_Recordings or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Recordings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Recordings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Recordings

% Last Modified by GUIDE v2.5 24-Mar-2023 12:19:47
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Recordings_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Recordings_OutputFcn, ...
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


% --- Executes just before GUI_Recordings is made visible.
function GUI_Recordings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Recordings (see VARARGIN)

%load the background image into Matlab
backgroundImage2 = importdata('Img/BioPatRec.png');
%select the axes
axes(handles.a_biopatrec);
%place image onto the axes
image(backgroundImage2);
%remove the axis tick marks
axis off
%Do the same for a_pic
axes(handles.a_pic);
axis off

fID = LoadFeaturesIDs;
set(handles.pm_features,'String',['Select feature:'; fID]);

% Choose default command line output for GUI_Recordings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

fast = varargin{1};
if(fast)
    set(handles.et_tW,'visible','on'); 
    set(handles.et_sT,'visible','on');
    set(handles.txt_tW,'visible','on');
    set(handles.txt_sT,'visible','on');
    set(handles.pb_Start,'visible','on');
end
    

% UIWAIT makes GUI_Recordings wait for user response (see UIRESUME)
% uiwait(handles.figure1);
movegui(hObject,'center');

% --- Outputs from this function are returned to the command line.
function varargout = GUI_Recordings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function et_if_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end

    xmax = str2double(get(handles.et_ff,'String'));
    set(handles.a_f0,'XLim',[input xmax]);

    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_if_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_if (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function et_ff_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end

    xmin = str2double(get(handles.et_if,'String'));
    set(handles.a_f0,'XLim',[xmin input]);

    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_ff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_ff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function et_n_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_fc1_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_fc1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_fc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    

function et_fc2_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_fc2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_fc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in pb_ApplyButter.
function pb_ApplyButter_Callback(hObject, eventdata, handles)
    % Get parameters
    N = str2double(get(handles.et_n,'String'));
    cF1 = str2double(get(handles.et_fc1,'String'));
    cF2 = str2double(get(handles.et_fc2,'String'));
    % Load matrix
    load('cdata.mat');
    handles.nCh = size(tempdata,2);
    handles.ComPortType = ComPortType;
    handles.deviceName = deviceName;
    tempdata = ApplyButterFilter(sF, N, cF1, cF2, tempdata);
    DataShow(handles,tempdata,sF,sT);
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');


function et_it_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end

    xmax = str2double(get(handles.et_ft,'String'));
    set(handles.a_pic,'XLim',[input xmax]);
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_it_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_it (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function et_ft_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end

    xmin = str2double(get(handles.et_it,'String'));
    set(handles.a_pic,'XLim',[xmin input]);
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_ft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_ft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function m_file_Callback(hObject, eventdata, handles)
% hObject    handle to m_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_load_Callback(hObject, eventdata, handles)
    t_load_ClickedCallback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function t_load_ClickedCallback(hObject, eventdata, handles)
    % Callback function run when the Open menu item is selected    
    ss = [];
    
    % for compatibility, delete previous temporary data
    if(exist('cdata','var')) == 1
        delete(cdata);
    end
    
    [file, path] = uigetfile({'*.mat';'*.csv'});
        if ~isequal(file, 0)
            [pathstr,name,ext] = fileparts(file);
            if(strcmp(ext,'.mat'))
                load([path,file]);
                if(exist('sF','var')) == 1              % Load current data
                    if(exist('cdata','var')) == 1              % Load current data (fix compatibility issues)
                        DataShow(handles,cdata,sF,sT);
                        tempdata = cdata;
                        save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');
                    elseif(exist('cData','var')) == 1              
                        DataShow(handles,cData,sF,sT);
                        tempdata = cdata;
                        save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');
                    elseif(exist('allData','var')==1)
                        sT = length(allData)/sF;
                        DataShow(handles,allData,sF,sT);
                        tempdata = allData;
                        cdata = allData;
                        nCh = size(allData,2);
                        ComPortType = 'NOT_KNOWN';
                        deviceName = 'ALCD2';
                        save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');
                    end
                elseif(exist('sData','var')) == 1              % fix compatibility with sData old recordings
                        sF = 2000;                             % We are assuming old recordings to be acquired at 2 KHz
                        nCh = size(sData,2);
                        sT = size(sData,1)/sF;
                        cdata = sData;
                        ComPortType = 'unknown';
                        deviceName = 'unknown';
                        DataShow(handles,cdata,sF,sT);
                        tempdata = cdata;
                        save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');      
                elseif exist('recSession','var') || ... % Load session
                       exist('ss','var')                  
                    df = GUI_RecordingSessionShow();
                    dfdata = guidata(df);
                    if ~isempty(ss)
                        recSession = Compatibility_recSession(ss);
                    end
                    set(dfdata.et_Fs,'String',num2str(recSession.sF));
                    set(dfdata.et_Ne,'String',num2str(recSession.nM));
                    set(dfdata.et_Nr,'String',num2str(recSession.nR));
                    set(dfdata.et_Tc,'String',num2str(recSession.cT));
                    set(dfdata.et_Tr,'String',num2str(recSession.rT));
                    set(dfdata.et_msg,'String',recSession.mov);
                    sNe = 1:recSession.nM;
                    set(dfdata.pm_nM,'String',num2str(sNe'));
                    set(dfdata.pm_data,'UserData',recSession); % Save Struct in user data
                    set(dfdata.t_mhandles,'UserData',handles); % Save this GUI handles
                    if isfield(recSession,'cmt')
                        set(dfdata.et_cmt,'String',recSession.cmt);
                    else
                        set(dfdata.et_cmt,'String','No Comment');
                    end
                    if isfield(recSession,'dev')
                        set(dfdata.t_dev,'String',recSession.dev);
                    else
                        set(dfdata.t_dev,'String','Unknown');
                    end
                end
            else
            %CSV / MCARE
                fid = fopen(file);
                fullDir = strcat(path,name,ext); % We get the path of the selected file
                fileDir = dir(fullDir); % We use this to get the size, which is a field of dir
                movText = fgetl(fid); % We read the first line
                movText = textscan(movText, '%s', 'Delimiter', ',', 'BufSize', fileDir.bytes); %Scans for objects seperated with commas
                recSession.mov = movText{1}; %And load them into the recSession
                fclose(fid); %We need to close the file, before we can textscan it with other parameters
                fid = fopen(file);
                C = textscan(fid, '%s', 'Delimiter', '\n', 'BufSize', fileDir.bytes); % Scans for objects seperated by line breaks         
                recSession.date = C{1}{2};
                recSession.comm = C{1}{3};
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

                df = GUI_RecordingSessionShow();
                dfdata = guidata(df);
                if ~isempty(ss)
                    recSession = Compatibility_recSession(ss);
                end
                set(dfdata.et_Fs,'String',num2str(recSession.sF));
                set(dfdata.et_Ne,'String',num2str(recSession.nM));
                set(dfdata.et_Nr,'String',num2str(recSession.nR));
                set(dfdata.et_Tc,'String',num2str(recSession.cT));
                set(dfdata.et_Tr,'String',num2str(recSession.rT));
                set(dfdata.et_msg,'String',recSession.mov);
                sNe = 1:recSession.nM;
                set(dfdata.pm_nM,'String',num2str(sNe'));
                set(dfdata.pm_data,'UserData',recSession); % Save Struct in user data
                set(dfdata.t_mhandles,'UserData',handles); % Save this GUI handles
                if isfield(recSession,'cmt')
                    set(dfdata.et_cmt,'String',recSession.cmt);
                else
                    set(dfdata.et_cmt,'String','No Comment');
                end
                if isfield(recSession,'dev')
                    set(dfdata.t_dev,'String',recSession.dev);
                else
                    set(dfdata.t_dev,'String','Unknown');
                end
            end
        end

    % Set visible the offline plot and process panels
    set(handles.uipanel9,'Visible','on'); 
    set(handles.uipanel10,'Visible','on');
    set(handles.uibuttongroup1,'Visible','on');
    set(handles.uipanel7,'Visible','on');
    set(handles.uipanel8,'Visible','on');
    set(handles.txt_it,'visible','on');
    set(handles.txt_ft,'visible','on');
    set(handles.et_it,'visible','on');
    set(handles.et_ft,'visible','on');
    set(handles.txt_if,'visible','on');
    set(handles.txt_ff,'visible','on');
    set(handles.et_if,'visible','on');
    set(handles.et_ff,'visible','on');
    
    if exist('recSession','var')
        chVector = 0:recSession.nCh-1;
    else
        chVector = 0:size(cdata,2)-1;
    end
    set(handles.lb_channels, 'String', chVector);


% --------------------------------------------------------------------
function t_save_ClickedCallback(hObject, eventdata, handles)    
% Callback function run when the Save menu item is selected
    load('cdata.mat');
    [filename, pathname] = uiputfile({'*.mat','MAT-files (*.mat)'},'Save as', 'Untitled.mat');
%     copyfile('cdata.mat',[pathname,filename],'f');
    cdata = tempdata;
   nCh = size(cdata,2);
    save([pathname filename],'cdata','sF','sT','nCh','ComPortType','deviceName');

% --------------------------------------------------------------------
function m_record_Callback(hObject, eventdata, handles)
% hObject    handle to m_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Rcustomizedsession_Callback(hObject, eventdata, handles)
    %Call the figure recording_Session_fig and pass this figure handles
    GUI_RecordingSession;

    
% --------------------------------------------------------------------
function m_filters_Callback(hObject, eventdata, handles)
% hObject    handle to m_filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Fplh_Callback(hObject, eventdata, handles)
    load('cdata.mat');
    handles.nCh = size(tempdata,2);
    handles.ComPortType = ComPortType;
    handles.deviceName = deviceName;
%    tempdata = BSbutterPLHarmonics(sF,tempdata);
    tempdata = BSbutterMRHarmonics(sF,tempdata);
    DataShow(handles,tempdata,sF,sT);
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');


% --------------------------------------------------------------------
function m_FBSbutter_Callback(hObject, eventdata, handles)
% hObject    handle to m_FBSbutter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    
% --------------------------------------------------------------------
function m_spatialFilterDDF_Callback(hObject, eventdata, handles)
% hObject    handle to m_spatialFilterDDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load('cdata.mat');
    handles.nCh = size(tempdata,2);
    handles.ComPortType = ComPortType;
    handles.deviceName = deviceName;
    tempdata = SpatialFilterDDF(tempdata);
    DataShow(handles,tempdata,sF,sT);
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');


% --------------------------------------------------------------------
function m_spatialFilterSDF_Callback(hObject, eventdata, handles)
% hObject    handle to m_spatialFilterSDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load('cdata.mat');
    handles.nCh = size(tempdata,2);
    handles.ComPortType = ComPortType;
    handles.deviceName = deviceName;
    tempdata = SpatialFilterSDF(tempdata);
    DataShow(handles,tempdata,sF,sT);
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');


% --------------------------------------------------------------------
function m_spatialFilterDDFAbs_Callback(hObject, eventdata, handles)
% hObject    handle to m_spatialFilterDDFAbs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load('cdata.mat');
    handles.nCh = size(tempdata,2);
    handles.ComPortType = ComPortType;
    handles.deviceName = deviceName;
    tempdata = SpatialFilterDDFAbs(tempdata);    
    DataShow(handles,tempdata,sF,sT);
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');


% --- Executes on selection change in pm_features.
function pm_features_Callback(hObject, eventdata, handles)
% hObject    handle to pm_features (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_features contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_features


% --- Executes during object creation, after setting all properties.
function pm_features_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_features (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_extract.
function pb_extract_Callback(hObject, eventdata, handles)
% hObject    handle to pb_extract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    allF = get(handles.pm_features,'String');
    fID  = char(allF(get(handles.pm_features,'Value')));    
    load('cdata.mat');
    handles.nCh = size(tempdata,2);
    handles.ComPortType = ComPortType;
    handles.deviceName = deviceName;
    tempdata = ExtractSigFeature(tempdata,sF,fID);
    fD  = 1/0.02;  % considering an overlap of 20 ms
    DataShow(handles,tempdata,fD,sT);
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');


% --------------------------------------------------------------------
function m_F50hz_Callback(hObject, eventdata, handles)
% hObject    handle to m_F50hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load('cdata.mat');
    handles.nCh = size(tempdata,2);
    handles.ComPortType = ComPortType;
    handles.deviceName = deviceName;
    tempdata = Filter50hz(sF,tempdata);
    DataShow(handles,tempdata,sF,sT);
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');

% --- Executes on selection change in lb_channels.
function lb_channels_Callback(hObject, eventdata, handles)
% hObject    handle to lb_channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_channels contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_channels


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


% --- Executes on button press in pb_plotAll.
function pb_plotAll_Callback(hObject, eventdata, handles)
% hObject    handle to pb_plotAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load('cdata.mat');
    handles.nCh = nCh;
    handles.ComPortType = ComPortType;
    handles.deviceName = deviceName;
    tempdata = cdata;
    DataShow(handles,cdata,sF,sT);
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');
    set(handles.pb_plotSelected,'enable','on');
    set(handles.pb_ApplySepAlg,'enable','on');

    
% --- Executes on button press in pb_plotSelected.
function pb_plotSelected_Callback(hObject, eventdata, handles)
% hObject    handle to pb_plotSelected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Load data
    load('cdata.mat');
    %Selected channels           
    Ch = get(handles.lb_channels,'Value'); 
    tempdata = tempdata(:,Ch);
    tt = 0:1/sF:(length(tempdata)-1)/sF; 
    axes(handles.a_pic);
    plot(tt, tempdata);
    %Fast Fourier Transform
    nS  = length(tempdata);
    NFFT = 2^nextpow2(nS);               
    f = sF/2*linspace(0,1,NFFT/2);
    dataf = fft(tempdata(1:nS,:),NFFT)/nS;    
    m = 2*abs(dataf((1:NFFT/2),:));
    axes(handles.a_f0);
    plot(f,m);
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');
    set(handles.pb_plotSelected,'enable','off');
    set(handles.pb_ApplySepAlg,'enable','off');
    

    
% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_Start.
function pb_Start_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    fast = 1;
    sT = str2double(get(handles.et_sT,'String'));
    tW = str2double(get(handles.et_tW,'String'));
    handles.sT = sT;
    handles.tW = tW;
%     GUI_AFEselection(0,0,0,0,0,handles,0,0,fast);
    GUI_AFEselection(0,0,0,0,0,handles,0,0,fast);



function et_sT_Callback(hObject, eventdata, handles)
% hObject    handle to et_sT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_sT as text
%        str2double(get(hObject,'String')) returns contents of et_sT as a double


% --- Executes during object creation, after setting all properties.
function et_sT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_sT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function et_tW_Callback(hObject, eventdata, handles)
% hObject    handle to et_tW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_tW as text
%        str2double(get(hObject,'String')) returns contents of et_tW as a double


% --- Executes during object creation, after setting all properties.
function et_tW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_tW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function m_Spatial_Callback(hObject, eventdata, handles)
% hObject    handle to m_Spatial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Recordings_Callback(hObject, eventdata, handles)
% hObject    handle to m_Recordings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.et_tW,'visible','on'); 
    set(handles.et_sT,'visible','on');
    set(handles.txt_tW,'visible','on');
    set(handles.txt_sT,'visible','on');
    set(handles.pb_Start,'visible','on');
   


% --- Executes on selection change in pm_icaAlg.
function pm_icaAlg_Callback(hObject, eventdata, handles)
% hObject    handle to pm_icaAlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_icaAlg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_icaAlg


% --- Executes during object creation, after setting all properties.
function pm_icaAlg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_icaAlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_ApplySepAlg.
function pb_ApplySepAlg_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ApplySepAlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('cdata.mat');
handles.nCh = size(tempdata,2);
if handles.nCh == 1
    error('Multichannel data required!')
end
handles.ComPortType = ComPortType;
handles.deviceName = deviceName;
alg = get(handles.pm_icaAlg,'String');
algSel = get(handles.pm_icaAlg,'Value');
tempdata = ComputeSigSep(tempdata',cell2mat(alg(algSel)),sF)';
DataShow(handles,tempdata,sF,sT);
save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');
disp('Signal separation algorithm applied.')


function ed_cropSigEnd_Callback(hObject, eventdata, handles)
% hObject    handle to ed_cropSigEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_cropSigEnd as text
%        str2double(get(hObject,'String')) returns contents of ed_cropSigEnd as a double


% --- Executes during object creation, after setting all properties.
function ed_cropSigEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_cropSigEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_cropSigStart_Callback(hObject, eventdata, handles)
% hObject    handle to ed_cropSigStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_cropSigStart as text
%        str2double(get(hObject,'String')) returns contents of ed_cropSigStart as a double


% --- Executes during object creation, after setting all properties.
function ed_cropSigStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_cropSigStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_cropSig.
function pb_cropSig_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cropSig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('cdata.mat');
handles.ComPortType = ComPortType;
handles.deviceName = deviceName;
cropStart = (str2double(get(handles.ed_cropSigStart,'String')) * sF +1);
cropEnd = str2double(get(handles.ed_cropSigEnd,'String')) * sF;
cdata = cdata(cropStart:cropEnd,:);
tempdata = tempdata(cropStart:cropEnd,:);
DataShow(handles,tempdata,sF,sT);
save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');
disp('Signal croped.')

% --------------------------------------------------------------------
function m_advFilters_Callback(hObject, eventdata, handles)
% hObject    handle to m_advFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_Tools_Callback(hObject, eventdata, handles)
% hObject    handle to m_Tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function m_artifactSelect_Callback(hObject, eventdata, handles)
% hObject    handle to m_artifactSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
brushobj = brush(handles.figure1);
set(handles.m_artifactSelect,'visible','off')
set(handles.m_artifactStop,'visible','on')
set(brushobj,'Enable','on','ActionPostCallback', @saveBrushData);

function saveBrushData(~, eventdata)
load('cdata.mat')
clear artData
nCh = size(tempdata,2);
count = 0;
for i = 1:nCh
    tData = eventdata.Axes.Children(i).BrushHandles.Children(1).VertexData(1,:);
    if ~isempty(tData)
        endSeg = find(diff(tData)>2*(1/sF));
        segIdx = [0, endSeg, numel(tData)];
        for i = 1:numel(segIdx)-1
            currTData = tData(1,segIdx(i)+1:segIdx(i+1));
            count = count +1;
            iCh = nCh+1-i;
            artDataNew = tempdata(round(sort(currTData)*sF),iCh);
            % Normalize artifact
            artDataNew = artDataNew - repmat(mean(artDataNew),size(artDataNew,1),1);
            artDataNew = artDataNew ./ max(max(abs(artDataNew)));
            % Set border of artifact to zero
            pts = 1:size(artDataNew,1);
            pts = [1,pts+8,pts(end)+16];
            grid = 1:pts(end);
            artDataNew = interp1(pts,[0;artDataNew;0],grid,'pchip')';

            if ~exist('artData','var'),
                artData{1}=artDataNew;
            else
                artData = cat(1,artData,artDataNew);
            end
        end
    end
end
save('cdata.mat','artData','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');


% --------------------------------------------------------------------
function m_artifactStop_Callback(hObject, eventdata, handles)
% hObject    handle to m_artifactStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

brushobj = brush(handles.figure1);
set(brushobj,'Enable','off')

load('cdata.mat')
if exist('artData','var')

    choice = questdlg('Add selected artifact(s) to Database?', 'Database','Yes','No','No');
    switch choice
        case 'Yes'
            fName = get(handles.m_artifactStop,'UserData');
            if isempty(fName)
                fName = inputdlg('Enter name of artifact DB:',...
                    'Input', [1 30]);
                fName = ([fName{1} '_artDB']);
                set(handles.m_artifactStop,'UserData',fName);
            end
            
            srtArt = {'Rapid movement','Cable movement','Contact artifact'};
            [selArt,ok] = listdlg('PromptString','Select artifact type:','SelectionMode','single',...
                'ListSize',[160 120],'ListString',srtArt); 
            if ~ok, 
                return; 
            end
            
            if ~exist([fName '.mat'],'file')
                artDB.typeNames = srtArt';
                artDB.data = cell(numel(srtArt),1);
                artDB.data{selArt} = artData;
            else
                load(fName);
                artDB.data{selArt} = cat(1,artDB.data{selArt},artData);
                
            end
            
            save(fName,'artDB')
            disp([num2str(numel(artData)) ' Artifacts added to Database.'])
            set(handles.m_showArt,'visible','on')
        case 'No'
            disp('Artifacts discarded.')
            save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');
    end
end

set(handles.m_artifactSelect,'visible','on')
set(handles.m_artifactStop,'visible','off')


% --------------------------------------------------------------------
function m_showArt_Callback(hObject, eventdata, handles)
% hObject    handle to m_showArt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('cdata.mat')
if exist('artData','var')
    fName = get(handles.m_artifactStop,'UserData');
    if ~isempty(fName)
    load(fName);
    else
        disp('DB not found.')
        return
    end
    srtArt = {'Rapid movement','Cable movement','Contact artifact'};
    [selArt,ok] = listdlg('PromptString','Select artifact type:','SelectionMode','single',...
        'ListSize',[160 120],'ListString',srtArt);
    if ~ok || isempty(artDB.data{selArt})
        disp('No artifacts found.')
        return; 
    end
    N = numel(artDB.data{selArt});
    nCol = ceil(sqrt(N));
    nRow = ceil(N/nCol);
    figure('name',[srtArt{selArt} ' Artifacts'],'color',[1 1 1]);
    nPlot = 1;
    for i = 1:N
        subplot(nRow,nCol,i)
        numArt = numel(artDB.data{selArt}{i});
        x = linspace(0,numArt*(1e3/sF),numArt);
        plot(x,artDB.data{selArt}{i})
        title(['#' num2str(i)])
        xlim([0, floor(x(end))])
        ax = gca;
        ax.YTick = [-1,0,1];
        xlabel('time [ms]');
    end
else
    disp('No artifact DB found.')
end

% --------------------------------------------------------------------
function m_addNoise_Callback(hObject, eventdata, handles)
% hObject    handle to m_addNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('cdata.mat');
snr = inputdlg('Enter noise power (SNR in dB):',...
    'Add white gaussian noise', [1 60]);
snr = str2double(snr{:});
handles.ComPortType = ComPortType;
handles.deviceName = deviceName;
for iCh = 1:size(tempdata,2)
    tempdata(:,iCh) = awgn(tempdata(:,iCh),snr,'measured');
end
DataShow(handles,tempdata,sF,sT);
save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');
disp('Added white gaussian noise.')

% --------------------------------------------------------------------
function m_plotExtern_Callback(hObject, eventdata, handles)
% hObject    handle to m_plotExtern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PlotTimeFreq

% --------------------------------------------------------------------
function m_wden_Callback(hObject, eventdata, handles)
% hObject    handle to m_wden (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wd = GUI_Denoising(); %Open Wavelet GUI
wddata = guidata(wd);
set(wddata.t_sthandles,'UserData',handles); %transfer parent handles to child GUI
denoiseParams = get(handles.t_denoiseParams,'UserData');
denoiseParams = SetDenoiseParams(wddata,denoiseParams);
uiwait(wd);
denoiseParams = get(handles.t_denoiseParams,'UserData');
if ~isempty(denoiseParams)
    load('cdata.mat');
    handles.nCh = size(tempdata,2);
    handles.ComPortType = ComPortType;
    handles.deviceName = deviceName;
    tempdata = WaveletSignalDenoising(tempdata,denoiseParams);    
    DataShow(handles,tempdata,sF,sT);
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');
    disp('Wavelet Denoising applied.')
end

% --------------------------------------------------------------------
function m_vRef_Callback(hObject, eventdata, handles)
% hObject    handle to m_vRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Load matrix
    load('cdata.mat');
    handles.nCh = size(tempdata,2);
    handles.ComPortType = ComPortType;
    handles.deviceName = deviceName;
    tempdata = tempdata - mean(tempdata,2)*ones(1,size(tempdata,2));
    DataShow(handles,tempdata,sF,sT);
    save('cdata.mat','cdata','tempdata','sF','sT','nCh','ComPortType','deviceName');
