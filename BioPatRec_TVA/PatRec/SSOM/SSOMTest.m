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
% Function to classifies the testing sets.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-09-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function [outMov predictVec]=SSOMTest(patRecTrained,x)


% Check if there is any NaN value
tKnownNaN = ~isnan(x);
if ~isempty(find(tKnownNaN==0, 1))
    disp('You have NaN value in Testing sets');
    errordlg('You have NaN value in Testing sets');
    error('You have Complex number in Testing sets');
end
% Check if there is any Inf value
tKnownInf = ~isinf(x);
if ~isempty(find(tKnownInf==0, 1))
    disp('You have Inf value in Testing sets');
    errordlg('You have Inf value in Testing sets');
    error('You have Complex number in Testing sets');
end
% Check if there is any Complex number in Testing sets
tKnownComplex = ~isreal(x);
if ~isempty(find(tKnownComplex==1, 1))
    disp('You have Complex number in Testing sets');
    errordlg('You have Complex number in Testing sets');
    error('You have Complex number in Testing sets');
end


% w represent only the first columns i.e(without the output)
w=patRecTrained.SSOM.w(:,1:size(patRecTrained.SSOM.w,2)-patRecTrained.SSOM.sizeSSOMOut);
SSOMOut=patRecTrained.SSOM.SSOMOut;

% finding the winning neuron.
[i0,~ ]=FindClosest(w,x);


predictVec=SSOMOut(i0,:);
% finding the winning movement
outMov=find(round(predictVec));
end

