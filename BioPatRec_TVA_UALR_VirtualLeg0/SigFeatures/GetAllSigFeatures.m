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
% This function recieves sigTreated and returns sigFeatures which is a
% matrix of structs of (sets x movements) where each struct contains the
% signals features identfied by their name code (ID) 
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-07-27 / Max Ortiz / Creation from EMG_AQ routines
% 20xx-xx-xx / Author  / Comment on update

function sigFeatures = GetAllSigFeatures(handles, sigTreated)

    sigFeatures.sF      = sigTreated.sF;
    sigFeatures.tW      = sigTreated.tW;
    sigFeatures.nCh     = sigTreated.nCh;
    sigFeatures.mov     = sigTreated.mov;
    
    % temporal conditional to keep compatibility with olrder rec session
    if isfield(sigTreated,'dev')
        sigFeatures.dev     = sigTreated.dev;
    else
        sigFeatures.dev     = 'Unknow';
    end    
    
    sigFeatures.fFilter = sigTreated.fFilter;
    sigFeatures.sFilter = sigTreated.sFilter;
    sigFeatures.trSets  = sigTreated.trSets;
    sigFeatures.vSets   = sigTreated.vSets;
    sigFeatures.tSets   = sigTreated.tSets;

    nM = sigTreated.nM;          % Number of exercises
    
    set(handles.t_msg,'String','Extracting ALL features for training...');
    drawnow;
    for m = 1: nM
        for i = 1 : sigTreated.trSets
            trFeatures(i,m) = GetSigFeatures(sigTreated.trData(:,:,m,i),sigTreated.sF);
           
        end
    end
   
    save('checkdata.mat','trFeatures');
    set(handles.t_msg,'String','Extracting ALL features for validation...');
    drawnow;
    for m = 1: nM
        for i = 1 : sigTreated.vSets
            vFeatures(i,m) = GetSigFeatures(sigTreated.vData(:,:,m,i),sigTreated.sF);
        end
    end
    
    set(handles.t_msg,'String','Extracting ALL features for testing...');
    drawnow;
    for m = 1: nM
        for i = 1 : sigTreated.tSets
            %tFeatures(i,m) = analyze_signal(sigTreated.tData(:,:,m,i),sigTreated.sF);
            tFeatures(i,m) = GetSigFeatures(sigTreated.tData(:,:,m,i),sigTreated.sF);
        end
    end
    
    sigFeatures.trFeatures = trFeatures;    
    sigFeatures.vFeatures  = vFeatures;    
    sigFeatures.tFeatures  = tFeatures;    

end
%     for e = 1: Ne
%         for i = 1 : sigTreated.nw
%             iidx = 1 + (assize*(i-1));
%             eidx = assize+(assize*(i-1));
%             tempdata(i,e) = analyze_signal(data(iidx:eidx,:,e),sigTreated.sF);
%         end
%     end
% 
%     %trPr    = 0.6;                          % Percentage to be used for training
%     %Ntr     = round(nR * nTw * trPr);               % Compute Number of trainning for the whole contraction time
%     %Nv      = round(nR * nTw * (1-trPr)/2);         % Compute Number of validation
%     trSets  = sigTreated.trSets;
%     vSets   = sigTreated.vSets;
%     tSets   = sigTreated.tSets;
%     trdata  = tempdata(1:trSets,:);
%     vdata   = tempdata(trSets+1:trSets+vSets,:);
%     tdata   = tempdata(trSets+vSets+1:trSets+vSets+tSets,:);