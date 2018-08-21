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
% Function to Show the SAVED data on the GUI
% Input = ai object, chp channels pressences
% Output = data and time 
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2009-04-15 / Max Ortiz    / Creation
% 2011-09-20 / Max Ortiz    / New routine for BioPatRec based in previous implementation
%                             for EMG_AQ   
% 2013-06-01 / Max Ortiz    / Fixed an issue with ploting when cdata is
%                             slightly bigger that it should be (NI DAQ issues)
% 2015-02-20 / Enzo Mastinu / Added the scaling of the data: now every channel plot will be 
                            % dynamically and automatically resize to fit in the proper portion
                            % of the main plot. This is to avoid overlapping of channels 
                            % waveforms and to have always the best zoom for every channel.
% 2015-02-23 / Enzo Mastinu / The scale of every channel plot is now the
                            % same scale of the channel which has the
                            % maximum absolute value


function DataShow(handles,cdata, sF, sT)

    tt          = 0:1/sF:sT-1/sF;            % Create vector of time
    nS          = length(cdata(:,1));        % It used to be sF*sT but due to change in lenght witht training data
    nCh         = size(cdata,2);
    
    if size(tt,2) ~= size(cdata,1)
        nSd = size(cdata,1)- size(tt,2); 
        tt(1,end:end+nSd) = 0;
    end

    % Initialize plots 
    ampPP = 5;
    ymin = -ampPP*2/3;
    ymax =  ampPP * nCh - ampPP*1/3;
    xmax =  max(tt);
    
    %Fast Fourier Transform
    NFFT = 2^nextpow2(nS);                                                 % Next power of 2 from number of samples
    f = sF/2*linspace(0,1,NFFT/2);
    dataf = fft(cdata(1:nS,:),NFFT)/nS;    
    m = 2*abs(dataf((1:NFFT/2),:));                                        
    
    % Offset and scale the data
    offVector = 0:nCh-1;
    offVector = offVector .* ampPP;
    Kt = ampPP/(2*max(max(abs(cdata))));
    Kf = ampPP/(max(max(abs(m))));
    tempData = zeros(size(cdata,1),nCh);
    fData = zeros(size(m,1),nCh);
    for j = 1 : nCh
        tempData(:,j) = cdata(:,j)*Kt + offVector(j);
        fData(:,j) = m(:,j)*Kf + offVector(j);
    end
    
    % plot
    axes(handles.a_t0);
    plot(tt(1:length(tempData(:,1))),tempData);
    set(handles.a_t0,'YTick',offVector);
    set(handles.a_t0,'YTickLabel',0:nCh-1);
    ylim(handles.a_t0, [ymin ymax]);
    xlim(handles.a_t0, [0 xmax]);
    axes(handles.a_f0);
    plot(f,fData);
    set(handles.a_f0,'YTick',offVector);
    set(handles.a_f0,'YTickLabel',0:nCh-1);
    xlim(handles.a_f0, [0,sF/2]);
    ymax =  ampPP * nCh;
    ylim(handles.a_f0, [ymin ymax]);
       
end
