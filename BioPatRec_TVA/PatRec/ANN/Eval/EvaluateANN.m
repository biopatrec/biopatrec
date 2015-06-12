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
% Evaluation of the ANN which comprises the sum of the weights and bias per
% neuron. The neuron output is given by the activation function (Phi).
%
% Activation function: Log-sigmoid or logistic function which provides an
% output between 0 and 1.
%
% ANN.a         Amplitude of the activation function
% ANN.v         Vector containing th sum of neuron inputs
% ANN.phi       Activation function
% ANN.o         ANN output per neuron using the activation function Phi
%
% ------------------------- Updates & Contributors ------------------------
% 2009-07-22 / Max Ortiz  / Modify to hanlde the new ANN MLP
% 2011-09-10 / Max Ortiz  / New routine for BioPatRec based in previous implementation
%                       for EMG_AQ
% 2011-10-09 / Max Ortiz  / Improved documentation
% 2011-11-23 / Joel Falk-Dahlin  / Vectorized implementation for great speed
%                                  improvement

function ANN = EvaluateANN(inputs, ANN)
    
    if strcmp(ANN.Type,'Perceptron')
        ll = length(ANN.nHn);
        
        %First Inpute Layer
        
        ANN.v(:,1) = ANN.w(1:length(inputs),:,1)'*inputs'+ANN.b(:,1);
        ANN.phi(:,1) = 1 ./ (1 + exp(-ANN.a .* ANN.v(:,1)));
        
%         for i=1:ANN.nHn(1)
%             ANN.v(i,1) = sum(ANN.w(1:length(inputs),i,1) .* inputs') + ANN.b(i,1);    % Induced local field
%             ANN.phi(i,1) = 1 /(1 + exp(-ANN.a * ANN.v(i,1)));    
%         end
        
        %Hiden Layers Layer
        for j=2:ll
            
            ANN.v(:,j) = ANN.w(1:ANN.nHn(j-1),:,j)' * ANN.phi(1:ANN.nHn(j-1),j-1) + ANN.b(:,j);
            ANN.phi(:,j) = 1 ./ (1 + exp(-ANN.a .* ANN.v(:,j)));
            
%             for i=1:ANN.nHn(j)
%                 ANN.v(i,j) = sum(ANN.w(1:ANN.nHn(j-1),i,j) .* ANN.phi(1:ANN.nHn(j-1),j-1)) + ANN.b(i,j);    % Induced local field
%                 ANN.phi(i,j) = 1 /(1 + exp(-ANN.a * ANN.v(i,j)));    
%             end
            
        end
        
        %Output layer neuron
        ol = ll + 1;
        
        ANN.v(:,ol) = ANN.w(1:ANN.nHn(end),:,ol)' * ANN.phi(1:ANN.nHn(end),ll) + ANN.b(:,ol);
        ANN.o    = 1 ./ (1 + exp(-ANN.a .* ANN.v(1:ANN.nOn,ol)));
        
%         for i=1:ANN.nOn
%             ANN.v(i,ol) = sum(ANN.w(1:ANN.nHn(end),i,ol) .* ANN.phi(1:ANN.nHn(end),ll)) + ANN.b(i,ol);    % Induced local field
%             ANN.o(i)    = 1 /(1 + exp(-ANN.a * ANN.v(i,ol)));
%         end        
   
    elseif strcmp(ANN.Type,'Other')
   
    end
    