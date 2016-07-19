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
% 2009-04-17 / Max Ortiz  / Creation 
% 2009-06-29 / Max Ortiz  / A dummy repeticion added before start recording 
% 2011-06-00 / Per and Gustav  / Added the analog front end sections
% 2011-06-29 / Max Ortiz  / Optimization to be integrated in the whole system and Fixed to new coding standard.
                            % Any filtering was removed from this routine
                            % Filtering and any other signal processing should be done in
                            % a singal treatment routine
% 2011-08-04 / Max Ortiz  / The 10% of extra indication for the user 
                            % to contract was removed.
% 2012-02-xx / Max Ortiz  / Upgrade DAQ routines for MATLAB R2011b, SBI
                            % Old version was kept as:
                            % RecordinSession_Legacy
% 2012-03-27 / Max Ortiz  / Bug fixed when an arbitrary selection of channels
                            % However, the NI doesn't allow to skip channels
% 2012-04-30 / Max Ortiz  / The possibility of simultaneous recordings was
                            % was removed since it didn't worked with the SBI
                            % in the current implementation. To see how the
                            % simultaneus recordings were done, see
                            % RecordingSession_Legacy
% 2012-12-07 / Nichlas Sander / Added VRE as an option during training.
                            % Movements to display are loaded in
                            % varargin{8}. This since previous movements
                            % were simply loaded as strings.
% 2013-03-07 / Nichlas Sander / When training Arm Flex/Extend the system
                            % will automatically change the view so the
                            % user can see the movement.
% 2013-08-23 / Morten Kristoffersen / Updated the recording sessions to support the new GUI_AFESelection structure                            
% 2013-09-19 / Pontus Lövinger  / Copy of RecordingSession.m
                            % Now used to obatin the effort during rest
                            % Removed plotting functions, only use one
                            % repetiotionm always 3 sec contraction
                            % (relax), no VRE, changed instructions to user
% 2014-11-19 / Enzo Mastinu / Added the ADS1299 AFE routines, modified the
                            % abs based mean into RMS based mean, set the 
                            % time window size to be samplingTime/100, RMS
                            % mean is done "manually" for Matlab compatibility
                            % reasons
% 2015-01-13 / Enzo Mastinu / The control of the different devices is now
                            % managed in other several functions placed
                            % into COMM/AFE folder. See recordingSession.m
% 2015-01-26 / Enzo Mastinu / A new GUI_Recordings has been developed for the
                            % BioPatRec_TRE release. Now it is possible to
                            % plot more then 8 channels at the same moment for 
                            % time and frequency plots both. It is faster and
                            % perfectly compatible with the ramp recording 
                            % session. At the end of the recording session it 
                            % is possible to check all channels individually, 
                            % apply offlinedata  process as feature extraction or filter etc.
% 2015-10-28 / Martin Holder / >2014b plot interface fixes

% 20xx-xx-xx / Author  / Comment



