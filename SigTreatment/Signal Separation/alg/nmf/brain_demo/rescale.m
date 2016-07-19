function [W_new, H_new, alpha] = rescale(W,H)
% [W_new H_new ] = rescale(W,H)
% Rescales the matrices W and H from the NMF.
% Makes rows of W sum to 1, probability map.
% Signals in H are correctly scaled.
 
% 08.08.2006, Bjarni Bodvarsson (bb@imm.dtu.dk)
 
alpha = sum(W)*(W'*W)^(-1);
if min(alpha)<0
    disp('Error: negative element in alpha vector!')
end
W_new = W.*repmat(alpha,size(W,1),1);
H_new = H./repmat(alpha',1,size(H,2));
