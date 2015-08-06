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
% [Give a short summary about the principle of your function here.]
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 20xx-xx-xx / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment on update

function varargout = GUI_SingleMotorTest(varargin)
% GUI_SINGLEMOTORTEST M-file for GUI_SingleMotorTest.fig
%      GUI_SINGLEMOTORTEST, by itself, creates a new GUI_SINGLEMOTORTEST or raises the existing
%      singleton*.
%
%      H = GUI_SINGLEMOTORTEST returns the handle to a new GUI_SINGLEMOTORTEST or the handle to
%      the existing singleton*.
%
%      GUI_SINGLEMOTORTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SINGLEMOTORTEST.M with the given input arguments.
%
%      GUI_SINGLEMOTORTEST('Property','Value',...) creates a new GUI_SINGLEMOTORTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_SingleMotorTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_SingleMotorTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_SingleMotorTest

% Last Modified by GUIDE v2.5 15-Sep-2011 12:10:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_SingleMotorTest_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_SingleMotorTest_OutputFcn, ...
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


% --- Executes just before GUI_SingleMotorTest is made visible.
function GUI_SingleMotorTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_SingleMotorTest (see VARARGIN)

% Choose default command line output for GUI_SingleMotorTest
handles.output = hObject;

% Button Group
set(handles.motordir,'SelectionChangeFcn',@motordir_SelectionChangeFcn);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_SingleMotorTest wait for user response (see UIRESUME)
% uiwait(handles.fig_one_motor_test_panel);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_SingleMotorTest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_initDAQ.
function pb_initDAQ_Callback(hObject, eventdata, handles)
% hObject    handle to pb_initDAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    sF = str2double(get(handles.et_Fs,'String'));
    sT = str2double(get(handles.et_Ts,'String'));
    [ai ao dio] = init_DAQ(sF,sT,1:8);
    
    set(handles.t_ai,'UserData',ai);
    set(handles.t_ao,'UserData',ao);
    set(handles.t_dio,'UserData',dio);

    % Enable Buttons
    set(handles.pb_recordAI,'Enable','on')
    set(handles.pb_stopDAQ,'Enable','on')


function et_Fs_Callback(hObject, eventdata, handles)
    set(handles.pb_recordAI,'Enable','off')
    set(handles.pb_stopDAQ,'Enable','off')


% --- Executes during object creation, after setting all properties.
function et_Fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Ts_Callback(hObject, eventdata, handles)
    set(handles.pb_recordAI,'Enable','off')
    set(handles.pb_stopDAQ,'Enable','off')


% --- Executes during object creation, after setting all properties.
function et_Ts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Ts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Tp_Callback(hObject, eventdata, handles)
% hObject    handle to et_Tp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_Tp as text
%        str2double(get(hObject,'String')) returns contents of et_Tp as a double


