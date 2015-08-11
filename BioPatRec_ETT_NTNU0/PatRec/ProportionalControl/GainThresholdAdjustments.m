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
% Function executing the gain and threshold adjustments.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2013-05-27 / Alf Bjørnar Bertnum / Creation
% 20xx-xx-xx / Author  / Comment on update

function newF = GainThresholdAdjustments ( F, handles )

disp(F);
%% Initialise variables
tempF = (F-0.5)*2*100;        % Translating from 0/1 to -100/100
xy_axis_length = handles.xy_axis_length;

% Offset values
offsetOpenClose = str2double(get(handles.et_offsetOpenClose,'String'));
offsetProSup = str2double(get(handles.et_offsetProSup,'String'));

% Gain values
gainClose = str2double(get(handles.et_gclose,'String'));
gainOpen = str2double(get(handles.et_gopen,'String'));
gainPronation = str2double(get(handles.et_gpro,'String'));
gainSupination = str2double(get(handles.et_gsup,'String'));

% Threshold values
angleOpenClose = str2double(get(handles.et_angleOpenClose,'String'));
anglePronSup = str2double(get(handles.et_anglePronSup,'String'));
restThreshold = str2double(get(handles.et_restThreshold,'String'));
angles = [angleOpenClose; anglePronSup];


%% Applying offset values
newF = [(tempF(1)+offsetOpenClose); (tempF(2)+offsetProSup)];

%% Applying gain values
for i=1:2
    if sign(newF(i)) == -1
        if i == 1
            newF(i) = newF(i)*gainOpen;
        else
            newF(i) = newF(i)*gainSupination;
        end
    else
        if i == 1
            newF(i) = newF(i)*gainClose;
        else
            newF(i) = newF(i)*gainPronation;
        end
    end
end

disp('Pausing...');
pause(0.5);

disp(newF);
newF = min(xy_axis_length, max(-xy_axis_length, newF));

%% Update dot object plot
DotObjectPlotter(newF, handles);

%% Applying thresholds
F = newF;         % F = [powerCloseOpen; powerPronSup]

% Consider removing, shouldn't be necessary
if(size(F,1)<size(F,2))
    F = F';
end

% Initialisation of threshold variables
sizeF = size(F,1);                  % Degrees of freedom
sizeAngles = size(angles,1);
newF = zeros(sizeF,1);              % New(modified) F
r = sqrt(sum(F.^2));
rz = sum(abs(F));

% Consider removing, shouldn't be necessary
if(sizeAngles < sizeF)
    angles(1:sizeF) = angles(1);
end

if( r > restThreshold )
    for i = 1:sizeF
        theta = atan(F(i)/sqrt(r^2-F(i)^2));

        %% Find maximum angle around other axes..
        beta = 0;
        for j = 1:sizeF
            if j == i
            else
                if angles(j) > beta
                    beta = angles(j);
                end
            end
        end

        %% "Magnetic" axes AND DIAGONALS in the 2D scenario
        if ( sizeF == 2 )
            if ( abs(theta) < beta*pi/180 )
                newF(i) = 0;
            elseif ( abs(theta) > pi/2 - angles(i) * pi/180 )
                newF(i) = F(i);
            else
                newF(i) = sign( F(i) ) * mean( abs(F) );
            end
%             r_m = (r-restThreshold) / ( 1-(restThreshold/xy_axis_length) * (r/rz) );
%             newF(i) = (r_m/r) * newF(i);
            newF(i) = min(xy_axis_length, max(-xy_axis_length, newF(i)));

        %% "Magnetic axes" in all cases with more than 2 dimensions
        else
            g = pi/(4*sqrt(sizeF-1));
            limit = beta*pi/(180*sqrt(sizeF-1));
            if abs(theta) > limit
                if abs(theta) > g
                    theta_m = theta;
                else
                    theta_m = real(sign(theta)*(abs(theta)-limit)/(1-(limit/g)));
                end
            end
            r_m = (r-restThreshold)/(1-(restThreshold/xy_axis_length)*(r/rz));
            newF(i) = real(r_m*sin(theta_m));
        end

    end
end

disp(newF);
disp('Pausing...');
pause(0.5);

%% Update dot object plot
DotObjectPlotter(newF, handles);

%% Translate to input format
newF = newF/(100*2)+0.5;        % Translating from -100/100 to 0/1


end