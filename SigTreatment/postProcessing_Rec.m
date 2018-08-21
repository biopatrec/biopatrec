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
% 2016-10-20 / Eva Lendaro / Creation


function [cdata, sF, sT] = postProcessing_Rec(handleX)

    global       handles;
    global       sigPreview;
    global       hTreatment;
    global       allData;
    global       nofilt_allData;
    global       timeStamps;
    
    
    allData      = [];
    handles      = handleX;
    hTreatment   = handles.varargin{1};
    sigPreview   = handles.varargin{2};

    
    % Get required informations from sigTreated structure
    nCh                  = size(sigPreview.nCh,2);
    sF                   = sigPreview.sF;
    deviceName           = sigPreview.dev;
    ComPortType          = sigPreview.comm;

    if strcmp(ComPortType, 'COM')
        ComPortName = sigPreview.comn;  

    end
    

%      Save back acquisition parameters to the handles
     handles.nCh         = nCh;
     handles.sF          = sF;
     handles.ComPortType = ComPortType;
     if strcmp(ComPortType, 'COM')
        handles.ComPortName = ComPortName;     
     end
     handles.deviceName  = deviceName;
     
%     % To avoid bugs in RecordingSession_ShowData function
    handles.fast        = 1;
    handles.rep         = 1;                                               
    handles.cT          = 0;
    handles.rT          = 0;
    handles.rampStatus  = 0;
    
    % Setting for data peeking
    sT = str2double(get(handles.et_rectime,'String'));  
    handles.sT    = sT;
    handles.sTall = sT;
    tW            = sigPreview.tW;
    sF            = sigPreview.sF;
    tWs           = tW*sF;                                                 % Time window samples
    handles.tWs   = tWs;
    timeStamps    = 0:1/sF:tW-1/sF;                                        % Create vector of time
    
    
    %% Initialize GUI..

   % pause on;
    
    ampPP = 5;                                              % Time window samples
    sData = zeros(tWs,nCh);  
    offVector = 0:nCh-1;
    offVector = offVector .* ampPP;
    timeStamps    = 0:1/sF:tW-1/sF;    
    for i = 1 : nCh
        sData(:,i) = sData(:,i) + offVector(i);
    end
    
    % Draw figure
    ymin = -ampPP*2/3;
    ymax =  ampPP * nCh - ampPP*1/3;
    
    %initialize post_plot axes
    p_t0 = plot(handles.post_plot, timeStamps, sData); 
    handles.p_t0 = p_t0;
    xlim(handles.post_plot, [0,tW]);
    ylim(handles.post_plot, [ymin ymax]);
    set(handles.post_plot,'YTick',offVector);
    set(handles.post_plot,'YTickLabel',0:nCh-1);
    
    %initialize pre_plot axes
    p_t1 = plot(handles.pre_plot, timeStamps, sData);  
    handles.p_t1 = p_t1;
    xlim(handles.pre_plot, [0,tW]);
    ylim(handles.pre_plot, [ymin ymax]);
    set(handles.pre_plot,'YTick',offVector);
    set(handles.pre_plot,'YTickLabel',0:nCh-1);
    drawnow;
    
    % Allocation of resource to improve speed, total data 
    filtData = zeros(sF*sT, nCh);


    %% Starting Session..
    
%     % Warning to the user
%     set(hTandles.t_msg,'String','Recording...');
%     drawnow;

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

        cData = zeros(tWs, nCh);  

        for timeWindowNr = 1:sT/tW
            cData = Acquire_tWs(deviceName, obj, nCh, tWs);    % acquire a new time window of samples  
            acquireEvent.nofilt_Data = cData;
            fData = cData;
            acquireEvent.Data = PostProcessing_RealtimePatRec(fData, sigPreview);
            
            %PostProcessing_OneShot or TreatData
            PostProc_Show(acquireEvent);            % plot data and add cData to allData vector          
         end 
     
        % Stop acquisition
        StopAcquisition(deviceName, obj);  
    end
     set(handles.t_msg,'String','Acquisition terminated');
     drawnow;
    % NI DAQ card: "You must delete the listener once the operation is complete"
    if strcmp(ComPortType,'NI');  
        if ~s.IsDone                                                   % check if is done
            s.wait();
        end
        delete(lh);
    end

%     % Save Data
    filtData = allData;
    allData = [];                                                      % clean global data for next movement
    nofiltData = nofilt_allData;
    nofilt_allData = [];
    
    %% Session finish..

%     %Not sure about what this is needed for
%     movI = importdata(fileName);                                       
%     set(handles.hPatch,'Xdata',[0 0 0 0]);

%     % Plot the entire thing at the end
    cdata = filtData;
    DataPlot(handles,cdata,nofiltData,sF,sT);
     set(handles.record,'Enable','on');
    set(handles.close,'Enable','on');
   
    
%     
%     chVector = 0:nCh-1;
%     set(handles.lb_channels, 'String', chVector);
%     

end
