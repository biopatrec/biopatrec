function [CP,U,perm]=sort_norm(C,U); 
% [CP,U,perm]=sort_norm(C,U); 
%  
% sort components in U according to their euclidian norm  
% CP is a permuted version of C, e.g. CP=C(:,perm); 
% used to fix the permutation indeterminacy of BSS 
% 
% version 2.01, 2/14/99 by AZ 
 
%THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of GMD FIRST Berlin. 
% 
%  The purpose of this software is the dissemination of 
%  scientific work for scientific use. The commercial 
%  distribution or use of this source code is prohibited.  
%  (c) 1996-1999 GMD FIRST Berlin, Andreas Ziehe  
%              - All rights reserved - 
 
if nargin ~=2 , 
   error('Usage: [C,U,perm]=sort_norm(C,U);'); 
end 
 
[N,T]=size(U); 
 
for k=1:N, 
   NN(k)=norm(U(k,:),2); 
end 
bar(NN) 
[u,perm]=sort(NN);  
perm=fliplr(perm); % sort big ones first 
 
U=U(perm,:); 
CP=C(:,perm); 