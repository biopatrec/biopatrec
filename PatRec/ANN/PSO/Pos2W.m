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
% Function to decode the a vector of weight into the MLP
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2009-04-23 / Max Ortiz/ Creation

function ANN = Pos2W(ANN,w)

    % First layer
    ANN.w(1:ANN.nIn*ANN.nHn(1))     = w(1 : ANN.nIn*ANN.nHn(1));
    offset                          = ANN.nIn*ANN.nHn(1);
    ANN.b(1:ANN.nHn(1))             = w(offset+1 : offset + ANN.nHn(1));
    offset                          = offset + ANN.nHn(1);
    
    % Hidden Layers
    for i = 2 : length(ANN.nHn)
        tmat                                    = zeros(ANN.nHn(i-1), ANN.nHn(i));
        tmat(1:end)                             = w(offset + 1 : offset + ANN.nHn(i-1)*ANN.nHn(i));
        ANN.w(1:ANN.nHn(i-1),1:ANN.nHn(i),i)    = tmat;
        offset                                  = offset + ANN.nHn(i-1)*ANN.nHn(i);
        ANN.b(1:ANN.nHn(i), i)                  = w(offset + 1 : offset + ANN.nHn(i));
        offset                                  = offset + ANN.nHn(i);
    end

    % Last layer
    tmat                                    = zeros(ANN.nHn(end), ANN.nOn);    
    tmat(1:end)                             = w(offset + 1 : offset + ANN.nHn(end)*ANN.nOn);
    ANN.w(1:ANN.nHn(end),1:ANN.nOn,end)     = tmat;
    offset                                  = offset + ANN.nHn(end)*ANN.nOn;
    ANN.b(1:ANN.nOn,end)                    = w(offset+1 : offset + ANN.nOn);
    
