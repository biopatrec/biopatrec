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
% 2013-06-10 / Kristian Berrum  / Added support for Trigno Wireless Sensor
                            % System. 



function [cdata, sF] = RecordingSession(varargin)

global handles;
global allData;
global allDataACC;
global data_arrayEMG;

allData     = [];
nM          = varargin{1};
nR          = varargin{2};
cT          = varargin{3};
rT          = varargin{4};
mov         = varargin{5};
handles     = varargin{6};
afeSettings = varargin{7};
trainWithVr = varargin{8};
vreMovements = varargin{9};

distance = 90;
numJumps = 45;

sT          = (cT+rT)*nR;   % Sampling time, it is the time of contraction + 
                            % Time of relaxation x Number of repetitions

% Get number of channels and sampling frequency
% for the device to be displayed
if afeSettings.NI.show
    nCh = afeSettings.NI.channels;
    sF  = afeSettings.NI.sampleRate;
elseif afeSettings.DT.show
    nCh = afeSettings.DT.channels;
    sF  = afeSettings.DT.sampleRate;
    sFa = 148;              %Acceleration data frequency 
elseif afeSettings.ADS.show
    nCh = afeSettings.ADS.channels;
    sF  = afeSettings.ADS.sampleRate;
elseif afeSettings.RHA.show
    nCh = afeSettings.RHA.channels;    
    sF  = afeSettings.RHA.sampleRate;
end

if trainWithVr
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
end

handles.sF = sF;
handles.cT = cT;
handles.rT = rT;
handles.nCh = nCh;

pause on;

%% Initialize plots
% Create handles for the plots
% this is faster than creating the plot everytime
   % Create data for sT / 100
if afeSettings.DT.active
    tt  = 0:1/sF:1.026-1/sF;
    ymin    = -0.006;
    ymax    = 0.006;
else
    tt  = 0:1/sF:sT/100-1/sF;
    ymin    = -3.00;
    ymax    = 3.00;
end


% Init the plots
if nCh >= 1
    %axes(handles.a_t0);
    p_t0 = plot(handles.a_t0,tt,tt);
    xlim('auto');
    ylim(handles.a_t0, [ymin ymax]);
    handles.p_t0 = p_t0;
    %axes(handles.a_f0);
    p_f0 = plot(handles.a_f0,1,1);
    handles.p_f0 = p_f0;
end
if nCh >= 2
    p_t1 = plot(handles.a_t1,tt,tt);
    ylim(handles.a_t1, [ymin ymax]);
    p_f1 = plot(handles.a_f1,1,1);
    handles.p_t1 = p_t1;
    handles.p_f1 = p_f1;
end
if nCh >= 3
    p_t2 = plot(handles.a_t2,tt,tt);
    ylim(handles.a_t2, [ymin ymax]);
    p_f2 = plot(handles.a_f2,1,1);
    handles.p_t2 = p_t2;
    handles.p_f2 = p_f2;
end

if nCh >= 4
    p_t3 = plot(handles.a_t3,tt,tt);
    ylim(handles.a_t3, [ymin ymax]);
    p_f3 = plot(handles.a_f3,1,1);
    handles.p_t3 = p_t3;
    handles.p_f3 = p_f3;
end

if nCh >= 5
    p_t4 = plot(handles.a_t4,tt,tt);
    ylim(handles.a_t4, [ymin ymax]);
    %axes(handles.a_f4);
    %p_f4 = plot(1,1);
    handles.p_t4 = p_t4;
end

if nCh >= 6
    p_t5 = plot(handles.a_t5,tt,tt);
    ylim(handles.a_t5, [ymin ymax]); 
    %axes(handles.a_f5);
    %p_f5 = plot(1,1);
    handles.p_t5 = p_t5;
end

if nCh >= 7
    p_t6 = plot(handles.a_t6,tt,tt);
    ylim(handles.a_t6, [ymin ymax]); 
    %axes(handles.a_f6);
    %p_f6 = plot(1,1);
    handles.p_t6 = p_t6;
