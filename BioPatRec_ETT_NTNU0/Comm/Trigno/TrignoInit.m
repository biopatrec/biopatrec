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

function [ interfaceObjectEMG, interfaceObjectACC, commObject ] = TrignoInit( handles )


%This code was added to find the correct HOST IP without having to set it
% manually. This code only works for computers that are running Windows.
[status, result] = system('ipconfig');
    resultSize = size(result,2);
    linefound = false;
    ipv4found = false;
    counter = 0;
    for i=1:resultSize,
        if (result(i) == 'I'  && result(i+3) == '4')
            linefound = true;
        elseif(result(i) == ':' && linefound)
            ipv4found = true;
        elseif(ipv4found && linefound)
            for k=i+1:i+20,
                if(result(k)==' ')
                    break;
                end
                counter = counter + 1;
            end
            HOST_IP = result(i+1:i+counter-1);
            break;
        end
    end
    
    %Total number of sensors
    NUM_SENSORS = 16;

    %TCPIP object to stream EMG data
    interfaceObjectEMG = tcpip(HOST_IP,50041);
    interfaceObjectEMG.InputBufferSize = 30000;

    %TCPIP object to stream ACC data
    interfaceObjectACC = tcpip(HOST_IP,50042);
    interfaceObjectACC.InputBufferSize = 30000;

    %TCPIP object to communicate with Delsys SDK
    commObject = tcpip(HOST_IP,50040);
end


