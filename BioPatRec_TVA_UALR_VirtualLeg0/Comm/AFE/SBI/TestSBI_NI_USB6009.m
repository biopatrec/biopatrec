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
% Test funtions for data aquisition using Session-base Interfaces
%
% --------------------------Updates--------------------------
% [Contributors are welcome to add their email]
% 2012-01-31 / Max Ortiz  / Creation 
% 20xx-xx-xx / Author  / Comment

function TestSBI_NI_USB6009

    %TestSimpleAIForeground();
    %TestSimpleAIBackground();
    TestGlobalAIBackground();

end

function TestSimpleAIForeground

    s = daq.createSession('ni')
    s.addAnalogInputChannel('dev1','ai0','Voltage')
    data = s.startForeground()
    plot (data)

end

function TestSimpleAIBackground

    s = daq.createSession('ni')
    s.addAnalogInputChannel('dev1','ai0','Voltage')
    lh = s.addlistener('DataAvailable', @plotData);
    s.startBackground();
    s.wait;
    delete (lh)

end

function TestGlobalAIBackground
    %clear global data;
    clear all;
    %clear functions
    
    global data
    
    s = daq.createSession('ni');
    s.addAnalogInputChannel('dev1',0,'voltage');
    s.Rate = 1000;
    s.DurationInSeconds = 1;    
    %Verify that the notification is done automatically
    %s.IsNotifyWhenDataAvailableExceedsAuto = 1;
    % Change the peek time
    s.NotifyWhenDataAvailableExceeds = 100;
    lh = s.addlistener('DataAvailable',@plotGloalData);
    
    s.startBackground();
    % Wait
    s.wait;
    %close(gcf);
    figure();
    plot(data); %  plot global data
    delete (lh)
end


function plotGloalData(src,event)
    persistent tempData;
    persistent i;
    global data 
    if(isempty(tempData))
         tempData = [];
         i = 1;
    end
    disp(i);
    %plot(event.TimeStamps, event.Data);
    plot(event.Data);
    tempData = [tempData;event.Data];
    data = tempData;
    i=i+1;
end


function plotData(src,event)
     plot(event.TimeStamps, event.Data)
 end