end

if nCh >= 8
    p_t7 = plot(handles.a_t7,tt,tt);
    ylim(handles.a_t7, [ymin ymax]); 
    %axes(handles.a_f7);
    %p_f7 = plot(1,1);
    handles.p_t7 = p_t7;
end

%% Initialization of progress bar
xpatch = [0 0 0 0];
ypatch = [0 0 1 1];
%set(handles.figure1,'CurrentAxes',handles.a_prog);
axes(handles.a_prog);
handles.hPatch = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');

%% Initialization of the effort bar
xpatch = [1 1 0 0];
ypatch = [0 0 0 0];
axes(handles.a_effort0);
handles.hPatch0 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(handles.a_effort1);
handles.hPatch1 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(handles.a_effort1);
handles.hPatch1 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(handles.a_effort2);
handles.hPatch2 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(handles.a_effort3);
handles.hPatch3 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(handles.a_effort4);
handles.hPatch4 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(handles.a_effort5);
handles.hPatch5 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(handles.a_effort6);
handles.hPatch6 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(handles.a_effort7);
handles.hPatch7 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
handles.effortMax = 3;

if afeSettings.DT.active
    handles.effortMax = 0.005;
end
        
%% Initialize DAQ card
if afeSettings.NI.active
    %afeSettings.NI.sampleRate=sF; %overrides the individual samplerate choise in AFS_select
                                    % instruction from Per and Gustav, why
                                    % would you overwrite the selected sF?
                                    
                                    % All following sF needs to be changed to
                                    % invidual sF in order to make it work
                                    % /Per
    %ai = Init_NI_AI(handles,afeSettings.NI.sampleRate,sT,nCh); %Legacy
    %Init SBI
    sCh = 1:nCh;
    s = InitSBI_NI(afeSettings.NI.sampleRate,sT,sCh);
    s.NotifyWhenDataAvailableExceeds = (sF*sT)/100;           % PEEK time
    lh = s.addlistener('DataAvailable', @RecordingSession_ShowData);   
    
    dev = afeSettings.NI.name;
    
end
if afeSettings.DT.active
     [interfaceObjectEMG, interfaceObjectACC, commObject] = TrignoInit(handles);
    
    data_arrayEMG = zeros(32832,1);
    
    %% Setup interface object to read chunks of data
    % Define a callback function to be executed when desired number of bytes
    % are available in the input buffer
    bytesToReadEMG = 13824;
    interfaceObjectEMG.BytesAvailableFcn = {@ReadAndPlotAdvancedEMG, handles, bytesToReadEMG};
    interfaceObjectEMG.BytesAvailableFcnMode = 'byte';
    interfaceObjectEMG.BytesAvailableFcnCount = bytesToReadEMG;
    bytesToReadACC = 3072;
    interfaceObjectACC.BytesAvailableFcn = {@ReadACC, handles, bytesToReadACC};
    interfaceObjectACC.BytesAvailableFcnMode = 'byte';
    interfaceObjectACC.BytesAvailableFcnCount = bytesToReadACC;
    %}
    
    %% 
    % Open the interface object
    try
        fopen(interfaceObjectEMG);
    
        fopen(interfaceObjectACC);
     
        fopen(commObject);
    catch
        localCloseFigure(1, interfaceObjectEMG, interfaceObjectACC, commObject);
        error('CONNECTION ERROR: Please start the Delsys Trigno Control Application and try again');
    end
    
    dev = afeSettings.DT.name;
    disp(dev)
end
if afeSettings.ADS.active
    Amp=12;
    Vref=2.4*2; %*2 is from bipolar reference
    ByteDepth=3;
    afeSettings.ADS.sampleRate=sF;  %overrides the individual samplerate choise in AFS_select
    dataFormat=2;
    ADS = AFE_PICCOLO(afeSettings.ADS.ComPortType,afeSettings.ADS.sampleRate, ...
        sT,nCh,Amp,Vref,dataFormat,afeSettings.ADS.name,ByteDepth);
