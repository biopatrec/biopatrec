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
% This function performs centering and whitening of the channels (PCA)
% 
%
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-03-01 / Julian Maier / Creation
% 20xx-xx-xx / Author  / Comment on update


function [X, W, iW, scales]  = WhitenAndCenter(X,m)

if nargin <2
	m = size(X,1);
end

 [nCh,nSamples]		= size(X);
  X			= X - mean(X,2) * ones(1,nSamples);
 [U,D] 		= eig((X*X')/nSamples)	; 
 [puiss,k]	= sort(diag(D))	;
 rangeW		= nCh-m+1:nCh			; 						% indices to the m  most significant directions
 scales		= sqrt(puiss(rangeW))		;                   % scales
 W  		= diag(1./scales)  * U(1:nCh,k(rangeW))'	;	% whitener
 iW  		= U(1:nCh,k(rangeW)) * diag(scales) 	;		% its pseudo-inverse
 X			= W*X;  
