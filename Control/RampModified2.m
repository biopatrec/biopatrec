function [patRec, outMov] = RampModified2(patRec, outMov, outVec)

% Read speeds
maxDegPerMov = patRec.control.currentDegPerMov;

% Read counters
timesPredicted = patRec.control.controlAlg.prop.timesPredicted;
timesNotPredicted = patRec.control.controlAlg.prop.timesNotPredicted;

% Read controlAlg parameters
nMisclassificationCompensation = patRec.control.controlAlg.parameters.nMisclassificationCompensation;
downCount = patRec.control.controlAlg.parameters.downCount;
nPredictionsToSteadyPhase = patRec.control.controlAlg.parameters.nPredictionsToSteadyPhase;
rampLength = patRec.control.controlAlg.parameters.rampLength;

% Create vector with boolean indicies of predicted movements
predictedMovementsIndex = false(1,patRec.nOuts);
predictedMovementsIndex(outMov) = true;

% Update Counters
timesPredicted(predictedMovementsIndex) = timesPredicted(predictedMovementsIndex) + 1;
timesNotPredicted(~predictedMovementsIndex) = timesNotPredicted(~predictedMovementsIndex) + 1;
timesNotPredicted(predictedMovementsIndex) = 0;

% Catergorize movements in initial and steady phases
initialPhaseMovementsIdx = timesPredicted < nPredictionsToSteadyPhase;
steadyPhaseMovementsIdx = timesPredicted >= nPredictionsToSteadyPhase;

% If movement is in initial phase and not classified, reset velocity
timesPredicted( initialPhaseMovementsIdx & ~predictedMovementsIndex ) = 0;

% If movement is in steady phase and not classified, only reset velocity if
% enough number of predictions has been made without movement
steadyPhaseNotPredictedIdx = (steadyPhaseMovementsIdx & ~predictedMovementsIndex);
steadyPhaseToDecreaseLongIdx = steadyPhaseNotPredictedIdx & (timesNotPredicted == nMisclassificationCompensation+1);
steadyPhaseToDecreaseShortIdx = steadyPhaseNotPredictedIdx & (timesNotPredicted > nMisclassificationCompensation+1);
steadyPhaseToIncrease = steadyPhaseNotPredictedIdx & (timesNotPredicted <= nMisclassificationCompensation);
timesPredicted(steadyPhaseToDecreaseLongIdx) = timesPredicted(steadyPhaseToDecreaseLongIdx)-(nMisclassificationCompensation+1)*downCount;
timesPredicted(steadyPhaseToDecreaseShortIdx) = timesPredicted(steadyPhaseToDecreaseShortIdx)-downCount;
timesPredicted(steadyPhaseToIncrease) = timesPredicted(steadyPhaseToIncrease)+1;

% If predicted movement is rest, reset all counters
if outMov == patRec.nOuts
    timesPredicted(:) = 0;
    timesNotPredicted(:) = 0;
end

% Limit Counters so they don't count to inifinity
timesPredicted( timesPredicted > rampLength ) = rampLength;
timesPredicted( timesPredicted < 0 ) = 0;
timesNotPredicted( timesNotPredicted > nMisclassificationCompensation+2 ) = nMisclassificationCompensation+2;
timesNotPredicted( timesNotPredicted < 0 ) = 0;

% Update Speeds, only output the speed of the predicted movement
rampGain = timesPredicted./rampLength;
patRec.control.currentDegPerMov = rampGain .* maxDegPerMov;
patRec.control.currentDegPerMov(~predictedMovementsIndex) = 0;

% Save Counters
patRec.control.controlAlg.prop.timesPredicted = timesPredicted;
patRec.control.controlAlg.prop.timesNotPredicted = timesNotPredicted;