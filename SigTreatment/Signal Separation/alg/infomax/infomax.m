function [S,A,U,ll,info]=infomax(X,K,par,debug_draw)

% icaML     : ICA by ML (Infomax) with square mixing matrix and no noise.
%
% function [S,A,U,ll,info]=icaML(X,[K],[par]) Independent component analysis (ICA) using
%                                       maximum likelihood, square mixing matrix and 
%                                       no noise [1] (Infomax). Source prior is assumed 
%                                       to be p(s)=1/pi*exp(-ln(cosh(s))). For optimization
%                                       the BFGS algorithm is used [2]. See code for 
%                                       references.
%                                       
%                                       X  : Mixed signals
%                                       K  : Number of source components.
%                                           For K=0 (default) number of sources are equal to number of
%                                           observations.
%                                           For K < number of observations, SVD is used to reduce the
%                                           dimension.
%                                       par:  Vector with 4 elements:
%                                           (1)  :  Expected length of initial step
%                                           Stopping criteria:
%                                           (2)  :  Gradient  ||g||_inf <= par(2) 
%                                           (3)  :  Parameter changes ||dW||_2  <= par(3)*(par(3) + ||W||_2)
%                                           (4)  :  Maximum number of iterations 
%                                           Any illegal element in  opts  is replaced by its
%                                           default value,  [1  1e-4*||g(x0)||_inf  1e-8  100]
%                                       debug_draw : Draw debug information
%                                       
%                                       S  : Estimated source signals with variance
%                                            scaled to one.
%                                       A  : Estimated mixing matrix
%                                       U  : Principal directions of preprocessing PCA. 
%                                            If K (the number of sources) is equal to the number
%                                            of observations then no PCA is performed and U=eye(K).  
%                                       ll : Log likelihood for estimated sources
%                                       info :  Performance information, vector with 6 elements:
%                                           (1:3)  : final values of [ll  ||g||_inf  ||dx||_2] 
%                                           (4:5)  : no. of iteration steps and evaluations of (ll,g)
%                                           (6)    : 1 means stopped by small gradient
%                                                    2 means stopped by small x-step
%                                                    3 means stopped by max number of iterations.
%                                                    4 means stopped by zero step.
%
%
%                                       Eks. Separate with number of sources equal number of
%                                       observations.
%                                       
%                                               [S,A] = icaML(X);
%                                       
%                                       Eks. Separate with number of sources equal to k, using SVD
%                                       as pre-processing.
%                                       
%                                               [S,A,U] = icaML(X,k);
%                                       
% - version 1.5 (Revised 9/9-2003)
% - IMM, Technical University of Denmark

% - version 1.4
% - by Thomas Kolenda 2002 - IMM, Technical University of Denmark

% Revised: 9/9-2003, Mads, mad@imm.dtu.dk
%   * Fixed help message to inform the user about U.
%   * Removed the automatic use of PCA in the quadratic case.

% Bibtex references:
% [1]  
%   @article{Bell95,
%       author =       "A. Bell and T.J. Sejnowski",
%       title =        "An Information-Maximization Approach to Blind Separation and Blind Deconvolution",
%       journal =      "Neural Computation",
%       year =         "1995",
%       volume =       "7",
%       pages =        "1129-1159",
%   }
%
% [2]
%   @techreport{Nielsen01:unopt,
%       author =        "H.B. Nielsen",
%       title =         "UCMINF - an Algorithm for Unconstrained, Nonlinear Optimization ",
%       institution =   "IMM, Technical University of Denmark",
%       number =        "IMM-TEC-0019",
%       year =          "2001",
%       url =           "http://www.imm.dtu.dk/pubdb/views/edoc_download.php/642/ps/imm642.ps",
%   }


% algorithm parameter settings
MaxNrIte = 1000;



try

  debug = debug_draw;

catch

  debug = 0;    

end



if debug==1,fprintf('\n** Start icaML ***************************************\n');tic;end



% Scale X to avoid numerical problems
Xorg = X;

scaleX = max([abs(max(X(:))),abs(min(X(:)))]);

