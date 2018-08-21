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
% Function outputs randomized list of target locations for Fitt's Law Test.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-11-28 / Jake Gusman  / Creation
% 20xx-xx-xx / Author  / Comment on update

function [combo, nCombo] = ComboXYR(DOFs,targetDOF)

dofs = num2str(DOFs);
switch dofs
    case '1  1  1'
        switch targetDOF
            case 3
            combo = [1,1,1;1,1,-1;1,-1,1;1,-1,-1;-1,1,1;-1,1,-1;-1,-1,1;-1,-1,-1];
            case 2
            combo = [1,1,0;1,-1,0;-1,1,0;-1,-1,0;1,0,1;1,0,-1;-1,0,1;-1,0,-1;0,1,1;0,1,-1;0,-1,1;0,-1,-1];
            case 1
            combo = [1,0,0;-1,0,0;0,1,0;0,-1,0;0,0,1;0,0,-1];
        end
    case '1  1  0'
        switch targetDOF
            case 2
                combo = [1,1,0;1,-1,0;-1,1,0;-1,-1,0];
            case 1
                combo = [1,0,0;-1,0,0;0,1,0;0,-1,0];
        end
    case '1  0  1'
        switch targetDOF
            case 2         
                combo = [1,0,1;1,0,-1;-1,0,1;-1,0,-1];
            case 1
                combo = [1,0,0;-1,0,0;0,0,1;0,0,-1];
        end
    case '0  1  1'
        switch targetDOF
            case 2
                combo = [0,1,1;0,1,-1;0,-1,1;0,-1,-1];
            case 1
                combo = [0,1,0;0,-1,0;0,0,1;0,0,-1];
        end
    case '1  0  0'
        combo = [1,0,0;-1,0,0];
    case '0  1  0'
        combo = [0,1,0;0,-1,0];
    case '0  0  1'
        combo = [0,0,1;0,0,-1];
end

%randomize target appearance
    sCombo = size(combo);
    rp = randperm(sCombo(1));
    combo = combo(rp,:);

nCombo = sCombo(1); % number of combinations

end

