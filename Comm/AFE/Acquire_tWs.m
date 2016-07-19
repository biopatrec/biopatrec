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
% 2015-1-19 / Enzo Mastinu / The ADS1299 part has been modified in way to be 
                            % compatible with the new ADS1299 acquisition mode (DSP + FPU) 
% 2015-4-10 / Enzo Mastinu / The ADS1299_DSP acquisition has been optimized, only desired
                            % channels are transmitted to PC, not all as before
% 2016-7-08 / Enzo Mastinu / The ADS_DSP/Neuromotus acquisition has been
                            % optimized introducing the re-synchronization
                            % in case the signal got lost
% 20xx-xx-xx / Author  / Comment



% It acquire tWs samples from the selected device
function [cData, error] = Acquire_tWs(deviceName, obj, nCh, tWs)
 
    error = 0;
    cData = zeros(tWs,nCh);                                                % this is the data structure that the function must return
    
    % Set warnings to temporarily issue error (exceptions)
    s = warning('error', 'instrument:fread:unsuccessfulRead');
    try
        %%%%% ADS1299 %%%%%
        if strcmp(deviceName, 'ADS1299')
        %   LSBweight = double(4.5/(24*8388607));                            % ADS1299: we always use the gain of 24 V/V
            LSBweight = double(4.5/(8388607));                                 % It is better to plot data with gain scaling effect
            for sampleNr = 1:tWs
                % 27bytes package mode
                byteData = fread(obj,27,'char');                               % Acquire 27 bytes packet from Tiva (and from ADS1299), 3 status bytes + 3 byte (24bit) for each channel
                value = [65536 256 1]*reshape(byteData(4:end), 3, 8);          % all channels data are now available on value vector, byteData(4:end) means throw away status bytes
                for k = 1:nCh  
                    if value(k) > 8388607                                      % the data must be converted from 2's complement
                        value(k) = value(k) - 2^24;
                    end
                    cData(sampleNr,k) = value(k) * LSBweight;                  
                end 
            end
        end
        if strcmp(deviceName, 'ADS_BP')   
            for sampleNr = 1:tWs
                go = 0;
                while go == 0
                    % nCh*4 bytes (float) mode
                    byteData = fread(obj,nCh,'float32');                             % float data mode (4bytes X nCh channels)
                    if byteData < 10
                        go = 1;
                    else
                        % Synchronize the device again
                        fwrite(obj,'T','char');
                        % Read available data and discard it
                        if obj.BytesAvailable > 1
                            fread(obj,obj.BytesAvailable,'uint8');        
                        end
                        fwrite(obj,'G','char');
                        fwrite(obj,nCh,'char');
                        fread(obj,1,'char');
                        go = 0;
                    end
                end
                cData(sampleNr,:) = byteData(1:nCh,:)';
            end
        end

       %%%%% INTAN RHA2216 %%%%%
       if strcmp(deviceName, 'RHA2216')   
    %        LSBweight = double(2.5/(200*65535));                              % Intan differential gain is 200 V/V
            LSBweight = double(2.5/(65535));                                   % It is better to plot data with gain scaling effect
            for sampleNr = 1:tWs                  
                value16 = fread(obj,nCh,'uint16');
                for k = 1:nCh
    %                 cData(sampleNr,k) = value16(k) - 16384;                  % Centers data and scales it to fit the graphs
                    cData(sampleNr,k) = value16(k)*LSBweight;                  % Convert data into volt
                end
            end 
       end
   
    catch exception
       error = 1;
    end
    %Set warning back to normal state
    warning(s);
   
end
