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
% ------------- Function Description -------------
% Function to obtain the corresponding movements from each raw of data in
% the sets
%
% ------------- Updates -------------
% 11-06-24 / Max Ortiz  / Creation
% 11-11-30 / Max Ortiz  / Removed tLables which are never used.

function [trLables, vLables] = GetSetsLables_Stack(mov, trOut, vOut, movIdxIndv)
%function [trLables, vLables, tLables] = GetSetsLables_Stack(mov, trOut,
%vOut, tOut, movIdxIndv)

    movIndv = mov(movIdxIndv);


    trLables = [];
    vLables  = [];
    tLables  = [];

    for i = 1 : size(trOut,1)
        trLables = [trLables;movIndv(find(trOut(i,:)))];
    end

    for i = 1 : size(vOut,1)
        vLables = [vLables;movIndv(find(vOut(i,:)))];
    end

% for i = 1 : length(tOut)
%     idxMov = find(tOut(i,:));
%     % check the number of labels involved
%     if size(idxMov,2) == 1
%         tLables = [tLables; movIndv(find(tOut(i,:)))];    
%     else
%         strLabel = [];
%         for j = 1 : size(idxMov,2)
%             strLabel = [strLabel char(movIndv(idxMov(j))) ' + '];
%         end
%         strLabel = strLabel(1:end-3); 
%         tLables = [tLables; strLabel];
%     end
% end