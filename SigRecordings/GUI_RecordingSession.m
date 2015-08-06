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
% 20xx-xx-xx / Pontus Lövinger  / Added an alternative for ramp recording
% 20xx-xx-xx / Author  / Comment on update

function varargout = GUI_RecordingSession(varargin)
% GUI_RECORDINGSESSION M-file for GUI_RecordingSession.fig
%      GUI_RECORDINGSESSION, by itself, creates a new GUI_RECORDINGSESSION or raises the existing
%      singleton*.
%
%      H = GUI_RECORDINGSESSION returns the handle to a new GUI_RECORDINGSESSION or the handle to
%      the existing singleton*.
%
%      GUI_RECORDINGSESSION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_RECORDINGSESSION.M with the given input arguments.
%
%      GUI_RECORDINGSESSION('Property','Value',...) creates a new GUI_RECORDINGSESSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_RecordingSession_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_RecordingSession_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_RecordingSession

% Last Modified by GUIDE v2.5 19-Sep-2013 09:13:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_RecordingSession_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_RecordingSession_OutputFcn, ...
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


% --- Executes just before GUI_RecordingSession is made visible.
function GUI_RecordingSession_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_RecordingSession (see VARARGIN)

backgroundImage2 = importdata('/../Img/BioPatRec.png');
%select the axes
axes(handles.axes2);
%place image onto the axes
image(backgroundImage2);
%remove the axis tick marks
axis off

%load the background image into Matlab
%if image is not in the same directory as the GUI files, you must use the 
%full path name of the iamge file
backgroundImage = importdata('/../Img/surface.jpg');
%select the axes
axes(handles.axes1);
%place image onto the axes
image(backgroundImage);
%remove the axis tick marks
axis off

%clear value of msg
set(handles.et_msg,'Value',1);

% Choose default command line output for GUI_RecordingSession
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_RecordingSession wait for user response (see UIRESUME)


% --- Outputs from this function are returned to the command line.
function varargout = GUI_RecordingSession_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function et_Fs_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


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



function et_Ne_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end

    if input == 2
        msg = {'Open  Hand';
               'Close Hand';};
        set(handles.et_msg,'String',msg);
    end
    if input == 4
        msg = {'Open   Hand';
               'Close  Hand';
               'Flex   Hand';
               'Extend Hand'};
        set(handles.et_msg,'String',msg);
    end
    if input == 6
        msg = {'Open   Hand';
               'Close  Hand';
               'Flex   Hand';
               'Extend Hand';
               'Pronation  ';
               'Supination '};
        set(handles.et_msg,'String',msg);
    end
    if input == 8
        msg = {'Open   Hand';
               'Close  Hand';
               'Flex   Hand';
               'Extend Hand';
               'Pronation  ';
               'Supination ';
               'Side Grip  ';
               'Fine Grip  '};
        set(handles.et_msg,'String',msg);
    end
    if input == 10
        msg = {'Open   Hand';
               'Close  Hand';
               'Flex   Hand';
               'Extend Hand';
               'Pronation  ';
               'Supination ';
               'Side Grip  ';
               'Fine Grip  ';
               'Agree      ';
               'Pointer    '};
          set(handles.et_msg,'String',msg);
    end
    if input == 12
        msg = {'Open   Hand';
               'Close  Hand';
               'Flex   Hand';
               'Extend Hand';
               'Pronation  ';
               'Supination ';
               'Side Grip  ';
               'Fine Grip  ';
               'Agree      ';
               'Pointer    ';
               'Thumb Ext  ';
               'Thumb Flex '};
          set(handles.et_msg,'String',msg);
    end
    if input == 14
        msg = {'Open Hand';
               'Close Hand';
               'Flex Hand';
               'Extend Hand';
               'Pronation  ';
               'Supination ';
               'Side Grip  ';
               'Fine Grip  ';
               'Agree      ';
               'Pointer    ';
               'Thumb Ext  ';
               'Thumb Flex ';
               'Thumb Abduc';
               'Thumb Adduc'};
          set(handles.et_msg,'String',msg);
    end




    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_Ne_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Ne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Nr_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_Nr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Nr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Tc_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_Tc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Tc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Tr_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_Tr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Tr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function et_Psr_Callback(hObject, eventdata, handles)
    input = str2double(get(hObject,'String'));
    if (isempty(input))
         set(hObject,'String','0')
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function et_Psr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_Psr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function et_msg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to et_msg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function et_msg_Callback(hObject, eventdata, handles)

    movS = get(handles.et_msg,'String');
    movN = get(handles.et_msg,'Value');
    
    mov = movS(movN(1));
    
    %backgroundImage = importdata(['/../Img/mov' num2str(num) '.JPG']);
    backgroundImage = importdata(['/../Img/' char(mov) '.JPG']);
    image(backgroundImage);
    axis off