end
if afeSettings.RHA.active
    Amp=200;
    Vref=2.5;
    ByteDepth=2;
    afeSettings.RHA.sampleRate=sF;  %overrides the individual samplerate choise in AFS_select
    dataFormat=1;
    RHA = AFE_PICCOLO(afeSettings.RHA.ComPortType,afeSettings.RHA.sampleRate, ...
        sT,nCh,Amp,Vref,dataFormat,afeSettings.RHA.name,ByteDepth);
end

%% Allocation of resource to improve speed, total data 

sbiData  = zeros(sF*sT,nCh,nM);
ADStdata = zeros(sF*sT,nCh,nM);
RHAtdata = zeros(sF*sT,nCh,nM);

trignoData = zeros(sF*sT,nCh,nM);
if afeSettings.DT.active
    atrignoData = zeros(sFa*sT,3,nCh,nM);
end

% Warning to the user
set(handles.t_msg,'String','Get ready to start: 3');
pause(1);
set(handles.t_msg,'String','Get ready to start: 2');
pause(1);
set(handles.t_msg,'String','Get ready to start: 1');
pause(1);

relax = importdata('Img/relax.jpg'); % Import Image
drawnow;

%% Run all movements or excersices
for ex = 1 : nM
    disp(['Start ex: ' num2str(ex) ])
    
    % Warning to the user
    fileName = ['Img/' char(mov(ex)) '.jpg'];
    if ~exist(fileName,'file')
        fileName = 'Img/relax.jpg';
    end
    
    movI = importdata(fileName); % Import Image
    set(handles.a_pic,'Visible','on');  % Turn on visibility
    %axes(handles.a_pic);        % get handles
    pic = image(movI,'Parent',handles.a_pic);   % set image
    axis(handles.a_pic,'off');     % Remove axis tick marks
    
    % Show warning to prepare
    set(handles.t_msg,'String',['Get ready for ' mov(ex) ' in 3 s']);
    pause(1);
    set(handles.t_msg,'String',['Get ready for ' mov(ex) ' in 2 s']);
    pause(1);
    set(handles.t_msg,'String',['Get ready for ' mov(ex) ' in 1 s']);
    %set(handles.a_pic,'Visible','off');  % Turn OFF visibility
    %delete(pic);                         % Delete image
    pause(1);
    
    %% Dummy Contraction
    set(handles.t_msg,'String',mov(ex));
    if afeSettings.prepare
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
        
        pause(cT);
        set(handles.t_msg,'String','Relax');
        if trainWithVr
            fwrite(handles.vreCommunication,sprintf(sprintf('%c%c%c%c%c','r',char(1),char(1),char(1),char(1))));
        end
        pic = image(relax,'Parent',handles.a_pic);           % set image
        axis(handles.a_pic,'off');     % Remove axis tick marks
        pause(rT);
    end

    
    %% Start DAQ
    if afeSettings.NI.active
        % start(ai);
        % Run in the backgroud
        s.startBackground();        
    end
    if afeSettings.DT.active
        fprintf(commObject, sprintf(['START\r\n\r']));
        pause(0.7);
    end
    if afeSettings.ADS.active
        ADS.startRecording
    end
    if afeSettings.RHA.active
        RHA.startRecording
    end
    
    %% Repetitions
    for rep = 1 : nR
        handles.rep = rep;
        
        % Contraction
        set(handles.t_msg,'String',mov(ex));
        pic = image(movI,'Parent',handles.a_pic);   % set image
        axis(handles.a_pic,'off');     % Remove axis tick marks
        handles.contraction = 1;
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
        
        % Relax
        set(handles.t_msg,'String','Relax');
        startRelaxingTic = tic;
        if trainWithVr
            for i = 1:numJumps
                fwrite(handles.vreCommunication,sprintf(sprintf('%c%c%c%c%c',char(1),char(14),char(1),char(distance/numJumps),char(1))));
            end
        end
        pic = image(relax,'Parent',handles.a_pic);   % set image
        axis(handles.a_pic,'off');     % Remove axis tick marks
        handles.contraction = 0;
        pause(rT - toc(startRelaxingTic));
    end
    
    %% Save Data
    if afeSettings.NI.active
        %check if is done
        if ~s.IsDone
            s.wait();
        end
        sbiData(:,:,ex) = allData;
        % clean global data for next movement
        allData = [];
        
    end
    if afeSettings.DT.active
        fprintf(commObject, sprintf(['STOP\r\n\r']));
        %Pad remaining samples
        padGridEMG = zeros(sF*sT - size(allData,1),nCh);
        padGridACC = zeros(sFa*sT - size(allDataACC,1),3,nCh);

        allData = [allData; padGridEMG];
        allDataACC = [allDataACC; padGridACC];
        
        trignoData(:,:,ex) = allData;
        atrignoData(:,:,:,ex) = allDataACC;
        % clean global data for next movement
        allData = [];
        allDataACC = [];
    end
    if afeSettings.RHA.active
