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
% This function performs Independent Coponent Analysis for Treated
% as Prprocessing using Fast Fixed Point Algorithm .
%
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2012-08-01 / Tanuj Kumar Aluru / Creation
% 20xx-xx-xx / Author  / Comment on update


function ICAUnmixMat  = ICA(data)

% Centering and PCA
allMovData=[];
for i=1:size(data,3)
 allMovData=[allMovData
      data(:,:,i)];
end

m  =  mean(allMovData)';
meanData  =  allMovData' - m*ones(1,size(allMovData,1));
variance  =  cov(meanData');
[E D]  =  eig(variance');
[Val index] =  sort(diag(D),'descend');

% Whitening

whitenData  =   (sqrt (D)^-1) * E';
dewhitenData  =  E * sqrt (D);
ProjData  =  whitenData*meanData;


%  Computing Mixing and Demixing Matrix
X = ProjData;
[vectorSize, numSamples] =  size(X);

B =  zeros(vectorSize); % Basis Vector
 
% parameters
epsilon = 0.0001; % Stopping Criterion
maxNumIterations = 1000;
myy = 1;
stroke = 0;

for l=1:vectorSize
    
    w=rand(vectorSize,1);
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
            fprintf('Stroke!');
            myy = .5*myy;
            wOld2 = wOld;
            wOld = w;
            % Optimization 
            EXGpow3 = (X * ((X' * w) .^ 3)) / numSamples;
            Beta = w' * EXGpow3;
            w = w - myy * (EXGpow3 - Beta * w) / (3 - Beta);
            
        elseif    j> maxNumIterations/2;
            %
            myy = .5*myy;
            wOld2 = wOld;
            wOld = w;
            %
            EXGpow3 = (X * ((X' * w) .^ 3)) / numSamples;
            Beta = w' * EXGpow3;
            w = w - myy * (EXGpow3 - Beta * w) / (3 - Beta);
        else
            wOld2 = wOld;
            wOld = w;
            w = (X * ((X' * w) .^ 3)) / numSamples - 3 * w;
            
        end
        w = w - B * B' * w;
        w = w/norm(w);
    end
    
    fprintf('Algoritm converged  for [%d] iterations \n',j);
    
        
    B(:, l)  =  w;
    A(:,l) = dewhitenData * w;
    W(l,:) = w' * whitenData;
    
    
end
ICAUnmixMat=W';
























