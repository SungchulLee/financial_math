%% Risk-neutral valuation - Put

clear all; close all; clc;

S=258; K=250; T=1; r=0.03; v=0.20;

% Put option price by Black Scholes formula
Put_1=Put(S,K,T,r,v); % My function
[~,Put_2]=blsprice(S,K,r,T,v); % Matlab built-in function
fprintf('Put option price by Black Scholes formula  %g\n',Put_1)
fprintf('Put option price by Black Scholes formula  %g\n',Put_2)

M=12*21; 
t=linspace(0,T,M+1);
dt=t(2)-t(1);

% Choose a parametrization
parametrization = 3;
switch parametrization
    case 1; U=1+v*sqrt(dt); D=1-v*sqrt(dt); q_u=0.5+r*sqrt(dt)/(2*v); q_d=1-q_u; % Wilmott parametrization
    case 2; U=exp(v*sqrt(dt)); D=exp(-v*sqrt(dt)); q_u=(exp(r*dt)-D)/(U-D); q_d=1-q_u; % CRR parametrization
    case 3; U=exp((r-0.5*v^2)*dt+v*sqrt(dt)); D=exp((r-0.5*v^2)*dt-v*sqrt(dt)); q_u=0.5; q_d=1-q_u; % JR parametrization
end

% Option payoff at maturity
Stock=S*D.^((0:M)').*U.^((M:-1:0)');
V=max(K-Stock,zeros(size(Stock))); 

% Risk-neutral valuation
for i=M:-1:1
    V=exp(-r*dt)*(q_u*V(1:end-1)+q_d*V(2:end)); 
end
Put_3=V;
fprintf('Put option price by binomial model         %g\n',Put_3)

%% Matlab built-in function

[Call_Price,Put_Price]=blsprice(S,K,r,T,v)
Volatility=blsimpv(S,K,r,T,Put_Price,10,0,1e-6,0)
[Call_Delta,Put_Delta]=blsdelta(S,K,r,T,v,0)
Gamma=blsgamma(S,K,r,T,v)
[Call_Lambda,Put_Lambda]=blslambda(S,K,r,T,v,0)
[Call_Theta,Put_Theta]=blstheta(S,K,r,T,v,0)
[Call_Rho,Put_Rho]=blsrho(S,K,r,T,v,0)

%% Risk-neutral valuation - Knock-out barrier put

% Barrier
B=190; 

% Option payoff at maturity
Stock=S*D.^((0:M)').*U.^((M:-1:0)');
V=max(K-Stock,zeros(size(Stock))); 

% Risk-neutral valuation
for i=M:-1:1
    Stock=S*D.^((0:i-1)').*U.^((i-1:-1:0)');
    V=exp(-r*dt)*(q_u*V(1:end-1)+q_d*V(2:end)); 
    V(Stock<=B)=0;
end
Put_B=V;
fprintf('Barrier put option price  %g\n',Put_B)

%% Risk-neutral valuation - American put

% Option payoff at maturity
Stock=S*D.^((0:M)').*U.^((M:-1:0)');
V=max(K-Stock,zeros(size(Stock))); 

% Risk-neutral valuation
for i=M:-1:1
    Stock=S*D.^((0:i-1)').*U.^((i-1:-1:0)');
    V=exp(-r*dt)*(q_u*V(1:end-1)+q_d*V(2:end)); 
    V=max(V,K-Stock);
end
Put_A=V;
fprintf('American put option price  %g\n',Put_A)