%% blsprice, blsimpv, blsdelta, blsgamma, blslambda, blstheta, blsrho   

clear all; close all; clc;

S=258; K=250; T=1; r=0.03; v=0.20;

% Put option price by Black Scholes formula
Put_1=Put(S,K,T,r,v); % My function
[~,Put_2]=blsprice(S,K,r,T,v); % Matlab built-in function
fprintf('Put option price by Black Scholes formula  %g\n',Put_1)
fprintf('Put option price by Black Scholes formula  %g\n',Put_2)

% Matlab built-in function
[Call_Price,Put_Price]=blsprice(S,K,r,T,v)
Volatility=blsimpv(S,K,r,T,Put_Price,10,0,1e-6,0)
[Call_Delta,Put_Delta]=blsdelta(S,K,r,T,v,0)
Gamma=blsgamma(S,K,r,T,v)
[Call_Lambda,Put_Lambda]=blslambda(S,K,r,T,v,0)
[Call_Theta,Put_Theta]=blstheta(S,K,r,T,v,0)
[Call_Rho,Put_Rho]=blsrho(S,K,r,T,v,0)