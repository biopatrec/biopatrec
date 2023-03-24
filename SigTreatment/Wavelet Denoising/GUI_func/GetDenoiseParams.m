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
% Get wavelet params from GUI.
%
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-02-03 / Julian Maier  / Creation
function sigDenoise = GetDenoiseParams(handles)

    %% Get pm inputs
    waveletType                 = get(handles.pm_waveletType,'String');    
    sigDenoise.waveletTypeSel   = get(handles.pm_waveletType,'Value');  
    
    waveletName                 = get(handles.pm_waveletShape,'String');    
    sigDenoise.waveletNameSel   = get(handles.pm_waveletShape,'Value');  
    
    waveletLevel                = get(handles.pm_waveletLevel,'String');    
    sigDenoise.waveletLevelSel  = get(handles.pm_waveletLevel,'Value');
    
    waveletExtWin               = get(handles.pm_waveletExtWin,'String');    
    sigDenoise.waveletExtWinSel = get(handles.pm_waveletExtWin,'Value');
    
    thresholdShrink              = get(handles.pm_thresholdShrink,'String');    
    sigDenoise.thresholdShrinkSel = get(handles.pm_thresholdShrink,'Value'); 
    
    sigDenoise.keepApp = get(handles.cb_keepApp,'Value');
    sigDenoise.wienerFilt = get(handles.cb_wienerFilt,'Value');
    
    thresholdSel               = get(handles.pm_thresholdSel,'String');    
    sigDenoise.thresholdSelSel = get(handles.pm_thresholdSel,'Value'); 
    
    thresholdSigma               = get(handles.pm_thresholdSigma,'String');    
    sigDenoise.thresholdSigmaSel = get(handles.pm_thresholdSigma,'Value');
    
    thresholdCycSpinNo              = get(handles.pm_thresholdCycSpinNo,'String');    
    sigDenoise.thresholdCycSpinNoSel = get(handles.pm_thresholdCycSpinNo,'Value'); 
    
    
    % Save inputs to sigTreated.sigDenoise
    
    sigDenoise.waveletType  	= cell2mat(waveletType(sigDenoise.waveletTypeSel));
    
    sigDenoise.waveletName      = cell2mat(waveletName(sigDenoise.waveletNameSel));
    
    sigDenoise.waveletLevel     = str2double(waveletLevel(sigDenoise.waveletLevelSel));
    
    sigDenoise.waveletExtWin    = cell2mat(waveletExtWin(sigDenoise.waveletExtWinSel));
    
    if sigDenoise.waveletExtWinSel == 1
        sigDenoise.waveletExtLength = 0;
    else
        sigDenoise.waveletExtLength = str2double(get(handles.ed_waveletExtLength,'String'));
    end
    
    sigDenoise.thresholdShrink = cell2mat(thresholdShrink(sigDenoise.thresholdShrinkSel));
    sigDenoise.thresholdSel   = cell2mat(thresholdSel(sigDenoise.thresholdSelSel));
    
    sigDenoise.thresholdSigma  = thresholdSigma(sigDenoise.thresholdSigmaSel);
    if strcmp(sigDenoise.thresholdSigma,'LD')
        sigDenoise.thresholdSigma = 'mln';
    elseif strcmp(sigDenoise.thresholdSigma,'FL')
        sigDenoise.thresholdSigma = 'sln';
    elseif strcmp(sigDenoise.thresholdSigma,'GL')
        sigDenoise.thresholdSigma = 'one';
    elseif strcmp(sigDenoise.thresholdSigma,'ALCD')
        sigDenoise.thresholdSigma = 'alcd';
    end
    
    sigDenoise.thresholdFactor  = str2double(get(handles.ed_thresholdFactor,'String'));
    sigDenoise.thresholdCycSpin = get(handles.cb_thresholdCycSpin,'Value');
    sigDenoise.thresholdCycSpinNo = str2double(thresholdCycSpinNo(sigDenoise.thresholdCycSpinNoSel));
