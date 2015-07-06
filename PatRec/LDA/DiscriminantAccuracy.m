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
% Function to compute the accuracy of the DA
% Test of the testing set using the coefficients found before
% currently not the faster or smatertest way to use the coeff
% needs to be improved
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2011-10-02 / Max Ortiz  / Creation
% 20xx-xx-xx / Author  / Comment on update

function acc = DiscriminantAccuracy(coeff, tSet, tOut, mov, dType)

nM   = length(mov);
good = zeros(length(tSet),1);
tIdx = 1;                %Test index used to compare results with tLables
sM   = length(tSet)/nM;  % set per movement, NOTE this is done assuming that
                         % the movements have equal amount of sets (rows)

% Run the DiscrimnantTest for each testing Set                        
for i = 1 : size(tSet,1)        
    
    [outMov outVector] = DiscriminantTest(coeff,tSet(i,:),dType);

    %Quick and dirty routine to evaluate 2 patterns
    % IF it's known that that more than two patterns are presented
    if length(find(tOut(i,:))) ~= 1 % Only one movement
        [Y, I] = sort(outVector,'descend');
        outMov = I(1:2)';
    end    

    if tOut(i,outMov) == 1      % Evaluate single movement
        good(i) = 1;
    else
        i;
    end   
    
    % for old version using labels
    %if strcmp(mov(outMov),tLables(tIdx))
    %    good(i) = 1;
    %end


end                        
                        
% Old processing rutines for testing the coeff before having DiscriminantTest funtion
% which might be slower since the "if" selecting the type is executed more
% times. This is paid for modularity
%
% Linears
%if strcmp(dType,'linear') || strcmp(dType,'diaglinear')
%     for i = 1 : length(tSet)
% 
%         tempRes = zeros(nM,nM);
%         for i = 1 : nM
%             for j = 1 : nM
%                 if i ~= j
%                     K = coeff(i,j).const;
%                     L = coeff(i,j).linear;
%                     tempRes(i,j) = K + tSet(tIdx,:)*L;      % k + f1*L1 + f2*L2 ......
%                 end
%             end
%         end
%         [maxV, m] = max(sum(tempRes,2));        
%         if strcmp(mov(m),tLables(tIdx))
%             good(i) = 1;
%         end
%         tIdx = tIdx + 1;
%     end
% Quadratrics
% elseif strcmp(dType,'quadratic') || strcmp(dType,'diagquadratic') || strcmp(dType,'mahalanobis')
% 
%     for i = 1 : length(tSet)
%         tempRes = zeros(nM,nM);
%         for i = 1 : nM
%             for j = 1 : nM
%                 if i ~= j
%                     K = coeff(i,j).const;
%                     L = coeff(i,j).linear;
%                     Q = coeff(i,j).quadratic;
%                     tempRes(i,j) = K + tSet(tIdx,:)*L + sum((tSet(tIdx,:)*Q) .* tSet(tIdx,:), 2);
%                 end
%             end
%         end
%         [maxV, m] = max(sum(tempRes,2));
%         if strcmp(mov(m),tLables(tIdx))
%             good(i) = 1;
%         end
%         tIdx = tIdx + 1;
%     end
% end

acc = zeros(nM+1,1);
for i = 1 : nM
    s = 1+((i-1)*sM);
    e = sM*i;
    acc(i) = sum(good(s:e))/sM;    
end    
acc(i+1) = sum(good) / length(tSet);
    