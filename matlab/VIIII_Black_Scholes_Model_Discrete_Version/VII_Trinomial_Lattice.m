%% Trinomial lattice - Put
%
% dS = (r-q)S dt + v*S*dB
%
% dX = (r-q-0.5*v^2) dt + v*dB

clear all; close all; clc;

S=258; K=250; T=1; r=0.03; v=0.20;

% Put option price by Black Scholes formula
Put_1=Put(S,K,T,r,v); % My function
[~,Put_2]=blsprice(S,K,r,T,v); % Matlab built-in function
fprintf('Put option price by Black Scholes formula  %g\n',Put_1)
fprintf('Put option price by Black Scholes formula  %g\n',Put_2)

q=0;
nu=r-q-0.5*v^2;

M=250; 
t=linspace(0,T,M+1);
dt=t(2)-t(1);
dx=3*sqrt(dt); D=exp(-dx); U=exp(dx);

% Risk-neutral probability measure
q_u=0.5*((v^2*dt+nu^2*dt^2)/(dx^2)+(nu*dt)/(dx));
q_m=1-(v^2*dt+nu^2*dt^2)/(dx^2);
q_d=0.5*((v^2*dt+nu^2*dt^2)/(dx^2)-(nu*dt)/(dx));

% Option payoff at maturity
Stock=S*U.^((M:-1:-M)');
V=max(K-Stock,zeros(size(Stock))); 

% Risk-neutral valuation
for i=M:-1:1
    V=exp(-r*dt)*(q_u*V(1:end-2)+q_m*V(2:end-1)+q_d*V(3:end)); 
end
Put_3=V;
fprintf('Put option price by trinomial model        %g\n',Put_3)

