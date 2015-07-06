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
%  Function returns the distance between each two neighbors neuron
%  in the map which is represente the intermediate spot between thos two
%  neighbors in U-matrix.
%  Note: The implementation of this function done corresponds to SOM Toolbox
%  Team:
%  Juha Vesanto, Johan Himberg, Esa Alhoniemi, and Parhankangs
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-08-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function UDMat=CreateUDMat(w,mSize,shape)


dim=size(w,2);

y = mSize(2);
x = mSize(1);
w = reshape(w,[y x dim]);

UDMat  = zeros(2 * x - 1, 2 * y - 1);


if strcmp(shape, 'rect'), % rectangular grid
    
    for i=1:y
        for j=1:x,
            % horizontal
            if j<x,
                disHoriz = (w(i,j,:) - w(i,j+1,:)).^2; 
                UDMat(2*i-1,2*j) = sqrt(sum(disHoriz(:)));
            end
            % vertical
            if i<y,
                disVert = (w(i,j,:) - w(i+1,j,:)).^2; 
                UDMat(2*i,2*j-1) = sqrt(sum(disVert(:)));
            end
            % diagonals
            if i<y && j<x,
                disDiag1 = (w(i,j,:) - w(i+1,j+1,:)).^2; 
                disDiag2 = (w(i+1,j,:) - w(i,j+1,:)).^2;
                UDMat(2*i,2*j) = (sqrt(sum(disDiag1(:)))+sqrt(sum(disDiag2(:))))/(2 * sqrt(2));
            end
        end
    end
    
elseif strcmp(shape, 'hexa') % hexagonal grid
    
    for i=1:y,
        for j=1:x,
            % Horizantal
            if j<x,
                disHoriz  = (w(i,j,:) - w(i,j+1,:)).^2; 
                UDMat(2*i-1,2*j) = sqrt(sum(disHoriz(:)));
            end
            % Diagonal
            if i<y, 
                disDiag = (w(i,j,:) - w(i+1,j,:)).^2;
                UDMat(2*i,2*j-1) = sqrt(sum(disDiag(:)));
                
                if rem(i,2)==0 && j<x,   
                    disZ= (w(i,j,:) - w(i+1,j+1,:)).^2;
                    UDMat(2*i,2*j) = sqrt(sum(disZ(:)));
                elseif rem(i,2)==1 && j>1,
                    disZ = (w(i,j,:) - w(i+1,j-1,:)).^2;
                    UDMat(2*i,2*j-2) = sqrt(sum(disZ(:)));
                end
            end
        end
    end
    
end

