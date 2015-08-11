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
% General function to call other filter functions if selected
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-07-27 / Max Ortiz  / Creation
% 2012-03-11 / Max Ortiz  / Added DDF Abs

function data = ApplyFilters(sigTreated, data)


    %% Frequency filters
    sF = sigTreated.sF;
    
%   disp('Frequency filtering data...');
    
    if strcmp(sigTreated.fFilter,'None')
        % Do nothing and exit if
    elseif strcmp(sigTreated.fFilter,'PLH')
        data  = BSbutterPLHarmonics(sF, data);
    elseif strcmp(sigTreated.fFilter,'BP 20-1k')
        data  = FilterBP(sF, data,20,1000);
    elseif strcmp(sigTreated.fFilter,'BP 70-1k')
        data  = FilterBP(sF, data,70,1000);
    end
    
%    disp('Frequency Filtering Done');
    
    %% Spatial filters
%    disp('Spatial filtering data...');
    
    if strcmp(sigTreated.sFilter,'None')
        % Do nothing and exit if
    elseif strcmp(sigTreated.sFilter,'SDF')
        data = SpatialFilterSDF(data);
    elseif strcmp(sigTreated.sFilter,'DDF')
        data = SpatialFilterDDF(data);
    elseif strcmp(sigTreated.sFilter,'DDF Abs')
        data = SpatialFilterDDFAbs(data);
        disp('Warning: Signals have been converted to their absulute value');
    end
    
%    disp('Spatial Filtering Done');
  

end