%% ---------------------------- Copyright Notice ---------------------------
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
%
% [patRec, outMov] = ApplyControl(patRec, outMov, outVec)
%
%       Applies the control algorithm stored inside patRec.control, if no
%       controlAlg structure is created, the outMov is passed through to
%       the output.
%
% INPUTS:
%
%       outMov - is the outMov predicted by the classifier
%
%       outVec - is the probabilities of each movement predicted by the
%       classifier       
%
% OUTPUTS:
%  
%       patRec - is the updated patRec structure, the control algorithms can
%       change e.g. their own properties and the output buffer. Inorder for
%       the control algorithms to work as intended, these changes has to be
%       stored between trials.
%
%       outMov - is the movement outputted from the control algorithm, may
%       not be the same as the outMov predicted by the classifier.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-07-18 / Max Ortiz  / Creation (moved out from RealtimePatRec)
%
% 2012-10-05 / Joel Falk-Dahlin / Changing from string checking to storing
%                                 a function handle within the controlAlg
%                                 structrue. Allows a single function call
%                                 to execute all controlAlg and no extra
%                                 hard coding is needed to implement new.
%
%                                 Added outVec and handles as extra inputs
%                                 to allow for even more complex control
%                                 algorithms.
%
% 2012-10-19 / Joel Falk-Dahlin / Added outMov = 0 control.
% 2012-11-23 / Joel Falk-Dahlin  / Removed handles since speeds now are in
%                                  patRec
%
% 20xx-xx-xx / Author  / Comment on update

function [patRec, outMov] = ApplyControl(patRec, outMov, outVec)

    if isfield(patRec.control,'controlAlg')
        [patRec, outMov] = patRec.control.controlAlg.fnc(patRec, outMov, outVec);
    end

%% OLD CODE
%         if strcmp(patRec.controlAlg,'Majority vote')
%             [patRec outMov] = MajorityVote(patRec,outMov);
%         elseif strcmp(patRec.controlAlg,'Buffer output')
%             [patRec outMov] = BufferOutput(patRec,outMov);    
%         elseif strcmp(patRec.controlAlg,'Ramp')
%             
%         end
end
        