% --- Executes during object creation, after setting all properties.
function et_Tp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Tp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_recordAI.
function pb_recordAI_Callback(hObject, eventdata, handles)
        
    Fs = str2double(get(handles.et_Fs,'String'));
    Ts = str2double(get(handles.et_Ts,'String'));
    Tp = str2double(get(handles.et_Tp,'String'));  
    
    cIdx = zeros(1,21);
    gcIdx = zeros(1,21);
    
    % Get ANN
        if get(handles.cb_ann,'Value')
            ANN = get(handles.cb_ann,'UserData');
            if isempty(ANN)    
                [file, path] = uigetfile('*.mat');
                load([path,file]);
                if exist('psoANN','var')
                    ANN = psoANN;
                elseif exist('eaANN','var')
                    ANN = eaANN;
                elseif exist('bpANN','var')
                    ANN = bpANN;
                else
                    errordlg('File without ANNs','Error');
                    return;
                end
                set(handles.cb_ann,'UserData',ANN)
            end
            if Tp ~= ANN.tw 
                errordlg(['Peek time does not match ANN.tw:' num2str(ANN.tw)],'Error');            
                return;
            elseif Fs ~= ANN.Fs 
                errordlg(['Fs does not match ANN.Fs:' num2str(ANN.Fs)],'Error');            
                return;
            end
            cIdx(ANN.cIdx) = 1;
            treated_data.vdata = [];
            treated_data.tdata = [];            
            treated_data.etrN   = 1; 
        end
        ncIdx = get(handles.pm_chrs,'Value');
        gcIdx(ncIdx) = 1;
            
    % Index
    mIIdx = 5;  % Index for motor I
    PWMIdx = 6; % Index for PWM
    
    % Init Graphs
    nxt = round(Ts/Tp) * 5;    % Total samples to peek
    nx = Fs*Tp;                 % samples to peek
    axes(handles.a_motorRI);
    mRIy = zeros(1,nxt);        % Motor RI y (or vector)
    p_motorRI = plot(1:nxt,mRIy);
    axes(handles.a_motorI);
    y = zeros(1,nx);            % Motor I and PWM vector
    p_motorI = plot(1:nx,y);
    axes(handles.a_PWM);
    p_PWM = plot(1:nx,y);       % PWM plot
    axes(handles.a_schr);
    pv = [zeros(1,nxt) ; zeros(1,nxt) ; zeros(1,nxt) ; zeros(1,nxt)];   % Plot vector for signal chrs
    p_schr = plot(1:nxt,pv);
    axes(handles.a_controls);
    cv = zeros(1,nxt);           % Control Vector
    cvA = cv;                    % Analog Control Vector
    p_controls = plot(1:nxt,cv);
    axes(handles.a_error);
    ev = zeros(1,nxt);           % Error Vector
    p_error = plot(1:nxt,ev);

    %Scaling
    chmin(1) = str2double(get(handles.et_ch0min,'String'));
    chmax(1) = str2double(get(handles.et_ch0max,'String'));
    chmin(2) = str2double(get(handles.et_ch1min,'String'));
    chmax(2) = str2double(get(handles.et_ch1max,'String'));
    chmin(3) = str2double(get(handles.et_ch2min,'String'));
    chmax(3) = str2double(get(handles.et_ch2max,'String'));
    chmin(4) = str2double(get(handles.et_ch3min,'String'));
    chmax(4) = str2double(get(handles.et_ch3max,'String'));
    Aoutmin = str2double(get(handles.et_Aoutmin,'String'));
    Aoutmax = str2double(get(handles.et_Aoutmax,'String'));
    errmRImin = str2double(get(handles.et_errmRImin,'String'));
    errmRImax = str2double(get(handles.et_errmRImax,'String'));

    % Chanel for control
    if get(handles.cb_ch0,'value')
        csch = 1;
    elseif get(handles.cb_ch1,'value')
        csch = 2;
    elseif get(handles.cb_ch2,'value')
        csch = 3;        
    elseif get(handles.cb_ch3,'value')
        csch = 4;    
    end
    Amin = chmin(csch);
    Amax = chmax(csch);

    % DAQ
    ai = get(handles.t_ai,'UserData');
    start(ai);
    dio = get(handles.t_dio,'UserData');
    ao = get(handles.t_ao,'UserData');
    StopMotor(dio,ao);

    % wait for the first samples to be aquired
    while ai.SamplesAcquired < Fs*Tp
    end
    i=1;
    while ai.SamplesAcquired < Fs*Ts

        data = peekdata(ai,Fs*Tp);
        datam = data(:,mIIdx);
        datapwm = data(:,PWMIdx);
        data = data(:,1:4);

        % MOTOR
