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
% Function to Record Exc Sessions
% Input :
%   Fs = Sampling frequenicy
%   nM = number of excersices or movements
%   nR = number of excersice repetition
%   cT = time that the contractions should last
%   rT = relaxing time
%   cTp = Porcentage of the signal to record
%   mov = message to be send to the user
%   hGUI_Rec= handles of the axes to plot
% Output = total data and data of interest
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2009-04-17 / Max Ortiz / Creation
% 2009-06-29 / Max Ortiz / A dummy repeticion added before start recording
% 2011-06 / Per and Gustav / added the analog front end sections
% 2011-06-29 / Max ORtiz / Optimization to be integrated in the whole system and Fixed to new coding standard.
                % Any filgering was removed from this routine
                % Filtering and any other signal processing should be done in
                % a singal treatment routine
% 2011-08-04 / Max Ortiz / % The 10% of extra indication for the user to contract was
                % removed.



function [cdata, sF] = RecordingSession_Legacy(varargin)

nM          = varargin{1};
nR          = varargin{2};
cT          = varargin{3};
rT          = varargin{4};
mov         = varargin{5};
hGUI_Rec    = varargin{6};
afeSettings = varargin{7};

% Get number of channels
if afeSettings.NI.show
    nCh = afeSettings.NI.channels;
    sF  = afeSettings.NI.sampleRate;
elseif afeSettings.ADS.show
    nCh = afeSettings.ADS.channels;
    sF  = afeSettings.ADS.sampleRate;
elseif afeSettings.RHA.show
    nCh = afeSettings.RHA.channels;    
    sF  = afeSettings.RHA.sampleRate;
end

%% Initialize plots
% Create handles for the plots
% this is faster than creating the plot everytime
tt = 0:1/sF:cT/100-1/sF;
ymin = -3;
ymax = 3;


if nCh >= 1
    %axes(hGUI_Rec.a_t0);
    p_t0 = plot(hGUI_Rec.a_t0,tt,tt);
    ylim(hGUI_Rec.a_t0, [ymin ymax]); 
    %axes(hGUI_Rec.a_f0);
    p_f0 = plot(hGUI_Rec.a_f0,1,1);
end
if nCh >= 2
    p_t1 = plot(hGUI_Rec.a_t1,tt,tt);
    ylim(hGUI_Rec.a_t1, [ymin ymax]); 
    p_f1 = plot(hGUI_Rec.a_f1,1,1);
end
if nCh >= 3
    p_t2 = plot(hGUI_Rec.a_t2,tt,tt);
    ylim(hGUI_Rec.a_t2, [ymin ymax]); 
    p_f2 = plot(hGUI_Rec.a_f2,1,1);
end

if nCh >= 4
    p_t3 = plot(hGUI_Rec.a_t3,tt,tt);
    ylim(hGUI_Rec.a_t3, [ymin ymax]); 
    p_f3 = plot(hGUI_Rec.a_f3,1,1);
end

if nCh >= 5
    p_t4 = plot(hGUI_Rec.a_t4,tt,tt);
    ylim(hGUI_Rec.a_t4, [ymin ymax]); 
    %axes(hGUI_Rec.a_f4);
    %p_f4 = plot(1,1);
end

if nCh >= 6
    p_t5 = plot(hGUI_Rec.a_t5,tt,tt);
    ylim(hGUI_Rec.a_t5, [ymin ymax]); 
    %axes(hGUI_Rec.a_f5);
    %p_f5 = plot(1,1);
end

if nCh >= 7
    p_t6 = plot(hGUI_Rec.a_t6,tt,tt);
    ylim(hGUI_Rec.a_t6, [ymin ymax]); 
    %axes(hGUI_Rec.a_f6);
    %p_f6 = plot(1,1);
end

if nCh >= 8
    p_t7 = plot(hGUI_Rec.a_t7,tt,tt);
    ylim(hGUI_Rec.a_t7, [ymin ymax]); 
    %axes(hGUI_Rec.a_f7);
    %p_f7 = plot(1,1);
