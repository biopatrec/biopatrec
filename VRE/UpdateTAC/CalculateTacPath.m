function tacTest = CalculateTacPath(tacTest)
    s = size(tacTest.trialResult);
    tacTest.allowance = 5;
    tacTest.distance = 40;

    movements = InitMovements();

    for trial = 1:s(1) %loop over each trial
        for rep = 1:s(2) %loop over each repetition
            for comb = 1:s(3) %loop over each combination
                result = tacTest.trialResult(trial,rep,comb);

                %Set the correct movements from names.
                names = regexp(result.name,',','split');
                movement = [];
                for i = 1:length(names)
                    movement = [movement, GetMovementFromName(names(i),movements)];
                end
                result.movement = movement;

                % Set recordedMovements correctly
                maximumMovement = tacTest.patRec.control.maxDegPerMov(1); %Only get the first since they are all the same.
                movementJumpSize = tacTest.patRec.control.controlAlg.parameters.rampLength;
                movementJump = maximumMovement / movementJumpSize;
                movementDecrease = tacTest.patRec.control.controlAlg.parameters.downCount * movementJump;
                
                maxId = 0;
                for i = 1:length(movements)
                    if(movements(i).idVRE > maxId)
                        maxId = movements(i).idVRE;
                    end
                end
                
                lastKnownSpeed = zeros(1,maxId); %An array that says last known speed of movements.
                
                for record = 1:length(result.recordedMovements)
                    newSpeeds = lastKnownSpeed;
                    currentMovement = GetMovementFromName(result.recordedMovements(record,1),movements);
                    currentSpeed = result.recordedMovements(record,2);
                    newSpeeds(currentMovement.idVRE) = currentSpeed;
                end

                tacTest.trialResult(trial,rep,comb) = result;             
            end
        end        
    end
end