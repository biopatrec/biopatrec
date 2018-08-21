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
% Function outputs a random target location in either 1, 2, or 3
% dimensions that maintains a Euclidean distance defined by targetDist:
%
%       targetDist^2 = sqrt((xt-xi)^2+(yt-yi)^2+(rt-ri)^2) 
%
% If a certain DOF is not assigned an input movement, the target coordinate
% along that DOF is the same as initial.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-11-29 / Jake Gusman  / Creation
% 20xx-xx-xx / Author  / Comment on update


function [xt,yt,rt] = FLT_EuclidDist(directions,targetDist,xi,yi,ri);

expand = directions(1);
shrink = directions(2);
right = directions(3);
left = directions(4);
up = directions(5);
down = directions(6);

nM = length(directions)+1;

if [right left] ~= nM    % nM corresponds to the 'None' value
    if [up down] ~= nM
        if [expand shrink] ~= nM
            % Coordinates Defined: []
            rt = randi([ri-targetDist ri+targetDist]); % random 'distance' between 0 and max dist
        else
            rt = ri;
        end
        % Coordinates Defined: rt
        ytmax = sqrt(targetDist.^2-(rt-ri).^2)+yi; %
        ytmin = -sqrt(targetDist.^2-(rt-ri).^2)+yi;
        yt = randi(floor([ytmin ytmax]));
    else
        if [expand shrink] ~= nM
            % Coordinates Defined: yt
            rt = randi([ri-targetDist ri+targetDist]); % random 'distance' between 0 and max dist
        else
            rt = ri;
        end
        yt = yi;
    end
    % Coordinates Defined: yt,rt
    xtabs = sqrt(targetDist.^2 - (yt-yi).^2 - (rt-ri).^2);
    sign = randi([0 1]);
    if sign == 0
        xt = xi - xtabs;
    else
        xt = xi + xtabs;
    end
    % Coordinates Defined: xt, yt, rt
else
    xt = xi;
    if sum([up down] == nM) > 0
        yt = yi;
        if sum([expand shrink] == nM) > 0
            rt = ri;
        else
            % Coordinates Defined: xt,yt
            rtabs = sqrt(targetDist.^2 - (yt-yi).^2 - (xt-xi).^2);
            sign = randi([0 1]);
            if sign == 0
                rt = ri - rtabs;
            else
                rt = ri + rtabs;
            end
            % Coordinates Defined: xt, yt, rt
        end
    else
        if sum([expand shrink] == nM) > 0
            rt = ri;
        else
            % Coordinates Defined: xt
            rtmax = sqrt(targetDist.^2-(xt-xi).^2)+ri; %
            rtmin = -sqrt(targetDist.^2-(xt-xi).^2)-ri;
            rt = randi(floor([rtmin rtmax]));
        end
        % Coordinates Defined: xt,rt
        ytabs = sqrt(targetDist.^2 - (rt-ri).^2 - (xt-xi).^2);
        sign = randi([0 1]);
        if sign == 0
            yt = yi - ytabs;
        else
            yt = yi + ytabs;
        end
        % Coordinates Defined: xt, yt, rt
    end
    
end

end