end


%%
% Initialize DAQ card
sT = (cT+rT)*nR;                    % Sampling time, it is the time of contraction + 
                                    % Time of relaxation x Number of repetitions


if afeSettings.NI.active
    %afeSettings.NI.sampleRate=sF; %overrides the individual samplerate choise in AFS_select
                                    % instruction from Per and Gustav, why
                                    % would you overwrite the selected sF?
                                    
                                    % All following sF needs to be changed to
                                    % invidual sF in order to make it work
                                    % /Per
    ai = Init_NI_AI(hGUI_Rec,afeSettings.NI.sampleRate,sT,nCh);
    dev = afeSettings.NI.name;
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

%% Initialization of progress bar
xpatch = [0 0 0 0];
ypatch = [0 0 1 1];
%set(hGUI_Rec.figure1,'CurrentAxes',hGUI_Rec.a_prog);
axes(hGUI_Rec.a_prog);
hGUI_Rec.hPatch = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');

xpatch = [1 1 0 0];
ypatch = [0 0 0 0];
axes(hGUI_Rec.a_effort0);
hGUI_Rec.hPatch0 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(hGUI_Rec.a_effort1);
hGUI_Rec.hPatch1 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(hGUI_Rec.a_effort1);
hGUI_Rec.hPatch1 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(hGUI_Rec.a_effort2);
hGUI_Rec.hPatch2 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(hGUI_Rec.a_effort3);
hGUI_Rec.hPatch3 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(hGUI_Rec.a_effort4);
hGUI_Rec.hPatch4 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(hGUI_Rec.a_effort5);
hGUI_Rec.hPatch5 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(hGUI_Rec.a_effort6);
hGUI_Rec.hPatch6 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
axes(hGUI_Rec.a_effort7);
hGUI_Rec.hPatch7 = patch(xpatch,ypatch,'b','EdgeColor','b','EraseMode','xor','visible','on');
effortMax = 2;

%%
% Allocation of resource to improve speed, total data 
    % Identified problem if the different devices have different sF 
    % then different amount of data is comming from the differnt devices
    % also problem in the counting of incoming data, needs to be changed so it
    % expects right amount of data /Per
tdata = zeros(sF*sT,nCh,nM);
ADStdata = zeros(sF*sT,nCh,nM);
RHAtdata = zeros(sF*sT,nCh,nM);

% Warning to the user
if afeSettings.prepare
    set(hGUI_Rec.t_msg,'String','Get ready to start: 3');
    pause(1);
    set(hGUI_Rec.t_msg,'String','Get ready to start: 2');
    pause(1);
    set(hGUI_Rec.t_msg,'String','Get ready to start: 1');
    pause(1);
end
relax = importdata('Img/relax.jpg'); % Import Image


