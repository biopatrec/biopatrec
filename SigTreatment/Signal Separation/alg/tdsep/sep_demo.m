%  THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of GMD FIRST Berlin. 
% 
%  The purpose of this software is the dissemination of 
%  scientific work for scientific use. The commercial 
%  distribution or use of this source code is prohibited.  
%  (c) 1996-1999 GMD FIRST Berlin, Andreas Ziehe  
%              - All rights reserved - 
% 
%  version 2.01, 2/14/99 by AZ 
% 
%  simple blind source separation demo  
%  type sep_demo to run 
 
disp(' *** blind source separation demo *** '); 
close all 
% define ica data --------------------------------------------- 
 FS=4000; 
 wnd=1:1000-1; 
 t = 0:1./FS:1 ; 
 echo on 
 s=zeros(2,length(t)) ; 
 s(1,:) = sin(2*pi*55*t); 
 s(2,:) = cos(2*pi* 100* t);    % source signals 
 %load source signals 
 %   load fischdon.mat 
 %% uncomment to load acoustic sample signals   
  
 %A=rand(2); 
 A = [1 0.85 ; 0.55 1 ] ;       % mixing matrix 
 x = A * s ;           % generate linear, instantaneous mixture 
 echo off 
% plot source signals   
figure(1) 
clf 
subplot(211) 
plot(t(wnd),s(1,wnd)) 
ylabel('src_1') 
subplot(212) 
plot(t(wnd),s(2,wnd)) 
ylabel('src_2') 
set(gcf,'Position',[50   400   300   150]) 
 
% plot mixed signals 
figure(2) 
clf 
subplot(211) 
plot(t(wnd),x(1,wnd)) 
ylabel('mix_1') 
 
subplot(212) 
plot(t(wnd),x(2,wnd)) 
ylabel('mix_2') 
 
set(gcf,'Position',[450   400   300   150]) 
 
% BEGIN  -------------------------------------------------  
 
fprintf(1,'keep on separating ..\n') 
C=tdsep2(x,[0:3]); 
 
fprintf(1,'Press any key to show results ..') 
pause; 
 
unmix = inv(C) * x  ;  
 
%normalized estimated mixing matrix 
mixing_mat=ntu(C) 
 
%performance evaluation (zero means perfect separation)  
separation_error=perf(C,A) 
% plot unmixed signals  
% should recover the source signals up to permutation and scaling 
 
%% uncomment to listen to the mixed and unmixed signals 
% soundsc(x(1,:)) 
% soundsc(x(2,:)) 
%  
% soundsc(unmix(1,:)) 
% soundsc(unmix(2,:)) 
 
figure(3) 
subplot(211) 
set(gcf,'Position',[250   200   300   150]) 
plot(t(wnd),unmix(1,wnd)) 
ylabel('unmix_1') 
 
 
subplot(212) 
plot(t(wnd),unmix(2,wnd)) 
ylabel('unmix_2') 
 
 
figure(1) 
subplot(211) 
hold on 
plot(t(wnd),unmix(1,wnd),'r') 
subplot(212) 
hold on 
plot(t(wnd),unmix(2,wnd),'r') 
 
 
% TERMINATE  -----------------------------------------------  
