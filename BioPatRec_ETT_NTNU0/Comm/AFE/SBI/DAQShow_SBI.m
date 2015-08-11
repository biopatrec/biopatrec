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
% ------------------- Function Description ------------------
% Funtion to show the aquired data in the GUI (based in NI_DataShow)
%
% --------------------------Updates--------------------------
% [Contributors are welcome to add their email]
% 2012-02-09 / Max Ortiz / Creation, moved from Legacy to SBI 
% 2012-03-27 / Max Ortiz / Bug fixed when an arbitrary selection of channels
% 20xx-xx-xx / Author    / Comment on update

function cdata = DAQShow_SBI(handlesX, sCh, sF, sT, pT)

    global handles;
    global allData;
    global timeStamps;
    
    % Variable to be sent globally
    allData     = [];
    timeStamps  = [];
    handles     = handlesX;
    handles.sCh = sCh;
    handles.sF  = sF;
    
    
    % Setting for data peeking
    tt = 0:1/sF:pT-1/sF;                   % Create vector of time
    data = zeros(length(tt),8);            % Current data

    % Create handles for the plots
    % this is faster than creating the plot everytime
    if sCh(1)
        axes(handles.a_t0);
        p_t0 = plot(tt,data(:,1));
        handles.p_t0 = p_t0;
        axes(handles.a_f0);
        p_f0 = plot(1,1);
        handles.p_f0 = p_f0;
    end
    if sCh(2)
        axes(handles.a_t1);
        p_t1 = plot(tt,data(:,2));        
        handles.p_t1 = p_t1;
        axes(handles.a_f1);
        p_f1 = plot(1,1);
        handles.p_f1 = p_f1;
    end
    if sCh(3)
        axes(handles.a_t2);        
        p_t2 = plot(tt,data(:,3));        
        handles.p_t2 = p_t2;
        axes(handles.a_f2);
        p_f2 = plot(1,1);
        handles.p_f2 = p_f2;
    end

    if sCh(4)
        axes(handles.a_t3);        
        p_t3 = plot(tt,data(:,4));
        handles.p_t3 = p_t3;
        axes(handles.a_f3);
        p_f3 = plot(1,1);    
        handles.p_f3 = p_f3;

    end

    if length(sCh) > 4      % Conditional added to keep compatibility with previous versions
        if sCh(5)
            axes(handles.a_t4);        
            p_t4 = plot(tt,data(:,5));
            handles.p_t4 = p_t4;
            %axes(handles.a_f4);
            %p_f4 = plot(1,1);
        end

        if sCh(6)
            axes(handles.a_t5);        
            p_t5 = plot(tt,data(:,6));
            handles.p_t5 = p_t5;
            %axes(handles.a_f5);
            %p_f5 = plot(1,1);
        end

        if sCh(7)
            axes(handles.a_t6);        
            p_t6 = plot(tt,data(:,7));
            handles.p_t6 = p_t6;
            %axes(handles.a_f6);
            %p_f6 = plot(1,1);
        end

        if sCh(8)
            axes(handles.a_t7);        
            p_t7 = plot(tt,data(:,8));
            handles.p_t7 = p_t7;
            %axes(handles.a_f7);
            %p_f7 = plot(1,1);
        end
    end
    
    % Send variables;
    %handles.p_f4 = handles.p_f4;
    %handles.p_f5 = handles.p_f5;
    %handles.p_f6 = handles.p_f6;
    %handles.p_f7 = handles.p_f7;

    

    %% Init DAQ
    s = InitSBI_NI(sF,sT,sCh);
    % Change the interruption time
    s.NotifyWhenDataAvailableExceeds = sF*pT;  
    lh = s.addlistener('DataAvailable', @DataShow_SBI_OneShot);    

    %% Run in the backgroud
    s.startBackground();

    % Wait until it has finished done
    %s.IsDone  % will report 0    
    s.wait(); % rather than while    
    %s.IsDone  % will report 1

    %% Finish session
    set(handles.t_msg,'String','Done')      % Show message about acquisition    
    data = allData;
    
    % Fast Fourier Transform
    aNs = length(data(:,1));
    NFFT = 2^nextpow2(aNs);                 % Next power of 2 from number of samples
    f = sF/2*linspace(0,1,NFFT/2);
    dataf = fft(data(1:aNs,:),NFFT)/aNs;
    m = 2*abs(dataf((1:NFFT/2),:));
    
    
    % Save acquired data into cdata
    % Settings for all data
    tt = timeStamps;              % Create vector of time
    chIdx=1;                      % Channel Index in the Data matrix
    if sCh(1) == 1        
        cdata(:,1) = data(:,chIdx);
        set(p_t0,'XData',tt);
        set(p_t0,'YData',cdata(:,1));
        set(p_f0,'XData',f);
        set(p_f0,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if sCh(2) == 1        
        cdata(:,2) = data(:,chIdx);
        set(p_t1,'XData',tt);
        set(p_t1,'YData',cdata(:,2));
        set(p_f1,'XData',f);
        set(p_f1,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if sCh(3) == 1        
        cdata(:,3) = data(:,chIdx);
        set(p_t2,'XData',tt);
        set(p_t2,'YData',cdata(:,3));
        set(p_f2,'XData',f);
        set(p_f2,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if sCh(4) == 1        
        cdata(:,4) = data(:,chIdx);
        set(p_t3,'XData',tt);
        set(p_t3,'YData',cdata(:,4));
        set(p_f3,'XData',f);
        set(p_f3,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if length(sCh) > 4
        if sCh(5) == 1        
            cdata(:,5) = data(:,chIdx);
            set(p_t4,'XData',tt);
            set(p_t4,'YData',cdata(:,5));
            chIdx=chIdx+1;
        end
        if sCh(6) == 1        
            cdata(:,6) = data(:,chIdx);
            set(p_t5,'XData',tt);
            set(p_t5,'YData',cdata(:,6));
            chIdx=chIdx+1;
        end
        if sCh(7) == 1        
            cdata(:,7) = data(:,chIdx);
            set(p_t6,'XData',tt);
            set(p_t6,'YData',cdata(:,7));
            chIdx=chIdx+1;
        end
        if sCh(8) == 1        
            cdata(:,8) = data(:,chIdx);
            set(p_t7,'XData',tt);
            set(p_t7,'YData',cdata(:,8));
        end
    end

%Delete listener SBI
delete (lh)

end

function DataShow_SBI_OneShot(src,event)

    global handles;
    global allData;
    global timeStamps;
    
    % Get info from hendles
    sF = handles.sF;
    sCh = handles.sCh;

    % Get data
    tempData = event.Data;
    allData = [allData; tempData];
    timeStamps = [timeStamps; event.TimeStamps];

    % filter the data
    tempData = filter_data(tempData, handles, sF);  %Filter the data
    % Fast Fourier Transform
    aNs = length(tempData(:,1));
    NFFT = 2^nextpow2(aNs);                 % Next power of 2 from number of samples
    f = sF/2*linspace(0,1,NFFT/2);
    dataf = fft(tempData(1:aNs,:),NFFT)/aNs;
    m = 2*abs(dataf((1:NFFT/2),:));

    chIdx = 1;                            %Channel Index for map data
    if sCh(1)
        p_t0 = handles.p_t0;
        p_f0 = handles.p_f0;
        set(p_t0,'YData',tempData(:,chIdx));
        set(p_f0,'XData',f);
        set(p_f0,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if sCh(2)
        p_t1 = handles.p_t1;
        p_f1 = handles.p_f1;
        set(p_t1,'YData',tempData(:,chIdx));
        set(p_f1,'XData',f);
        set(p_f1,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if sCh(3)
        p_t2 = handles.p_t2;
        p_f2 = handles.p_f2;
        set(p_t2,'YData',tempData(:,chIdx));
        set(p_f2,'XData',f);
        set(p_f2,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if sCh(4)
        p_t3 = handles.p_t3;
        p_f3 = handles.p_f3;
        set(p_t3,'YData',tempData(:,chIdx));
        set(p_f3,'XData',f);
        set(p_f3,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if length(sCh) > 4
        if sCh(5)
            p_t4 = handles.p_t4;
            set(p_t4,'YData',tempData(:,chIdx));
            chIdx=chIdx+1;
            %set(p_f4,'XData',f);
            %set(p_f4,'YData',m(:,chIdx));
        end
        if sCh(6)
            p_t5 = handles.p_t5;
            set(p_t5,'YData',tempData(:,chIdx));
            chIdx=chIdx+1;
            %set(p_f5,'XData',f);
            %set(p_f5,'YData',m(:,chIdx));
        end
        if sCh(7)
            p_t6 = handles.p_t6;
            set(p_t6,'YData',tempData(:,chIdx));
            chIdx=chIdx+1;
            %set(p_f6,'XData',f);
            %set(p_f6,'YData',m(:,chIdx));
        end
        if sCh(8)
            p_t7 = handles.p_t7;
            set(p_t7,'YData',tempData(:,chIdx));
            %set(p_f7,'XData',f);
            %set(p_f7,'YData',m(:,chIdx));
        end
    end

    drawnow;
        
end