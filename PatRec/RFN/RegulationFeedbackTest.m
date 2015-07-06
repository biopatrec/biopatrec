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
% Regulation Feedback Algorithm created from the "rf_alg" originally 
% by Tsvi Achler 
%
% Inputs:
%    connMat: The conectivity Matrix is made of a vector of features per pattern
%    tVector: Test vector
%    newY:    New vector. In the absence of a suggested output, RFN randomly
%             initializes an ouput in newY.
%    thOut:   If an output threshold is provided, it will
%             consider it for the computation of the prediction.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-09-26 / Max Ortiz  / Creation from "rf_alg" by Tsvi Achler
% 2011-10-09 / Max Ortiz  / Added newY like an optional input
% 2012-04-01 / Max Ortiz  / Ouput fixed to a single max value
% 2012-05-20 / Max Ortiz / Incorporated thOut to delete the additional
%                          thOut routines
% 20xx-xx-xx / Author  / Comment on update

% Regulatory Feedback Algorithm
function [outMov outVector unstable] = RegulationFeedbackTest(connMat, tVector, newY, thOut)     

    numOutputs = size(connMat,1);        % number of y's
    steadyStateTolerance = 0.00001;     % determines when steady state criteria
%    salienceValues = zeros(size(tVector));
%    feedback = zeros(size(tVector)); 
    
    itr = 0;    
    unstable = 0;
    
        numConnectionsInY = sum(connMat, 2);  % calculate number of connections for normalization
   
        % NOTE: newY could be substitude by the output of the ANN to test
        % its stability 2011-09-26
        if ~exist('newY','var') || isempty(newY)
            newY = rand(numOutputs, 1);% random initial values for all y's.  alternate: initial*ones(numOutputs, 1); initial = .1;
%            newY = ones(numOutputs, 1);% random initial values for all y's.  alternate: initial*ones(numOutputs, 1); initial = .1;
        end

        oldY = Inf(numOutputs, 1);  %start with infinity to overcome tolerance

     
   % caluclulate new Y values and salience from old Y values and inputs.     
        while( sum(abs(newY - oldY)) > steadyStateTolerance )  %iterate until steady state
     
            itr  = itr+1;  %count number of iterations
            oldY = newY;   %advance t to t+1
            
            feedback = connMat'*oldY;  %determine feedback to inputs            
            
            % It will cause an error if the feedback vector has zero values
            % which comes form the connMat with only 0 values per column
            salienceValues = tVector ./ feedback(feedback ~= 0);     % calculate salience
            newY = oldY .* (connMat * salienceValues) ./ numConnectionsInY;    % calculate updated Y's
                
            %Watchdog
            if itr == 200
                unstable = 1;
                break;
            end
        end
        outVector = newY;
           
        % Ouput using threshold?
        if exist('thOut','var')
            if ~isempty(thOut)            
                %mask(1:numOutputs) = thOut;
                %outMov = find(outVector>mask');
                outMov = find(outVector>thOut');
            else
                [maxV, outMov] = max(outVector);
            end
        else 
            [maxV, outMov] = max(outVector);
        end
end
 