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
% from on MDWTDEC (Copyright 1995-2015 The MathWorks, Inc.).
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2016-02-03 / Julian Maier  / Creation

function dec = msWaveletDec(wType,sig,wLevel,wName)

% Transpose x if necessary
if size(sig,1) > size(sig,2)
    sig = sig';
end

% Set extension mode
dwtExtM = 'per';

% Initialization
firstCol = 2;
sData = size(sig);
sDec = zeros(wLevel+2,2);
sDec(end,:) = size(sig);
cD = cell(1,wLevel);
evenoddVal = 0;
evenLen    = 1;

% Get DWT filters
[LoD,HiD,LoR,HiR] = wfilters(wName);

% Iterative decomposition
switch wType
    case 'DWT'
        for j = wLevel+1:-1:2
            [sig,d] = dwtFilt(sig,LoD,HiD,dwtExtM,firstCol);
            cD{wLevel+2-j} = d;
            sDec(j,:) = size(d);
        end
        sDec(1,:) = size(d);
        cA = sig;
        
    case 'SWT'
        lo = LoD;
        hi = HiD;
        for j = wLevel+1:-1:2
            [cA,d] = swtFilt(sig,lo,hi,dwtExtM);
            cD{wLevel+2-j} = d;
            lo = dyadup(lo,evenoddVal,evenLen);
            hi = dyadup(hi,evenoddVal,evenLen);
            sig = cA;
            sDec(j,:) = size(d);
        end
        sDec(1,:) = size(d);
end

% Output struct
Filters = struct('LoD',LoD,'HiD',HiD,'LoR',LoR,'HiR',HiR);
dec = struct(...
    'wType',wType,'wLevel',wLevel,          ...
    'wName',wName,'dwtFilters',Filters,   ...
    'dwtExtM',dwtExtM,'sData',sData,...
    'sDec',sDec,'cA',cA,'cD',{cD} ...
    );

%---------------------------------------------------------------%
function [a,d] = dwtFilt(x,LoD,HiD,dwtExtM,firstCol)
% Compute sizes
lf = length(LoD);
lx = size(x,2);

% Extend, decompose &  extract coefficients
dCol = lf-1;
lExt = lf-1; 
lKept = lx+lf-1;      
   
idxCol = (firstCol + dCol : 2 : lKept + dCol);
y = wextend('addcol',dwtExtM,x,lExt);
a = conv2(y,LoD,'full');
a = a(:,idxCol);
d = conv2(y,HiD,'full');
d = d(:,idxCol);

%---------------------------------------------------------------%
function [a,d] = swtFilt(x,LoD,HiD,dwtExtM)
% Compute sizes.
lf = length(LoD);
lx = size(x,2);

% Extend, decompose &  extract coefficients
y = wextend('addcol',dwtExtM,x,lf/2);
a = conv2(y,LoD,'full');
d = conv2(y,HiD,'full');

first = lf+1; 
last = first+lx-1;
a = a(:,first:last);
d = d(:,first:last);

%---------------------------------------------------------------%