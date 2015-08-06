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
% Funtion to compute the local gradient for the back-propagation algorithm
% and back-propagate
% The right most index is the layer
% The middle is the neuron
% The left most is the input
%
% ------------------------- Updates & Contributors ------------------------
% 2011-09-10 / Max Ortiz / New routine for BioPatRec based in previous implementation
%               for EMG_AQ
% 2013-01-15 / Joel Falk-Dahlin / Vectorized calculations, now faster

function ANN = Backpropagation(in, out, ANN, eta, alpha)

    if strcmp(ANN.Type,'Perceptron')
        ll = length(ANN.nHn);
        ol = ll + 1;
        
        %Output layer neuron        
        % Local gradient
        ANN.lg(1:ANN.nOn,ol) = ANN.a .* (out' - ANN.o) .* ANN.o .* (1 - ANN.o);
        % Weight correction
        ANN.dw(:,1:ANN.nOn,ol) = (alpha .* ANN.dw(:,1:ANN.nOn,ol)) + (eta .* bsxfun(@times, ANN.lg(1:ANN.nOn,ol)', ANN.phi(:,ll)) );
        ANN.db(1:ANN.nOn,ol)   = (alpha .* ANN.db(1:ANN.nOn,ol)) + (eta .* ANN.lg(1:ANN.nOn,ol));
        ANN.w(:,:,ol)  = ANN.w(:,:,ol) + ANN.dw(:,:,ol);  
        ANN.b(:,ol)    = ANN.b(:,ol)   + ANN.db(:,ol);  
        
    % OLD CODE
        %Output layer neuron
%         for i=1:ANN.nOn
%             %Local gradient
%             ANN.lg(i,ol) = ANN.a .* (out(i) - ANN.o(i)) .* ANN.o(i) .* (1 - ANN.o(i));
%             %Weight correction
%             ANN.dw(1:ll,i,ol) = (alpha .* ANN.dw(1:ll,i,ol)) + (eta .* ANN.lg(i,ol) .* ANN.phi(1:ll,ll));
%             ANN.dw(:,i,ol) = (alpha .* ANN.dw(:,i,ol)) + (eta .* ANN.lg(i,ol) .* ANN.phi(:,ll));
%             ANN.db(i,ol)   = (alpha .* ANN.db(i,ol)) + (eta .* ANN.lg(i,ol));
%         end
%         ANN.w(1:ll,:,ol)  = ANN.w(1:ll,:,ol) + ANN.dw(1:ll,:,ol);
%         ANN.w(:,:,ol)  = ANN.w(:,:,ol) + ANN.dw(:,:,ol);  
%         ANN.b(:,ol)    = ANN.b(:,ol)   + ANN.db(:,ol);  
        
        
        %Hiden Layers Layer
        for l=ll : -1 : 2
            
            % Local gradient
            ANN.lg(1:ANN.nHn(l),l) = ANN.a * (1 - ANN.phi(1:ANN.nHn(l),l)) .* ANN.phi(1:ANN.nHn(l),l) .*  ( ANN.w(1:ANN.nHn(l),:,l+1) * ANN.lg(:,l+1) );
            % Weight correction
            ANN.dw(:,1:ANN.nHn(l),l) = (alpha .* ANN.dw(:,1:ANN.nHn(l),l)) + (eta .*  bsxfun(@times, ANN.lg(1:ANN.nHn(l),l)', ANN.phi(:,l-1)) );
            ANN.db(1:ANN.nHn(l),l)   = (alpha .* ANN.db(1:ANN.nHn(l),l)) + (eta .* ANN.lg(1:ANN.nHn(l),l));
            ANN.w(:,1:ANN.nHn(l),l)  = ANN.w(:,1:ANN.nHn(l),l) + ANN.dw(:,1:ANN.nHn(l),l);
            ANN.b(1:ANN.nHn(l),l)    = ANN.b(1:ANN.nHn(l),l)   + ANN.db(1:ANN.nHn(l),l);
            
    % OLD CODE
%             for i=1:ANN.nHn(l)
%                 % Local gradient
%                 ANN.lg(i,l) = ANN.a * (1 - ANN.phi(i,l)) * ANN.phi(i,l) *  sum(ANN.lg(:,l+1) .* ANN.w(i,:,l+1)');
%                 % Weight correction
%                 ANN.dw(:,i,l) = (alpha .* ANN.dw(:,i,l)) + (eta .* ANN.lg(i,l) .* ANN.phi(:,l-1));
%                 ANN.db(i,l)   = (alpha .* ANN.db(i,l)) + (eta .* ANN.lg(i,l));
%                 ANN.w(:,i,l)  = ANN.w(:,i,l) + ANN.dw(:,i,l);
%                 ANN.b(i,l)    = ANN.b(i,l)   + ANN.db(i,l);  
%             end            
            
        end

        %First layer neuron
        l = 1;
        lin = length(in);
        
        %Local gradient
        ANN.lg(1:ANN.nHn(l),l) = ANN.a * (1 - ANN.phi(1:ANN.nHn(l),l)) .* ANN.phi(1:ANN.nHn(l),l) .* (ANN.w(1:ANN.nHn(l),:,l+1) * ANN.lg(:,l+1));
        %Weight correction
        ANN.dw(1:lin,1:ANN.nHn(l),l) = (alpha .* ANN.dw(1:lin,1:ANN.nHn(l),l)) + (eta .* bsxfun(@times, ANN.lg(1:ANN.nHn(l),l)', in' ) );
        ANN.db(1:ANN.nHn(l),l) = (alpha .* ANN.db(1:ANN.nHn(l),l)) + (eta .* ANN.lg(1:ANN.nHn(l),l));
        ANN.w(:,1:ANN.nHn(l),l) = ANN.w(:,1:ANN.nHn(l),l) + ANN.dw(:,1:ANN.nHn(l),l);
        ANN.b(1:ANN.nHn(l),l) = ANN.b(1:ANN.nHn(l),l) + ANN.db(1:ANN.nHn(l),l);
        
        % OLD CODE
%             for i=1:ANN.nHn(l)
%                 % Local gradient
%                 ANN.lg(i,l) = ANN.a * (1 - ANN.phi(i,l)) * ANN.phi(i,l) *  sum(ANN.lg(:,l+1) .* ANN.w(i,:,l+1)');
%                 % Weight correction
%                 ANN.dw(1:lin,i,l) = (alpha .* ANN.dw(1:lin,i,l)) + (eta .* ANN.lg(i,l) .* in');
%                 ANN.db(i,l)   = (alpha .* ANN.db(i,l)) + (eta .* ANN.lg(i,l));
%                 ANN.w(:,i,l)  = ANN.w(:,i,l) + ANN.dw(:,i,l);  
%                 ANN.b(i,l)    = ANN.b(i,l)   + ANN.db(i,l);  
%             end
    end

end
        