for ex = 1 : nM
    disp(['Start ex: ' num2str(ex) ])
    
    % Warning to the user
    fileName = ['Img/' char(mov(ex)) '.jpg'];
    if ~exist(fileName,'file')
        fileName = 'Img/relax.jpg';
    end
    
    %movI = importdata(['Img/mov' num2str(ex) '.jpg']); % Import Image
    movI = importdata(fileName); % Import Image
    set(hGUI_Rec.a_pic,'Visible','on');  % Turn on visibility
    %axes(hGUI_Rec.a_pic);        % get hGUI_Rec
    pic = image(movI,'Parent',hGUI_Rec.a_pic);   % set image
    axis(hGUI_Rec.a_pic,'off');     % Remove axis tick marks
    
    if afeSettings.prepare
        set(hGUI_Rec.t_msg,'String',['Get ready for ' mov(ex) ' in 3 s']);
        pause(1);
        set(hGUI_Rec.t_msg,'String',['Get ready for ' mov(ex) ' in 2 s']);
        pause(1);
        set(hGUI_Rec.t_msg,'String',['Get ready for ' mov(ex) ' in 1 s']);
        %set(hGUI_Rec.a_pic,'Visible','off');  % Turn OFF visibility
        %delete(pic);                          % Delete image
        pause(1);
    end
    
    %% Dummy Contraction
    set(hGUI_Rec.t_msg,'String',mov(ex));
    if afeSettings.prepare
        pause(cT);
        set(hGUI_Rec.t_msg,'String','Relax');
        pic = image(relax,'Parent',hGUI_Rec.a_pic);           % set image
        axis off;                   % Remove axis tick marks
        pause(rT);
    end

    
    %% Start DAQ
    if afeSettings.NI.active
        start(ai);
    end
    if afeSettings.ADS.active
        ADS.startRecording
    end
    if afeSettings.RHA.active
        RHA.startRecording
    end
    

    for rep = 1 : nR
        
        while  afeSettings.NI.active && afeSettings.NI.show && (ai.SamplesAcquired < (cT+rT)*sF*rep) || ...
                afeSettings.ADS.active && afeSettings.ADS.show && (ADS.SamplesAcquired < (cT+rT)*sF*rep*nCh) || ...
                afeSettings.RHA.active && afeSettings.RHA.show && (RHA.SamplesAcquired < (cT+rT)*sF*rep*nCh)
            
            %sF in both condition needs to be changed to the invidual samplings
                %frequencies of the different devices
                  
            %Instructions to the user
            if  afeSettings.NI.active && afeSettings.NI.show && (ai.SamplesAcquired <= sF*cT*rep + sF*rT*(rep-1)) || ...
                    afeSettings.ADS.active && afeSettings.ADS.show && (ADS.SamplesAcquired <= (sF*cT*rep + sF*rT*(rep-1)) * nCh) || ...
                    afeSettings.RHA.active && afeSettings.RHA.show && (RHA.SamplesAcquired <= (sF*cT*rep + sF*rT*(rep-1)) * nCh)
                
                set(hGUI_Rec.t_msg,'String',mov(ex));
                %axes(hGUI_Rec.a_pic);
                pic = image(movI,'Parent',hGUI_Rec.a_pic);   % set image
                axis(hGUI_Rec.a_pic,'off');     % Remove axis tick marks
                
                % Status bar update
                lastToc = sF*cT;
                thisToc = ai.SamplesAcquired - (sF*cT*(rep-1)) - sF*rT*(rep-1);                 
            else
                set(hGUI_Rec.t_msg,'String','Relax');
                pic = image(relax,'Parent',hGUI_Rec.a_pic);   % set image
                axis(hGUI_Rec.a_pic,'off');     % Remove axis tick marks
                
                % Status bar update
                lastToc =  sF*rT;
                thisToc = ai.SamplesAcquired - (sF*cT*rep) - sF*rT*(rep-1);
                        
            end
            % Status bar update
            x =1-(thisToc/lastToc);                
            set(hGUI_Rec.figure1,'CurrentAxes',hGUI_Rec.a_prog);
            set(hGUI_Rec.hPatch,'Xdata',[0 x x 0]);
            drawnow;
            
            %---------------------------------
            if afeSettings.NI.show
                data = peekdata(ai,cT*sF/100);
                %data=data/1700; %Converting to input referred voltage
            elseif afeSettings.ADS.show
                data = ADS.storeFromBuffer;
                
                ADS.data = [ADS.data ; data];
                
                if size(ADS.data,1) > (cT*sF/100)
                    data = (ADS.data(end-(cT*sF/100)+1:end,:) ).* (ADS.vref/(ADS.amplification*2^(ADS.byteDepth*8) )); %Converting to input referred voltage
                else
                    data = zeros((cT*sF/100),nCh);
                end
            elseif afeSettings.RHA.show
                data = RHA.storeFromBuffer;
                
                RHA.data = [RHA.data ; data];
                if size(RHA.data,1) > (cT*sF/100)
                    data = (RHA.data(end-(cT*sF/100)+1:end,:) ).* (RHA.vref/(RHA.amplification*2^(RHA.byteDepth*8))); %Converting to input referred voltage
                else
                    data = zeros((cT*sF/100),nCh);
                end
            end
                        
            aNs = length(data(:,1));
            NFFT = 2^nextpow2(aNs);                 % Next power of 2 from number of samples
            f = sF/2*linspace(0,1,NFFT/2);
            dataf = fft(data(1:aNs,:),NFFT)/aNs;
            m = 2*abs(dataf((1:NFFT/2),:));
            
            
            chi = 1;%Channel Index for map data
            if nCh >= 1
                set(p_t0,'YData',data(:,chi));
                set(p_f0,'XData',f);
                set(p_f0,'YData',m(:,chi));                
                % Update effort bar
                xT = mean(abs(data(:,chi)));
                x = xT / effortMax;
                set(hGUI_Rec.hPatch0,'Ydata',[0 x x 0]);
                
                chi=chi+1;
            end
            if nCh >= 2
                set(p_t1,'YData',data(:,chi));
                set(p_f1,'XData',f);
                set(p_f1,'YData',m(:,chi));
                % Update effort bar
                xT = mean(abs(data(:,chi)));
                x = xT / effortMax;
                set(hGUI_Rec.hPatch1,'Ydata',[0 x x 0]);
                                
                chi=chi+1;
            end
            if nCh >= 3
                set(p_t2,'YData',data(:,chi));
                set(p_f2,'XData',f);
                set(p_f2,'YData',m(:,chi));
                 % Update effort bar
                xT = mean(abs(data(:,chi)));
                x = xT / effortMax;
                set(hGUI_Rec.hPatch2,'Ydata',[0 x x 0]);
                
                chi=chi+1;
            end
            if nCh >= 4
                set(p_t3,'YData',data(:,chi));
                set(p_f3,'XData',f);
                set(p_f3,'YData',m(:,chi));
                 % Update effort bar
                xT = mean(abs(data(:,chi)));
                x = xT / effortMax;
                set(hGUI_Rec.hPatch3,'Ydata',[0 x x 0]);
                
                chi=chi+1;
            end
            if nCh >= 5
                set(p_t4,'YData',data(:,chi));
                 % Update effort bar
                xT = mean(abs(data(:,chi)));
                x = xT / effortMax;
                set(hGUI_Rec.hPatch4,'Ydata',[0 x x 0]);
                
                chi=chi+1;
                %set(p_f4,'XData',f);
                %set(p_f4,'YData',m(:,chi));
            end
            if nCh >= 6
                set(p_t5,'YData',data(:,chi));
                 % Update effort bar
                xT = mean(abs(data(:,chi)));
                x = xT / effortMax;
                set(hGUI_Rec.hPatch5,'Ydata',[0 x x 0]);
                
                chi=chi+1;
                %set(p_f5,'XData',f);
                %set(p_f5,'YData',m(:,chi));
            end
            if nCh >= 7
                set(p_t6,'YData',data(:,chi));
                 % Update effort bar
                xT = mean(abs(data(:,chi)));
                x = xT / effortMax;
                set(hGUI_Rec.hPatch6,'Ydata',[0 x x 0]);
                
                chi=chi+1;
                %set(p_f6,'XData',f);
                %set(p_f6,'YData',m(:,chi));
            end
            if nCh >= 8
                set(p_t7,'YData',data(:,chi));
                 % Update effort bar
                xT = mean(abs(data(:,chi)));
                x = xT / effortMax;
                set(hGUI_Rec.hPatch7,'Ydata',[0 x x 0]);
                
                %set(p_f7,'XData',f);
                %set(p_f7,'YData',m(:,chi));
            end
            
            
            %---------------------------------
        end

    end
       
    %Check if all data has arrived from the other devices
    while  (afeSettings.NI.active && (ai.SamplesAcquired < (cT+rT)*sF*nR)) || ...
            (afeSettings.ADS.active  && (ADS.SamplesAcquired < (cT+rT)*sF*nR*nCh)) || ...
            (afeSettings.RHA.active  && (RHA.SamplesAcquired < (cT+rT)*sF*nR*nCh))
        
        pause(1)
        disp('Waiting for more data')
        if afeSettings.NI.active
            disp('NI')
            disp((cT+rT)*sF*nR-ai.SamplesAcquired)
            disp([ai.SamplesAcquired ai.SamplesAcquired*4])
        end
        if afeSettings.RHA.active
            disp('RHA')
            disp((cT+rT)*sF*nR*nCh-RHA.SamplesAcquired)
            disp(RHA.SamplesAcquired)
        end
        if afeSettings.ADS.active
            disp('ADS')
            disp((cT+rT)*sF*nR*nCh-ADS.SamplesAcquired)
            disp(ADS.SamplesAcquired)
            disp((cT+rT)*sF*nR*nCh)
        end
    end
    
    % Save Data
    if afeSettings.NI.active
