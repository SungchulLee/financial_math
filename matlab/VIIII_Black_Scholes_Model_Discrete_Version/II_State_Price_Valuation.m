%% State price valuation - Call and Put

clear all; close all; clc;

S=258; K=250; T=1; r=0.03; v=0.20;

M=250;
t=linspace(0,T,M+1);
dt=t(2)-t(1);

% Choose a parametrization
parametrization = 3;
switch parametrization
    case 1; U=1+v*sqrt(dt); D=1-v*sqrt(dt); q_u=0.5+r*sqrt(dt)/(2*v); q_d=1-q_u; % Wilmott parametrization
    case 2; U=exp(v*sqrt(dt)); D=exp(-v*sqrt(dt)); q_u=(exp(r*dt)-D)/(U-D); q_d=1-q_u; % CRR parametrization
    case 3; U=exp((r-0.5*v^2)*dt+v*sqrt(dt)); D=exp((r-0.5*v^2)*dt-v*sqrt(dt)); q_u=0.5; q_d=1-q_u; % JR parametrization
end

% Option value at maturity
V1 = max(S*D.^((M:-1:0)').*U.^((0:M)')-K,0); % Call at maturity 
V2 = max(K-S*D.^((M:-1:0)').*U.^((0:M)'),0); % Put at maturity 

% State price valuation
pi_u = exp(-r*dt)*q_u;
pi_d = exp(-r*dt)*q_d;
call_SP = sum(V1.*pi_d.^((M:-1:0)').*pi_u.^((0:M)').*binomial(M,(M:-1:0)')); 
put_SP  = sum(V2.*pi_d.^((M:-1:0)').*pi_u.^((0:M)').*binomial(M,(M:-1:0)')); 
fprintf('Call option price %f\n',call_SP)
fprintf('Put option price  %f\n',put_SP)