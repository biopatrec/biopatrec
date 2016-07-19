function [C,D]=tdsep2(x,sel) 
%blind separation using approximate joint diagonalization of 
%time delayed correlation-matrices 
% 
%version 2.01, 2/14/99 by AZ 
%usage: [C,D]=tdsep2(x,sel); 
% input   x     data matrix  
%         sel   array of integer time lag values, default sel=[0:1] 
% output  C     estimated mixing matrix 
%         D     set of aproximate diagonal matrices 
% 
 
%THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of GMD FIRST Berlin. 
% 
%  The purpose of this software is the dissemination of 
%  scientific work for scientific use. The commercial 
%  distribution or use of this source code is prohibited.  
%  (c) 1996-1999 GMD FIRST Berlin, Andreas Ziehe  
%              - All rights reserved - 
 
 
if nargin<2, 
  sel=[0 1]; 
end   
 
% whitening or sphering 
M0=cor2(x',sel(1)); 
 
SPH=inv(sqrtm(M0)); 
spx=SPH*x; 
[p,q]=size(M0); 
 
 
N=length(sel); 
 
% for two matrices, solve directly as general eigenvalue problem 
if N==2, 
     M1=cor2(spx',sel(2)); 
  [Q,D]=eig(M1); 
      C=inv(SPH)*Q; 
 else 
 
t=1;          % compute correlation matrices 
for tau=1:N, 
  M(:,t*p+1:((t+1)*p))=cor2(spx',sel(tau)); 
  t=t+1; 
end 
% joint diagonalization 
[Q,D]=jdiag(M,0.00000001); 
% compute mixing matrix 
C=inv(SPH)*Q; 
end 
 