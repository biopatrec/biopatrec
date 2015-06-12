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
%
%   patRec = InitOutBuffer(patRec)
%
%       Initializes the outBuffer stored in patRec.control. This buffer can
%       be used by the control algorithms. Initialization of the buffer
%       looks if the patRec has an attached control algorithm, if that
%       control algorithm has either a parameter or a property called
%       bufferSize. If not, the outBuffer is either created to contains one
%       row and patRec.nOuts columns. If the buffer already exists it is
%       reflushed to contain only zeros.
%
%   INPUTS:
%
%       patRec - pattern recognition structure that are to be initialized
%       with an outBuffer
%
%   OUTPUTS:
%
%       patRec - new, updated patRec structure, that has an empty outBuffer
%       stored in patRec.control.outBuffer
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-10 / Joel Falk-Dahlin  / Creation

function patRec = InitOutBuffer(patRec)

% Is there a parameter bufferSize?
if isfield(patRec.control.controlAlg,'parameters')
    if isfield(patRec.control.controlAlg.parameters,'bufferSize')
        bufferSize = patRec.control.controlAlg.parameters.bufferSize;
        % Is the outBuffer already initialized?
        if isfield(patRec.control,'outBuffer')
            % Is the size of the outBuffer correct?
            if size(patRec.control.outBuffer,1) ~= bufferSize
                patRec = InitBuffer(patRec,[bufferSize, patRec.nOuts]);
            end
        % If not, initialize the outBuffer
        else
            patRec = InitBuffer(patRec,[bufferSize, patRec.nOuts]);
        end
    end
end

% Is there a property bufferSize?
if isfield(patRec.control.controlAlg,'prop')
    if isfield(patRec.control.controlAlg.prop,'bufferSize')
        bufferSize = patRec.control.controlAlg.prop.bufferSize;
        % Is the outBuffer already initialized?
        if isfield(patRec.control,'outBuffer')
            % Is the size of the outBuffer correct?
            if size(patRec.control.outBuffer,1) ~= bufferSize
                patRec = InitBuffer(patRec,[bufferSize, patRec.nOuts]);
            end            
        % If not, initialize the outBuffer
        else
            patRec = InitBuffer(patRec,[bufferSize, patRec.nOuts]);
        end
    end
end

% If bufferSize in neither a parameter of property, check if already exist
% Initialize it to be 1, if it does not exists
if ~isfield(patRec.control,'outBuffer')
    patRec = InitBuffer(patRec,[1, patRec.nOuts]);
% Reinitialize it to the same size if it already exists    
else
    bufferSize = size(patRec.control.outBuffer);
    patRec = InitBuffer(patRec,bufferSize);
end

end

function patRec = InitBuffer(patRec,bufferSize)
    patRec.control.outBuffer = zeros(bufferSize);
end