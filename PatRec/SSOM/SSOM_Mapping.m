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
% This function check if there is any NaN or Inf value in training and
% validation sets then it run the training method of SOM.
%
%
%
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-09-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update


function [out accV]=SSOM_Mapping(trSets, trOuts, vSets, vOuts, tType,algConf)
% Check if there is any NaN value in training sets
trKnownNaN = ~isnan(trSets);
if ~isempty(find(trKnownNaN==0, 1))
    disp('You have NaN value in Training sets');
    errordlg('You have NaN value in Training sets');
    error('You have NaN value in Training sets');
    
end
% Check if there is any Inf value in training sets
trKnownInf = ~isinf(trSets);
if ~isempty(find(trKnownInf==0, 1))
    disp('You have Inf value in Training sets');
    errordlg('You have Inf value in Training sets');
    error('You have Inf value in Training sets');
end
% Check if there is any Complex number in training sets
trKnownComplex = ~isreal(trSets);
if ~isempty(find(trKnownComplex==1, 1))
    disp('You have Complex number in Training sets');
    errordlg('You have Complex number in Training sets');
    error('You have Complex number in Training sets');
end
% Check if there is any NaN value in validation sets
vKnownNaN = ~isnan(vSets);
if ~isempty(find(vKnownNaN==0, 1))
    disp('You have NaN value in Validation sets');
    errordlg('You have NaN value in Validation sets');
    error('You have NaN value in Validation sets');
end
% Check if there is any Inf value in validation sets
vKnownInf = ~isinf(vSets);
if ~isempty(find(vKnownInf==0, 1))
    disp('You have Inf value in Validation sets');
    errordlg('You have Inf value in Validation sets');
    error('You have Inf value in Validation sets');
end
% Check if there is any Complex number in Validation sets
vKnownComplex = ~isreal(vSets);
if ~isempty(find(vKnownComplex==1, 1))
    disp('You have Complex number in Validation sets');
    errordlg('You have Complex number in Validation sets');
    error('You have Complex number in Validation sets');
end
% adding the lalel of training sets last columns to make it Supervised.
trSets=[trSets trOuts];

[out accV]=EvaluateSSOM(trSets, trOuts, vSets, vOuts,tType,algConf);

end


