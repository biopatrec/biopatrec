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
% Function for executing linear mapping.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2013-05-27 / Alf Bjørnar Bertnum / Creation
% 20xx-xx-xx / Author  / Comment on update

function F = LinearMapping ( featureVector, handles )

estimatorType = handles.patRec.patRecTrained.training;
persistent matrixA
if isempty(matrixA)
    matrixA = rand(2,20)/rand(16,20);
end
% matrixA = handles.patRec.patRecTrained.PropCon;

%% Calculation of F
if strcmp(estimatorType, 'Normal linear estimator')
    A = matrixA;
    x = featureVector;
    F = A*x;
elseif strcmp(estimatorType, 'Decoupled linear estimator')
    A_mean = matrixA(1);
    A_std = matrixA(2);
    A_form = matrixA(3);
    x = featureVector;
    F = (A_form*x).*(A_std*x) + A_mean*x;
end

end