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
% Function to run the Stochastic Training
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-09-01 / Ali Fouad  / Creation
% 20xx-xx-xx / Author  / Comment on update

function SSOM=SSOMStochasticTraining(trSet,SSOM,trOut)
t=SSOM.t;
% width of neighbour function.
sigmaIni=SSOM.sigmaIni;
% constant's decay of sigma
tow1=SSOM.tow1;
% learning rate parameter
etaIni=SSOM.etaIni;
% constant's decay of eta
tow2=SSOM.tow2;
%the weight matrix
w=SSOM.w;
sizeSSOMOut=SSOM.sizeSSOMOut;

% Draw random samples
p=randperm(length(trOut(:,1)));
for i=1:size(trSet,1)
    % width of neighbour function.
    sigmaT=Sigma(t,sigmaIni,tow1);
    sigmaT(sigmaT==0)=eps;
    % learning rate parameter
    eta= Eta(t,etaIni,tow2);
    %Finding the winning neuron (min euclidean distance weights matrix and input vector )
    [i0 mindist]=FindClosest(w,trSet(p(i),:));
    %Updating the weights
    w=UpdateWeights(i0,trSet(p(i),:),w,eta,sigmaT,SSOM);
    %  increase the iteration
    t=t+1;
    SSOM.t=t;
    
end

SSOMOut=w(:,end-sizeSSOMOut+1:end);
SSOM.w=w;
SSOM.SSOMOut=SSOMOut;
