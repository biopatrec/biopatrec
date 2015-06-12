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
% Function to execute the discrimant analysis provided by matlab
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-06-24 / Max Ortiz  / Created
% 2011-08-01 / Max Ortiz  / Creation of the function DiscriminantTest
% 2011-10-02 / Max Ortiz  / Creation of the function DiscriminantAccuracy
% 2012-05-20 / Max Ortiz  / Move the Get_SetsLabels funtion inside this
%                           routne and deleted old commented code
% 20xx-xx-xx / Author     / Comment on update

%function [coeff accVset] = DiscriminantAnalysis(trSet, trLables, vSet, vLables, mov, dType)
function [coeff accVset] = DiscriminantAnalysis(dType, trSets, trOuts, vSets, vOuts, mov, movIdx)

% Get labels required for LDA (only LDA so far)
 [trLables, vLables] = GetSetsLables_Stack(mov, trOuts, vOuts, movIdx);
 mov = mov(movIdx);   
 if size(trLables,1) ~= size(trOuts,1)
     disp('Error obtaining the lables!!!!')
     errordlg('Error obtaining the lables!','Discriminant A.')
     return;
 end    

%Apply discriminat to vset
[class,err,POSTERIOR,logp,coeff] = classify(vSets,trSets,trLables,dType);

nM   = size(mov,1);
good = zeros(size(vSets,1),1);
sM   = size(vSets,1)/nM;  % set per movement, NOTE this is done assuming that
                         % the movements have equal amount of sets (rows)

% Run the DiscrimnantTest for each testing Set                        
for i = 1 : size(vSets,1)        
    if strcmp(class(i),vLables(i))
        good(i) = 1;
    end
end   

accVset = zeros(nM,1);
for i = 1 : nM
    s = 1+((i-1)*sM);
    e = sM*i;
    accVset(i) = sum(good(s:e))/sM;    
end    
accVset(i+1) = sum(good) / size(vSets,1);

%Compute General level of accuracy for the validation set
% good = 0;
% for i = 1 : size(vSets,1)
%     if strcmp(class(i),vLables(i))
%         good = good + 1;
%     end
% end
% accvSets = good / length(vSets);     % Accuracy on the validation set