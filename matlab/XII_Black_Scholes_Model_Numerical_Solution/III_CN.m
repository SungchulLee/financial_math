%% CN - Barrier put

clear all; close all; clc;

figure(1)

S=50; K=50; T=1; r=0.1; v=0.4; 

Smin=20; Smax=100; NS=80; NT=100; dS=(Smax-Smin)/(NS-1); dT=(T-0)/(NT-1);

P=zeros(NS,NT);
Stock=linspace(Smin,Smax,NS)';
P(1,:)=0; P(NS,:)=0; P(:,NT)=max(K-Stock,0);

a=-0.25*v^2*dT*((Smin/dS)+(1:NS-2)).*2+0.25*r*dT*((Smin/dS)+(1:NS-2));
b=1+0.5*r*dT+0.5*v^2*dT*((Smin/dS)+(1:NS-2)).*2;
c=-0.25*v^2*dT*((Smin/dS)+(1:NS-2)).*2-0.25*r*dT*((Smin/dS)+(1:NS-2));
a_plus=-a; b_plus=1-0.5*r*dT-0.5*v^2*dT*((Smin/dS)+(1:NS-2)).*2; c_plus=-c; 
i=[(2:NS-2) (1:NS-2) (1:NS-3)];
j=[(1:NS-3) (1:NS-2) (2:NS-2)];
s=[a(2:NS-2) b c(1:NS-3)];
s_plus=[a_plus(2:NS-2) b_plus c_plus(1:NS-3)];
A=sparse(i,j,s);
A_plus=sparse(i,j,s_plus);

for t=NT-1:-1:1
    d1=zeros(NS-2,1); d1(1)=a_plus(1)*P(1,t+1); d1(end)=c_plus(end)*P(end,t+1);
    d2=zeros(NS-2,1); d2(1)=a(1)*P(1,t); d2(end)=c(end)*P(end,t);
    P(2:end-1,t)=A\(A_plus*P(2:end-1,t+1)+d1-d2);
end
 
x=linspace(Smin,Smax,NS)'; y=interp1(Stock, P(:,1), x);
x1=sort([x; K]); y2=max(K-x1,0);
plot(x,y,x1,y2,'--r'); legend('Barrier put by CN')
xlabel('Stock price'); ylabel('Barrier put price')