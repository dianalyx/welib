
%% Exercice
clear all;
clc;
r0=[0.30 0.50 1.00 1.50 2.00 2.50 2.60 2.70 2.80 2.90 2.95];
EI1=[500.00 468.75 390.62 312.50 234.38 167.19 151.56 137.50 121.88 107.81 100.00]*100;
EI2=[12000.00 11250.00 9375.00 7500.00 5625.00 4012.50 3637.50 3300.00  2925.00 2587.50 2400.00]*100;
m=[1.70 1.59 1.33 1.06 0.80 0.57 0.52 0.47 0.41 0.37 0.34];
beta=[21.32 14.66 7.69 5.17 3.31 1.38 0.90 0.42 -0.07 0.03 0.74];

% 
% r=fliplr(interp(fliplr(r),100));
% m=fliplr(interp(fliplr(m),100));
% beta=fliplr(interp(fliplr(beta),100));
% EI1=fliplr(interp(fliplr(EI1),100));
% EI2=fliplr(interp(fliplr(EI2),100));

r=linspace(0.3,3,20);
m=spline(r0,m,r);
beta=spline(r0,beta,r);
EI1=spline(r0,EI1,r);
EI2=spline(r0,EI2,r);
nu=0;

%%

V0=[5 8 14 20];
py0=[2.5 15 50 70];
pz0=[90 160 260 280];
beta=beta*pi/180; % now beta is in radians
n=length(r);
R=30.56;

%% Flapwise mode
step=0;
py=ones(1,n);
pz=ones(1,n)*1;
[uy1f uz1f]=fDeflectionFromLoad(py,pz,beta,nu,r,EI1,EI2);
while 1
   step=step+1;
   omega2=pz(end)/(uz1f(end)*m(end));
   sqrt(omega2);
   pz=omega2.*m.*uz1f/sqrt( uz1f(end)^2+uy1f(end)^2 );
   py=omega2.*m.*uy1f/sqrt( uz1f(end)^2+uy1f(end)^2 );
   %getting uz and uy
   [uy1f uz1f]=fDeflectionFromLoad(py,pz,beta,nu,r,EI1,EI2);
   if(abs( (pz(end)/(uz1f(end)*m(end))-omega2) / (pz(end)/(uz1f(end)*m(end)))) <0.00001)
        [sqrt(omega2) sqrt(omega2)/(2*pi) step]
        %storing first flapwise moment
        pz1f=pz;
        py1f=py;
       break
   end
%     figure(5)
%     hold on
%     plot(r,uy1f/max(abs([uy1f uz1f])),'b-+')
%     plot(r,uz1f/max(abs([uy1f uz1f])),'r-+')
end

figure(51)
hold on
plot(r,uy1f/max(abs([uy1f uz1f])),'b-+')
plot(r,uz1f/max(abs([uy1f uz1f])),'r-+')
grid
box
legend('Uy','Uz','Location','NorthWest')
xlabel('r [m]')
ylabel('Flapwise Eigenmode [arb.]')
title('1stflap')


%% Edge wise mode
step=0;
py=-ones(1,n)*pz0(2);
pz=ones(1,n)*pz0(2);
omega2=0;
while 1
   step=step+1;
   %getting uz and uy
   [uy uz]=fDeflectionFromLoad(py,pz,beta,nu,r,EI1,EI2);
   const=( trapz(r,uz1f.*m.*uz ) + trapz(r,uy1f.*m.*uy ) )/ ( trapz(r,uz1f.*m.*uz1f ) + trapz(r,uy1f.*m.*uy1f ));
   %const=0;
   uz1e=(uz-const*uz1f);
   uy1e=(uy-const*uy1f);
   verif=( trapz(r,uz1f.*m.*uz1e )+trapz(r,uy1f.*m.*uy1e ) );
   if(abs( (pz(end)/(uz1e(end)*m(end))-omega2) / (pz(end)/(uz1e(end)*m(end)))) <0.00001)
   %if(abs(pz(end)/(uz1e(end)*m(end))-omega2)<0.01 || step==100)
       [sqrt(omega2) sqrt(omega2)/(2*pi) step]
       break
   end
   omega2=pz(end)/(uz1e(end)*m(end));
   pz=omega2.*m.*uz1e/sqrt( uz1e(end)^2+uy1e(end)^2 );
   py=omega2.*m.*uy1e/sqrt( uz1e(end)^2+uy1e(end)^2 );
%     figure(6)
%     hold on
%     plot(r,uy1e/max(abs([uy1e uz1e])),'b-+')
%     plot(r,uz1e/max(abs([uy1e uz1e])),'r-+')
end  
figure(61)
hold on
plot(r,uy1e/max(abs([uy1e uz1e])),'b-+')
plot(r,uz1e/max(abs([uy1e uz1e])),'r-+')
grid
box
xlabel('r [m]')
ylabel('Edgewise Eigenmode [arb.]')
legend('Uy','Uz','Location','NorthWest')
title('1stedge')


