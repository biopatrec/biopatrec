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
% Function to scale the data in a recording session (recSession)
% to integers as adquired by the ADC using 2^(n-1) n=bits
% (n-1) is used because one bit is required by the sign (+ or -)
% n (bits) =  8,   10,   12,   14,    16     
% 2^n      = 256, 1024, 4096, 16384, 32768   
% 2^(n-1)  = 128,  256, 1024,  4096, 16384   
%
% Given the signal x, make values of x fall on the interval [a,b]
% x_scaled = (x-min(x))*(b-a)/(max(x)-min(x)) + a;
%
% input:    recSession (struct)
%           scalingBits = number of bits to be fitted
% output:   recSession (struct)
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2014-12-28 / Max Ortiz  / Creation 
% 20xx-xx-xx / Author     / Comment on update

function recSession = Scale_recSession(recSession, scalingBits)

if scalingBits == 8
    a = 128;
elseif scalingBits == 10
    a = 256;
elseif scalingBits == 12
    a = 1024;
elseif scalingBits == 14
    a = 4096;
elseif scalingBits == 16
    a = 16384;
else
    errordlg('Scaling failed','Error');
    return;
end        
b = a;
a = a * -1;

% Range of the original aquisition
minX = -5;
maxX = 5;

% Scale
for i=1:length(recSession.tdata(1,1,:))
    recSession.tdata(:,:,i) = round((recSession.tdata(:,:,i) - minX) .* (b-a) ./ (maxX-minX) + a);
end


