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
% Function updating the dot object in the realtime-plot.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2013-06-02 / Alf Bjørnar Bertnum / Creation
% 20xx-xx-xx / Author  / Comment on update

function DotObjectPlotter (plotInput, handles)

dimSize = size(plotInput,1);

switch dimSize
    case 1
        % Dot object values
        dotObjectRadius = handles.dotObject.radius;
        angleStep = handles.dotObject.angleStep;
        
        x = plotInput(1); y = 0;   % Center coordinates of the circle
        xp = dotObjectRadius*cos(angleStep);
        yp = dotObjectRadius*sin(angleStep);

        % Refresh dot object plot
        dotObjectPlot = findobj('tag', 'dotObjectPlot');
        set(dotObjectPlot, 'XData', x+xp, 'YData', y+yp);
        refreshdata
    
    case 2
        % Dot object values
        dotObjectRadius = handles.dotObject.radius;
        angleStep = handles.dotObject.angleStep;
        
        x = plotInput(1); y = plotInput(2);     % Center coordinates of the circle
        xp = dotObjectRadius*cos(angleStep);
        yp = dotObjectRadius*sin(angleStep);

        % Refresh dot object plot
        dotObjectPlot = findobj('tag', 'dotObjectPlot');
        set(dotObjectPlot, 'XData', x+xp, 'YData', y+yp);
        refreshdata
    
    case 3
        x = plotInput(1); y = plotInput(2); z = plotInput(3);
        
        % Refresh dot object plot
        dotObjectPlot = findobj('tag', 'dotObjectPlot');
        set(dotObjectPlot, 'XData', x, 'YData', y, 'ZData', z);
        refreshdata
        
    case 4
        x = plotInput(1); y = plotInput(2); z = plotInput(3);
        c = plotInput(4);
        
        % Refresh dot object plot
        dotObjectPlot = findobj('tag', 'dotObjectPlot');
        set(dotObjectPlot, 'XData', x, 'YData', y, 'ZData', z, 'CData', c);
        refreshdata
        
    otherwise
        errordlg('Defined dimension size is not supported.','Error');
        return
        
end