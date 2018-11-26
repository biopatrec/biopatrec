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
% 2012-02-23 / James Austin  / Changed MovMatrix to use movement classes from
%                           pattern recognition controller (patRec.mov(1), patRec.mov(1), etc.) 
%                           instead of matching to pre-defined labels ('Open Hand', etc.),
%                           so that TrackStateSpace now works for any set of up to 6
%                           input movement classes (plus rest) chosen for the TAC test.
% 2018-11-26 / Adam Naber / Changed MovMatrix to rely directly on the number of indivicual
%                           movements themselves, rather than making any assumptions about
%                           the number of available movements.
% 20xx-xx-xx / Author  / Comment on update

function [movMatrix, movMatrixNorm] = CreateMovMatrix(patRec)

    % Placeholder value for the index of the "Rest" movement class
    restIdx = 0;
    % Find the indexes of all individual movements
    indvMovs  = find(cellfun('length',patRec.movOutIdx) == 1);
    % Calculate number of individual movements, excluding 'Rest'
    nIndvMovs = length(indvMovs)-1;
    % Calculate the number of DoFs contained in movement set
    nMovDims  = floor(nIndvMovs/2);
    % Preallocate the movement matrix
    movMatrix = zeros(length(patRec.mov),nMovDims);

    % Loop through entire movement list
    for mm = 1:length(patRec.mov)
        % Read current movements (could be individual or simultaneous)
        movNames = regexp(patRec.mov{mm}, '\W+\W', 'split');

        % Skip the "Rest" movement (all zeros)
        if strcmp(movNames{1}, 'Rest')
            restIdx = mm;
        else
            % Loop through all the individual movements in the current group
            for ii = 1:length(movNames)
                % Find the individual movement index
                movIdx = find(strcmp(movNames{ii}, patRec.mov(indvMovs)));

                % Record the DoF-wise index and direction of the movement
                dofIdx = ceil(movIdx/2);
                if mod(movIdx,2) == 0
                    dofDir = -1;
                else
                    dofDir = 1;
                end
                movMatrix(mm,dofIdx) = dofDir;
            end
        end
    end

    movMatrixNorm = movMatrix ./ sqrt(sum(movMatrix.^2,2));
    % Make sure the "Rest" norm is 0
    if restIdx > 0
        movMatrixNorm(restIdx,:) = [];
    end
end
