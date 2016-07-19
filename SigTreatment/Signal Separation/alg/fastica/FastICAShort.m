% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec ? which is open and free software under
% the GNU Lesser General Public License (LGPL). See the file "LICENSE" for
% the full license governing this code and copyrights.
%
% BioPatRec was initially developed by Max J. Ortiz C. at Integrum AB and
% Chalmers University of Technology. All authors? contributions must be kept
% acknowledged below in the section "Updates % Contributors".
%
% Would you like to contribute to science and sum efforts to improve
% amputees? quality of life? Join this project! or, send your comments to:
% maxo@chalmers.se.
%
% The entire copyright notice must be kept in this or any source file
% linked to BioPatRec. This will ensure communication with all authors and
% acknowledge contributions here and in the project web page (optional).
%
% -------------------------- Function Description -------------------------
% This function performs Independent Coponent Analysis
% using Fast Fixed Point Algorithm (fastICA).
%
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-04-22 / Julian Maier / Creation
% 20xx-xx-xx / Author  / Comment on update


function [dataSep,W,A]  = FastICAShort(X,dim)

% Whiten and Center
[X, whitener, dewhitener, ~]  = WhitenAndCenter(X,dim);

%  Computing Mixing and Demixing Matrix
[nCh, nSamples] =  size(X);

B =  zeros(nCh); % Basis Vector
 
% parameters
epsilon = 1e-4; % Stopping Criterion
maxNumIterations = 1e3;
myy = 1;
stroke = 0;

for iCh=1:nCh
    
    w=rand(nCh,1);
    w = w - B * B' * w;
    w = w / norm(w);
    wOld = zeros(size(w));
    wOld2 = zeros(size(w));
    
    %   This Hyvarinen's fixed point algorithm from FASTICA Matlab Package.
    for j=1:maxNumIterations
        
        if  norm(w-wOld)< epsilon | norm(w+wOld)< epsilon
            
             break
	  
        elseif   (~stroke)& norm(w-wOld2)<epsilon | norm(w+wOld2)< epsilon
            stroke = myy;
            myy = .5*myy;
            wOld2 = wOld;
            wOld = w;
            % Optimization 
            EXGpow3 = (X * ((X' * w) .^ 3)) / nSamples;
            Beta = w' * EXGpow3;
            w = w - myy * (EXGpow3 - Beta * w) / (3 - Beta);
            
        elseif    j> maxNumIterations/2;
            %
            myy = .5*myy;
            wOld2 = wOld;
            wOld = w;
            %
            EXGpow3 = (X * ((X' * w) .^ 3)) / nSamples;
            Beta = w' * EXGpow3;
            w = w - myy * (EXGpow3 - Beta * w) / (3 - Beta);
        else
            wOld2 = wOld;
            wOld = w;
            w = (X * ((X' * w) .^ 3)) / nSamples - 3 * w;
            
        end
        w = w - B * B' * w;
        w = w/norm(w);
    end

    B(:,iCh)  =  w;
    W(iCh,:) = w' * whitener;
  
end
A = pinv(W);
dataSep = W * X;