%         disp('RHA:')
%         disp(RHA.SamplesAcquired)
%         disp(RHA.bytesAcquired)
%         disp(size(RHA.data))
        data = [RHA.data ; RHA.storeFromBuffer];
%         disp(size(data))
%         disp(size(RHAtdata))
        RHAtdata(:,:,ex)=data * (RHA.vref/(RHA.amplification*2^(RHA.byteDepth*8))); %Converting to input referred voltage
    end
    if afeSettings.ADS.active
%         disp('ADS:')
%         disp(ADS.SamplesAcquired)
%         disp(ADS.bytesAcquired)
%         disp(size(data))
        
        data = [ADS.data ; ADS.storeFromBuffer];
%         disp(size(data))
%         disp(size(ADStdata))
        ADStdata(:,:,ex)=data * (ADS.vref/(ADS.amplification*2^(ADS.byteDepth*8))); %Converting to input referred voltage
    end
    
end


set(handles.t_msg,'String','Session Terminated');      % Show message about acquisition

%% Save data and compute training data using cTp
if afeSettings.NI.active
    delete(lh);
    NItdata=sbiData;
else
    NItdata=[];
end
if afeSettings.DT.active
    if isvalid(interfaceObjectEMG)
        fclose(interfaceObjectEMG);
        delete(interfaceObjectEMG);
        clear interfaceObjectEMG;
    end
    if isvalid(interfaceObjectACC)
        fclose(interfaceObjectACC);
        delete(interfaceObjectACC);
        clear interfaceObjectACC;
    end
    if isvalid(commObject)
        fclose(commObject);
        delete(commObject);
        clear commObject;
    end
    DTtdata=trignoData;
    aDTtdata=atrignoData;
else
    DTtdata=[];
    aDTtdata=[];
end
if afeSettings.ADS.active
    ADStdata=ADStdata;
    %ADStrdata=ComputeTrainingData(ADStdata,sF,cT,rT,nR,nM,cTp);    
else
    ADStdata=[];
    %ADStrdata=[];
end

if afeSettings.RHA.active
    RHAtdata=RHAtdata;
    %RHAtrdata=ComputeTrainingData(RHAtdata,sF,cT,rT,nR,nM,cTp);    
else
    RHAtdata=[];
    %RHAtrdata=[];
end


%% Save Session to file
recSession.sF       = sF;
recSession.sT       = sT;
recSession.cT       = cT;
recSession.rT       = rT;
recSession.nM       = nM;
recSession.nR       = nR;
recSession.nCh      = nCh;
recSession.dev      = dev;
recSession.mov      = mov;
recSession.date     = fix(clock);
recSession.cmt      = inputdlg('Additional comment on the recording session','Comments');

[filename, pathname] = uiputfile({'*.mat','MAT-files (*.mat)'},'Save as', 'Untitled.mat');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       disp(['User selected ', fullfile(pathname, filename)])
       if afeSettings.NI.active
           recSession.tdata    = NItdata;
           save([pathname,filename],'recSession');

           %recSession.trdata   = NItrdata;
