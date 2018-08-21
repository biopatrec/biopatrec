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
% ------------------- Function Description ------------------
%
%   desiredSpeedPercent = CalculateDesiredSpeedPercent(featureCurrent, featureMin,featureMax, map)
%
%       Function to convert a feature value to a desired speed percentage.
%       The conversion is done using the threshold values featuresMin,
%       featuresMax and the mapping function map.
%
%       The value of featureCurrent is mapped to the interval of [0,1]
%       where values <= featureMin are mapped to zero and values >=
%       featureMax are mapped to 1. The value that is retrieved is
%       recalculated using the map function, remapping it to the interval
%       [0,1].
%
%       This function is used in proportional control
%
%   INPUTS:
%
%       featureCurrent - A number, currently the mean value of the selected
%       feature to use with proportional control across all channels.
%
%       featureMin - The threshold when movement should begin, all values
%       below featureMin will be mapped to the value 0.
%
%       featureMax - Feature value where maximum speed should be outputted,
%       all values above featureMax will be mapped to the value 1.
%
%       featureMap - string determining which function to use when mapping
%       the value in [0,1] back onto the interval [0,1]. Available options
%       are currently; 'linear', 'quad', 'sqrt'.
%
%   OUTPUTS:
%   
%       desiredSpeedPercent - a number (or row vector with elements) from
%       0 - 100 that gives how many percent of the maximum degrees per 
%       movement that are to be outputted.
%
% --------------------------Updates--------------------------
% [Contributors are welcome to add their email]
% 2012-10-26 / Joel Falk-Dahlin / Creation
% 2017-7-27  / Jake Gusman      / changes to allow featureMax and
%                                 featureMin vectors (i.e. prop control
%                                 where each movement has different max and
%                                 min values
% 20xx-xx-xx / Author     / Comment on update

function desiredSpeedPercent = CalculateDesiredSpeedPercent(featureCurrent, featureMin,featureMax, map)
    
%     if featureCurrent > featureMax
%         featureCurrent = featureMax;
%     elseif featureCurrent < featureMin
%         featureCurrent = featureMin;
%     end
    
    % turn featureCurrent into vector
    featureCurrent = featureCurrent.*ones(size(featureMax));
    % if feature is greater than max for that movement, set to feature max
    featureCurrent(featureCurrent > featureMax) = featureMax((featureCurrent > featureMax));
    % if feature is lower than min for that movement, set to feature min
    featureCurrent(featureCurrent < featureMin) = featureMin((featureCurrent < featureMin));
    
    % Map into [0,1] interval
    xVal = featureCurrent ./ (featureMax - featureMin) - featureMin./(featureMax - featureMin);
    
    % Now we can use any mapping we want (f(0) should be minimum
    % activation percentage (0.0 for threshold), f(1) should be 100 percent (1.0)
    
    % Linear mapping
    if strcmp(map, 'linear')
        desiredSpeedPercent = xVal;
    % Quadratic mapping
    elseif strcmp(map,'quad')
        desiredSpeedPercent = xVal.^2;
    % Square-root mapping
    elseif strcmp(map,'sqrt')
        desiredSpeedPercent = sqrt(xVal);
    % Logistic (sigmoid) function
    elseif strcmp(map,'logistic')   
        desiredSpeedPercent = 1./(1+exp(-10*(xVal-0.5)));
        for i = 1:length(xVal)
            if xVal(i) == 0
            desiredSpeedPercent(i) = 0;
            end
        end
    else
        desiredSpeedPercent = xVal;
    end
    
    desiredSpeedPercent = desiredSpeedPercent*100;
    desiredSpeedPercent(end+1) = 0;  % Add value for Rest at the end
end