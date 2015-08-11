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
% Function used by the StateSpaceTracker, creates a matrix that corresponds
% to the different movements trained in the patRec.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-11-23 / Joel Falk-Dahlin  / Creation
% 20xx-xx-xx / Author  / Comment on update

function [movMatrix, movMatrixNorm] = CreateMovMatrix(patRec)

    %indMovIdx = patRec.indMovIdx; % Read movement indexes
    %movMatrix = zeros(length(indMovIdx),3); % Preset movMatrix for speed
    
    %for i = 1:length(indMovIdx) % Loop through all output movement patRec has
    k = 1;
    for i = patRec.indMovIdx
        
        %moves = regexp(patRec.mov{indMovIdx(i)},'\W+\W','split'); % Read current movement (could be individual or simultaneous)
        moves = regexp(patRec.mov{i},'\W+\W','split'); % Read current movement (could be individual or simultaneous)
        
        outMovTmp = [];
        
        for j = 1:length(moves) % Loop through all movement that current output is (1 if individual several if simultaneous)

            if strcmp(moves{j},'Open Hand') % If read movement is Open hand, map to 1
                outMovTmp = [outMovTmp; 1];
            end

            if strcmp(moves{j},'Close Hand') % If read movement is Close Hand, map to 2
                outMovTmp = [outMovTmp; 2];
            end

            if strcmp(moves{j},'Flex Hand') % If read movement is Flex Hand, map to 3
                outMovTmp = [outMovTmp; 3];
            end

            if strcmp(moves{j},'Extend Hand') % If read movement is Extend Hand, map to 4
                outMovTmp = [outMovTmp; 4];
            end

            if strcmp(moves{j},'Pronation') % If read movement is Pronation, map to 5
                outMovTmp = [outMovTmp; 5];
            end

            if strcmp(moves{j},'Supination') % If read movement is Supination, map to 6
                outMovTmp = [outMovTmp; 6];
            end

            if strcmp(moves{j},'Rest') % If read movement is Rest, map to 7
                outMovTmp = [outMovTmp; 7];
            end
            
        end
        
        movement = [0,0,0];
        
        for j = 1:length(outMovTmp)
   
            switch outMovTmp(j)
                case 1 % Open Hand
                    dim = 1;
                    dir = 1;
                case 2 % Close Hand
                    dim = 1;
                    dir = -1;
                case 3 % Flex Hand
                    dim = 2;
                    dir = 1;
                case 4 % Extend Hand
                    dim = 2;
                    dir = -1;
                case 5 % Pronation
                    dim = 3;
                    dir = 1;
                case 6 % Supination
                    dim = 3;
                    dir = -1;
                case 7
                    dim = [];
                    dir = 0;
            end
            
            movement(dim) = movement(dim) + dir;
        
        end
        
        movMatrix(k,:) = movement;
        k = k+1;
        
    end
    
    movMatrixNorm = movMatrix(1:end-1,:) ./ repmat(  sqrt( diag(movMatrix(1:end-1,:)*movMatrix(1:end-1,:)') ), [1,3] ) ;

