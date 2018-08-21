function [] = changeFolderToMyoDLL()
%% Function finds the Folder where BPR is stored and cuts the Path by the filename
 BPR_Path = which('BioPatRec.m'); %find location of BPR and cut the path to the folder
 BPR_cut = 0;
 leng_BPR_Path = length(BPR_Path);
 
 while ~BPR_cut %cut the Path to the folder
     if BPR_Path(leng_BPR_Path) ~= '\'
         BPR_Path(leng_BPR_Path) = [];
         leng_BPR_Path = leng_BPR_Path - 1;
     else
         BPR_Path(leng_BPR_Path) = [];
         BPR_cut = 1;
     end
 end
 
 cd (BPR_Path)

 %% Changes to The Folder where the DLL is stored
 
 cd comm/Myoband
end

