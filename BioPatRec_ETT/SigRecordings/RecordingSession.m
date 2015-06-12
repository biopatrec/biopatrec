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
%                           was removed since it didn't worked with the SBI
%                           in the current implementation. To see how the
%                           simultaneus recordings were done, see
%                           RecordingSession_Legacy
% 20xx-xx-xx / Author  / Comment



function [cdata, sF] = RecordingSession(varargin)

global handles;
global allData;

allData     = [];
nM          = varargin{1};
nR          = varargin{2};
cT          = varargin{3};
rT          = varargin{4};
mov         = varargin{5};
handles     = varargin{6};
afeSettings = varargin{7};

sT          = (cT+rT)*nR;   % Sampling time, it is the time of contraction + 
                            % Time of relaxation x Number of repetitions

% Get number of channels and sampling frequency
% for the device to be displayed
if afeSettings.NI.show
    nCh = afeSettings.NI.channels;
    sF  = afeSettings.NI.sampleRate;
% elseif afeSettings.ADS.show
%     nCh = afeSettings.ADS.channels;
%     sF  = afeSettings.ADS.sampleRate;
% elseif afeSettings.RHA.show
%     nCh = afeSettings.RHA.channels;    
%     sF  = afeSettings.RHA.sampleRate;
end


handles.sF = sF;
handles.cT = cT;
handles.rT = rT;
handles.nCh = nCh;

pause on;

%% Initialize plots
% Create handles for the plots
% this is faster than creating the plot everytime
tt      = 0:1/sF:sT/100-1/sF;   % Create data for sT / 100
ymin    = -3;
ymax    = 3;

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
handles.effortMax = 2;

        
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

%% Allocation of resource to improve speed, total data 

sbiData  = zeros(sF*sT,nCh,nM);

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
        pause(cT);
        set(handles.t_msg,'String','Relax');
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
    
    %% Repetitions
    for rep = 1 : nR
        handles.rep = rep;
        
        % Contraction
        set(handles.t_msg,'String',mov(ex));
        pic = image(movI,'Parent',handles.a_pic);   % set image
        axis(handles.a_pic,'off');     % Remove axis tick marks
        handles.contraction = 1;
        pause(cT);
        
        % Relax
        set(handles.t_msg,'String','Relax');
        pic = image(relax,'Parent',handles.a_pic);   % set image
        axis(handles.a_pic,'off');     % Remove axis tick marks
        handles.contraction = 0;
        pause(rT);        
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
    
end


set(handles.t_msg,'String','Session Terminated');      % Show message about acquisition

%% Save data and compute training data using cTp
if afeSettings.NI.active
    delete(lh);
    NItdata=sbiData;
else
    NItdata=[];
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
       end
    end

% Copy acquired data from the last excersice into cdata
% Display it
disp(recSession); 

if afeSettings.NI.show
    data = NItdata(:,:,end);    
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


