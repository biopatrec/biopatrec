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
% Selection of different Source Separation Algorithms with input data:
% [nCh x nSample]
%
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-08-03 / Julian Maier / Creation
% 20xx-xx-xx / Author  / Comment on update
function [dataSep, W, A] = ComputeSigSep(data,alg,sF,dim)

if nargin <= 3
	dim = size(data,1); 
end

switch alg
    
    case 'PCA'
        [dataSep, W, A, ~]  = WhitenAndCenter(data,dim);
      
    case 'FastICA'
        [dataSep, A, W]  =  fastica(data,'numOfIC',dim,'stabilization','on');

    case 'TDSEP'
        A = tdsep2(data,[0:1]);
        W = pinv(A);
        dataSep = W * data;
        
    case 'JADE'
        W =jader(data,dim);
        A = pinv(W);
        dataSep = W * data;
        
    case 'Infomax'
        data = WhitenAndCenter(data);
        [dataSep,A]=infomax(data,dim);
        W = pinv(A);
        
    case 'SOBI'
        [A, dataSep] = sobi(data,dim,30);
        W = pinv(A);
        
    case 'NNMF'
        k = size(data,1);
        opt = statset('MaxIter',10,'Display','off');
        [W,dataSep] = nnmf(data,k,'replicates',5,'options',opt,'algorithm','mult');
        A = pinv(W);
        
    case 'CCA' 
        [dataSep,W] = ccabss(data);
        A = pinv(W);
end
