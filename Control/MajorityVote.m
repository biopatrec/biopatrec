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
% Funtion to compute the Majority voting control strategy. It looks at the
% latest prediction and extracts the most common
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-06-07 / Max Ortiz  / Creation
% 2012-10-05 / Joel Falk-Dahlin  / Added input and output arguments to
%                                  match controlAlg standard. Added find
%                                  function so outMov can be several
%                                  outputs if there is equal ammount of
%                                  predictions for two movements
%                                  (simultaneous control)
% 20xx-xx-xx / Author  / Comment on update

function [patRec, outMov] = MajorityVote(patRec, outMov, outVec)

% Remove the oldest prediction
patRec.control.outBuffer = patRec.control.outBuffer(2:end,:);
% Add the new prediction
patRec.control.outBuffer(end+1,outMov') = 1;

%% Compute output
% Not suitable for simltaneous control
outMax = max(sum(patRec.control.outBuffer));
outMov = find(sum(patRec.control.outBuffer) == outMax )';