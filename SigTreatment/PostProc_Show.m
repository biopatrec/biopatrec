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
% 2016-10-20 / Eva Lendaro/ Creation

function PostProc_Show(event) %(src, event)
% % % global sigTreated
% % % global handles

    global      handles;
    global      allData;
    global      nofilt_allData;
    global      timeStamps;
    global      plotGain;
    global      plotGain_f;
    
    
    nofilt_tempData = event.nofilt_Data;
    nofilt_allData = [nofilt_allData; nofilt_tempData];

   
    % Get required info from handles
    sF              = handles.sF;
    nCh             = handles.nCh;
    rep             = handles.rep;
    cT              = handles.cT;
    rT              = handles.rT;
    sT              = handles.sT;
    ComPortType     = handles.ComPortType;

    
    p_t0 = handles.p_t0;
    p_t1 = handles.p_t1;
    
    % Get data from tempData and add to allData global vector
    if(isempty(allData))                                                   % Fist DAQ callback
        timeStamps = [];      
        plotGain = 10000000;
        plotGain_f = 10000000;
    end
    tempData = event.Data;
    allData = [allData; tempData];
    nCh2 = size(tempData,2);
    timeStamps = [timeStamps; event.TimeStamps];
   
    
    

    %% Display peeked Data

    % Offset the plot of the different channels to fit into the main figure
    ampPP     = 5;
    offVector = 0:nCh-1;
    offVector = offVector .* ampPP;  

    K = ampPP/(2*(max(max(abs(nofilt_tempData)))));
    if K < plotGain
        plotGain = K;
    end
       Kf = ampPP/(2*(max(max(abs(tempData)))));
    if Kf < plotGain_f
        plotGain_f = Kf;
    end
    % plot a new tWs sized window
    for j = 1 : nCh2
     set(p_t0(j),'YData',tempData(:,j)*plotGain_f + offVector(j));              % add offsets to plot channels in same graph
    end 
    
     for j = 1 : nCh
    % set(p_t0(j),'YData',tempData(:,j)*plotGain_f + offVector(j));              % add offsets to plot channels in same graph
     set(p_t1(j),'YData',nofilt_tempData(:,j)*plotGain + offVector(j));
    end 
    drawnow expose      

end