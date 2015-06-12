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
% ------------------- Function Description ------------------
% Input: None. Hard-coded, should be dynamic.
%
% Output: combinations - The possible combinations of the inputting
% movements, with respect to the limitations in the limitMovements.def
% file.
% --------------------------Updates--------------------------
% [Contributors are welcome to add their email]
% 2012-07-30 / Nichlas Sander  / Creation of GetMovementCombination

function combinations = GetMovementCombination(num,numMovements)

if num == 1
    combinations = randperm(numMovements)';
    return;
elseif num == 2
    if numMovements < 3
        return;
    end
    combos = [1,3;1,4;2,3;2,4;];
    if numMovements > 4
        combos = [combos;
                    1,5;
                    1,6;
                    2,5;
                    2,6;
                    3,5;
                    3,6;
                    4,5;
                    4,6; ];
    end
elseif num == 3
    if numMovements < 6
        return;
    end        
    combos = [  1,3,5;
                1,3,6;
                1,4,5;
                1,4,6;
                2,3,5;
                2,3,6;
                2,4,5;
                2,4,6; ];
else

    return;
end


combinations = combos(randperm(length(combos)),:);

% fid = fopen('limitMovements.def');
% tline = fgetl(fid);
% while ischar(tline)
%     %Puts the data of tline into t
%     t = textscan(tline,'%s','delimiter',';');
%     t = t{1};
%     %These are for movements that are not to be combined with any other
%     %movements, such as rest.
%     if strcmp(t(2),'*')
%         tline = fgetl(fid);
%         continue;
%     end
%     temp = t(2);
%     temp = textscan(temp{1},'%s','delimiter',',');
%     limitMovements(t(1),2:length(temp{1})+1) = temp{1};
%     tline = fgetl(fid);
% end
% %Loop through the movements, and generate a random array.
% for j = 1:size(movOutIdx,1)
%     movement = movements(movOutIdx{j});
%     notAllowed = limitMovements(movement.idVRE,:);
%     movs = movOutIdx;
%     movs(j) = [];
%     movs(find(movs == notAllowed)) = [];
% end
% 
% combinations = zeros(length(movements),1);
% 
% fclose(fid);
end