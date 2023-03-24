% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec © which is open and free software under 
% the GNU Lesser General Public License (LGPL). See the file "LICENSE" for
% the full license governing this code and copyrights.
%
% BioPatRec was initially developed by Max J. Ortiz C. at Integrum AB and
% Chalmers University of Technology. All authors? contributions must be kept
% acknowledged below in the section "Updates % Contributors".
%
% Would you like to contribute to science and sum efforts to improve
% amputees? quality of life? Join this project! or, send your comments to:
% maxo@chalmers.se.
%
% The entire copyright notice must be kept in this or any source file
% linked to BioPatRec. This will ensure communication with all authors and
% acknowledge contributions here and in the project web page (optional).
%
% -------------------------- Function Description -------------------------
% Creates string with wavelet denoising parameters
%
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-02-03 / Julian Maier  / Creation
function name = WaveletName(s)

    if s.keepApp
        keepApp = '_keepApp';
    else
        keepApp ='_shrinkApp';
    end
    
    if s.wienerFilt
        wCF = '_wCF';
    else
        wCF = '';
    end
    
    name = [s.waveletType '_' num2str(s.waveletLevel) '_' ...
            s.waveletName '_' s.thresholdShrink '_' ...
            s.thresholdSel '_' s.thresholdSigma '_' ...
            num2str(s.thresholdFactor) wCF keepApp];
        
   %clipboard('copy',name);