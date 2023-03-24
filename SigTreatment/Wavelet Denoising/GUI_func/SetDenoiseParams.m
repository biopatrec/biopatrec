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
% Load selected wavelet params for GUI.
%
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-02-03 / Julian Maier  / Creation

function denoiseParams = SetDenoiseParams(wddata,denoiseParams)
%Set DenoiseParams

 if ~isempty(denoiseParams)
   set(wddata.pm_waveletType,'Value',denoiseParams.waveletTypeSel)
   if strcmp(denoiseParams.waveletType,'DWT')
      set(wddata.cb_thresholdCycSpin,'Enable','on')
   else
      set(wddata.cb_thresholdCycSpin,'Enable','off')
      set(wddata.pm_thresholdCycSpinNo,'Enable','off')
   end
   set(wddata.pm_waveletShape,'Value',denoiseParams.waveletNameSel)
   set(wddata.pm_waveletLevel,'Value',denoiseParams.waveletLevelSel)
   set(wddata.pm_waveletExtWin,'Value',denoiseParams.waveletExtWinSel)
   set(wddata.ed_waveletExtLength,'String',num2str(denoiseParams.waveletExtLength))
   if denoiseParams.waveletExtWinSel ~= 1
    set(wddata.ed_waveletExtLength,'Enable','on')
   end

   set(wddata.pm_thresholdShrink,'Value',denoiseParams.thresholdShrinkSel)
   set(wddata.cb_keepApp,'Value',denoiseParams.keepApp)
   set(wddata.cb_wienerFilt,'Value',denoiseParams.wienerFilt)
   set(wddata.pm_thresholdSel,'Value',denoiseParams.thresholdSelSel)
   set(wddata.ed_thresholdFactor,'String',num2str(denoiseParams.thresholdFactor))
   set(wddata.pm_thresholdSigma,'Value',denoiseParams.thresholdSigmaSel)
   set(wddata.pm_thresholdCycSpinNo,'Value',denoiseParams.thresholdCycSpinNoSel)
   set(wddata.cb_thresholdCycSpin,'Value',denoiseParams.thresholdCycSpin)
   if denoiseParams.thresholdCycSpin
    set(wddata.pm_thresholdCycSpinNo,'Enable','on')
   end
   
 end
end