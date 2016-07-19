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
% This Function Performs Independent component analysis for Training
% Validation and testing.
% CAVE: Normal: s = W * x  with s = [nCh x nSample]
% HERE:  s' = x' * W', therefore W was transposed in the TreatData function.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-10-20 / Tanuj Kumar Aluru  / Creation
% 2014-04-01 / Julian Maier  / Changed variable names and comment about
% W transpose!

function [trData,vData,tData]=ICAPreprocess(sigTreated,trData,vData,tData)

W = sigTreated.sigSeparation.W;

% Projecting ICA Unmixing Matrix on Training Sets
for i=1:size(trData,3)
    for j=1:size(trData,4)
        tempTrData(:,:,i,j)= trData(:,:,i,j)*W;      
    end
end

% Projecting ICA Unmixing Matrix on Validation Sets
for i=1:size(vData,3)
    for j=1:size(vData,4)
        tempVData(:,:,i,j)= vData(:,:,i,j)*W;        
    end
end

% Projecting ICA Unmixing Matrix on Testing Sets
for i=1:size(tData,3)
    for j=1:size(tData,4)
        tempTData(:,:,i,j)= tData(:,:,i,j)*W;        
    end
end

trData=tempTrData;
vData=tempVData;
tData=tempTData;

