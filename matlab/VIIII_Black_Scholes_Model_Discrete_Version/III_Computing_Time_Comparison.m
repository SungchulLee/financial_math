%% Computing time comparison between risk-neutral and state price valuation

clear all; close all; clc;

S=258; K=250; T=1; r=0.03; v=0.20;
M=250:10:2500; % M - Number of time grids before maturity

Time_SP=zeros(size(M)); 
Time_RN=zeros(size(M));

for M=250:10:2500
    
    dt=T/M;

    % JR parametrization
    U=exp((r-0.5*v^2)*dt+v*sqrt(dt)); D=U*exp(-2*v*sqrt(dt));
    q_u=0.5; q_d=1-q_u; 

    % Option value at maturity
    V1=max(S*D.^((M:-1:0)').*U.^((0:M)')-K,0); % Call at maturity 
    V2=max(K-S*D.^((M:-1:0)').*U.^((0:M)'),0); % Put at maturity 

    % State price valuation time
    tic
    pi_u=exp(-r*dt)*q_u; pi_d = exp(-r*dt)*q_d;
    C_SP=sum(V1.*pi_d.^((M:-1:0)').*pi_u.^((0:M)').*binomial(M,(M:-1:0)')); 
    P_SP=sum(V2.*pi_d.^((M:-1:0)').*pi_u.^((0:M)').*binomial(M,(M:-1:0)'));
    Time_SP((M-240)/10) = toc;

    % Risk-neutral valuation time
    tic
    for i=M:-1:1
        V1=exp(-r*dt)*(q_u*V1(2:i+1)+q_d*V1(1:i)); % Call backward roll
        V2=exp(-r*dt)*(q_u*V2(2:i+1)+q_d*V2(1:i)); % Put backward roll
    end
    C_JR=V1; P_JR=V2; Time_RN((M-240)/10)=toc;

end

plot(250:10:2500,Time_SP,'or',250:10:2500,Time_RN,'ob'); grid on
xlabel('Number of periods'); ylabel('Computing time of option valuation')
legend('State price valuation','Risk-neutral valuation')
