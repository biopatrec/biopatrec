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
% Function to execute the Offline calculations for proportional control.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2013-05-19 / Alf Bjørnar Bertnum / Creation
% 20xx-xx-xx / Author  / Comment on update

function [PropCon, accV] = OfflineProportionalControl( tType, trSets, trOuts, vSets, vOuts, mov )

%% Integration of training and validation sets in one set
trSets = [trSets ; vSets];
trOuts = [trOuts ; vOuts];

%% Initialisation of system variables
x = trSets';
preFormatF = trOuts';
F = zeros(2,size(preFormatF,2));

%% Formatting the trOuts vector to match the Proportional Control Alg.
% Current support: close-/open-hand, pron/sup and rest
preFormatF = preFormatF * 0.5;  % Translating from 0/1 to 0/0.5
tempF = preFormatF;


% Translating two and two motions classes to act as positive or negative
% values of their degrees of freedom. In addition, reformatting the vector
% such that the next for-loop can merge it from 4xn to 2xn.
% Output format will be -0.5/0.5
counterDemand = 0;
for i=1:size(mov)
    if strcmp(mov(i),'Close Hand')      % Activate for 0.5>=x>0
        preFormatF(1,:) = tempF(i,:);
        
        counterDemand = counterDemand + 1;
    elseif strcmp(mov(i),'Open Hand')   % Activate for -0.5<=x<0
        tempF(i,:) = tempF(i,:) * -1;
        preFormatF(2,:) = tempF(i,:);
        
        counterDemand = counterDemand + 1;
    elseif strcmp(mov(i),'Pronation')   % Activate for 0.5>=x>0
        preFormatF(3,:) = tempF(i,:);
        
        counterDemand = counterDemand + 1;
    elseif strcmp(mov(i),'Supination')  % Activate for -0.5<=x<0
        tempF(i,:) = tempF(i,:) * -1;
        preFormatF(4,:) = tempF(i,:);
        
        counterDemand = counterDemand + 1;
    end
end

% Checking whether all necessary movements are implemented; close, open,
% pronation or supination of hand.
if counterDemand ~= 4
    errordlg('The required movement set is not available.','Error');
    return;
end

% Merging the 4xn vector to a 2xn vector.
for i=1:size(preFormatF,2)
    F(1,i) = preFormatF(1,i) + preFormatF(2,i);
    F(2,i) = preFormatF(3,i) + preFormatF(4,i);
end
F = F + 0.5;    % Translating from -0.5/0.5 to 0/1

%% Calculation of the A matrix based on recorded values from the prosthesis training

if strcmp(tType, 'Normal linear estimator')
    A = F/x;

elseif strcmp(tType, 'Decoupled linear estimator')
    Tdata = size(x,2);

    F_mean = mean(F,2);                 % Offset
    F_mean_rep = repmat(F_mean,1,Tdata);
    F_std = std(F,0,2);                 % Amplitude
    F_std_rep = repmat(F_std,1,Tdata);
    F_shape = bsxfun(@minus, F, F_mean)./repmat(F_std,1,Tdata);

    A_mean = F_mean_rep/x;              % Training of Offset estimator
    A_std = F_std_rep/x;                % Training of Amplitude estimator
    A_shape = F_shape/x;                % Training of Shape estimator
    A = struct('A_mean', A_mean, 'A_std', A_std, 'A_shape', A_shape);

end

PropCon = A;
accV = 0;

end