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
% Function to print the results of the TAC test
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2013-04-27 / Max Ortiz  / Created from TacTestResults to obtained the
%                           results ordered accorded to the movement id


function tacTest = TacTestResults_Ordered(tacTest)

nM = size(tacTest.trialResult,3);
% Matrix to keep track of the number of succesful trials
nSucct = zeros(1,nM);
% General matrix
for t = 1 : tacTest.trials
    for r = 1 : tacTest.nR
        for m = 1 : nM
            movIdx = tacTest.trialResult(t,r,m).movement.id;
            movements{movIdx} = tacTest.trialResult(t,r,m).name;
            selectionTime(r+(tacTest.nR*(t-1)),movIdx)  = tacTest.trialResult(t,r,m).selectionTime;
            compTime(r+(tacTest.nR*(t-1)),movIdx)       = tacTest.trialResult(t,r,m).completionTime;
            pathEfficiency(r+(tacTest.nR*(t-1)),movIdx) = tacTest.trialResult(t,r,m).pathEfficiency;
            % Check the numer of succesful trails
            if ~tacTest.trialResult(t,r,m).fail
                 nSucct(movIdx) = nSucct(movIdx) + 1;  % Number of succesful trials
            end
        end
    end
end

compRate = nSucct ./ (tacTest.nR*tacTest.trials);

%% Save results
tacTest.compRate        = compRate;
tacTest.selectionTime   = selectionTime;
tacTest.compTime        = compTime;
tacTest.pathEfficiency  = pathEfficiency;
tacTest.movements       = movements;