function [rampMin, minData] = ObtainRampMin(varargin)

    global       handles;
    global       allData;
    global       timeStamps;
    global       samplesCounter;
   
    allData      = [];
    nR           = 1;                                                           % Only one repetition
    rT           = 3;                                                           % Always use 3 sec relaxation time
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
    handles.nR          = nR;
    handles.rT          = rT;
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
    handles.cT          = rT;
    handles.rampStatus  = 0;
   
    % Initialization of sampling time
    sT            = rT;
    sTall         = rT;
    handles.sTall = sTall;
    handles.sT    = sT;
    
    % Setting for data peeking
    tW            = sT/100;                                                % Time window size
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
    axis(handles.a_prog,'off');
    set(handles.a_prog,'XLimMode','manual');
    handles.hPatch = patch(xpatch,ypatch,'b','EdgeColor','b','visible','on');
    drawnow update
    

    %% Starting Session..
    
    % Warning to the user
    set(handles.t_msg,'String','Keep a relaxed/rest position, avoid every contraction');
    relax = importdata('Img/relax.jpg');                                       % Import Image
    set(handles.a_pic,'Visible','on');                                     % Turn on visibility
    pic = image(relax,'Parent',handles.a_pic);                             % set image
    axis(handles.a_pic,'off');                                             % Remove axis tick marks
    drawnow;
    pause(7);
    
    handles.contraction = 0;

    % for ex = 1 : nM
    ex = 1;
    
    % Show warning to prepare
    set(handles.t_msg,'String','Get ready to Relax in 3 s');
    pause(1);
    set(handles.t_msg,'String','Get ready to Relax in 2 s');
    pause(1);
    set(handles.t_msg,'String','Get ready to Relax in 1 s');
    pause(1);
 
    timeStamps = 0:1/sF:tW-1/sF;                                       % Timestamps used the time vector
    currentTv = 1;                                                     % Current time vector
    tV = timeStamps(currentTv):1/sF:(tW-1/sF)+timeStamps(currentTv);   % Time vector used for drawing graphics
    currentTv = currentTv - 1 + tWs;                                   % Updated everytime tV is updated
    acquireEvent.TimeStamps = tV';
        
    % Minimum Voluntary Contraction with NI DAQ card
    if strcmp (ComPortType, 'NI')

        % Init SBI
        sCh = 1:nCh;
        s = InitSBI_NI(sF,sT,sCh);
        s.NotifyWhenDataAvailableExceeds = tWs;                            % PEEK time
        lh = s.addlistener('DataAvailable', @RecordingSession_ShowData);   

        % Start DAQ
        cData = zeros(sF*sT, nCh);
        s.startBackground();                                               % Run in the backgroud

        % Contraction
        set(handles.t_msg,'String','Relax');
        startRelaxationTic = tic;
        pause(rT - toc(startRelaxationTic));
        
    % Minimum Voluntary Contraction with other devices    
    else

        % Connect the chosen device, it returns the connection object
        obj = ConnectDevice(handles);

        % Set the selected device and Start the acquisition
        SetDeviceStartAcquisition(handles, obj);

        % update the GUI
        set(handles.t_msg,'String','Relax');

        samplesCounter = 1;                                        % variable used to track the progressing time of the recording session
        tic
        for timeWindowNr = 1:sT/tW

            cData = Acquire_tWs(deviceName, obj, nCh, tWs);    % acquire a new time window of samples
            acquireEvent.Data = cData;
            RecordingSession_ShowData(0, acquireEvent);            % plot data and add cData to allData vector

            samplesCounter = samplesCounter + tWs;
        end
        toc
        
        % Stop acquisition, "contraction" time expired
        StopAcquisition(deviceName, obj);
        
    end

    % NI DAQ card: "You must delete the listener once the operation is complete"
    if strcmp(ComPortType,'NI');  
        if ~s.IsDone                                                   % check if is done
            s.wait();
        end
        delete(lh);
    end   
    
    set(handles.a_pic,'Visible','off');                                 % Turn OFF visibility
    delete(pic);                                                            % Delete image
    set(handles.t_msg,'String','Relaxed State Recorded');              % Show message about acquisition
    pause(3);
    

    %% Get the minimum voluntary contraction informations from allData vector
    minData = allData(1:rT*sF,:);                           % Take only "contraction" part, from 0 to rT [s]
    percent = (rT/100)*20;
    cleaned = minData(percent*sF:(rT-percent)*sF-1,:);                 % Remove the 20% from the begin and from the end of the data
%     avgSample = mean(rms(cleaned),1);                                % RMS Mean value over the samples
    avgSample = sqrt(mean((cleaned.^2),1));                            % RMS Mean value compatible with old version of Matlab

    chMean = mean(avgSample);                                                  % Averages over the channels
    rampMin = chMean(:,:,1);                                                   % Get the averge minimum value
    % rampMin = squeeze(chMean);
    
end
