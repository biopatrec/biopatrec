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
% The input function for the ProportionalControlTimer.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2013-05-27 / Alf Bjørnar Bertnum / Creation
% 20xx-xx-xx / Author  / Comment on update

function ProportionalControlCalculation ( featureVector, handles )

% Testing rand-function for running the proportional control without the live
% feed:
% featureVector = rand(20,1);

F = LinearMapping( featureVector, handles );
disp(F);

persistent preF;
if isempty( preF )
    preF = [0;0];
end

newF = NonlinearFlutterRejectionFilter( preF, F, handles );
preF = newF;

newF = GainThresholdAdjustments(newF, handles); % Input-format: 0/1

%% === Implement function for output-control here ===
% newF should be send to the output-control
% handles.estimatedProportionalControlOutput = newF;


end