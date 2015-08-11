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
% Function containing a nonlinear flutter rejection filter.
%
% ------------------------- Updates & Contributors ------------------------
% [Contributors are welcome to add their email]
% 2013-05-27 / Alf Bjørnar Bertnum / Creation
% 20xx-xx-xx / Author  / Comment on update


function newF = NonlinearFlutterRejectionFilter ( preF, F, handles )
newF = preF;
fgain = str2double(get(handles.et_fgain,'String'));
ftgain = str2double(get(handles.et_ftgain,'String'));

xInput = F-newF;

dimF = size(F,1);
tempF = zeros(dimF,1);
k = ftgain;

for i=1:dimF
    x = xInput(i);
    
    %% Precalculated integral of the nonlinearity
    % Nonlinearity = |x|tanh(kx)
    % Note: Mathematically, polylog(2,x) coincides with dilog(1-x).
    tempF(i) = double((norm(x)*(k*x*(k*x+2*log(exp(-2*k*x)+1))-feval(symengine, 'dilog', 1-(-exp(-2*k*x)))))/(2*k^2*x));
end

newF = tempF*fgain;

% x1 = x(1);
% x2 = x(2);
% k = ftgain;
% 
% % Note: Mathematically, polylog(2,x) coincides with dilog(1-x).
% tempF1 = double((norm(x1)*(k*x1*(k*x1+2*log(exp(-2*k*x1)+1))-feval(symengine, 'dilog', 1-(-exp(-2*k*x1)))))/(2*k^2*x1));
% tempF2 = double((norm(x2)*(k*x2*(k*x2+2*log(exp(-2*k*x2)+1))-feval(symengine, 'dilog', 1-(-exp(-2*k*x2)))))/(2*k^2*x2));
% tempF = [tempF1; tempF2];
% 
% newF = tempF*fgain;

%% Alternate methods tried for calculating nonlinear filter
% s = tf('s');
% syms s;
% newF = Nonlinearity((F-newF), ftgain)*1/s*fgain

% newF = int(Nonlinearity((x), ftgain), x)*fgain;

end