% --- Executes on button press in pb_Record.
function pb_Record_Callback(hObject, eventdata, handles)
    % get the EMG_AQ Handles
    fast = 0;
    h1 = GUI_Recordings(fast); 
    hGUI_Rec = guidata(h1);
    rampStatus = get(handles.cb_ramp,'Value');
    
    %psr = str2double(get(handles.et_Psr,'String'));   % Percentage of the exercise time to be consider for training
    %sF = str2double(get(handles.et_Fs,'String'));     % Sampling Frequency
    %nM = str2double(get(handles.et_Ne,'String'));     % number of exercises or movements

    nR = str2double(get(handles.et_Nr,'String'));     % number of excersice repetition
    cT = str2double(get(handles.et_Tc,'String'));     % time that the contractions should last
    rT = str2double(get(handles.et_Tr,'String'));     % relaxing time
    
    movS = get(handles.et_msg,'String');
    movN = get(handles.et_msg,'Value');
    nM = length(movN);
    mov = movS(movN);
    allMovements = InitMovements();
    tempMovements = num2cell(allMovements(movN+1));
    vreMovements = num2cell(tempMovements);
    
    % Simultaneous movements
    % Only for pairs 
    if get(handles.cb_simultaneous,'Value');     % sim mov
        %Validate is a pair number
        pF = factor(nM);     % Prime factor        
        if pF(1) == 2
            % Create combinations by 2
            newM = 0;
            for i = 1 : 2:  nM
                for j = i+2 : nM
                    mov{end+1} = [char(mov(i)) ' + ' char(mov(j))];
                    mov{end+1} = [char(mov(i+1)) ' + ' char(mov(j))];  
                    vreMovements{end + 1} = [tempMovements(i), tempMovements(j)];
                    vreMovements{end + 1} = [tempMovements(i+1), tempMovements(j)];
                    newM = newM + 2;
                end
            end
            nM = nM + newM;

            % Create combinations by 3
            if size(movN,2) >= 6
                newM = 0;
                for i = 1 : 2 :  size(movN,2)
                    for j = i+2 : size(movN,2) - 2
                        for k = i+4 : size(movN,2)
                            mov{end+1} = [char(mov(i)) ' + ' char(mov(j)) ' + ' char(mov(k))];
                            mov{end+1} = [char(mov(i+1)) ' + ' char(mov(j)) ' + ' char(mov(k))];        
                            vreMovements{end + 1} = [tempMovements(i), tempMovements(j), tempMovements(k)];
                            vreMovements{end + 1} = [tempMovements(i+1), tempMovements(j), tempMovements(k)];
                            newM = newM + 2;
                        end
                    end
                end
                nM = nM + newM;
           end
            
        else
            msgbox('Simultaneous movements require an even number','Recording session','Error')
            return;
        end                  
    end

    fast = 0;
    GUI_AFEselection(nM,nR,cT,rT,mov,hGUI_Rec,vreMovements,rampStatus,fast)
    %GUI_AFEselection(sF,nM,nR,cT,rT,psr,mov,hGUI_Rec)
    
% Moved to AFE_select
%     cdata = recording_session(Fs,Ne,Nr,Tc,Tr,Psr,msg,EMG_AQhandle);
%     Ts = (Tc+Tr)*Nr;
%     save('cdata.mat','cdata','Fs','Ts');
%     close(GUI_RecordingSession);



% --- Executes on button press in pb_cancel.
function pb_cancel_Callback(hObject, eventdata, handles)
    close(GUI_RecordingSession);


% --- Executes on button press in cb_simultaneous.
function cb_simultaneous_Callback(hObject, eventdata, handles)
% hObject    handle to cb_simultaneous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_simultaneous


% --- Executes on button press in cb_ramp.
function cb_ramp_Callback(hObject, eventdata, handles)
% hObject    handle to cb_ramp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_ramp
