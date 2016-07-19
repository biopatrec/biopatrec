function CN=norm_it(C) 
% CN=norm_it(C) 
% Normalize Matrix C to unity 
% 
% version 2.01, 2/14/99 by AZ 
 
% 
%THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of GMD FIRST Berlin. 
% 
%  The purpose of this software is the dissemination of 
%  scientific work for scientific use. The commercial 
%  distribution or use of this source code is prohibited.  
%  (c) 1996-1999 GMD FIRST Berlin, Andreas Ziehe  
%              - All rights reserved - 
 
[m n]=size(C); 
%if m~=n error('Matrix must be square'); 
%end; 
for t=1:n, 
 CN(:,t)=C(:,t)./norm(C(:,t),2); 
end 