% % ---------------------------- Copyright Notice ---------------------------
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
% This function is used as a hub to call any algorithm for feature reduction.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-08-01 / Tanuj Kumar Aluru  / Creation
% 2013-01-02 / Max Ortiz 	/ Review and corrected documentation
% 				/ All the calls are hard coded, 
%				/ see ApplyControl for further improvement.
% 20xx-xx-xx / Author  / Comment on update

function x = ApplyFeatureReduction(x, patRec)

    if strcmp(patRec.featureReduction.Alg,'PCA') 

        x = PCATest(x ,patRec.featureReduction.eigVecTrData,patRec.selFeatures);

    end
