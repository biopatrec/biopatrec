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
% Funtion to Show data on the GUI
% Input = ai object, sCh channels pressences
% Output = data and time 
% Max J. Ortiz C. 
% 09-04-15
% hGUI_Rec  = handles from the GUI_Recordings
% ai        = analog input "object"
% sCh       = Selected channels, binary string to indicate which channels have been selected
% sF        = Sample frequency
% sT        = Samople time
% pT        = peek time
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 20xx-xx-xx / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment on update


function cdata = NI_DataShow(handles, ai, sCh, sF, sT, pT)

% Setting for data peeking
tt = 0:1/sF:pT-1/sF;                   % Create vector of time
data = zeros(length(tt),8);            % Current data

% Create handles for the plots
% this is faster than creating the plot everytime
if sCh(1)
    axes(handles.a_t0);
    p_t0 = plot(tt,data(:,1));
    axes(handles.a_f0);
    p_f0 = plot(1,1);
end
if sCh(2)
    axes(handles.a_t1);
    p_t1 = plot(tt,data(:,2));        
    axes(handles.a_f1);
    p_f1 = plot(1,1);
end
if sCh(3)
    axes(handles.a_t2);        
    p_t2 = plot(tt,data(:,3));        
    axes(handles.a_f2);
    p_f2 = plot(1,1);
end

if sCh(4)
    axes(handles.a_t3);        
    p_t3 = plot(tt,data(:,4));
    axes(handles.a_f3);
    p_f3 = plot(1,1);
end

if length(sCh) > 4      % Conditional added to keep compatibility with previous versions
    if sCh(5)
        axes(handles.a_t4);        
        p_t4 = plot(tt,data(:,5));
        %axes(handles.a_f4);
        %p_f4 = plot(1,1);
    end

    if sCh(6)
        axes(handles.a_t5);        
        p_t5 = plot(tt,data(:,6));
        %axes(handles.a_f5);
        %p_f5 = plot(1,1);
    end

    if sCh(7)
        axes(handles.a_t6);        
        p_t6 = plot(tt,data(:,7));
        %axes(handles.a_f6);
        %p_f6 = plot(1,1);
    end

    if sCh(8)
        axes(handles.a_t7);        
        p_t7 = plot(tt,data(:,8));
        %axes(handles.a_f7);
        %p_f7 = plot(1,1);
    end
end

%% Start DAQ
start(ai);
%ao = init_ao(); test of ao, hardware connections must be done

% Wait until the first samples are aquired
while ai.SamplesAcquired < sF*pT
end
% Peek Data
while ai.SamplesAcquired < sT*sF

    %putsample(ao,5); test of ao

    % Peek data
    set(handles.t_msg,'String',['Peek at: ' num2str(ai.SamplesAcquired)])          % Show message about acquisition
    data = peekdata(ai,pT*sF);     
    data = filter_data(data, handles, sF);  %Filter the data
    % Fast Fourier Transform
    aNs = length(data(:,1));
    NFFT = 2^nextpow2(aNs);                 % Next power of 2 from number of samples
    f = sF/2*linspace(0,1,NFFT/2);
    dataf = fft(data(1:aNs,:),NFFT)/aNs;
    m = 2*abs(dataf((1:NFFT/2),:));
    
    chi = 1;                            %Channel Index for map data
    if sCh(1)
        set(p_t0,'YData',data(:,chi));
        set(p_f0,'XData',f);
        set(p_f0,'YData',m(:,chi));
        chi=chi+1;
    end
    if sCh(2)
        set(p_t1,'YData',data(:,chi));
        set(p_f1,'XData',f);
        set(p_f1,'YData',m(:,chi));
        chi=chi+1;
    end
    if sCh(3)
        set(p_t2,'YData',data(:,chi));
        set(p_f2,'XData',f);
        set(p_f2,'YData',m(:,chi));
        chi=chi+1;
    end
    if sCh(4)
        set(p_t3,'YData',data(:,chi));
        set(p_f3,'XData',f);
        set(p_f3,'YData',m(:,chi));
        chi=chi+1;
    end
    if length(sCh) > 4
        if sCh(5)
            set(p_t4,'YData',data(:,chi));
            chi=chi+1;
            %set(p_f4,'XData',f);
            %set(p_f4,'YData',m(:,chi));
        end
        if sCh(6)
            set(p_t5,'YData',data(:,chi));
            chi=chi+1;
            %set(p_f5,'XData',f);
            %set(p_f5,'YData',m(:,chi));
        end
        if sCh(7)
            set(p_t6,'YData',data(:,chi));
            chi=chi+1;
            %set(p_f6,'XData',f);
            %set(p_f6,'YData',m(:,chi));
        end
        if sCh(8)
            set(p_t7,'YData',data(:,chi));
            %set(p_f7,'XData',f);
            %set(p_f7,'YData',m(:,chi));
        end
    end

    drawnow
end

wait(ai,sT+1);                              %Wait until the daq is over or until sT+1 is reached
[data,time,abstime] = getdata(ai);
abstime = fix(abstime);
set(handles.t_msg,'String',['DAQ Done ' num2str(abstime(4)) ':' num2str(abstime(5))])      % Show message about acquisition    


% Save acquired data into cdata
% Settings for total data
tt = time;                    % Create vector of time
chi=1;    
if sCh(1) == 1        
    cdata(:,1) = data(:,chi);
    set(p_t0,'XData',tt);
    set(p_t0,'YData',cdata(:,1));
    chi=chi+1;
end
if sCh(2) == 1        
    cdata(:,2) = data(:,chi);
    set(p_t1,'XData',tt);
    set(p_t1,'YData',cdata(:,2));
    chi=chi+1;
end
if sCh(3) == 1        
    cdata(:,3) = data(:,chi);
    set(p_t2,'XData',tt);
    set(p_t2,'YData',cdata(:,3));
    chi=chi+1;
end
if sCh(4) == 1        
    cdata(:,4) = data(:,chi);
    set(p_t3,'XData',tt);
    set(p_t3,'YData',cdata(:,4));
    chi=chi+1;
end
if length(sCh) > 4
    if sCh(5) == 1        
        cdata(:,5) = data(:,chi);
        set(p_t4,'XData',tt);
        set(p_t4,'YData',cdata(:,5));
        chi=chi+1;
    end
    if sCh(6) == 1        
        cdata(:,6) = data(:,chi);
        set(p_t5,'XData',tt);
        set(p_t5,'YData',cdata(:,6));
        chi=chi+1;
    end
    if sCh(7) == 1        
        cdata(:,7) = data(:,chi);
        set(p_t6,'XData',tt);
        set(p_t6,'YData',cdata(:,7));
        chi=chi+1;
    end
    if sCh(8) == 1        
        cdata(:,8) = data(:,chi);
        set(p_t7,'XData',tt);
        set(p_t7,'YData',cdata(:,8));
    end
end

