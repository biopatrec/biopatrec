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
% 2009-04-15 / Eva Lendaro


function DataPlot(handles,cdata, nofiltData, sF, sT)

    tt          = 0:1/sF:sT-1/sF;            % Create vector of time
    nS          = length(cdata(:,1));        % It used to be sF*sT but due to change in lenght witht training data
    nCh         = size(nofiltData,2);
    nCh2         = size(cdata,2);
    if size(tt,2) ~= size(cdata,1)
        nSd = size(cdata,1)- size(tt,2); 
        tt(1,end:end+nSd) = 0;
    end

    % Initialize plots 
    ampPP = 5;
    ymin = -ampPP*2/3;
    ymax =  ampPP * nCh - ampPP*1/3;
                                       
    
    % Offset and scale the data
    offVector = 0:nCh-1;
    offVector = offVector .* ampPP;
    Kf = ampPP/(2*max(max(abs(cdata))));
    Kt = ampPP/(2*max(max(abs(nofiltData))));
    for j = 1 : nCh2
        tempData(:,j) = cdata(:,j)*Kf + offVector(j);
    end
     for j = 1 : nCh
         nofilt_tempData(:,j) = nofiltData(:,j)*Kt + offVector(j);
    end
    
    % plot
    axes(handles.post_plot);
    plot(tt(1:length(tempData(:,1))),tempData);
    set(handles.post_plot,'YTick',offVector);
    set(handles.post_plot,'YTickLabel',0:nCh-1);
    ylim(handles.post_plot, [ymin ymax]);
   
    axes(handles.pre_plot);
    plot(tt(1:length(nofilt_tempData(:,1))),nofilt_tempData);
    set(handles.pre_plot,'YTick',offVector);
    set(handles.pre_plot,'YTickLabel',0:nCh-1);
    ylim(handles.pre_plot, [ymin ymax]);
       
end