%% Second flap wise mode
step=0;
py=ones(1,n);
pz=ones(1,n);
omega2=0;
while 1
   step=step+1;
   %getting uz and uy
   [uy uz]=fDeflectionFromLoad(py,pz,beta,nu,r,EI1,EI2);
   const2=( trapz(r,uz1e.*m.*uz ) + trapz(r,uy1e.*m.*uy ) )/ ( trapz(r,uz1e.*m.*uz1e ) + trapz(r,uy1e.*m.*uy1e ));
   const1=( trapz(r,uz1f.*m.*uz ) + trapz(r,uy1f.*m.*uy ) )/ ( trapz(r,uz1f.*m.*uz1f ) + trapz(r,uy1f.*m.*uy1f ));
   uz2f=(uz-const2*uz1e-const1*uz1f);
   uy2f=(uy-const2*uy1e-const1*uy1f);
   verif=( trapz(r,uz1e.*m.*uz2f )+trapz(r,uy1e.*m.*uy2f ) );
   if(abs( (pz(end)/(uz2f(end)*m(end))-omega2) / (pz(end)/(uz2f(end)*m(end)))) <0.00001)
   %if(abs(pz(end)/(uz2f(end)*m(end))-omega2)<0.01 || step==100)
       [sqrt(omega2) sqrt(omega2)/(2*pi) step]
       break
   end
   omega2=pz(end)/(uz2f(end)*m(end));
   pz=omega2.*m.*uz2f/sqrt( uz2f(end)^2+uy2f(end)^2 );
   py=omega2.*m.*uy2f/sqrt( uz2f(end)^2+uy2f(end)^2 );
%     figure(7)
%     hold on
%     plot(r,uy2f/max(abs([uy2f uz2f])),'b-+')
%     plot(r,uz2f/max(abs([uy2f uz2f])),'r-+')
end  
figure(71)
hold on
plot(r,uy2f/max(abs([uy2f uz2f])),'b-+')
plot(r,uz2f/max(abs([uy2f uz2f])),'r-+')
grid
box
xlabel('r [m]')
ylabel('Second Flapwise Eigenmode [arb.]')
legend('Uy','Uz','Location','NorthWest')
title('2ndflap')



%% Second edge wise mode
step=0;
py=ones(1,n);
pz=ones(1,n);
omega2=0;
while 1
   step=step+1;
   %getting uz and uy
   [uy uz]=fDeflectionFromLoad(py,pz,beta,nu,r,EI1,EI2);
   const1=( trapz(r,uz1f.*m.*uz ) + trapz(r,uy1f.*m.*uy ) )/ ( trapz(r,uz1f.*m.*uz1f ) + trapz(r,uy1f.*m.*uy1f ));
   const2=( trapz(r,uz1e.*m.*uz ) + trapz(r,uy1e.*m.*uy ) )/ ( trapz(r,uz1e.*m.*uz1e ) + trapz(r,uy1e.*m.*uy1e ));
   const3=( trapz(r,uz2f.*m.*uz ) + trapz(r,uy2f.*m.*uy ) )/ ( trapz(r,uz2f.*m.*uz2f ) + trapz(r,uy2f.*m.*uy2f ));   
   uz2e=(uz-const3*uz2f-const2*uz1e-const1*uz1f);
   uy2e=(uy-const3*uy2f-const2*uy1e-const1*uy1f);
   if(abs( (pz(end)/(uz2e(end)*m(end))-omega2) / (pz(end)/(uz2e(end)*m(end)))) <0.00001)
   %if(abs(pz(end)/(uz2e(end)*m(end))-omega2)<0.01 || step==100)
       [sqrt(omega2) sqrt(omega2)/(2*pi) step]
       break
   end
   omega2=pz(end)/(uz2e(end)*m(end));
   pz=omega2.*m.*uz2e/sqrt( uz2e(end)^2+uy2e(end)^2 );
   py=omega2.*m.*uy2e/sqrt( uz2e(end)^2+uy2e(end)^2 );
%     figure(8)
%     hold on
%     plot(r,uy2e/max(abs([uy2e uz2e])),'b-+')
%     plot(r,uz2e/max(abs([uy2e uz2e])),'r-+')
end  
figure(81)
hold on
plot(r,uy2e/max(abs([uy2e uz2e])),'b-+')
plot(r,uz2e/max(abs([uy2e uz2e])),'r-+')
ylim([min([uy2e uz2e]/max(abs([uy2e uz2e]))) 1])
grid
box
xlabel('r [m]')
ylabel('Second Edgewise Eigenmode [arb.]')
legend('Uy','Uz','Location','NorthWest')


%%
eigen1e=[uy1e uz1e];
eigen1f=[uy1f uz1f];
eigen2e=[uy2e uz2e];
eigen2f=[uy2f uz2f];
%save('Eigenmodes.',eigen1e,eigen1f,eigen2e,eigen2f,'-ASCII')

