function [SIR,variance]=perf(C,A) 
%[SIR,variance]=perf(C,A) 
% 
%  computes the distance of matrices C and A  
%  ignoring permutation and scaling of columns 
%  used to evaluate the separation error 
%  SIR = Signal to Interference Ratio   
%              x = A*s 
%    u= inv(C)*x = inv(C)*A*s = P*D*s, 
%  where P is a permutation and D is a diagonal matrix 
%  
% version 2.01, 2/14/99 by AZ 
 
%THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of GMD FIRST Berlin. 
% 
%  The purpose of this software is the dissemination of 
%  scientific work for scientific use. The commercial 
%  distribution or use of this source code is prohibited.  
%  (c) 1996-1999 GMD FIRST Berlin, Andreas Ziehe  
%              - All rights reserved - 
 
[N,N]=size(C); 
 
dummy=inv(C)*A; 
 
dummy= sum(ntu(abs(dummy)))-1; 
 
SIR=mean(dummy); 
variance=std(dummy).^2; 

