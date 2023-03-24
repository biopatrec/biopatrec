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
% Multisignal 1-D wavelet shrinking.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-02-03 / Julian Maier  / Creation

function y = msWaveletShrink(x,rule,t)

% Set t to size of x
t = t(:,ones(1,size(x,2)));

switch rule
    case 'soft'
        tmp = abs(x)-t;
        tmp = (tmp + abs(tmp))/2;
        y   = sign(x).*tmp;
        
    case 'hard'
        y = x.*(abs(x)>t);
        
    case 'hyperbolic' %semi hyperbolic Liu2014 (better than SorH)
        y = sign(x).*sqrt(abs(x.^2-t.^2));
        y(abs(x)<=t) = 0;
        
    case 'adaptive' %adpative denoising Phynomark2010 (best)
        y = x-t+(2*t./(1+exp(2.1*x./t)));
        
    case 'improved' %improved denoising Phynomark2010 (2nd best)
        beta = 15*ones(size(x));
        tmp = abs(x) - beta.^(t-abs(x)) .*t;
        y = sign(x).*tmp;
        y(abs(x)<=t) = 0;
        
    case 'non-negative' %improved denoising Phynomark2010 (3rd best)
        y = x-((t.^2)./x);
        y(abs(x)<=t) = 0;
        
end
