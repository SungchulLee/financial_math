%% Implicit - Call

clear all; close all; clc;

figure(1)

S = 50; K = 50; T = 1; r = 0.1; v = 0.4; 

Smax = 100; Smin = 0;
NS = 10; NT = 100;
dS = (Smax-Smin)/(NS-1); dT = (T-0)/(NT-1);

C = zeros(NS,NT);
Stock = linspace(Smin,Smax,NS)';
C(1,:)  = 0;
C(NS,:) = (Stock(end)-K);
C(:,NT) = max(Stock-K,0);

a = -0.5*v^2*dT*((Smin/dS)+(1:NS-2)).^2+0.5*r*dT*((Smin/dS)+(1:NS-2));
b = 1+r*dT+v^2*dT*((Smin/dS)+(1:NS-2)).^2;
c = -0.5*v^2*dT*((Smin/dS)+(1:NS-2)).^2-0.5*r*dT*((Smin/dS)+(1:NS-2));
i = [(2:NS-2) (1:NS-2) (1:NS-3)];
j = [(1:NS-3) (1:NS-2) (2:NS-2)];
s = [a(2:NS-2) b c(1:NS-3)];
A = sparse(i,j,s);

for t=NT-1:-1:1
    d = zeros(NS-2,1); d(1) = a(1)*C(1,t); d(end) = c(end)*C(end,t);	
    C(2:end-1,t) = A\(C(2:end-1,t+1)-d);
end

x = linspace(Smin,Smax,NS)'; y = interp1(Stock, C(:,1), x);
x1 = sort([x; K]); y1 = Call(x1,K,T,r,v); y2 = max(x1-K,0);
plot(x,y,x1,y1,'-r',x1,y2,'--r'); grid on;
legend('Call by Implicit','Call by Black-Scholes')
xlabel('Stock price'); ylabel('Call price')