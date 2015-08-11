%%RealTime Data Streaming with Delsys SDK

% Copyright (C) 2011 Delsys, Inc.
% 
% Permission is hereby granted, free of charge, to any person obtaining a 
% copy of this software and associated documentation files (the "Software"), 
% to deal in the Software without restriction, including without limitation 
% the rights to use, copy, modify, merge, publish, and distribute the 
% Software, and to permit persons to whom the Software is furnished to do so, 
% subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
% DEALINGS IN THE SOFTWARE.

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
% Funtion to show the aquired data in the GUI (based in Delsys Trigno Wireless System)
%
% --------------------------Updates--------------------------
% [Contributors are welcome to add their email]
% 2013-06-10 / Kristian Berrum / Created

function cdata = TrignoSession4(handlesX, sCh, sF, sT, pT)

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
    tt = 0:1/sF:1.026-1/sF;                   % Create vector of time
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

    
    %% Init Trigno Sensor
    [interfaceObjectEMG, interfaceObjectACC, commObject] = TrignoInit(handles);
    
    % Get channels as a number
    numOfCh = 0;
    for index=1:8,
        if sCh(index)
            numOfCh = numOfCh +1;
        end
    end
     %Timer object for drawing plots.
    global data_arrayEMG
    data_arrayEMG = zeros(32832,1);
    
    %% Setup interface object to read chunks of data
    % Define a callback function to be executed when desired number of bytes
    % are available in the input buffer
     bytesToReadEMG = 3456;
     interfaceObjectEMG.BytesAvailableFcn = {@ReadAndPlotEMG, handles, bytesToReadEMG};
     interfaceObjectEMG.BytesAvailableFcnMode = 'byte';
     interfaceObjectEMG.BytesAvailableFcnCount = bytesToReadEMG;
    
    %% 
    % Open the interface object
    try
        fopen(interfaceObjectEMG);
        
        fopen(commObject);
    catch
        localCloseFigure(sCh, 1, interfaceObjectEMG, commObject, t);
        error('CONNECTION ERROR: Please start the Delsys Trigno Control Application and try again');
    end

    %%
    % Start streaming by messaging SDK
    fprintf(commObject, sprintf(['START\r\n\r']));
    drawnow
    pause(sT);
    
    %% Finish session
    set(handles.t_msg,'String','Done')      % Show message about acquisition    
    data = allData;
    
    if isvalid(interfaceObjectEMG)
        fclose(interfaceObjectEMG);
        delete(interfaceObjectEMG);
        clear interfaceObjectEMG;
    end

    if isvalid(commObject)
        fclose(commObject);
        delete(commObject);
        clear commObject;
    end
    
    % Fast Fourier Transform
    aNs = length(data(1:16:end));
    structData = zeros(aNs, 2);
    for index=1:numOfCh,
        structData(:,index) = data(index:16:end);
    end
    NFFT = 2^nextpow2(aNs);                 % Next power of 2 from number of samples
    f = sF/2*linspace(0,1,NFFT/2);
    dataf = fft(structData(1:aNs,:),NFFT)/aNs;
    m = 2*abs(dataf((1:NFFT/2),:));
    
    
    % Save acquired data into cdata
    % Settings for all data
    tt = 0:sT/aNs:sT-sT/aNs;              % Create vector of time ----------- Needs modification----------- IMPORTANT!
    chIdx=1;                      % Channel Index in the Data matrix
    if sCh(1) == 1        
        cdata(:,1) = structData(:,chIdx);
        set(p_t0,'XData',tt);
        set(p_t0,'YData',cdata(:,1));
        set(p_f0,'XData',f);
        set(p_f0,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if sCh(2) == 1        
        cdata(:,2) = structData(:,chIdx);
        set(p_t1,'XData',tt);
        set(p_t1,'YData',cdata(:,2));
        set(p_f1,'XData',f);
        set(p_f1,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if sCh(3) == 1        
        cdata(:,3) = structData(:,chIdx);
        set(p_t2,'XData',tt);
        set(p_t2,'YData',cdata(:,3));
        set(p_f2,'XData',f);
        set(p_f2,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if sCh(4) == 1        
        cdata(:,4) = structData(:,chIdx);
        set(p_t3,'XData',tt);
        set(p_t3,'YData',cdata(:,4));
        set(p_f3,'XData',f);
        set(p_f3,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if length(sCh) > 4
        if sCh(5) == 1        
            cdata(:,5) = structData(:,chIdx);
            set(p_t4,'XData',tt);
            set(p_t4,'YData',cdata(:,5));
            chIdx=chIdx+1;
        end
        if sCh(6) == 1        
            cdata(:,6) = structData(:,chIdx);
            set(p_t5,'XData',tt);
            set(p_t5,'YData',cdata(:,6));
            chIdx=chIdx+1;
        end
        if sCh(7) == 1        
            cdata(:,7) = structData(:,chIdx);
            set(p_t6,'XData',tt);
            set(p_t6,'YData',cdata(:,7));
            chIdx=chIdx+1;
        end
        if sCh(8) == 1        
            cdata(:,8) = structData(:,chIdx);
            set(p_t7,'XData',tt);
            set(p_t7,'YData',cdata(:,8));
        end
    end
end

function ReadAndPlotEMG(interfaceObjectEMG, ~,~,~, ~)

    bytesReady = interfaceObjectEMG.BytesAvailable;
    bytesReady = bytesReady - mod(bytesReady, 3456);

    if (bytesReady == 0)
        return
    end
    global allData;
    global data_arrayEMG;
    global handles;
    global timeStamps;
    sF = handles.sF;
    sCh = handles.sCh;
    first = false;
    data = cast(fread(interfaceObjectEMG,bytesReady), 'uint8');
    data = typecast(data, 'single');
    if(isempty(allData))
        first = true;
    end
    allData = [allData; data];
    
 
    if(size(data_arrayEMG, 1) < 32832)
        data_arrayEMG = [data_arrayEMG; data];
    else
        data_arrayEMG = [data_arrayEMG(size(data,1) + 1:size(data_arrayEMG, 1));data];
    end
    
    newDataSize = length(data(1:16:end));
    
    % Setting timestamps
    if(first==true)
       timeStamps = 0:1/sF:newDataSize/sF - 1/sF;
    else
       timeStamps = [timeStamps linspace(timeStamps(end)+1/sF, timeStamps(end)+newDataSize/sF, newDataSize)];  
    end
    
    plotData = data_arrayEMG;
    aNs = length(plotData(1:16:end));
    structData = zeros(aNs, 2);
    
    % Get channels in number
    numOfCh = 0;
    for index=1:8,
        if sCh(index)
            numOfCh = numOfCh +1;
        end
    end
    
    % Structure data
    for index=1:numOfCh,
        structData(:,index) = plotData(index:16:end);
    end
    
    % Fast Fourier Transform
    NFFT = 2^nextpow2(aNs);                 % Next power of 2 from number of samples
    f = sF/2*linspace(0,1,NFFT/2);
    dataf = fft(structData(1:aNs,:),NFFT)/aNs;
    m = 2*abs(dataf((1:NFFT/2),:));
    
    chIdx = 1;                            %Channel Index for map data
    if sCh(1)
        p_t0 = handles.p_t0;
        p_f0 = handles.p_f0;
        set(p_t0,'YData',structData(:,chIdx));
        set(p_f0,'XData',f);
        set(p_f0,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if sCh(2)
        p_t1 = handles.p_t1;
        p_f1 = handles.p_f1;
        set(p_t1,'YData',structData(:,chIdx));
        set(p_f1,'XData',f);
        set(p_f1,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if sCh(3)
        p_t2 = handles.p_t2;
        p_f2 = handles.p_f2;
        set(p_t2,'YData',structData(:,chIdx));
        set(p_f2,'XData',f);
        set(p_f2,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if sCh(4)
        p_t3 = handles.p_t3;
        p_f3 = handles.p_f3;
        set(p_t3,'YData',structData(:,chIdx));
        set(p_f3,'XData',f);
        set(p_f3,'YData',m(:,chIdx));
        chIdx=chIdx+1;
    end
    if length(sCh) > 4
        if sCh(5)
            p_t4 = handles.p_t4;
            set(p_t4,'YData',structData(:,chIdx));
            chIdx=chIdx+1;
            %set(p_f4,'XData',f);
            %set(p_f4,'YData',m(:,chI+dx));
        end
        if sCh(6)
            p_t5 = handles.p_t5;
            set(p_t5,'YData',structData(:,chIdx));
            chIdx=chIdx+1;
            %set(p_f5,'XData',f);
            %set(p_f5,'YData',m(:,chIdx));
        end
        if sCh(7)
            p_t6 = handles.p_t6;
            set(p_t6,'YData',structData(:,chIdx));
            chIdx=chIdx+1;
            %set(p_f6,'XData',f);
            %set(p_f6,'YData',m(:,chIdx));
        end
        if sCh(8)
            p_t7 = handles.p_t7;
            set(p_t7,'YData',structData(:,chIdx));
            %set(p_f7,'XData',f);
            %set(p_f7,'YData',m(:,chIdx));
        end
    end

    drawnow
end

function localCloseFigure(sCh, ~, interfaceObject1, commObject, t)
    
    %% 
    % Clean up the network objects
    if isvalid(interfaceObject1)
        fclose(interfaceObject1);
        delete(interfaceObject1);
        clear interfaceObject1;
    end

    if isvalid(t)
       stop(t);
       delete(t);
    end

    if isvalid(commObject)
        fclose(commObject);
        delete(commObject);
        clear commObject;
    end
end
