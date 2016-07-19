function [out eucl_dist] = run_nmf(K, alg, maxiter, norm, dataset)

%%%%%%%%%%%%%%%%%%%%%%%
% load data
%%%%%%%%%%%%%%%%%%%%%%%

addpath ../

if strcmp('email', dataset)
    load exp_data_email;
elseif strcmp('medical', dataset)
    load exp_data_med;
else
    load exp_data_cnn;
end


%%%%%%%%%%%%%%%%%%%%%%%
% normalize X
%%%%%%%%%%%%%%%%%%%%%%%

if strcmp('sqrt', norm)
    X = sqrt(X);
elseif strcmp('log', norm)
    X = sparse(log(X+1));
elseif strcmp('tfidf', norm)

    [T,D]=size(X);

    sums = diag(sparse(1./sum(X)));
    tdm  = X*sums; % tf weighting

    df   = sum(X'>0)/D;
    idf  = sparse(1./df);
    idf  = diag(log(idf));
    X    = idf*tdm;

end

%%%%%%%%%%%%%%%%%%%%%%%
% run nmf
%%%%%%%%%%%%%%%%%%%%%%%

[W H]=nmf(X,K,alg,maxiter);

%%%%%%%%%%%%%%%%%%%%
% calculate probs
%%%%%%%%%%%%%%%%%%%%

alfa = sum(W);
beta = sum(H');
q    = alfa.*beta;

W_ = W./repmat(alfa, size(W,1),1);
H_ = H./repmat(beta, size(H,2),1)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find most probable words
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maxword = 10;
for i=1:K
    [y indx]=sort(W_(:,i), 'descend');
    out{i}=words(indx(1:maxword));
end

eucl_dist=nmf_euclidean_dist(sparse(X), sparse(W*H));

