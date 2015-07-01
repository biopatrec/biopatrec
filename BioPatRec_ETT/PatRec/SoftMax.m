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
% ------------- Function Description -------------
% Apply SoftMax activation function
%
% ------------- Updates -------------
% 2011-10-09 / Max Ortiz  / Creation
% 20xx-xx-xx / Author / Comment on update
function vector = SoftMax(vector)

%% Manual
    %vector = vector - min(vector);      % Offset negative numbers
    vector(vector < 0) = 0;             % Remove negative numbers
    vector = vector ./ sum(vector);

  
    
%% Automatic
%      vector = softmax(vector);


%% Validations
    
    % The softmax function can returns NaN
    if find(isnan(vector))
        vector(isnan(vector)) = 1;
    end
       
    % Replace 0 for small values
    vector(vector == 0) = 0.0000000001;  
    