%           if exist([pathname 'NI\'],'dir') == 0
%               mkdir(pathname,'NI')
%           end
%           save([pathname, 'NI\',filename],'recSession');
       end
       if afeSettings.DT.active
           recSession.tdata    = DTtdata;
           recSession.adata    = aDTtdata;
           if exist([pathname 'Trigno\'],'dir') == 0
               mkdir(pathname,'Trigno')
           end
           save([pathname, 'Trigno\',filename],'recSession');
          
       end
       if afeSettings.ADS.active
           recSession.tdata    = ADStdata;
           %recSession.trdata   = ADStrdata; 
           %Possible to add string with device info for example recSession.device=afeSettings.ADS.name;
           if exist([pathname 'ADS1298\'],'dir') == 0
               mkdir(pathname,'ADS1298')
           end
           save([pathname, 'ADS1298\',filename],'recSession');
           
           % not needed here any more?
%            if filters.PLH || filters.BP
%                recSession.tdata    = ADStdataFiltered;
%               % recSession.trdata   = ADStrdataFiltered;
%                if exist([pathname 'ADS1298Filtered\'],'dir') == 0
%                    mkdir(pathname,'ADS1298Filtered')
%                end
%                save([pathname,'ADS1298Filtered\',filename],'recSession');
%            end
       end
       if afeSettings.RHA.active
           recSession.tdata    = RHAtdata;
           %recSession.trdata   = RHAtrdata;
           %Possible to add string with device info for example recSession.device=afeSettings.RHA.name;
           if exist([pathname 'RHA2216\'],'dir') == 0
               mkdir(pathname,'RHA2216')
           end
           save([pathname 'RHA2216\',filename],'recSession');
           
           % not needed here any more?
%            if filters.PLH || filters.BP
%                recSession.tdata    = RHAtdataFiltered;
%                %recSession.trdata   = RHAtrdataFiltered;
%                if exist([pathname 'RHA2216Filtered\'],'dir') == 0
%                    mkdir(pathname,'RHA2216Filtered')
%                end
%                save([pathname,'RHA2216Filtered\',filename],'recSession');
%            end
       end
    end

% Copy acquired data from the last excersice into cdata
% Display it
disp(recSession); 

if afeSettings.NI.show
    data = NItdata(:,:,end);
elseif afeSettings.DT.show
    data = DTtdata(:,:,end);
elseif afeSettings.ADS.show
    data = ADStdata(:,:,end).* (ADS.vref/(ADS.amplification*2^(ADS.byteDepth*8)));
elseif afeSettings.RHA.show
    data = RHAtdata(:,:,end).* (RHA.vref/(RHA.amplification*2^(RHA.byteDepth*8)));
end

chIdx=1;
if nCh >= 1
    cdata(:,1) = data(:,chIdx);
    chIdx=chIdx+1;
end
if nCh >= 2
    cdata(:,2) = data(:,chIdx);
    chIdx=chIdx+1;
end
if nCh >= 3
    cdata(:,3) = data(:,chIdx);
    chIdx=chIdx+1;
end
if nCh >= 4
    cdata(:,4) = data(:,chIdx);
    chIdx=chIdx+1;
end
if nCh >= 5
    cdata(:,5) = data(:,chIdx);
    chIdx=chIdx+1;
end
if nCh >= 6
    cdata(:,6) = data(:,chIdx);
    chIdx=chIdx+1;
end
if nCh >= 7
    cdata(:,7) = data(:,chIdx);
    chIdx=chIdx+1;
end
if nCh >= 8
    cdata(:,8) = data(:,chIdx);
end

if trainWithVr
   fclose(handles.vreCommunication); 
end

DataShow(handles,cdata,sF,sT);
set(handles.a_pic,'Visible','off');  % Turn OFF visibility
delete(pic);        % Delete image
end


function RecordingSession_ShowData(src,event)

    global      handles;
    global      allData;
    persistent  timeStamps;
    
    % Get info from hendles
    sF          = handles.sF;
    nCh         = handles.nCh;
    effortMax   = handles.effortMax;
    rep         = handles.rep;
    cT          = handles.cT;
    rT          = handles.rT;
        
    
    % Get data
    if(isempty(allData)) % Fist DAQ callback
        timeStamps = [];
    end
    
    tempData = event.Data;
    allData = [allData; tempData];
    timeStamps = [timeStamps; event.TimeStamps];

            %% Status bar update
            %thisToc = timeStamps(end) - ((rep-1)*(cT+rT));
            %lastToc = (cT+rT);
            if handles.contraction
                thisToc = timeStamps(end) - ((rep-1)*(cT+rT));
                lastToc = cT;
            else
                thisToc = timeStamps(end) - ((rep*cT)+((rep-1)*rT));
                lastToc = rT;            
            end
        
            x =1-(thisToc/lastToc);
%             set(handles.figure1,'CurrentAxes',handles.a_prog);
            set(handles.hPatch,'Xdata',[0 x x 0]);

            
            %% Display peeked Data
            aNs = length(tempData(:,1));
            NFFT = 2^nextpow2(aNs);                 % Next power of 2 from number of samples
            f = sF/2*linspace(0,1,NFFT/2);
            dataf = fft(tempData(1:aNs,:),NFFT)/aNs;
            m = 2*abs(dataf((1:NFFT/2),:));
            
            
            chIdx = 1;%Channel Index for map data
            if nCh >= 1
                p_t0 = handles.p_t0;
                p_f0 = handles.p_f0;
                set(p_t0,'YData',tempData(:,chIdx));
                set(p_f0,'XData',f);
                set(p_f0,'YData',m(:,chIdx));                
                % Update effort bar
                xT = mean(abs(tempData(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch0,'Ydata',[0 x x 0]);
                
                chIdx=chIdx+1;
            end
            if nCh >= 2
                p_t1 = handles.p_t1;
                p_f1 = handles.p_f1;
                set(p_t1,'YData',tempData(:,chIdx));
                set(p_f1,'XData',f);
                set(p_f1,'YData',m(:,chIdx));
                % Update effort bar
                xT = mean(abs(tempData(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch1,'Ydata',[0 x x 0]);
                                
                chIdx=chIdx+1;
            end
            if nCh >= 3
                p_t2 = handles.p_t2;
                p_f2 = handles.p_f2;
                set(p_t2,'YData',tempData(:,chIdx));
                set(p_f2,'XData',f);
                set(p_f2,'YData',m(:,chIdx));
                 % Update effort bar
                xT = mean(abs(tempData(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch2,'Ydata',[0 x x 0]);
                
                chIdx=chIdx+1;
            end
            if nCh >= 4
                p_t3 = handles.p_t3;
                p_f3 = handles.p_f3;
                set(p_t3,'YData',tempData(:,chIdx));
                set(p_f3,'XData',f);
                set(p_f3,'YData',m(:,chIdx));
                 % Update effort bar
                xT = mean(abs(tempData(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch3,'Ydata',[0 x x 0]);
                
                chIdx=chIdx+1;
            end
            if nCh >= 5
                p_t4 = handles.p_t4;
                set(p_t4,'YData',tempData(:,chIdx));
                 % Update effort bar
                xT = mean(abs(tempData(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch4,'Ydata',[0 x x 0]);
                
                chIdx=chIdx+1;
                %set(p_f4,'XData',f);
                %set(p_f4,'YData',m(:,chIdx));
            end
            if nCh >= 6
                p_t5 = handles.p_t5;
                set(p_t5,'YData',tempData(:,chIdx));
                 % Update effort bar
                xT = mean(abs(tempData(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch5,'Ydata',[0 x x 0]);
                
                chIdx=chIdx+1;
                %set(p_f5,'XData',f);
                %set(p_f5,'YData',m(:,chIdx));
            end
            if nCh >= 7
                p_t6 = handles.p_t6;
                set(p_t6,'YData',tempData(:,chIdx));
                 % Update effort bar
                xT = mean(abs(tempData(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch6,'Ydata',[0 x x 0]);
                
                chIdx=chIdx+1;
                %set(p_f6,'XData',f);
                %set(p_f6,'YData',m(:,chIdx));
            end
            if nCh >= 8
                p_t7 = handles.p_t7;
                set(p_t7,'YData',tempData(:,chIdx));
                 % Update effort bar
                xT = mean(abs(tempData(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch7,'Ydata',[0 x x 0]);
                
                %set(p_f7,'XData',f);
                %set(p_f7,'YData',m(:,chIdx));
            end    
    

end

function ReadAndPlotAdvancedEMG(interfaceObjectEMG, ~,~,~, ~)
    
    global allData;
    global data_arrayEMG;
    global handles;
    persistent timeStamps;

    %% Get info from hendles
    sF          = handles.sF;
    nCh         = handles.nCh;
    effortMax   = handles.effortMax;
    rep         = handles.rep;
    cT          = handles.cT;
    rT          = handles.rT;
    
    first = false;
    
    if isempty(allData)
       timeStamps = [];
       first = true;
    end
    
    
    %% Get data
    bytesReady = interfaceObjectEMG.BytesAvailable;
    bytesReady = bytesReady - mod(bytesReady, 13824);

    if (bytesReady == 0)
        return
    end
    
    data = cast(fread(interfaceObjectEMG,bytesReady), 'uint8');
    data = typecast(data, 'single');
    
    data_arrayEMG = [data_arrayEMG(size(data,1) + 1:size(data_arrayEMG, 1));data];
    
    %% Set timestamps
    
    newDataSize = length(data(1:16:end));
    if(first == true)
        timeStamps = 0:1/sF:newDataSize/sF - 1/sF;
    else
        timeStamps = [timeStamps linspace(timeStamps(end) + 1/sF, timeStamps(end) + newDataSize/sF, newDataSize)]; 
    end
    
    %% Structuring Data
    
    plotData = data_arrayEMG;
    
    aNs = length(data(1:16:end));
    aNsPlot = length(plotData(1:16:end));
    structData = zeros(aNs, nCh);
    structDataPlot = zeros(aNsPlot, nCh);
    for index=1:nCh,
        structData(:,index) = data(index:16:end);
        structDataPlot(:,index) = plotData(index:16:end);
    end
    
    allData = [allData; structData];
   
 
    %% status bar update
            %thistoc = timestamps(end) - ((rep-1)*(ct+rt));
            %lasttoc = (ct+rt);
            if handles.contraction
                thisToc = timeStamps(end) - ((rep-1)*(cT+rT));
                lastToc = cT;
            else
                thisToc = timeStamps(end) - ((rep*cT)+((rep-1)*rT));
                lastToc = rT;            
            end
        
            x =1-(thisToc/lastToc);
            %set(handles.figure1,'currentaxes',handles.a_prog);
            set(handles.hPatch,'xdata',[0 x x 0]);    
            
    %% Fast Fourier Transform
    NFFT = 2^nextpow2(aNs);                 % Next power of 2 from number of samples
    f = sF/2*linspace(0,1,NFFT/2);
    dataf = fft(structDataPlot(1:aNs,:),NFFT)/aNs;
    m = 2*abs(dataf((1:NFFT/2),:));
    
    
    %% Display Data
    chIdx = 1;%Channel Index for map data
            if nCh >= 1
                p_t0 = handles.p_t0;
                p_f0 = handles.p_f0;
                set(p_t0,'YData',structDataPlot(:,chIdx));
                set(p_f0,'XData',f);
                set(p_f0,'YData',m(:,chIdx));                
                % Update effort bar
                xT = mean(abs(structDataPlot(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch0,'Ydata',[0 x x 0]);
                
                chIdx=chIdx+1;
            end
            if nCh >= 2
                p_t1 = handles.p_t1;
                p_f1 = handles.p_f1;
                set(p_t1,'YData',structDataPlot(:,chIdx));
                set(p_f1,'XData',f);
                set(p_f1,'YData',m(:,chIdx));
                % Update effort bar
                xT = mean(abs(structDataPlot(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch1,'Ydata',[0 x x 0]);
                                
                chIdx=chIdx+1;
            end
            if nCh >= 3
                p_t2 = handles.p_t2;
                p_f2 = handles.p_f2;
                set(p_t2,'YData',structDataPlot(:,chIdx));
                set(p_f2,'XData',f);
                set(p_f2,'YData',m(:,chIdx));
                 % Update effort bar
                xT = mean(abs(structDataPlot(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch2,'Ydata',[0 x x 0]);
                
                chIdx=chIdx+1;
            end
            if nCh >= 4
                p_t3 = handles.p_t3;
                p_f3 = handles.p_f3;
                set(p_t3,'YData',structDataPlot(:,chIdx));
                set(p_f3,'XData',f);
                set(p_f3,'YData',m(:,chIdx));
                 % Update effort bar
                xT = mean(abs(structDataPlot(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch3,'Ydata',[0 x x 0]);
                
                chIdx=chIdx+1;
            end
            if nCh >= 5
                p_t4 = handles.p_t4;
                set(p_t4,'YData',structDataPlot(:,chIdx));
                 % Update effort bar
                xT = mean(abs(structDataPlot(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch4,'Ydata',[0 x x 0]);
                
                chIdx=chIdx+1;
                %set(p_f4,'XData',f);
                %set(p_f4,'YData',m(:,chIdx));
            end
            if nCh >= 6
                p_t5 = handles.p_t5;
                set(p_t5,'YData',structDataPlot(:,chIdx));
                 % Update effort bar
                xT = mean(abs(structDataPlot(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch5,'Ydata',[0 x x 0]);
                
                chIdx=chIdx+1;
                %set(p_f5,'XData',f);
                %set(p_f5,'YData',m(:,chIdx));
            end
            if nCh >= 7
                p_t6 = handles.p_t6;
                set(p_t6,'YData',structDataPlot(:,chIdx));
                 % Update effort bar
                xT = mean(abs(structDataPlot(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch6,'Ydata',[0 x x 0]);
                
                chIdx=chIdx+1;
                %set(p_f6,'XData',f);
                %set(p_f6,'YData',m(:,chIdx));
            end
            if nCh >= 8
                p_t7 = handles.p_t7;
                set(p_t7,'YData',structDataPlot(:,chIdx));
                 % Update effort bar
                xT = mean(abs(structDataPlot(:,chIdx)));
                x = xT / effortMax;
                set(handles.hPatch7,'Ydata',[0 x x 0]);
                
                %set(p_f7,'XData',f);
                %set(p_f7,'YData',m(:,chIdx));
            end

    drawnow
end

function ReadACC(interfaceObjectACC, ~, ~, ~, ~)
   
    global handles;
    global allDataACC;
    
    nCh = handles.nCh;
    
    bytesReady = interfaceObjectACC.BytesAvailable;
    bytesReady = bytesReady - mod(bytesReady, 3072);

    if(bytesReady == 0)
        return
    end
    
    data = cast(fread(interfaceObjectACC, bytesReady), 'uint8');
    data = typecast(data, 'single');
    
 
    aNs = length(data(1:48:end));
    structData = zeros(aNs, 3, nCh);
    for index=1:3:nCh,
        structData(:,1,index) = data(index:48:end);
        structData(:,2,index) = data(index+1:48:end);
        structData(:,3,index) = data(index+2:48:end);
    end
    
    allDataACC = [allDataACC; structData];
end

function localCloseFigure( ~, interfaceObject1, commObject)

    if isvalid(interfaceObject1)
        fclose(interfaceObject1);
        delete(interfaceObject1);
        clear interfaceObject1;
    end
    
    if isvalid(interfaceObject2)
        fclose(interfaceObject2);
        delete(interfaceObject2);
        clear interfaceObject2;
    end

    if isvalid(commObject)
        fclose(commObject);
        delete(commObject);
        clear commObject;
    end
end
