%% Replicating portflio - Call

clear all; close all; clc; clf; %rng(16); 

figure(1)

S=50; K=45; T=0.5; r=0.03; v=0.30;

n=24; % Weekly rebalance
dt=T/n;
tau=T-0*dt; % Time to maturity

% Initialization
d1=zeros(1,n+1);
d2=zeros(1,n+1);
N_Stock=zeros(1,n+1);
N_Bond=zeros(1,n+1);
STOCK=zeros(1,n+1);
BOND=zeros(1,n+1); 
TOTAL=STOCK+BOND;
STOCK_at_END=zeros(1,n+1);
BOND_at_END=zeros(1,n+1); 
TOTAL_at_END=STOCK_at_END+BOND_at_END;

% Week 0 
d1(1)=(log(S/K)+(r+0.5*v^2)*tau)/(v*sqrt(tau));
d2(1)=d1(1)-v*sqrt(tau);
N_Stock(1)=normcdf(d1(1),0,1);
N_Bond(1)=-K*exp(-r*tau)*normcdf(d2(1),0,1);
STOCK(1)=N_Stock(1)*S;
BOND(1)=N_Bond(1)*1; 
TOTAL(1)=STOCK(1)+BOND(1);

for i=1:n
    tau=T-i*dt; % Time to maturity
    S=S*exp((r-0.5*v^2)*dt+v*sqrt(dt)*randn(1,1));
    STOCK_at_END(i)=N_Stock(i)*S;
    BOND_at_END(i)=N_Bond(i)*exp(r*dt); 
    TOTAL_at_END(i)=STOCK_at_END(i)+BOND_at_END(i);
    TOTAL(i+1)=TOTAL_at_END(i);
    d1(i+1)=(log(S/K)+(r+0.5*v^2)*tau)/(v*sqrt(tau));
    d2(i+1)=d1(i+1)-v*sqrt(tau);
    N_Stock(i+1)=normcdf(d1(i+1));
    STOCK(i+1)=N_Stock(i+1)*S;
    N_Bond(i+1)=TOTAL(i+1)-STOCK(i+1);
    BOND(i+1)=N_Bond(i+1); 
end

S=S*exp((r-0.5*v^2)*dt+v*sqrt(dt)*randn(1,1));
STOCK_at_END(n+1)=N_Stock(n+1)*S;
BOND_at_END(n+1)=N_Bond(n+1)*exp(r*dt); 
TOTAL_at_END(n+1)=STOCK_at_END(n+1)+BOND_at_END(n+1);

% Number of stocks in replicating portflio
plot((0:n),N_Stock,'o-r')
xlabel('Time')
ylabel('Number of Shares in Self-finacing Portfolio')

