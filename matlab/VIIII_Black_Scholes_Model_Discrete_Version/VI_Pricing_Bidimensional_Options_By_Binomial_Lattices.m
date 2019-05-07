%% Pricing bidimensional options by binomial lattices  
%
% Payoff (S1-S2-K)^+
%
% European
%
% dS_1 = (r-q_1)S_1 dt + si_1S_1 dB_1
% dS_2 = (r-q_2)S_2 dt + si_2S_2 dB_2
%
% dB_1dB_2 = rho dt
%
% dX_1 = (r-q_1-0.5*si_1^2) dt + si_1 dB_1
% dX_2 = (r-q_2-0.5*si_1^2) dt + si_2 dB_2

clear all; close all; clc;

S1=200; S2=100; K=1; T=1; r=0.06; q1=0.03; q2=0.04; v1=0.2; v2=0.3; rho=0.5;

nu1=r-q1-0.5*v1^2;
nu2=r-q2-0.5*v2^2;

M=3; 
t=linspace(0,T,M+1);
dt=t(2)-t(1);

% Risk-neutral probability measure
q_uu=0.25*(1+sqrt(dt)*((nu1/v1)+(nu2/v2))+rho);
q_ud=0.25*(1+sqrt(dt)*((nu1/v1)-(nu2/v2))-rho);
q_du=0.25*(1+sqrt(dt)*(-(nu1/v1)+(nu2/v2))-rho);
q_dd=0.25*(1+sqrt(dt)*(-(nu1/v1)-(nu2/v2))+rho);

dx1=v1*sqrt(dt); D1=exp(-dx1); U1=exp(dx1);
dx2=v2*sqrt(dt); D2=exp(-dx2); U2=exp(dx2);

% Option payoff at maturity
Stock1=S1*D1.^((0:M)').*U1.^((M:-1:0)');
Stock2=S2*D2.^((0:M)').*U2.^((M:-1:0)');
[STOCK1,STOCK2]=meshgrid(Stock1,Stock2);
V=max(STOCK1-STOCK2-K,zeros(size(STOCK1))); 

% Risk-neutral valuation
for i=M:-1:1
    V=exp(-r*dt)*(q_uu*V(1:end-1,1:end-1)+ ...
        q_ud*V(2:end,1:end-1)+q_du*V(1:end-1,2:end)+ ...
        q_dd*V(2:end,2:end)); 
end
Put_3=V;
fprintf('Option price by binomial model         %g\n',Put_3)

% Q. Can you add the early exercise feature and modify the code?

