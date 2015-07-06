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
% Function the slipt the information of recording sessions in different
% channels
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 20xx-xx-xx / Max Otiz / Creation
% 20xx-xx-xx / Author  / Comment on update


function [rS1 rS2] = Split_recSession_Ch(chA,chB)

    [file, path] = uigetfile('*.mat');
    if ~isequal(file, 0)
        load([path,file]);
        if exist('recSession','var')
            % Make a copy of the original recording session
            rS1 = recSession;
            rS2 = recSession;

            rS1.tdata = rS1.tdata(:,chA,:);    
            rS1.trdata = rS1.trdata(:,chA,:);
            rS1.nCh = length(chA);
            recSession = rS1;
            save([path,'\BiLong_',file],'recSession')

            rS2.tdata = rS2.tdata(:,chB,:);
            rS2.trdata = rS2.trdata(:,chB,:);
            rS2.nCh = length(chB);
            recSession = rS2;
            save([path,'\BiTrans_',file],'recSession')
          
        end
    end

