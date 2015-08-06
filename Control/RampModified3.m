function [patRec, outMov] = RampModified3(patRec, outMov, outVec)

if ismember(patRec.nOuts,outMov) && strcmp(patRec.mov{end},'Rest')
    outMov = patRec.nOuts;
    % Reset buffer if rest is predicted
    patRec.control.controlAlg.prop.timesPredicted(:) = 0;
else
    % Smooth the prediction with Store Last Prediction from buffer
    lastPredictionInBuffer = patRec.control.outBuffer(1,:) > 0;

    % Update output buffer with the newly predicted movement
    patRec.control.outBuffer(1:end-1,:) = patRec.control.outBuffer(2:end,:);
    patRec.control.outBuffer(end,:) = zeros(1,size(patRec.control.outBuffer,2));
    patRec.control.outBuffer(end,outMov) = 1;

    % Save index of all movements occuring in buffer
    increaseSpeedIdx = sum(patRec.control.outBuffer,1) > 0;
    decreaseSpeedBigIdx = (lastPredictionInBuffer > 0) &(lastPredictionInBuffer ~= increaseSpeedIdx);
    decreaseSpeedSmallIdx = ~increaseSpeedIdx & ~decreaseSpeedBigIdx;

    % Read controlAlg parameters and properties
    timesPredicted = patRec.control.controlAlg.prop.timesPredicted;
    downCount = patRec.control.controlAlg.parameters.downCount;
    rampLength = patRec.control.controlAlg.parameters.rampLength;
    bufferSize = patRec.control.controlAlg.parameters.bufferSize;
    maxDegPerMov = patRec.control.currentDegPerMov;

    % Update time predicted vector.
    timesPredicted( increaseSpeedIdx ) = timesPredicted( increaseSpeedIdx )+1;
    timesPredicted( decreaseSpeedSmallIdx ) = timesPredicted( decreaseSpeedSmallIdx )-downCount;
    timesPredicted( decreaseSpeedBigIdx ) = timesPredicted( decreaseSpeedBigIdx )- (bufferSize-1)*downCount;

    % Limit Counters so they don't count to inifinity
    timesPredicted( timesPredicted > rampLength ) = rampLength;
    timesPredicted( timesPredicted < 0 ) = 0;

    % Update Speeds, only output the speed of the predicted movement
    rampGain = timesPredicted./rampLength;
    patRec.control.currentDegPerMov(:) = 0;
    patRec.control.currentDegPerMov(outMov) = rampGain(outMov) .* maxDegPerMov(outMov);

    % Save Counters
    patRec.control.controlAlg.prop.timesPredicted = timesPredicted;
end