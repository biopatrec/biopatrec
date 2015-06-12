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
% Function to randomize the order of the validation data
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 20xx-xx-xx / Max Ortiz  / creation
% 2009-07-21 / Max Ortiz  / Change to use the treated_data struct

function treated_data = rand_TrainingData(treated_data)

temp(1:treated_data.trN,:) = treated_data.trdata;
temp(treated_data.trN+1:treated_data.trN+treated_data.vN,:) = treated_data.vdata;
temp(treated_data.trN+treated_data.vN+1:treated_data.trN+treated_data.vN+treated_data.tN,:) = treated_data.tdata;

temp2 = temp;

for i = 1 : size(temp,1)
    j = round(1 + rand * (size(temp,1)-1));
    temp(i,:) = temp2(j,:);
    temp(j,:) = temp2(i,:);
    temp2 = temp;
end

treated_data.trdata = temp(1:treated_data.trN,:);
treated_data.vdata  = temp(treated_data.trN+1:treated_data.trN+treated_data.vN,:);
treated_data.tdata  = temp(treated_data.trN+treated_data.vN+1:treated_data.trN+treated_data.vN+treated_data.tN,:);
