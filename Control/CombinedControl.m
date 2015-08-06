function [patRec, outMov, handles] = CombinedControl(patRec, outMov, outVec, handles)
    
    % Apply first controller
    p = patRec.control.controlAlg.prop.patRecOne;
    [patRecOut, outMov] = ApplyControl(p, outMov, outVec);
    patRec.controlAlg.prop.patRecOne = patRecOut;
    
    % Apply second controller
    p = patRec.control.controlAlg.prop.patRecTwo;
    [patRecOut, outMov] = ApplyControl(p, outMov, outVec);
    patRec.control.controlAlg.prop.patRecTwo = patRecOut;
    
end