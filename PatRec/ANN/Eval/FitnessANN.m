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
% Particle Validation or in this case, validation of the ANN's weights
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 20xx-xx-xx / Max Ortiz  / Creation
% 2010-05-16 / Max Ortiz  / New version to return both Accuracies
% 2011-09-10 / Max Ortiz  / New routine for BioPatRec based in previous implementation
%                           for EMG_AQ
% 2012-06-02 / Max Ortiz  / Created from ValidateANN

function fitness = FitnessANN(ANN,x,y) 
        
    nSets = length(x(:,1));
    nOuts = ANN.nOn;

    %Get the deviation
    d = zeros(nSets,nOuts);            % This vector is used to validate output    
    
    dsum=0;
    for i = 1:nSets
        ANN = EvaluateANN(x(i,:),ANN);
        d(i,:)= ANN.o;
        dsum = dsum + sum((d(i,:)-y(i,:)).^2);        
    end

    fitness = sqrt(dsum/(nSets*nOuts)); % for minimum
    %fitness = 1/(sqrt(dsum/Nsets)) for maximum
    
    
    
    
    
    