DATA = [(0:n)' TOTAL' STOCK' BOND' TOTAL_at_END' STOCK_at_END' BOND_at_END']'; 
t = 'WEEK    TOTAL    STOCK      BOND    T_at_END S_at_END  B_at_END\n';
fprintf(t)
fprintf('%3d   %7.2f   %6.2f   %7.2f     %7.2f   %6.2f   %7.2f  \n',DATA)

%% Replicating portflio - Put

figure(2)

% Initialization
d1=zeros(1,n+1);
d2=zeros(1,n+1);
N_Stock=zeros(1,n+1);
N_Bond=zeros(1,n+1);
STOCK=zeros(1,n+1);
BOND=zeros(1,n+1); 
TOTAL=STOCK+BOND;
STOCK_at_END=zeros(1,n+1);
BOND_at_END=zeros(1,n+1); 
TOTAL_at_END=STOCK_at_END+BOND_at_END;

% Week 0 
d1(1)=(log(S/K)+(r+0.5*v^2)*tau)/(v*sqrt(tau));
d2(1)=d1(1)-v*sqrt(tau);
N_Stock(1)=-normcdf(-d1(1));  % This line is modified
N_Bond(1)=K*exp(-r*tau)*normcdf(-d2(1));  % This line is modified
STOCK(1)=N_Stock(1)*S;
BOND(1)=N_Bond(1)*1; 
TOTAL(1)=STOCK(1)+BOND(1);

for i=1:n
    tau=T-i*dt; % Time to maturity
    S=S*exp((r-0.5*v^2)*dt+v*sqrt(dt)*randn(1,1));
    STOCK_at_END(i)=N_Stock(i)*S;
    BOND_at_END(i)=N_Bond(i)*exp(r*dt); 
    TOTAL_at_END(i)=STOCK_at_END(i)+BOND_at_END(i);
    TOTAL(i+1)=TOTAL_at_END(i);
    d1(i+1)=(log(S/K)+(r+0.5*v^2)*tau)/(v*sqrt(tau));
    d2(i+1)=d1(i+1)-v*sqrt(tau);
    N_Stock(i+1)=-normcdf(-d1(i+1));  % This line is modified
    STOCK(i+1)=N_Stock(i+1)*S;
    N_Bond(i+1)=TOTAL(i+1)-STOCK(i+1);
    BOND(i+1)=N_Bond(i+1); 
end

S=S*exp((r-0.5*v^2)*dt+v*sqrt(dt)*randn(1,1));
STOCK_at_END(n+1)=N_Stock(n+1)*S;
BOND_at_END(n+1)=N_Bond(n+1)*exp(r*dt); 
TOTAL_at_END(n+1)=STOCK_at_END(n+1)+BOND_at_END(n+1);

% Number of stocks in replicating portflio
plot((0:n),N_Stock,'o-r')
xlabel('Time')
ylabel('Number of Shares in Self-finacing Portfolio')

DATA = [(0:n)' TOTAL' STOCK' BOND' TOTAL_at_END' STOCK_at_END' BOND_at_END']'; 
t = 'WEEK    TOTAL    STOCK      BOND    T_at_END S_at_END  B_at_END\n';
fprintf(t)
fprintf('%3d   %7.2f   %6.2f   %7.2f     %7.2f   %6.2f   %7.2f  \n',DATA)

%% Replicating portflio - Protective Put
% Protective Put protecting long stock position
% Protective Put = Stock 1 + Put 1

figure(3)

% Initialization
d1=zeros(1,n+1);
d2=zeros(1,n+1);
N_Stock=zeros(1,n+1);
N_Bond=zeros(1,n+1);
STOCK_PRICE=zeros(1,n+1);
STOCK=zeros(1,n+1);
BOND=zeros(1,n+1); 
TOTAL=STOCK+BOND;
STOCK_at_END=zeros(1,n+1);
BOND_at_END=zeros(1,n+1); 
TOTAL_at_END=STOCK_at_END+BOND_at_END;

% Week 0 
d1(1)=(log(S/K)+(r+0.5*v^2)*tau)/(v*sqrt(tau));
d2(1)=d1(1)-v*sqrt(tau);
N_Stock(1)=normcdf(d1(1),0,1);   
N_Bond(1)=K*exp(-r*tau)*normcdf(-d2(1)); % This line is modified 
STOCK_PRICE(1)=S;
STOCK(1)=N_Stock(1)*S;
BOND(1)=N_Bond(1)*1; 
TOTAL(1)=STOCK(1)+BOND(1);

for i=1:n
    tau = T-i*dt; % Time to maturity
    S = S*exp((r-0.5*v^2)*dt+v*sqrt(dt)*randn(1,1));
    STOCK_at_END(i) = N_Stock(i)*S;
    BOND_at_END(i) = N_Bond(i)*exp(r*dt); 
    TOTAL_at_END(i) = STOCK_at_END(i)+BOND_at_END(i);
    TOTAL(i+1) = TOTAL_at_END(i);
    d1(i+1) = (log(S/K)+(r+0.5*v^2)*tau)/(v*sqrt(tau));
    d2(i+1) = d1(i+1) - v*sqrt(tau);
    N_Stock(i+1) = normcdf(d1(i+1)); 
    STOCK_PRICE(i+1) = S;
    STOCK(i+1) = N_Stock(i+1)*S;
    N_Bond(i+1) = TOTAL(i+1)-STOCK(i+1);
    BOND(i+1) = N_Bond(i+1); 
end

S = S*exp((r-0.5*v^2)*dt+v*sqrt(dt)*randn(1,1));
STOCK_at_END(n+1) = N_Stock(n+1)*S;
BOND_at_END(n+1) = N_Bond(n+1)*exp(r*dt); 
TOTAL_at_END(n+1) = STOCK_at_END(n+1)+BOND_at_END(n+1);

subplot(131)
% Stock price
plot((0:n),STOCK_PRICE,'-b'); grid on; xlabel('Time'); ylabel('Stock')

subplot(132)
% Stock price and replicating portflio price
plot((0:n),STOCK_PRICE,'-b',(0:n),TOTAL,'-r'); hold on; grid on
legend('Stock','Protective Put'); xlabel('Time'); ylabel('Protective PUT45')

subplot(133)
% Number of stocks in replicating portflio
plot((0:n),N_Stock,'o-r'); grid on
xlabel('Time'); ylabel('Number of Shares in Protective PUT45')

DATA = [(0:n)' TOTAL' STOCK' BOND' TOTAL_at_END' STOCK_at_END' BOND_at_END']'; 
t = 'WEEK    TOTAL    STOCK      BOND    T_at_END S_at_END  B_at_END\n';
fprintf(t)
fprintf('%3d   %7.2f   %6.2f   %7.2f     %7.2f   %6.2f   %7.2f  \n',DATA)

%% Replicating portflio - Covered Call
% Covered Call protecting short call position
% Covered Call = Stock 1 + Call -1

figure(4)

% Initialization
d1=zeros(1,n+1);
d2=zeros(1,n+1);
N_Stock=zeros(1,n+1);
N_Bond=zeros(1,n+1);
STOCK_PRICE=zeros(1,n+1);
STOCK=zeros(1,n+1);
BOND=zeros(1,n+1); 
TOTAL=STOCK+BOND;
STOCK_at_END=zeros(1,n+1);
BOND_at_END=zeros(1,n+1); 
TOTAL_at_END=STOCK_at_END+BOND_at_END;

% Week 0 
d1(1) = (log(S/K)+(r+0.5*v^2)*tau)/(v*sqrt(tau));
d2(1) = d1(1) - v*sqrt(tau);
N_Stock(1) = normcdf(-d1(1));   
N_Bond(1) = K*exp(-r*tau)*normcdf(d2(1),0,1); 
STOCK_PRICE(1) = S;
STOCK(1) = N_Stock(1)*S;
BOND(1) = N_Bond(1)*1; 
TOTAL(1) = STOCK(1)+BOND(1);

for i=1:n
    tau = T-i*dt; % Time to maturity
    S = S*exp((r-0.5*v^2)*dt+v*sqrt(dt)*randn(1,1));
    STOCK_at_END(i) = N_Stock(i)*S;
    BOND_at_END(i) = N_Bond(i)*exp(r*dt); 
    TOTAL_at_END(i) = STOCK_at_END(i)+BOND_at_END(i);
    TOTAL(i+1) = TOTAL_at_END(i);
    d1(i+1) = (log(S/K)+(r+0.5*v^2)*tau)/(v*sqrt(tau));
    d2(i+1) = d1(i+1) - v*sqrt(tau);
    N_Stock(i+1) = normcdf(-d1(i+1)); 
    STOCK_PRICE(i+1) = S;
    STOCK(i+1) = N_Stock(i+1)*S;
    N_Bond(i+1) = TOTAL(i+1)-STOCK(i+1);
    BOND(i+1) = N_Bond(i+1); 
end

S = S*exp((r-0.5*v^2)*dt+v*sqrt(dt)*randn(1,1));
STOCK_at_END(n+1) = N_Stock(n+1)*S;
BOND_at_END(n+1) = N_Bond(n+1)*exp(r*dt); 
TOTAL_at_END(n+1) = STOCK_at_END(n+1)+BOND_at_END(n+1);

subplot(131)
% Stock price
plot((0:n),STOCK_PRICE,'-b'); grid on; xlabel('Time'); ylabel('Stock')

subplot(132)
% Stock price and replicating portflio price
plot((0:n),STOCK_PRICE,'-b',(0:n),TOTAL,'-r'); grid on
legend('Stock','Covered Call'); xlabel('Time'); ylabel('Covered Call45')

subplot(133)
% Number of stocks in replicating portflio
plot((0:n),N_Stock,'o-r'); grid on
xlabel('Time'); ylabel('Number of Shares in Covered Call45')

DATA = [(0:n)' TOTAL' STOCK' BOND' TOTAL_at_END' STOCK_at_END' BOND_at_END']'; 
t = 'WEEK    TOTAL    STOCK      BOND    T_at_END S_at_END  B_at_END\n';
fprintf(t)
fprintf('%3d   %7.2f   %6.2f   %7.2f     %7.2f   %6.2f   %7.2f  \n',DATA)