X = X./scaleX;



% set number of source parameters
if nargin<2, K=size(X,1); end
if ((K>0) & (K<size(X,1))),
  [U,X] = callSVD(X,K,debug);
else
  U=eye(size(X,1));
  if debug==1,disp('Don''t use SVD');end
end

% initialize optimize parameters
try 

  ucminf_opt(1) = par(1);

  ucminf_opt(2) = par(2);

  ucminf_opt(3) = par(3);

  ucminf_opt(4) = par(4);

catch

  if debug==1,disp('Use default parameters to optimize');end

  ucminf_opt = [1  1e-4  1e-8  MaxNrIte];

end



% initialize variables
[M,N] = size(X);

W = eye(M);
%W= rand(M);


if debug==1,fprintf('Number of samples %d - Number of sources %d\n',N,M);end



% optimize
if debug==1,fprintf('Optimize ICA ... ');end

par.X=X; par.M=M; par.N=N;

[W,info] = ucminf( 'ica_MLf' , par , W(:) , ucminf_opt );

W = reshape(W,M,M); 



% estimates
A=pinv(W);

S=W*X;



if debug==1,disp('done optimize ICA!');end



% sort components according to energy
Avar=diag(A'*A)/M;

Svar=diag(S*S')/N;

vS=var(S');

sig=Avar.*Svar;

[a,indx]=sort(sig);

S=S(indx(M:-1:1),:);

A=A(:,indx(M:-1:1));



% scale back
A=A.*scaleX;



% log likelihood
if nargout>3

  ll= N*log(abs(det(inv(A)))) - sum(sum(log( cosh(S) ))) - N*M*log(pi);

end



if debug==1,fprintf('** End of icaML ****** time %0.2f sec******************\n\n',toc/60);end







function [f,dW]=ica_MLf(W,par)

% returns the negative log likelihood and its gradient w.r.t. W


X=par.X; M=par.M; N=par.N;

W=reshape(W,M,M);



S=W*X;



% negative log likelihood function
f=-( N*log(abs(det(W))) - sum(sum(log( cosh(S) ))) - N*M*log(pi) );



if nargout>1

  % gradient w.r.t. W
  dW=-(N*inv(W') - tanh(S)*X');

  dW=dW(:);

end







function [U,DV] = callSVD(X,K,draw)

% Reduce dimension with SVD


[M,N] = size(X);



if N>M % Transpose if matrix is flat, to speed up the svd and later transpose back again
    if draw==1,disp('Do Transpose SVD');end

    [V,D,U] = svd(X',0);

else;  

    if draw==1,disp('Do SVD');end

    [U,D,V] = svd(X,0);

end;

  

DV = D(1:K,1:K)*V(:,1:K)';







function  [X, info, perf, D] = ucminf(fun,par, x0, opts, D0)

%UCMINF  BFGS method for unconstrained nonlinear optimization:
% Find  xm = argmin{f(x)} , where  x  is an n-vector and the scalar
% function  F  with gradient  g  (with elements  g(i) = DF/Dx_i )
% must be given by a MATLAB function with with declaration
%           function  [F, g] = fun(x, par)
% par  holds parameters of the function.  It may be dummy.  
% 
% Call:  [X, info {, perf {, D}}] = ucminf(fun,par, x0, opts {,D0})
%
% Input parameters
% fun  :  String with the name of the function.
% par  :  Parameters of the function.  May be empty.
% x0   :  Starting guess for  x .
% opts :  Vector with 4 elements:
%         opts(1) :  Expected length of initial step
%         opts(2:4)  used in stopping criteria:
%             ||g||_inf <= opts(2)                     or 
%             ||dx||_2 <= opts(3)*(opts(3) + ||x||_2)  or
%             no. of function evaluations exceeds  opts(4) . 
%         Any illegal element in  opts  is replaced by its
%         default value,  [1  1e-4*||g(x0)||_inf  1e-8  100]
% D0   :  (optional)  If present, then approximate inverse Hessian
%         at  x0 .  Otherwise, D0 := I 
% Output parameters
% X    :  If  perf  is present, then array, holding the iterates
%         columnwise.  Otherwise, computed solution vector.
% info :  Performance information, vector with 6 elements:
%         info(1:3) = final values of [f(x)  ||g||_inf  ||dx||_2] 
%         info(4:5) = no. of iteration steps and evaluations of (F,g)
%         info(6) = 1 :  Stopped by small gradient
%                   2 :  Stopped by small x-step
%                   3 :  Stopped by  opts(4) .
%                   4 :  Stopped by zero step.
% perf :  (optional). If present, then array, holding 
%          perf(1:2,:) = values of  f(x) and ||g||_inf
%          perf(3:5,:) = Line search info:  values of  
%                        alpha, phi'(alpha), no. fct. evals. 
%          perf(6,:)   = trust region radius.
% D    :  (optional). If present, then array holding the 
%         approximate inverse Hessian at  X(:,end) .


%  Hans Bruun Nielsen,  IMM, DTU.  00.12.18 / 02.01.22


  % Check call 
  [x n F g] = check(fun,par,x0,opts);

  if  nargin > 4,  D = checkD(n,D0);  fst = 0;

  else,            D = eye(n);  fst = 1;    end

  %  Finish initialization
  k = 1;   kmax = opts(4);   neval = 1;   ng = norm(g,inf);

  Delta = opts(1);

  Trace = nargout > 2;

  if  Trace

        X = x(:)*ones(1,kmax+1);

        perf = [F; ng; zeros(3,1); Delta]*ones(1,kmax+1);

      end

  found = ng <= opts(2);      

  h = zeros(size(x));  nh = 0;

  ngs = ng * ones(1,3);

   

  while  ~found

    %  Previous values
    xp = x;   gp = g;   Fp = F;   nx = norm(x);

    ngs = [ngs(2:3) ng];

    h = D*(-g(:));   nh = norm(h);   red = 0; 

    if  nh <= opts(3)*(opts(3) + nx),  found = 2;  

    else

      if  fst | nh > Delta  % Scale to ||h|| = Delta
        h = (Delta / nh) * h;   nh = Delta;   

        fst = 0;  red = 1;

      end

      k = k+1;

      %  Line search
      [al  F  g  dval  slrat] = softline(fun,par,x,F,g, h);

      if  al < 1  % Reduce Delta
        Delta = .35 * Delta;

      elseif   red & (slrat > .7)  % Increase Delta

        Delta = 3*Delta;      

      end 

      %  Update  x, neval and ||g||
      x = x + al*h;   neval = neval + dval;  ng = norm(g,inf);

      if  Trace

             X(:,k) = x(:); 

             perf(:,k) = [F; ng; al; dot(h,g); dval; Delta]; end

      h = x - xp;   nh = norm(h);

      if  nh == 0,

        found = 4; 

      else

        y = g - gp;   yh = dot(y,h);

        if  yh > sqrt(eps) * nh * norm(y)

          %  Update  D
          v = D*y(:);   yv = dot(y,v);

          a = (1 + yv/yh)/yh;   w = (a/2)*h(:) - v/yh;

          D = D + w*h' + h*w';

        end  % update D
        %  Check stopping criteria
        thrx = opts(3)*(opts(3) + norm(x));

        if      ng <= opts(2),              found = 1;

        elseif  nh <= thrx,                 found = 2;

        elseif  neval >= kmax,              found = 3; 

%        elseif  neval > 20 & ng > 1.1*max(ngs), found = 5;
        else,   Delta = max(Delta, 2*thrx);  end

      end  

    end  % Nonzero h
  end  % iteration


  %  Set return values
  if  Trace

    X = X(:,1:k);   perf = perf(:,1:k);

  else,  X = x;  end

  info = [F  ng  nh  k-1  neval  found];



% ==========  auxiliary functions  =================================


function  [x,n, F,g, opts] = check(fun,par,x0,opts0)

% Check function call
  x = x0(:);   sx = size(x);   n = max(sx);   

  if  (min(sx) > 1)

      error('x0  should be a vector'), end

  [F g] = feval(fun,x,par);

  sf = size(F);   sg = size(g);

  if  any(sf-1) | ~isreal(F)

      error('F  should be a real valued scalar'), end

  if  (min(sg) ~= 1) | (max(sg) ~= n)

      error('g  should be a vector of the same length as  x'), end

  so = size(opts0);

  if  (min(so) ~= 1) | (max(so) < 4) | any(~isreal(opts0(1:4)))

      error('opts  should be a real valued vector of length 4'), end

  opts = opts0(1:4);   opts = opts(:).';

  i = find(opts <= 0);

  if  length(i)    % Set default values
    d = [1  1e-4*norm(g, inf)  1e-8  100];

    opts(i) = d(i);

  end   

% ----------  end of  check  ---------------------------------------


function  D = checkD(n,D0)

% Check given inverse Hessian
  D = D0;   sD = size(D);

  if  any(sD - n)

      error(sprintf('D  should be a square matrix of size %g',n)), end

  % Check symmetry
  dD = D - D';   ndD = norm(dD(:),inf);

  if  ndD > 10*eps*norm(D(:),inf)

      error('The given D0 is not symmetric'), end

  if  ndD,  D = (D + D')/2; end  % Symmetrize      
  [R p] = chol(D);

  if  p

      error('The given D0 is not positive definite'), end

    

function  [alpha,fn,gn,neval,slrat] = ...
              softline(fun,fpar, x,f,g, h)

% Soft line search:  Find  alpha = argmin_a{f(x+a*h)}
  % Default return values 
  alpha = 0;   fn = f;   gn = g;   neval = 0;  slrat = 1;

  n = length(x);  

  

  % Initial values
  dfi0 = dot(h,gn);  if  dfi0 >= 0,  return, end

  fi0 = f;    slope0 = .05*dfi0;   slopethr = .995*dfi0;

  dfia = dfi0;   stop = 0;   ok = 0;   neval = 0;   b = 1;

  

  while   ~stop

    [fib g] = feval(fun,x+b*h,fpar);  neval = neval + 1;

    dfib = dot(g,h); 

    if  b == 1, slrat = dfib/dfi0; end

    if  fib <= fi0 + slope0*b    % New lower bound
      if  dfib > abs(slopethr),  stop = 1;

      else

        alpha = b;   fn = fib;   gn = g;   dfia = dfib;  

        ok = 1;   slrat = dfib/dfi0;

        if  (neval < 5) & (b < 2) & (dfib < slopethr)

          % Augment right hand end
          b = 2*b;

        else,  stop = 1; end

      end

    else,  stop = 1; end   

  end

  

  stop = ok;  xfd = [alpha fn dfia; b fib dfib; b fib dfib];

  while   ~stop

    c = interpolate(xfd,n);

    [fic g] = feval(fun, x+c*h, fpar);   neval = neval+1;

    xfd(3,:) = [c  fic  dot(g,h)];

    if fic < fi0 + slope0*c    % New lower bound
      xfd(1,:) = xfd(3,:);   ok = 1;

      alpha = c;   fn = fic;   gn = g;  slrat = xfd(3,3)/dfi0;

    else,  xfd(2,:) = xfd(3,:);  ok = 0; end

    % Check stopping criteria
    ok = ok & abs(xfd(3,3)) <= abs(slopethr);

    stop = ok | neval >= 5 | diff(xfd(1:2,1)) <= 0;

  end  % while   
%------------  end of  softline  ------------------------------
  

function  alpha = interpolate(xfd,n);

% Minimizer of parabola given by
% xfd(1:2,1:3) = [a fi(a) fi'(a); b fi(b) dummy]


  a = xfd(1,1);   b = xfd(2,1);   d = b - a;   dfia = xfd(1,3);

  C = diff(xfd(1:2,2)) - d*dfia;

  if C >= 5*n*eps*b    % Minimizer exists
    A = a - .5*dfia*(d^2/C);

    d = 0.1*d;   alpha = min(max(a+d, A), b-d);

  else

    alpha = (a+b)/2;

  end

%------------  end of  interpolate  --------------------------
