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
% Function to compute Traning Data according to the contraction time
% percentage (cTp)
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 20xx-xx-xx / Max Ortiz  / Creation
% 2011-07-19 / Max Ortiz  / Updated to consider cTp before and after
%                           contraction
% 20xx-xx-xx / Author  / Comment on update

function sigTreated = RemoveTransient_cTp(recSession, cTp)

    sF      = recSession.sF;
    cT      = recSession.cT;
    rT      = recSession.rT;
    nR      = recSession.nR;
    nM      = recSession.nM;
    tdata   = recSession.tdata;
    
    % New structured for the signal treated
    sigTreated      = recSession;
    sigTreated.cTp  = cTp;
    eRed            = (1-cTp)/2;    % effective reduction at the begining and at the end of contraction

    % Removed useless fields for following operations
    if isfield(sigTreated,'tdata')
        sigTreated = rmfield(sigTreated,'tdata');         
    end
    if isfield(sigTreated,'trdata')
        sigTreated = rmfield(sigTreated,'trdata');                 
    end
    
    for ex = 1 : nM
        tempdata =[];
        for rep = 1 : nR
            % Samples of the exersice to be consider for training
            % (sF*cT*(cTp-1)) Number of the samples that wont be consider for training
            % (sF*cT*rep) Number of samples that takes a contraction
            % (sF*rT*rep) Number of samples that takes a relaxation
            is = fix((sF*cT*(1-cTp-eRed)) + (sF*cT*(rep-1)) + (sF*rT*(rep-1)) + 1);
            fs = fix((sF*cT*(cTp+eRed)) + (sF*cT*(rep-1)) + (sF*rT*(rep-1)));
            tempdata = [tempdata ; tdata(is:fs,:,ex)];
        end
        trData(:,:,ex) = tempdata;
    end
    
    sigTreated.trData = trData;
end