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
% Multisignal 1-D wavelet decomposition: Support of DWT and SWT, adapted
% from on MDWTREC (Copyright 1995-2015 The MathWorks, Inc.).
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-02-03 / Julian Maier  / Creation

function x = msWaveletRec(dec)
% Initialization
wType = dec.wType;
wLevel = dec.wLevel;
LoR = dec.dwtFilters.LoR;
HiR = dec.dwtFilters.HiR;
cA = dec.cA;
cD = dec.cD;
sDec = dec.sDec;
dwtExtM = dec.dwtExtM;

% Iterative reconstruction
switch wType
    case 'DWT'
        x = cA;
        for j = wLevel:-1:1
            p = wLevel+2-j;
            d = cD{j};
            s = sDec(p+1,:);
            x = upsconv(x,LoR,s) + upsconv(d,HiR,s);
        end
        
    case 'SWT'
        a = cA;
        for j = wLevel:-1:1
            step = 2^(j-1);
            last = step;
            d = cD{j};
            lx = size(d,2);
            for first = 1:last
                ind = first:step:lx;
                l = length(ind);
                subind = ind(1:2:l);
                x1 = idwtFilt(a(:,subind),d(:,subind),LoR,HiR,l,0);
                subind = ind(2:2:l);
                x2 = idwtFilt(a(:,subind),d(:,subind),LoR,HiR,l,-1);
                a(:,ind) = 0.5*(x1+x2);
            end
        end
        x=a;
end

%---------------------------------------------------------------%
function y = idwtFilt(a,d,LoR,HiR,l,shift)
y = upconvSWTFilt(a,LoR,l) + upconvSWTFilt(d,HiR,l);
if shift == -1
    y = y(:,[end,1:end-1]);
end
%---------------------------------------------------------------%
function y = upconvSWTFilt(x,f,l)
lF = length(f);
y  = dyadup(x,'c',0,1);
y  = wextend('addcol','per',y,lF/2);
y  = conv2(y,f);
first = lF;
last = first+l-1;
y = y(:,first:last);

%---------------------------------------------------------------%
function y = upsconv(x,f,s)
if isempty(x)
    y = 0; 
    return; 
end

[sX1,sX2] = size(x);
sX2 = 2*sX2;
lenKept = s(2);

y = zeros(sX1,sX2-1);
y(:,1:2:end) = x;
y = conv2(y,f,'full');
sY = size(y,2);
if lenKept>sY
    lenKept = sY
end
d = (sY-lenKept)/2;
first = 1+floor(d); 
last = sY-ceil(d);
y = y(:,first:last);

%---------------------------------------------------------------%