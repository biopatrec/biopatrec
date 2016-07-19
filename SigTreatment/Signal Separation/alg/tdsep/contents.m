% TDSEP ICA tools version 2.01, 2/14/99 by AZ 
% 
% This is a simple and efficient MATLAB implementation of blind source separation. 
% Along the lines of Schuster and Molgedey [1] two (lagged) correlation matrices 
% are computed and diagonalized simultaneously using MATLAB's  general eigen-problem solver 
% (eig.m). The big problem with this approach is to determine the optimal lag value tau  
% suitable for the given data. Usually tau1=0 and tau2=1 will do, but this is strongly data dependent. 
% Therefore, as an extension we developed the TDSEP (Temporal Decorrelation) algorithm, which 
% uses _several_ correlation matrices and finds an approximate joint diagonalizer of this  
% matrix set (see Cardosos papers [2] for more details on joint diagonalization) 
% See the references below for a description of the TDSEP algorithm [3][4]. 
%  
% The package includes: 
% tdsep2.m      separate instantaneous, linear mixtures of independent 
%               sources using an eigen-decomposition of correlation matrices  
% cor2.m        compute time-delayed correlation matrices 
% ntu.m         normalize (mixing) matrix to unity (diagonal elements ==1) 
% perf.m        evaluate separation performance  
%               by comparing the _estimated_ and the _true_ mixing matrix 
% norm_it.m     normalize (mixing) matrix (column vector length =1, e.g. norm(C(:,k),2)==1)  
% sort_norm.m   sort components according to their euclidian norm 
% jdiag.m       joint diagonalization of several matrices by J.F. Cardoso 
% fischdon.mat  acoustic demo signals (speech and music, 10 sec., sample rate 8kHz) 
% sep_demo.m    test routine; run this for a demonstration of blind source separation 
% 
% 
% 
%References: 
%[1] @Article{Molgedey+Schuster:1994, 
%    author      = {L. Molgedy and H.G. Schuster}, 
%    title       = {Separation of a mixture of independent signals using 
%                   time delayed correlations}, 
%    journal     = {Physical Review Letters}, 
%    year        = {1994}, 
%    number      = {72}, 
%    pages       = {3634-3637}  
%    } 
% 
%[2] @Article{SC-siam, 
%    HTML         = "ftp://sig.enst.fr/pub/jfc/Papers/siam_note.ps.gz", 
%    author       = "Jean-Fran\c{c}ois Cardoso and Antoine Souloumiac", 
%    journal      = "{SIAM} J. Mat. Anal. Appl.", 
%    title        = "Jacobi angles for simultaneous diagonalization", 
%    pages        = "161--164", 
%    volume       = "17", 
%    number       = "1", 
%    month        = jan, 
%    year         = {1996} 
%  } 
% 
%[3] @TechReport{GMD_REP:Ziehe:1998, 
%    type         = {Technical Report}, 
%    number       = {1998-31}, 
%    title        = {Artifact Reduction in Magnetoneurography Based on 
%                    Time-Delayed Second Order Correlations}, 
%    author       =  {A. Ziehe and K.-R. M{\"u}ller and G. Nolte  
%                    and B.-M. Mackert and G. Curio} 
%    series       =  {GMD Report No. 31}, 
%    pages        =  {27}, 
%    year         =  {1998}, 
%    notes        =  {ISSN 1435-2702} 
%  } 
% 
%[4] @InProceedings{ICANN:Ziehe:1998, 
%    title        = {TDSEP - an efficient algorithm  
%                    for blind separation using time structure}, 
%    author       =  {A. Ziehe and K.-R. M{\"u}ller} 
%    booktitle    =  {ICANN'98}, 
%    address      =  {Skovde}, 
%    pages        =  {675-680}, 
%    year         =  {1998} 
% }  
% 
% 
%---------------- (c) 1996-1999 GMD FIRST Berlin, Andreas Ziehe ----------- 
%                          - All rights reserved - 