%        data(:,mIIdx) = data(:,mIIdx)./ str2double(get(handles.et_senseR,'String'));    % Change from Voltage to Current
%        motorRI(i) = trapz(data(:,mIIdx)) / 1000;   % Integral of the current per mS
        datam = datam ./ str2double(get(handles.et_senseR,'String'));    % Change from Voltage to Current
        motorRI(i) = trapz(datam) / 1000;   % Integral of the current per mS
        %motorRI(i) = sum(data(:,mIIdx).^2)/Fs*Tp;
        if motorRI(i) >= 0.9                        % Safety routing
            StopMotor(dio,ao);
        end        
        mRIy(i) = motorRI(i);
        set(handles.et_motorRI,'String',num2str(motorRI(i)));
        set(p_motorRI,'YData',mRIy);        
        set(p_motorI,'YData',datam);
        set(p_PWM,'YData',datapwm);
        drawnow;
        
            
        % Signal Characteristics for Amplitud    
        treated_data.trdata = analyze_signal(data(:,1:4),Fs,gcIdx);   % Only Breakdown the Biosignals
        allChrs = fieldnames(treated_data.trdata);
        Chr = allChrs(ncIdx);    
        pv(:,i) = treated_data.trdata.(Chr{1});
        % Graphics
        set(p_schr(1),'YData',pv(1,:));
        set(p_schr(2),'YData',pv(2,:));
        set(p_schr(3),'YData',pv(3,:));       
        set(p_schr(4),'YData',pv(4,:));
            
        if get(handles.cb_ann,'Value')                        
                % filtering
            if ANN.filters.PLH
                data  = BSbutterPLHarmonics(Fs, data);
            elseif ANN.filters.BP
                data  = FilterBP_EMG(Fs, data);    
            end
            treated_data.trdata = analyze_signal(data,Fs,cIdx);
            trset = get_Sets(treated_data,ANN.Chrs);
            
            % Normalize
            if ANN.normalize == 1
                allsets = get(handles.t_allsets,'UserData');
                allsets(length(allsets(:,1))+1 : length(allsets(:,1))+length(trset(:,1)),:) = trset;
                mn = mean(allsets,1);
                vr = var(allsets);
                trset = (trset - mn(ones(size(trset,1), 1), :)) ./ vr(ones(size(trset,1), 1), :);
            end

            ANN = evaluate_ann(trset, ANN);
            
            if round(ANN.o(1)) == 1 && round(ANN.o(2)) == 0 
                dir = [0 1];    % 1 Open
                csch = 2;    
                set(handles.t_msgdir,'String','Open');
            elseif round(ANN.o(1)) == 0 && round(ANN.o(2)) == 1 
                dir = [1 0];    % 2 Close
                csch = 1;    
                set(handles.t_msgdir,'String','Close');
            else
                dir = [1 1];    % 2 Close                
                set(handles.t_msgdir,'String','Do nothing');
            end
            
        else
            % Automatic direction
            if get(handles.cb_ch1and2,'Value')  % CH 1 and CH 2 Natural
                if pv(2,i) > pv(1,i)
                    dir = [0 1];    % 1 Open
                    csch = 2;
                    set(handles.t_msgdir,'String','Open');
                else
                    dir = [1 0];    % 2 Close
                    csch = 1;
                    set(handles.t_msgdir,'String','Close');
                end
            elseif get(handles.cb_ch2and3,'Value')  % CH 2 and CH 3 Usual
                if pv(2,i) > pv(3,i)                
                    dir = [0 1];    % 1 Open
                    csch = 2;
                    set(handles.t_msgdir,'String','Open');
                else
                    dir = [1 0];    % 2 Close
                    csch = 3;
                    set(handles.t_msgdir,'String','Close');
                end
            end
        end
        
        % Scaling: First range is how you want the output, seconde range is where the raw-data comes
        Amin = chmin(csch);        
        Amax = chmax(csch);
        cv(i) = scale(pv(csch,i),0,100,Amin,Amax);
        if cv(i) > 0                        % Set direction only if there is control planned
            putvalue(dio.Line([1 2]), dir);
        else
            putvalue(dio.Line([1 2]), [1 1]); 
        end
        set(p_controls,'YData',cv);
        
        % Error
        smotorRI = scale(motorRI(i),0,100,errmRImin,errmRImax);
        ev(i) = cv(i) - smotorRI;   % 1 Amp = 100%
        set(p_error,'YData',ev);
        
            
        % Scaling output 1 - 4 V and control signal from 0 - 100;    
        cvA(i) = scale(cv(i),Aoutmin,Aoutmax,0,100);
        if get(handles.cb_linkcontrols,'Value')
            putsample(ao,cvA(i));   % Exit according to slider
        end

        i=i+1;
    end

    [data t] = getdata(ai);
    data(:,mIIdx) = data(:,mIIdx)./ str2double(get(handles.et_senseR,'String'));    % change from V to I
    set(handles.t_t,'UserData',t);
    
    set(handles.pb_pmotorRI,'UserData',motorRI);

    motorI = data(:,mIIdx);
    set(p_motorI,'XData',t);
    set(p_motorI,'YData',motorI);
    set(handles.pb_pmotorI,'UserData',motorI);

    PWM = data(:,PWMIdx);
    set(p_PWM,'XData',t);
    set(p_PWM,'YData',PWM);
    set(handles.pb_pPWM,'UserData',PWM);

    set(handles.pb_pschr,'UserData',pv);
    set(handles.pb_pcontrols,'UserData',cv);
    set(handles.pb_pcontrolsA,'UserData',cvA);
    set(handles.pb_perror,'UserData',ev);
    
    StopMotor(dio,ao); % End by stoping the motor
    

