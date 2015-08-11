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
% Function initialising the dot object in the realtime-plot.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2013-06-02 / Alf Bjørnar Bertnum / Creation
% 20xx-xx-xx / Author  / Comment on update

function dotObject = DotObjectInitialisation (dimSize)

%% Creating dot object for plot
switch dimSize
    case {1,2}
        x = 0; y = 0;   % Center coordinates of the circle
        radius = 2;
        angleStep = 0:0.01:2*pi;    % Angle step, higher value = faster drawn but less smooth circle
        xp = radius*cos(angleStep);
        yp = radius*sin(angleStep);

        fill(x+xp, y+yp, 'blue', 'tag', 'dotObjectPlot');

        % Update handles to include dot object
        dotObject.radius = radius;
        dotObject.angleStep = angleStep;
        
    case 3
        x = 0; y = 0; z = 0;   % Center coordinates of the circle
        radius = 5;
        circleArea = pi*radius^2;

        scatter3(x, y, z, circleArea, 'blue', 'filled', 'tag', 'dotObjectPlot');

        % Update handles to include dot object
        dotObject.radius = radius;
        
    case 4
        x = 0; y = 0; z = 0; c = 0;   % Center coordinates of the circle
        radius = 5;
        circleArea = pi*radius^2;
        
        scatter3(x,y,z,circleArea,c, 'filled', 'tag', 'dotObjectPlot');
        
        % Update handles to include dot object
        dotObject.radius = radius;
        
    otherwise
        errordlg('Defined dimension size is not supported.','Error');
        return
end



end