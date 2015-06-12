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
% Funtion to Initialize the NI-6009 Analog Inputs 
% Input = Handles
% Output = ai object 
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2009-03-31 / Max Ortiz  / Creation
% 2011-06-19 / Max Ortiz  /Modified for general numer of channels
% 20xx-xx-xx / Author  / Comment on update


function [ai,chp] = Init_NI_AI(handles,sF,sT,nCh)

% Close possible daq objects running
if (~isempty(daqfind))
    stop(daqfind)
end

% Use this command to determine Board IDs in system, if needed
hw = daqhwinfo('nidaq');
hw.InstalledBoardIds;
hw.BoardNames

% Create an analog input object using Board ID "Dev6".
ai = analoginput('nidaq','Dev1');

% Set the sample rate and samples per trigger
ai.SampleRate = sF;
ai.SamplesPerTrigger = sF*sT;

% Set Inputy Type and Ranges
%set(ai,'InputType','Differential');
set(ai,'InputType','SingleEnde');

% Add all chanels
if get(handles.cb_ch0,'Value') == 1 && nCh > 0
    addchannel(ai, 0,'ch0');
    set(ai.ch0,'InputRange',[-10 10]);
    chp(1)=1;
    nCh = nCh - 1;
end
if get(handles.cb_ch1,'Value') == 1 && nCh > 0
    addchannel(ai, 1,'ch1');
    set(ai.ch1,'InputRange',[-10 10]);
    chp(2)=1;
    nCh = nCh - 1;
end
if get(handles.cb_ch2,'Value') == 1 && nCh > 0
    addchannel(ai, 2,'ch2');
    set(ai.ch2,'InputRange',[-10 10]);
    chp(3)=1;
    nCh = nCh - 1;
end
if get(handles.cb_ch3,'Value') == 1 && nCh > 0
    addchannel(ai, 3,'ch3');
    set(ai.ch3,'InputRange',[-10 10]);
    chp(4)=1;
    nCh = nCh - 1;
end
if get(handles.cb_ch4,'Value') == 1 && nCh > 0
    addchannel(ai, 4,'ch4');
    set(ai.ch4,'InputRange',[-10 10]);
    chp(5)=1;
    nCh = nCh - 1;
end
if get(handles.cb_ch5,'Value') == 1 && nCh > 0
    addchannel(ai, 5,'ch5');
    set(ai.ch5,'InputRange',[-10 10]);
    chp(6)=1;
    nCh = nCh - 1;
end
if get(handles.cb_ch6,'Value') == 1 && nCh > 0
    addchannel(ai, 6,'ch6');
    set(ai.ch6,'InputRange',[-10 10]);
    chp(7)=1;
    nCh = nCh - 1;
end
if get(handles.cb_ch7,'Value') == 1 && nCh > 0
    addchannel(ai, 7,'ch7');
    set(ai.ch7,'InputRange',[-10 10]);
    chp(8)=1;
end




