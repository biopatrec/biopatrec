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
% 2015-1-12 / Enzo Mastinu / Divided the RecordingSession function into
                            % several functions: ConnectDevice(),
                            % SetDeviceStartAcquisition(),
                            % Acquire_tWs(), StopAcquisition(). This functions 
                            % has been moved to COMM/AFE folder, into this new script.
                            

% 20xx-xx-xx / Author  / Comment



% it creates IP object and sets the buffersize depending on the device that has been chose
function obj = ConnectDevice(handles)

    deviceName  = handles.deviceName;
    ComPortType = handles.ComPortType;
    if strcmp(ComPortType, 'COM')
        ComPortName = handles.ComPortName;
    end
    sF          = handles.sF;
    sT          = handles.sT;
    nCh         = handles.nCh;
    sTall       = handles.sTall;
    
    % Delete previous connection objects
    if exist('obj')
        fclose(obj);
        delete(obj);
    end

    %%%%% WiFi %%%%%
    if strcmp(ComPortType, 'WiFi')
        %%%%% TI ADS1299 %%%%%
        if strcmp(deviceName, 'ADS1299')
           obj = tcpip('192.168.100.10',65100,'NetworkRole','client');     % WIICOM                       
           obj.InputBufferSize = sTall*sF*27;                              % 27bytes data package
        end
        %%%%% INTAN RHA2216 %%%%%
        if strcmp(deviceName, 'RHA2216')
            obj = tcpip('192.168.100.10',65100,'NetworkRole','client');    % WIICOM
            obj.InputBufferSize = sT*sF*nCh*2;  
        end
    end

    %%%%% COM %%%%%
    if strcmp(ComPortType, 'COM')
        %%%%% TI ADS1299 %%%%%
        if strcmp(deviceName, 'ADS1299')
           obj = serial (ComPortName, 'baudrate', 2500000, 'databits', 8, 'byteorder', 'bigEndian');                       
           obj.InputBufferSize = sTall*sF*27;                              % 27bytes data package
        end
        %%%%% INTAN RHA2216 %%%%%
        if strcmp(deviceName, 'RHA2216')
            obj = serial (ComPortName, 'baudrate', 1250000, 'databits', 8, 'byteorder', 'bigEndian');
            obj.InputBufferSize = sT*sF*nCh*2;
        end
    end     

    % Open the connection
    fopen(obj);

    % Read available data and discard it
    if obj.BytesAvailable > 1
        fread(obj,obj.BytesAvailable,'uint8');       
    end    
%     disp(obj);
    
end
