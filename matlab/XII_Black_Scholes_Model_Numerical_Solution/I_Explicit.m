%% Explicit - Put

clear all; close all; clc;

figure(1)

S = 50; K = 50; T = 1; r = 0.1; v = 0.4;
 
Smax = 100; Smin = 0;
NS = 10; NT = 100; 
dS = (Smax-Smin)/(NS-1); dT = (T-0)/(NT-1);

P = zeros(NS,NT);
Stock = linspace(Smin,Smax,NS)';
P(1,:)  = (K-Smin);
P(NS,:) = 0;
P(:,NT) = max(K-Stock,0);

a = 0.5*v^2*dT*((Smin/dS)+(1:NS-2)).^2-0.5*r*dT*((Smin/dS)+(1:NS-2));
b = 1-r*dT-v^2*dT*((Smin/dS)+(1:NS-2)).^2;
c = 0.5*v^2*dT*((Smin/dS)+(1:NS-2)).^2+0.5*r*dT*((Smin/dS)+(1:NS-2));
i = [(1:NS-2) (1:NS-2) (1:NS-2)]; 
j = [(1:NS-2) (2:NS-1) (3:NS)]; 
s = [a b c];
A = sparse(i,j,s);

for t=NT-1:-1:1
    P(2:end-1,t) = A*P(:,t+1);
end

x = linspace(Smin,Smax,NS)'; 
y = interp1(Stock, P(:,1), x);
x1 = sort([x; K]); y1 = Put(x1,K,r,v,T); y2 = max(K-x1,0);
plot(x,y,x1,y1,'-r',x1,y2,'--r'); grid on;
legend('Put by Explicit','Put by Black-Scholes')
xlabel('Stock price'); ylabel('Put price')
