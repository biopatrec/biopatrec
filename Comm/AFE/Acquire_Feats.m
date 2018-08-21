% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec © which is open and free software under 
% the GNU Lesser General Public License (LGPL). See the file "LICENSE" for 
% the full license governing this code and copyrights.
%
% BioPatRec was initially developed by Max J. Ortiz C. at Integrum AB and 
% Chalmers University of Technology. All authors contributions must be kept
% acknowledged below in the section "Updates % Contributors". 
%
% Would you like to contribute to science and sum efforts to improve 
% amputees quality of life? Join this project! or, send your comments to:
% maxo@chalmers.se.
%
% The entire copyright notice must be kept in this or any source file 
% linked to BioPatRec. This will ensure communication with all authors and
% acknowledge contributions here and in the project web page (optional).
% ------------------- Function Description ------------------
% Function to Record Feature Extraction Sessions
%
% --------------------------Updates--------------------------
% 2016-23-12 / Adam Naber / Added on-board feature extraction support

function [cData, error] = Acquire_Feats(deviceName, obj, nCh, nSamps, nFeats)

    error = 0;
    cData = zeros(nSamps,nCh*nFeats);
    
    % Set warnings to temporarily issue error (exceptions)
    s = warning('error', 'instrument:fread:unsuccessfulRead');
    
    try
        %%%%% ALC_D %%%%%
        if strcmp(deviceName,'ALC_D')
            for sampleNr = 1:nSamps
                cData(sampleNr,:) = fread(obj,nCh*nFeats,'float32')';
            end
        end
    catch e
        error = 1;
        % Print the error message to the console
        fprintf('%s\n',getReport(e));
    end
    
    %Set warning back to normal state
    warning(s);
end
