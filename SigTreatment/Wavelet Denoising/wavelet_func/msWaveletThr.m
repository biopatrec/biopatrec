% ---------------------------- Copyright Notice ---------------------------
% This file is part of BioPatRec © which is open and free software under 
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
% Wavelet threshold selection, adapted from WDEN & THSELECT
% (Copyright 1995-2010 The MathWorks, Inc.)
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-02-03 / Julian Maier  / Creation
% 2017-02-03 / Adam Naber    / Added approximation threshold coefficients

function [threshold, sigma] = msWaveletThr(dec,rule,scal,fac,nSample)

cA = dec.cA;
cD = dec.cD;
wLevel = dec.wLevel;
nCh = dec.sData(1);

% Compute level noise estimation.
switch scal
    case 'one' % global
        sigma = ones(nCh,wLevel+1);
    case 'sln' % first level
        sigma = median(abs(cD{1}),2)/0.6745 * ones(1,wLevel+1);
    case 'mln' % level dependent
        sigma = ones(nCh,wLevel+1);
        for k = 1:wLevel
            sigma(:,k) = median(abs(cD{k}),2)/0.6745;
        end
        sigma(:,wLevel+1) = median(abs(cA),2)/0.6745;
    case 'alcd' % ALCD-style denoising
        sigma = std(cD{1},0,2) * ones(1,wLevel+1);
end

% Compute thresholds.
threshold = zeros(nCh,wLevel);
switch rule
    case {'sqtwolog','gsmu','minimaxi'}
        switch rule
            case 'sqtwolog'
                thrINI = sqrt(2*log(nSample));
            case 'gsmu'
                thrINI = sqrt(2*log(nSample))*2^(-wLevel/2);
            case 'minimaxi'
                if nSample <= 32
                    thrINI = 0;
                else
                    thrINI = 0.3936 + 0.1829*(log(nSample)/log(2));
                end
        end
        threshold = fac*thrINI*sigma;
        
    case {'rigrsure','heursure'}
        sqEPS = sqrt(eps);
        for k = 1:wLevel
            matCFS = cD{k};
            nbCFS_LEV = size(matCFS,2);
            idxRows = ~(sigma(:,k) < sqEPS*max(abs(matCFS),[],2));
            matSIGMA = sigma(idxRows,k);
            matCFS = matCFS(idxRows,:)./matSIGMA(:,ones(1,nbCFS_LEV));
            nbROWS = size(matCFS,1);
            thrLOC = zeros(nbROWS,1);
            continu = true;
            if isequal(rule,'heursure')
                hTHR = sqrt(2*log(nbCFS_LEV));
                crit = (log(nbCFS_LEV)/log(2))^(1.5)/sqrt(nbCFS_LEV);
                eta = (sum(matCFS.*matCFS,2)-nbCFS_LEV)/nbCFS_LEV;
                idxR1 = eta < crit;
                thrLOC(idxR1) = hTHR;
                idxR2 = ~idxR1;
                continu = any(idxR2);
            end
            if continu
                repIDX = ones(1,nbROWS);
                Vn_1 = nbCFS_LEV - (2*(1:nbCFS_LEV));
                Vn_1 = Vn_1(repIDX,:);
                Vn_2 = (nbCFS_LEV-1:-1:0);
                Vn_2 = Vn_2(repIDX,:);
                sx2 = sort(abs(matCFS),2).^2;
                risks = (Vn_1 + cumsum(sx2,2) + Vn_2.*sx2)/nbCFS_LEV;
                [~,best] = min(risks,[],2);
                rigTHR = sqrt(diag(sx2(1:nbROWS,best)));
                if isequal(rule,'heursure')
                    thrLOC(idxR2) = min(rigTHR(idxR2),hTHR);
                else
                    thrLOC = rigTHR;
                end
            end
            threshold(idxRows,k) = fac*thrLOC.*sigma(idxRows,k);
        end
    case {'penal'}
        alpha = 2;  scal = 'sln';
        matCFS = msWaveletRec(dec);
        sigmaTemp = sigma(:,1);
        [nCh,n] = size(matCFS);
        sigmaTemp = sigmaTemp(:,ones(1,n)).^2;
        thresh = sort(abs(matCFS),2,'descend');
        rl2scr = cumsum(thresh.^2,2);
        xpen   = 1:n;
        xpen   = xpen(ones(nCh,1),:);
        pen    = 2*xpen.*(alpha + log(n./xpen));
        pen    = pen.*sigmaTemp;
        [~,indmin] = min(pen-rl2scr,[],2);
        thrLOC = thresh(indmin);
        for k = 1:length(indmin)
            thrLOC(k) = thresh(k,indmin(k));
        end
        threshold = fac*thrLOC(:,ones(1,wLevel));
end

end
