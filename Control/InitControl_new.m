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
%   patRec = InitControl_new(patRec,type)
%       
%       Initializes a control algorithm onto the patRec structure. The
%       control algorithm is stored in a structure called controlAlg and is
%       placed at patRec.control.controlAlg.
%
%       The controlAlg structure contains the name of the control
%       algorithm, a funciton handle to the control algorithm script,
%       parameters set by the user and properties that are to be used only
%       by the algorithm itself.
%
%       Each control algorithm can have its own initialization script
%       setting up the properties, this should be named
%       Init'MyControlAlg' ( replace 'MyControlAlg' with the name of the
%       algorithm ).
%
%   INPUTS:
%
%       patRec - pattern recognition structure that are to be appended with
%       the controlAlg structure
%
%       type - a string with the name of any of the valid control
%       algorithms stored in \Control\ValidControlAlgs.txt
%       If type is empty or 'None', any controlAlg structure is removed
%       from the patRec
%
%   OUTPUTS:
%
%       patRec - new pattern recognition structure with controlAlg
%       structure stored inside patRec.control
%
%
%%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-05 / Joel Falk-Dahlin  / Creation
% 2012-10-08 / Joel Falk-Dahlin  / Added correct buffer setting from
                                % internal property (.prop.bufferSize) and
                                % not only from parameter
                                % (.parameter.bufferSize) allowing for
                                % different types of controlAlgs.
% 2012-10-10 / Joel Falk-Dahlin  / Added check for outBuffer before
                                % initializing it, this way the buffer can
                                % be initialized in another manor in
                                % init-file
% 20xx-xx-xx / Author  / Comment on update

function patRec = InitControl_new(patRec,type)

% Check if function is called with empty or None type
% Remove current controlAlg and return the patRec
if isempty(type) || strcmp(type,'None')    
    if isfield(patRec.control,'controlAlg')
        patRec.control = rmfield(patRec.control,'controlAlg');
    end 
    
% Else, if type is not 'None' or empty, Check if it is a valid algorithm
else
    % Read PostProcessors from file ValidControlAlg.txt
    validControlAlg = ReadValidControlAlgs;

    % Check that the inputed type is a valid controlAlg
    validTypes = [];
    for i = 1:size(validControlAlg,2)
        validTypes = [validTypes, validControlAlg{i}.name];
    end
    validatestring(type, validTypes); % Gives error if not true

    % Find desired algorithm
    desiredControlAlg = strcmp(type,validTypes);
    
    % Set patRec.controlAlg.name / .fnc / .parameters
    % Set chosen postprocessor
    patRec.control.controlAlg = validControlAlg{desiredControlAlg};

    % Remove any output buffer that may be initialized
    if isfield(patRec.control,'outBuffer')
        patRec.control = rmfield(patRec.control,'outBuffer');
    end

    % Update buffers using current parameters
    patRec = ReInitControl(patRec);

end % end "if type is None"