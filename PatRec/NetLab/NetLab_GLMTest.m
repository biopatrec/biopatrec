function [outMov outVector] = NetLab_GLMTest(patRecTrained, tSet)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

          
    outVector = glmfwd(patRecTrained.GLM, tSet);
    
    if isfield(patRecTrained,'thOut')
        % Output according to a given threshold
        outMov = find(outVector>patRecTrained.thOut');
    else
        % The output movement is given by any prediction over 50%
        outMov = find(round(outVector));
        
        % The output movement is given by the higest prediction
        %[maxV, outMov] = max(outVector);  
    end











end