% --- Executes on button press in pb_stopDAQ.
function pb_stopDAQ_Callback(hObject, eventdata, handles)
% hObject    handle to pb_stopDAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    ai = get(handles.t_ai,'UserData');
    ao = get(handles.t_ao,'UserData');
    dio = get(handles.t_dio,'UserData');

    stop(ai);
    stop(ao);
    stop(dio);

    

% --- Executes on slider movement.
function s_speed_Callback(hObject, eventdata, handles)
% hObject    handle to s_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    set(handles.et_speed,'String',num2str(get(hObject,'Value')));
    ao = get(handles.t_ao,'UserData');
    putsample(ao,get(hObject,'Value'));      % Exit according to slider


% --- Executes during object creation, after setting all properties.
function s_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function et_speed_Callback(hObject, eventdata, handles)
% hObject    handle to et_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_speed as text
%        str2double(get(hObject,'String')) returns contents of et_speed as a double

    set(handles.s_speed,'Value',str2double(get(hObject,'String')));
    ao = get(handles.t_ao,'UserData');
    putsample(ao,get(handles.s_speed,'Value'));   % Exit according to slider

% --- Executes during object creation, after setting all properties.
function et_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_motordir_Callback(hObject, eventdata, handles)
% hObject    handle to et_motordir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_motordir as text
%        str2double(get(hObject,'String')) returns contents of et_motordir as a double


% --- Executes during object creation, after setting all properties.
function et_motordir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_motordir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function motordir_SelectionChangeFcn(hObject, eventdata)

%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 

dio = get(handles.t_dio,'UserData');

switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'rb_stop'
        set(handles.et_motordir,'String','3');
        putvalue(dio.Line([1 2]), [1 1]);   % Stop motor

    case 'rb_close'
        set(handles.et_motordir,'String','2');
        putvalue(dio.Line([1 2]), [1 0]);   
 
    case 'rb_open'
        set(handles.et_motordir,'String','1');
        putvalue(dio.Line([1 2]), [0 1]); 

    otherwise
        set(handles.et_motordir,'String','3');
        putvalue(dio.Line([1 2]), [1 1]);  
end
%updates the handles structure
guidata(hObject, handles);


% --- Executes on button press in pb_pmotorI.
function pb_pmotorI_Callback(hObject, eventdata, handles)
    figure;
    plot(get(handles.t_t,'UserData'),get(handles.pb_pmotorI,'UserData'));
    title('Motor Current (I)')


% --- Executes on button press in pb_pPWM.
function pb_pPWM_Callback(hObject, eventdata, handles)
    figure;
    plot(get(handles.t_t,'UserData'),get(handles.pb_pPWM,'UserData'));
    title('PWM')


% --- Executes on button press in pb_pmotorV.
function pb_pmotorV_Callback(hObject, eventdata, handles)
% hObject    handle to pb_pmotorV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function et_motorRI_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.

function et_motorRI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_motorRI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_pmotorRI.
function pb_pmotorRI_Callback(hObject, eventdata, handles)
    figure;
    plot(get(handles.pb_pmotorRI,'UserData'));
    title('Motor R Current')



function et_senseR_Callback(hObject, eventdata, handles)
% hObject    handle to et_senseR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_senseR as text
%        str2double(get(hObject,'String')) returns contents of et_senseR as a double


% --- Executes during object creation, after setting all properties.
function et_senseR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_senseR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_pcontrols.
function pb_pcontrols_Callback(hObject, eventdata, handles)
    figure;
    plot(get(handles.pb_pcontrols,'UserData'));
    title('Control Signal')


