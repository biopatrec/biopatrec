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
% Initialization of the Session-Based Inferface 
% This routine was created from the Init_NIx routines used in previous
% versions of Matlab 2011. The daq toolbox in the 64 releases required a 
% completly different initialization (the session-based interface).
%
% --------------------------Updates--------------------------
% [Contributors are welcome to add their email]
% 2012-01-24 / Max Ortiz  / Creation 
% 2012-03-27 / Max Ortiz  / Bug fixed when an arbitrary selection of channels
%                           not the most elegant solution but it does the
%                           job
% 2012-05-29 / Max Ortiz  / Removed the routine for sequentially adding
%                           channels to a loop.
% 20xx-xx-xx / Author    / Comment on update

function [s] = InitSBI_NI(sF, sT, chAI, chAO)

% Auxiliar variables
nChAI = size(chAI,2);
chAIidx = find(chAI);

% Close possible daq objects running
if (~isempty(daqfind))
    stop(daqfind)
end

% Find devices
dev = daq.getDevices;

% Create a session
s = daq.createSession('ni');


% Add channels in a loop

for i = 1 : size(chAIidx,2)
    chID = ['ai' num2str(chAIidx(i)-1)];    
    s.addAnalogInputChannel(dev.ID,chID,'Voltage');
    s.Channels(i).InputType ='SingleEnded';
    s.Channels(i).Range = [-5 5];    
end

% Add channels
% if nChAI >= 1;
%     if chAI(1)
%         s.addAnalogInputChannel(dev.ID,'ai0','Voltage');
%         s.Channels(1).InputType ='SingleEnded';
%         s.Channels(1).Range = [-5 5];
%     end
% end
% if nChAI >= 2;
%     if chAI(2)
%         s.addAnalogInputChannel(dev.ID,'ai1','Voltage');
%         s.Channels(2).InputType ='SingleEnded';
%         s.Channels(2).Range = [-5 5];
%     end
% end
% if nChAI >= 3;
%     if chAI(3)
%         s.addAnalogInputChannel(dev.ID,'ai2','Voltage');
%         s.Channels(3).InputType ='SingleEnded';
%         s.Channels(3).Range = [-5 5];
%     end
% end
% if nChAI >= 4;
%     if chAI(4)
%         s.addAnalogInputChannel(dev.ID,'ai3','Voltage');
%         s.Channels(4).InputType ='SingleEnded';
%         s.Channels(4).Range = [-5 5];
%     end
% end
% if nChAI >= 5;
%     if chAI(5)
%         s.addAnalogInputChannel(dev.ID,'ai4','Voltage');
%         s.Channels(5).InputType ='SingleEnded';
%         s.Channels(5).Range = [-5 5];
%     end
% end
% if nChAI >= 6;
%     if chAI(6)
%         s.addAnalogInputChannel(dev.ID,'ai5','Voltage');
%         s.Channels(6).InputType ='SingleEnded';
%         s.Channels(6).Range = [-5 5];
%     end
% end
% if nChAI >= 7;
%     if chAI(7)
%         s.addAnalogInputChannel(dev.ID,'ai6','Voltage');
%         s.Channels(7).InputType ='SingleEnded';
%         s.Channels(7).Range = [-5 5];
%     end
% end
% 
% if nChAI >= 8;
%     if chAI(8)
%         s.addAnalogInputChannel(dev.ID,'ai7','Voltage');
%         s.Channels(8).InputType ='SingleEnded';
%         s.Channels(8).Range = [-5 5];
%     end
% end
% Modify duration and frequency

s.DurationInSeconds = sT;
s.Rate = sF;

disp(s);
