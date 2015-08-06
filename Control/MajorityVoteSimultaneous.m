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
%   Function that extends the use of the MajorityVote strategy by remapping
%   movements involving multiple DoFs to their corresponding movOutIdx,
%   e.g. the outMov [2 3 6]' are mapped to the index i that corresponds to
%   the same movement given by patRec.movOutIdx{i}. This way the movement
%   containing all three DoFs are stored in a single number that can fill
%   the buffer. Otherwise if one of the DoFs are misclassified the buffer
%   will need to be filled all the way for that DoF to be predicted again.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-10 / Joel Falk-Dahlin  / Creation
% 20xx-xx-xx / Author  / Comment on update

function [patRec, outMov] = MajorityVoteSimultaneous(patRec, outMov, outVec)

if ismember(patRec.nOuts,outMov) && strcmp(patRec.mov{end},'Rest')
    outMov = patRec.nOuts;
    % Reset buffer if rest is predicted
    patRec.control.outBuffer(:) = 0;
else
    % Update output buffer with the newly predicted movement
    patRec.control.outBuffer(1:end-1,:) = patRec.control.outBuffer(2:end,:);
    patRec.control.outBuffer(end,:) = zeros(1,size(patRec.control.outBuffer,2));
    patRec.control.outBuffer(end,outMov) = 1;

    % Count the occurances of the output vectors in outBuffer
    outBuffer = patRec.control.outBuffer;
    emptyRow = ( sum(outBuffer,2) == 0 ); % Remove all rows in buffer without prediction
    outBuffer(emptyRow,:) = [];
    counterMat = [];
    while ~isempty(outBuffer)
       currentMov = outBuffer(end,:);
       eqMat = bsxfun(@eq, currentMov, outBuffer);
       eqIdx = all(eqMat');

       % Remove all entries that are equal and count them
       counterMat  = [counterMat; sum(eqIdx), currentMov];
       outBuffer(eqIdx,:) = [];
    end

    % Find movement that is counted most times in buffer, if several movements
    % are counted the same ammount of times, this gives the most recent
    [~,I] = max(counterMat(:,1));
    outMovIdx = counterMat(I,2:end) > 0;
    numberVector = 1:size(outBuffer,2);
    outMov = numberVector(outMovIdx);
end
