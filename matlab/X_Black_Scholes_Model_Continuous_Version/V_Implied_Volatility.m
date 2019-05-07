%% Implied volatility - Call

clear all; close all; clc;

S=110; K=100; T=1; r=0.03; v=0.2;

% Call option price
C=Call(S,K,T,r,v) 

% Implied volatility
% Q. Construct Implied_Volatility_Call function. 
Implied_Volatility = Implied_Volatility_Call(S,K,T,r,C)

%% Implied volatility - Put

% Put option price
P=Put(S,K,T,r,v); 

% Implied volatility
% Q. Construct Implied_Volatility_Put function. 
Implied_Volatility = Implied_Volatility_Put(S,K,T,r,P)