% --- Executes on button press in pb_pschr.
function pb_pschr_Callback(hObject, eventdata, handles)
    figure;
    plot(get(handles.pb_pschr,'UserData')');
    title('Signal Characteristic')
    legend('1','2','3','4')



function et_ch0min_Callback(hObject, eventdata, handles)
% hObject    handle to et_ch0min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_ch0min as text
%        str2double(get(hObject,'String')) returns contents of et_ch0min as a double


% --- Executes during object creation, after setting all properties.
function et_ch0min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_ch0min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_ch0max_Callback(hObject, eventdata, handles)
% hObject    handle to et_ch0max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_ch0max as text
%        str2double(get(hObject,'String')) returns contents of et_ch0max as a double


% --- Executes during object creation, after setting all properties.
function et_ch0max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_ch0max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_ch0.
function cb_ch0_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch0


% --- Executes on button press in cb_ch1.
function cb_ch1_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch1


% --- Executes on button press in cb_ch2.
function cb_ch2_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch2


% --- Executes on button press in cb_ch3.
function cb_ch3_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch3


% --- Executes on button press in pb_perror.
function pb_perror_Callback(hObject, eventdata, handles)
    figure;
    plot(get(handles.pb_perror,'UserData'));
    title('Error')


% --- Executes on selection change in pm_chrs.
function pm_chrs_Callback(hObject, eventdata, handles)
% hObject    handle to pm_chrs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pm_chrs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_chrs


% --- Executes during object creation, after setting all properties.
function pm_chrs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_chrs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_linkcontrols.
function cb_linkcontrols_Callback(hObject, eventdata, handles)
% hObject    handle to cb_linkcontrols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_linkcontrols


% --- Executes on button press in pb_pcontrolsA.
function pb_pcontrolsA_Callback(hObject, eventdata, handles)
    figure;
    plot(get(handles.pb_pcontrolsA,'UserData'));
    title('Analog Control Signal')



function et_Aoutmin_Callback(hObject, eventdata, handles)
% hObject    handle to et_Aoutmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_Aoutmin as text
%        str2double(get(hObject,'String')) returns contents of et_Aoutmin as a double


% --- Executes during object creation, after setting all properties.
function et_Aoutmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Aoutmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Aoutmax_Callback(hObject, eventdata, handles)
% hObject    handle to et_Aoutmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_Aoutmax as text
%        str2double(get(hObject,'String')) returns contents of et_Aoutmax as a double


% --- Executes during object creation, after setting all properties.
function et_Aoutmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Aoutmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_errmRImin_Callback(hObject, eventdata, handles)
% hObject    handle to et_errmRImin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_errmRImin as text
%        str2double(get(hObject,'String')) returns contents of et_errmRImin as a double


% --- Executes during object creation, after setting all properties.
function et_errmRImin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_errmRImin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_errmRImax_Callback(hObject, eventdata, handles)
% hObject    handle to et_errmRImax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_errmRImax as text
%        str2double(get(hObject,'String')) returns contents of et_errmRImax as a double


% --- Executes during object creation, after setting all properties.
function et_errmRImax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_errmRImax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_ch1min_Callback(hObject, eventdata, handles)
% hObject    handle to et_ch1min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_ch1min as text
%        str2double(get(hObject,'String')) returns contents of et_ch1min as a double


% --- Executes during object creation, after setting all properties.
function et_ch1min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_ch1min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_ch1max_Callback(hObject, eventdata, handles)
% hObject    handle to et_ch1max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_ch1max as text
%        str2double(get(hObject,'String')) returns contents of et_ch1max as a double


% --- Executes during object creation, after setting all properties.
function et_ch1max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_ch1max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_ch2min_Callback(hObject, eventdata, handles)
% hObject    handle to et_ch2min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_ch2min as text
%        str2double(get(hObject,'String')) returns contents of et_ch2min as a double


% --- Executes during object creation, after setting all properties.
function et_ch2min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_ch2min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_ch2max_Callback(hObject, eventdata, handles)
% hObject    handle to et_ch2max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_ch2max as text
%        str2double(get(hObject,'String')) returns contents of et_ch2max as a double


% --- Executes during object creation, after setting all properties.
function et_ch2max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_ch2max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_ch3min_Callback(hObject, eventdata, handles)
% hObject    handle to et_ch3min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_ch3min as text
%        str2double(get(hObject,'String')) returns contents of et_ch3min as a double


% --- Executes during object creation, after setting all properties.
function et_ch3min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_ch3min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_ch3max_Callback(hObject, eventdata, handles)
% hObject    handle to et_ch3max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of et_ch3max as text
%        str2double(get(hObject,'String')) returns contents of et_ch3max as a double


% --- Executes during object creation, after setting all properties.
function et_ch3max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_ch3max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_ch1and2.
function cb_ch1and2_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch1and2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch1and2


% --- Executes on button press in cb_ch2and3.
function cb_ch2and3_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ch2and3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ch2and3


% --- Executes on button press in cb_ann.
function cb_ann_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ann (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ann
