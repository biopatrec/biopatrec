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
% ------------------- Function Description ------------------
% Function to Record Exc Sessions
%
% --------------------------Updates--------------------------
% 2015-01-26 / Enzo Mastinu / A new GUI_Recordings has been developed for the
                            % BioPatRec_TRE release. Now it is possible to
                            % plot more then 8 channels at the same moment, for 
                            % time and frequency plots both. It is faster and
                            % perfectly compatible with the ramp recording 
                            % session. At the end of the recording session it 
                            % is possible to check all channels individually, 
                            % apply offline data process as feature extraction or filter etc.

% 20xx-xx-xx / Author  / Comment



function [cdata, sF, sT] = FastRecordingSession(varargin)

    global       handles;
    global       allData;
    global       timeStamps;
    global       samplesCounter;
    allData      = [];
    handles      = varargin{1};
    afeSettings  = varargin{2};

    % Get required informations from afeSettings structure
    nCh          = afeSettings.channels;
    sF           = afeSettings.sampleRate;
    deviceName   = afeSettings.name;
    ComPortType  = afeSettings.ComPortType;
    if strcmp(ComPortType, 'COM')
        ComPortName = afeSettings.ComPortName;  
    end
    
    % Save back acquisition parameters to the handles
    handles.nCh         = nCh;
    handles.sF          = sF;
    handles.ComPortType = ComPortType;
    if strcmp(ComPortType, 'COM')
        handles.ComPortName = ComPortName;     
    end
    handles.deviceName  = deviceName;
    % To avoid bugs in RecordingSession_ShowData function
    handles.fast        = 1;
    handles.rep         = 1;                                               
    handles.cT          = 0;
    handles.rT          = 0;
    handles.rampStatus  = 0;
    
    % Setting for data peeking
    sT            = handles.sT;
    handles.sT    = sT;
    handles.sTall = sT;
    tW            = handles.tW;
    tWs           = tW*sF;                                                 % Time window samples
    handles.tWs   = tWs;
    timeStamps    = 0:1/sF:tW-1/sF;                                        % Create vector of time
    
    
    %% Initialize GUI..

    pause on;
    
    % Initialize plots, offset the data
    ampPP = 5;
    sData = zeros(tWs,nCh);   
    fData = zeros(tWs,nCh);
    offVector = 0:nCh-1;
    offVector = offVector .* ampPP;
    for i = 1 : nCh
        sData(:,i) = sData(:,i) + offVector(i);
        fData(:,i) = fData(:,i) + offVector(i);
    end
    
    % Draw figure
    ymin = -ampPP*2/3;
    ymax =  ampPP * nCh - ampPP*1/3;
    p_t0 = plot(handles.a_t0, timeStamps, sData);
    handles.p_t0 = p_t0;
    xlim(handles.a_t0, [0,tW]);
    ylim(handles.a_t0, [ymin ymax]);
    set(handles.a_t0,'YTick',offVector);
    set(handles.a_t0,'YTickLabel',0:nCh-1);
    p_f0 = plot(handles.a_f0,timeStamps,fData);
    handles.p_f0 = p_f0;  
    xlim(handles.a_f0, [0,sF/2]);
    ylim(handles.a_f0, [ymin ymax]);
    set(handles.a_f0,'YTick',offVector);
    set(handles.a_f0,'YTickLabel',0:nCh-1);
    
    % Initialization of progress bar
    xpatch = [0 0 0 0];
    ypatch = [0 0 1 1];
    axes(handles.a_prog);
    handles.hPatch = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');

    % Allocation of resource to improve speed, total data 
    recSessionData = zeros(sF*sT, nCh);


    %% Starting Session..
    
    % Warning to the user
    set(handles.t_msg,'String','start');
    drawnow;

    % Run 
    timeStamps = 0:1/sF:tW-1/sF;                                       % Timestamps used the time vector
    currentTv = 1;                                                     % Current time vector
    tV = timeStamps(currentTv):1/sF:(tW-1/sF)+timeStamps(currentTv);   % Time vector used for drawing graphics
    currentTv = currentTv - 1 + tWs;                                   % Updated everytime tV is updated
    acquireEvent.TimeStamps = tV';

    %%%%% NI DAQ card %%%%%
    if strcmp (ComPortType, 'NI')

        % Init SBI
        sCh = 1:nCh;
        s = InitSBI_NI(sF,sT,sCh);
        s.NotifyWhenDataAvailableExceeds = tWs;                        % PEEK time
        lh = s.addlistener('DataAvailable', @RecordingSession_ShowData);   

        % Start DAQ
        cData = zeros(sF*sT, nCh);
        s.startBackground();                                           % Run in the backgroud

        startTimerTic = tic;
        pause(sT - toc(startTimerTic));

    % Repetitions other devices     
    else

        % Connect the chosen device, it returns the connection object
        obj = ConnectDevice(handles);

        % Set the selected device and Start the acquisition
        SetDeviceStartAcquisition(handles, obj);

        samplesCounter = 1;
        cData = zeros(tWs, nCh);  

        for timeWindowNr = 1:sT/tW
            cData = Acquire_tWs(deviceName, obj, nCh, tWs);    % acquire a new time window of samples  
            acquireEvent.Data = cData;
            RecordingSession_ShowData(0, acquireEvent);            % plot data and add cData to allData vector
            samplesCounter = samplesCounter + tWs;
        end

        % Stop acquisition
        StopAcquisition(deviceName, obj);  
    end

    % NI DAQ card: "You must delete the listener once the operation is complete"
    if strcmp(ComPortType,'NI');  
        if ~s.IsDone                                                   % check if is done
            s.wait();
        end
        delete(lh);
    end

    % Save Data
    recSessionData = allData;
    allData = [];                                                      % clean global data for next movement
    
    
    %% Session finish..
    set(handles.t_msg,'String','Session Terminated');                  % Show message about acquisition completed     
    fileName = 'Img/Agree.jpg';
    movI = importdata(fileName);                                       % Import Image
    set(handles.a_pic,'Visible','on');                                 % Turn on visibility
    pic = image(movI,'Parent',handles.a_pic);                          % set image
    axis(handles.a_pic,'off');                                         % Remove axis tick marks
    set(handles.a_prog,'visible','off');
    set(handles.hPatch,'Xdata',[0 0 0 0]);

    % Data Plot
    cdata = recSessionData;
    DataShow(handles,cdata,sF,sT);
    
    % Set visible the offline plot and process panels
    set(handles.uipanel9,'Visible','on');   
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
    
    chVector = 0:nCh-1;
    set(handles.lb_channels, 'String', chVector);
end
