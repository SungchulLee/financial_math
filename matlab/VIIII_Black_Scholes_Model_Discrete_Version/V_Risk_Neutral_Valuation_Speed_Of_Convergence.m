%% Risk-neutral valuation - Speed of convergence

clear all; close all; clc;

S=258; K=250; T=1; r=0.03; v=0.20;

for M=10:12*21
    t=linspace(0,T,M+1);
    dt=t(2)-t(1);

    % Choose a parametrization
    parametrization = 2;
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

    plot(M,Put_3,'o'); hold on
end