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
% ------------------- Function Description ------------------
%
% Reads the file features.def and loads the data into motor objects.
%
% --------------------------Updates--------------------------
% 2012-07-18 / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment on update

function fID = LoadFeaturesIDs

fileid = fopen('features.def');
tline = fgetl(fileid);
i=1;
fID = {};
while ischar(tline) && ~isempty(tline)
    t = textscan(tline,'%s');
    t = t{1};
    fID(i) = t(1);
    %disp(t{1});
    tline = fgetl(fileid);
    i=i+1;
end

fID = fID'; % It made a vector to keep compatibility with the rest of BioPatRec

fclose(fileid);


