function varargout = GUI_SNR(varargin)
% GUI_SNR MATLAB code for GUI_SNR.fig
%      GUI_SNR, by itself, creates a new GUI_SNR or raises the existing
%      singleton*.
%
%      H = GUI_SNR returns the handle to a new GUI_SNR or the handle to
%      the existing singleton*.
%
%      GUI_SNR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SNR.M with the given input arguments.
%
%      GUI_SNR('Property','Value',...) creates a new GUI_SNR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_SNR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_SNR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_SNR

% Last Modified by GUIDE v2.5 26-Oct-2015 10:20:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_SNR_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_SNR_OutputFcn, ...
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

% --- Executes just before GUI_SNR is made visible.
function GUI_SNR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_SNR (see VARARGIN)

% Choose default command line output for GUI_SNR
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_SNR_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_SNR.
function pb_SNR_Callback(hObject, eventdata, handles)
% hObject    handle to pb_SNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.txt_info,'String','Loading Data...');
    
    % Dialog box to open a file
    [file, path] = uigetfile({'*.mat';'*.csv'});
    % Check that the loaded file is a "ss" struct
    if ~isequal(file, 0)
        [pathstr,name,ext] = fileparts(file);
        if(strcmp(ext,'.mat'))
            load([path,file]);
            if (exist('recSession','var'))   
                if recSession.cT < 2
                    disp('The contraction time is too short');
                    errordlg('That was not a valid recording session','Error');
                    return;                
                end
                if recSession.rT < 2
                    disp('The resting time is too short');
                    errordlg('That was not a valid recording session','Error');
                    return;                
                end
             
                set(handles.et_sT,'String',recSession.sT);
                set(handles.et_cT,'String',recSession.cT);
                set(handles.et_rT,'String',recSession.rT);
                set(handles.et_nR,'String',recSession.nR);
                set(handles.et_nM,'String',recSession.nM);
                set(handles.et_nCh,'String',recSession.nCh);

                %% Process SNR for every movement and every channel
                snrValues = zeros(recSession.nM,recSession.nCh);
                for mov = 1:recSession.nM
                    for i = 1:recSession.nCh
                        tempC=[];
                        tempR=[];
                        data = recSession.tdata(:,i,mov);
                        
                        %take 1s from the center of every repetition
                        for r = 1:recSession.nR
                            C_inf =(r-1)*(recSession.rT + recSession.cT)*recSession.sF+(recSession.cT-1)*recSession.sF/2 + 1;
                            C_sup = C_inf-1 + recSession.sF;
                            tempC = cat(1,tempC, data(C_inf:C_sup));
                            R_inf = r*(recSession.cT+recSession.rT)*recSession.sF-(recSession.sF)*(recSession.rT+1)/2 + 1;
                            R_sup = R_inf-1 + recSession.sF;
                            tempR = cat(1,tempR, data(R_inf:R_sup));
                        end
                        contract = rms(tempC);
                        relax = rms(tempR);
                        
                        % snr computation
                        c = (contract)^2;
                        r = (relax)^2;
                        snrValues(mov,i) = 10*log10(c/r);
                    end
                end
                % Create the column and row names in cell arrays 
                cnames = strsplit(num2str(1:recSession.nCh));
                rnames = recSession.mov;
                % Fill up the table
                set(handles.tbl_results,'Data',snrValues,'ColumnName',cnames,'RowName',rnames);
                % Save & print
                save('snr.mat', 'snrValues');
                set(handles.txt_info,'String','SNR results ready and saved in snr.mat file');
                
                %% Process SNR for every movement and every channel for MVC
                mvcsnrValues = zeros(recSession.nM,recSession.nCh);
                if isfield(recSession,'ramp')
                    for mov = 1:recSession.nM
                        for i = 1:recSession.nCh
                            data = recSession.ramp;
                            % contraction information, avoid first second
                            contract = rms(data.maxData(recSession.sF:end,i,mov));
                            % rest information from the same channel
                            relax = rms(data.minData(recSession.sF:end,i));
                            % snr computation
                            c = (contract)^2;
                            r = (relax)^2;
                            mvcsnrValues(mov,i) = 10*log10(c/r);
                        end
                    end
                    % Fill up the table
                    set(handles.tbl_resultsMVC,'Data',mvcsnrValues,'ColumnName',cnames,'RowName',rnames);
                    % Save & print
                    save('snrMVC.mat', 'mvcsnrValues')
                    set(handles.txt_info,'String','SNR results ready and saved in snr.mat and snrMVC.mat files');
                end  
            else
                disp('That was not a valid recording session');
                errordlg('That was not a valid recording session','Error');
                return;                
            end
        end
    end
    
    
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



function et_cT_Callback(hObject, eventdata, handles)
% hObject    handle to et_cT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_cT as text
%        str2double(get(hObject,'String')) returns contents of et_cT as a double


% --- Executes during object creation, after setting all properties.
function et_cT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_cT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function et_rT_Callback(hObject, eventdata, handles)
% hObject    handle to et_rT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_rT as text
%        str2double(get(hObject,'String')) returns contents of et_rT as a double


% --- Executes during object creation, after setting all properties.
function et_rT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_rT (see GCBO)
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



function et_nM_Callback(hObject, eventdata, handles)
% hObject    handle to et_nM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_nM as text
%        str2double(get(hObject,'String')) returns contents of et_nM as a double


% --- Executes during object creation, after setting all properties.
function et_nM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_nM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_nCh_Callback(hObject, eventdata, handles)
% hObject    handle to et_nCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_nCh as text
%        str2double(get(hObject,'String')) returns contents of et_nCh as a double


% --- Executes during object creation, after setting all properties.
function et_nCh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_nCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
