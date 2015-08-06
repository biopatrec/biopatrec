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
% funtion to add information about rest or no movement as an actuall
% movemen for training
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-xx-xx / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment on update


function sigTreated = AddRestAsMovement(sigTreated, recSession)

    sF      = recSession.sF;
    cT      = recSession.cT;
    rT      = recSession.rT;
    nR      = recSession.nR;
    nM      = recSession.nM;
    tdata   = recSession.tdata;
     
    % Collect the 50% to 75% of rest in between each contraction per each
    % movement
    for ex = 1 : nM
    tempdata =[];   
        for rep = 1 : nR
            % Samples of the exersice to be consider for training
            % (sF*cT*rep) Number of samples that takes a contraction
            % (sF*rT*rep) Number of samples that takes a relaxation
            is = fix((sF*cT*rep) + (sF*rT*.5) + (sF*rT*(rep-1)) + 1);
            fs = fix((sF*cT*rep) + (sF*rT*.75) + (sF*rT*(rep-1)));
            tempdata = [tempdata ; tdata(is:fs,:,ex)];
        end
        trData(:,:,ex) = tempdata;
    end
    
    % Gather the required amount of data for a movement
    % The rest data set is made with contributions from all movements rest
    % period
    totSamp = size(sigTreated.trData,1);
    sampXmov = fix(totSamp / sigTreated.nM);    
    sd = totSamp - sampXmov * sigTreated.nM;    %samples difference

%     if totSamp ~= sampXmov * sigTreated.nM;
%         disp(['"Rest" not fitted with ' num2str(sd) ' samples']);
%         errordlg(['"Rest" not fitted with ' num2str(sd) ' samples'],'Error');
%     end
    
    restData = [];
    %Using the first samples of each movement
    is = 1;
    fs = sampXmov;
    for ex = 1 : nM
        restData = [restData ; trData(is:fs,:,ex)];         
    end
    
    % If the rest data set wasn't completed from the information of all
    % rest periods, then it  willbe completed using the information from
    % the last rest period of the 1st movement
    if size(restData,1) ~= totSamp
        restData = [restData ; trData(end-sd+1:end,:,1)];
    end

    %Random selection of the sets to be use

%     trDL = size(trData,1);
%     while size(restData,1) ~= size(sigTreated.trData,1)
%         ex = fix(1 + (nM-1).*rand);
%         sOff = fix(0 + (trDL-sampXmov).*rand);
%         is = sOff + 1;
%         fs = sOff + sampXmov;
%         restData = [restData ; trData(is:fs,:,ex)];    
%     end
    
    sigTreated.nM = sigTreated.nM+1;
    sigTreated.mov(sigTreated.nM) = {'Rest'};
    sigTreated.trData(:,:,sigTreated.nM) = restData;
