function [outMov outVector] = NetLab_MLPTest(patRecTrained, tSet)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
          
    outVector = mlpfwd(patRecTrained.MLP(1), tSet);
    
    if isfield(patRecTrained,'thOut')
        % Output according to a given threshold
        outMov = find(outVector>patRecTrained.thOut');
    else
        % The output movement is given by any prediction over 50%
        outMov = find(round(outVector));  % returns all indices for accepted movements
                               
        if size(patRecTrained.MLP,2) == 2                                    
            outVector(outMov) = mlpfwd(patRecTrained.MLP(2), tSet);
            
            
        end
  
    end

 
    







end

