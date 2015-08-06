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
% Initialization of BayesianFusion, sets up the weight matrix if weight
% parameters is 1.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-09 / Joel Falk-Dahlin  / Creation
% 20xx-xx-xx / Author  / Comment on update

function patRec = InitBayesianFusion(patRec)

weight = patRec.control.controlAlg.parameters.weight;
bufferSize = patRec.control.controlAlg.parameters.bufferSize;

if weight == 1
    l = 1:bufferSize;
    Z = sum( exp( -0.5/bufferSize.*l) );
    k = 10.*exp(-0.5/bufferSize.*l')./Z;
    k = flipud(k);
    k = repmat(k,1,patRec.nOuts);
else
    k = zeros(bufferSize,patRec.nOuts);
end

patRec.control.controlAlg.prop.k = k;

end