%         disp('NI:')
%         ai.SamplesAcquired
        wait(ai,sT+1);
        [data,tt,abstime] = getdata(ai);
%         disp(['date = ' num2str(fix(abstime))])
%         size(data)
%         size(tdata)
        tdata(:,:,ex) = data; % / 1.70e3; %Converting to input referred voltage
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
set(hGUI_Rec.t_msg,'String','Session Terminated');      % Show message about acquisition

%% Save data and compute training data using cTp
if afeSettings.NI.active
    stop(ai);
    delete(ai);
    NItdata=tdata;
    %NItrdata=ComputeTrainingData(tdata,sF,cT,rT,nR,nM,cTp);    
else
    NItdata=[];
    %NItrdata=[];
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
% date        = [];%fix(abstime); 
recSession.sF       = sF;
recSession.sT       = sT;
recSession.cT       = cT;
recSession.rT       = rT;
%recSession.cTp      = cTp;
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
           %recSession.trdata   = NItrdata;
           if exist([pathname 'NI\'],'dir') == 0
               mkdir(pathname,'NI')
           end
           save([pathname, 'NI\',filename],'recSession');
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
elseif afeSettings.ADS.show
    data = ADStdata(:,:,end).* (ADS.vref/(ADS.amplification*2^(ADS.byteDepth*8)));
elseif afeSettings.RHA.show
    data = RHAtdata(:,:,end).* (RHA.vref/(RHA.amplification*2^(RHA.byteDepth*8)));
end

chi=1;
if nCh >= 1
    cdata(:,1) = data(:,chi);
    chi=chi+1;
end
if nCh >= 2
    cdata(:,2) = data(:,chi);
    chi=chi+1;
end
if nCh >= 3
    cdata(:,3) = data(:,chi);
    chi=chi+1;
end
if nCh >= 4
    cdata(:,4) = data(:,chi);
    chi=chi+1;
end
if nCh >= 5
    cdata(:,5) = data(:,chi);
    chi=chi+1;
end
if nCh >= 6
    cdata(:,6) = data(:,chi);
    chi=chi+1;
end
if nCh >= 7
    cdata(:,7) = data(:,chi);
    chi=chi+1;
end
if nCh >= 8
    cdata(:,8) = data(:,chi);
end


data_show(hGUI_Rec,cdata,sF,sT);
set(hGUI_Rec.a_pic,'Visible','off');  % Turn OFF visibility
delete(pic);        % Delete image
end

% function trdata = ComputeTrainingData(tdata,sF,cT,rT,nR,nM,cTp)
% %Compute Traning Data
% 
%     for ex = 1 : nM
%         tempdata =[];
%         for rep = 1 : nR
%             % Samples of the exersice to be consider for training
%             % (sF*cT*cTp) Number of the samples that wont be consider for training
%             % (sF*cT*rep) Number of samples that takes a contraction
%             % (sF*rT*rep) Number of samples that takes a relaxation
%             is = (sF*cT*cTp) + (sF*cT*(rep-1)) + (sF*rT*(rep-1)) + 1;
%             fs = (sF*cT) + (sF*cT*(rep-1)) + (sF*rT*(rep-1));
%             tempdata = [tempdata ; tdata(is:fs,:,ex)];
%         end
%         trdata(:,:,ex) = tempdata;
%     end
% 
% end