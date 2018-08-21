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
% 2017-02-28 / Simon Nilsson / Changed time window size to 200 samples
                            % when acquiring data using the RHA2132 for
                            % the buffered acquisition mode to work well.


% 20xx-xx-xx / Author  / Comment



function [rampMax, maxData] = ObtainRampMax(varargin)

    global       handles;
    global       allData;
    global       timeStamps;
    global       samplesCounter;

    allData      = [];
    nM           = varargin{1};
    cT           = 3;
    mov          = varargin{2};
    handles      = varargin{3};
    afeSettings  = varargin{4};
    trainWithVr  = varargin{5};
    vreMovements = varargin{6};
    vreLeftHand  = varargin{7};
    
    % Get required informations from afeSettings structure
    nCh          = afeSettings.channels;
    sF           = afeSettings.sampleRate;
    deviceName   = afeSettings.name;
    ComPortType  = afeSettings.ComPortType;
    if strcmp(ComPortType, 'COM')
        ComPortName = afeSettings.ComPortName;  
    end
    
    % Save back acquisition parameters to the handles
    handles.cT          = cT;
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
    handles.rT          = cT;
    handles.rampStatus  = 0;
    
    % Initialization of sampling time
    sT            = cT;
    sTall         = cT;
    handles.sTall = sTall;
    handles.sT    = sT;
    
    % Setting for data peeking
    % Time window size
    % Window of 200 samples works well with buffered sending mode of RHA2132
    if strcmp(deviceName,'RHA2132')
        tW = 200/sF;
    else
        tW = sT/100;
    end
    tWs           = tW*sF;                                                 % Time window samples
    handles.tWs   = tWs;
    timeStamps    = 0:1/sF:tW-1/sF;                                        % Create vector of time
    
    
    %% Initialize GUI..
  
    % Initialization of the VRE for training if required
    if trainWithVr
        % Parameters for the movement in the VRE
        distance = 60;
        numJumps = 30;
        % Open and connect to the VRE
        open('Virtual Reality.exe');
        handles.vreCommunication = tcpip('127.0.0.1',23068,'NetworkRole','server');
        fopen(handles.vreCommunication);

        %Set up VRE to not return any data. This will speed up the
        %communication.
        fwrite(handles.vreCommunication,sprintf('%c%c%c%c%c','c',char(7),char(0),char(0),char(0)));

        % Send value to show Arm if that value is chosen.
        sent = 0;
        for i = 1:nM
            for j = 1:length(vreMovements{i})
                movement = vreMovements{i}{j};
                if ismember(movement.id,[20 21]) && sent == 0
                    fwrite(handles.vreCommunication,sprintf('%c%c%c%c%c','c',char(6),char(1),char(0),char(0)));
                    sent = 1;
                end
            end
        end

        if vreLeftHand
            fwrite(handles.vreCommunication,sprintf('%c%c%c%c%c','c',char(5),char(1),char(0),char(0)));
        end
    end
    
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

    % Allocation of resource to improve speed, total data 
    recSessionData = zeros(sF*sTall, nCh, nM);

    
    %% Starting Session..
    
    % Warning to the user
    set(handles.t_msg,'String','Get ready for Maximum Voluntary Contraction');
    pause(7);
    importdata('Img/relax.jpg'); % Import Image
    drawnow;
    
    handles.contraction = 1;

    % Run all movements or excersices
    for ex = 1 : nM

        timeStamps = 0:1/sF:tW-1/sF;                                       % Timestamps used the time vector
        currentTv = 1;                                                     % Current time vector
        tV = timeStamps(currentTv):1/sF:(tW-1/sF)+timeStamps(currentTv);   % Time vector used for drawing graphics
        currentTv = currentTv - 1 + tWs;                                   % Updated everytime tV is updated
        acquireEvent.TimeStamps = tV';

        disp(['Start ex: ' num2str(ex) ])
    
        % Warning to the user
        fileName = ['Img/' char(mov(ex)) '.jpg'];
        if ~exist(fileName,'file')
            fileName = 'Img/relax.jpg';
        end

        movI = importdata(fileName); % Import Image
        set(handles.a_pic,'Visible','on');  % Turn on visibility
        pic = image(movI,'Parent',handles.a_pic);   % set image
        axis(handles.a_pic,'off');     % Remove axis tick marks

        % Show warning to prepare
        set(handles.t_msg,'String',['Get ready for Maximum Effort ' mov(ex) ' in 3 s']);
        pause(1);
        set(handles.t_msg,'String',['Get ready for Maximum Effort ' mov(ex) ' in 2 s']);
        pause(1);
        set(handles.t_msg,'String',['Get ready for Maximum Effort ' mov(ex) ' in 1 s']);
        pause(1);
        
        % Minimum Maximum Contraction with NI DAQ card
        if strcmp (ComPortType, 'NI')

            % Init SBI
            sCh = 1:nCh;
            s = InitSBI_NI(sF,sT,sCh);
            s.NotifyWhenDataAvailableExceeds = tWs;                            % PEEK time
            lh = s.addlistener('DataAvailable', @RecordingSession_ShowData);   

            % Start DAQ
            s.startBackground();                                               % Run in the backgroud

            % Contraction
            set(handles.t_msg,'String',mov(ex));
            pic = image(movI,'Parent',handles.a_pic);                      % set image
            axis(handles.a_pic,'off');                                     % Remove axis tick marks
            startContractionTic = tic;
            if trainWithVr
                numberOfMovements = length(vreMovements{ex});
                tempJumps = numJumps/numberOfMovements;
                tempDistance = round(distance/tempJumps);
                vreString = '';
                for i = 1:numberOfMovements
                    movement = vreMovements{ex}{i};
                    vreString = sprintf('%s%c%c%c%c%c',vreString,char(1),char(movement.idVRE),char(movement.vreDir),char(tempDistance),char(1));
                end
                for j = 1:tempJumps
                    fwrite(handles.vreCommunication,vreString);
                end
            end
            pause(cT - toc(startContractionTic));  

        % Minimum Voluntary Contraction with other devices    
        else

            % Connect the chosen device, it returns the connection object
            obj = ConnectDevice(handles);

            % Set the selected device and Start the acquisition
            SetDeviceStartAcquisition(handles, obj);

            % new contraction, the GUI must be updated
            set(handles.t_msg,'String',mov(ex));
            pic = image(movI,'Parent',handles.a_pic);                      % set image
            axis(handles.a_pic,'off');                                     % Remove axis tick marks
            drawnow;
            if trainWithVr
                numberOfMovements = length(vreMovements{ex});
                tempJumps = numJumps/numberOfMovements;
                tempDistance = round(distance/tempJumps);
                vreString = '';
                for i = 1:numberOfMovements
                movement = vreMovements{ex}{i};
                vreString = sprintf('%s%c%c%c%c%c',vreString,char(1),char(movement.idVRE),char(movement.vreDir),char(tempDistance),char(1));
                end
                for j = 1:tempJumps
                fwrite(handles.vreCommunication,vreString);
                end
            end

            samplesCounter = 1;                                        % variable used to track the progressing time of the recording session
            tic
            for timeWindowNr = 1:sT/tW

                cData = Acquire_tWs(deviceName, obj, nCh, tWs);    % acquire a new time window of samples
                acquireEvent.Data = cData;
                RecordingSession_ShowData(0, acquireEvent);            % plot data and add cData to allData vector

                samplesCounter = samplesCounter + tWs;
            end
            toc
            
            % Stop acquisition, contraction time expired
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
        recSessionData(:,:,ex) = allData(:,:);
        allData = [];                                                      % clean global data for next movement
        
    end

    set(handles.a_pic,'Visible','off');                                 % Turn OFF visibility
    delete(pic);                                                            % Delete image
    set(handles.t_msg,'String','Maximum and Minimum Session Terminated');              % Show message about acquisition
    pause(3);
    
    if trainWithVr
       fclose(handles.vreCommunication); 
    end

    %% Get the max value and organize them acccording to the selected movements
    maxData = recSessionData(1:cT*sF,:,:);                         % Take only contraction part, from 0 to cT [s]
    percent = (cT/100)*20;
    cleaned = maxData(percent*sF:(cT-percent)*sF-1,:,:);               % Remove the 20% from the begin and from the end of the data
    avgSample = sqrt(mean((cleaned.^2),1));                            % RMS Mean value compatible with old version of Matlab
    
    chMean = mean(avgSample);                                                  % Averages the time windows then averages the channels
    rampMax = squeeze(chMean);
    
end
