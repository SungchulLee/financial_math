function V = BS_CN_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v)

% xspan = [log(Smin) log(Smax)]; Log stock price ( x = log S ) interval
% Nx; Number of x nodes

% ic;  initial condition, i.e., payoff as a function form 
% bcl; boundary condition at left end as a function form 
% bcr; boundary condition at right end as a function form 

% tspan = [0 T]; Time to maturity interval 
% Nt; Number of t nodes

% r; interest
% v; volatility

x = linspace(xspan(1),xspan(2),Nx);
dx = x(2)-x(1);

t = linspace(tspan(1),tspan(2),Nt);
dt = t(2)-t(1); 

rho = dt/dx^2;

L  =              - 0.5*0.5*v^2*rho + 0.5*(r-0.5*v^2)*(dt/(2*dx));
C  = (1+0.5*r*dt) +     0.5*v^2*rho;
R  =              - 0.5*0.5*v^2*rho - 0.5*(r-0.5*v^2)*(dt/(2*dx));

L1 = -L;
C1 = (1-0.5*r*dt) -     0.5*v^2*rho;
R1 = -R;

e1 = ones(Nx-2,1);
LL = L*e1;
CC = C*e1;
RR = R*e1;
LL1 = L1*e1;
CC1 = C1*e1;
RR1 = R1*e1;

D = [CC RR LL];
d = [ 0  1 -1];
A = spdiags(D,d,Nx-2,Nx-2);
D1 = [CC1 RR1 LL1];
d1 = [  0   1  -1];
B = spdiags(D1,d1,Nx-2,Nx-2);

[LLL UUU] = lu(A);

V       = zeros(Nx,Nt);
V(:,1)  = ic(x');  % initial condition, i.e., payoff
V(1,:)  = bcl(t'); % boundary condition at left end
V(Nx,:) = bcr(t'); % boundary condition at right end

for j=2:Nt
    e0 = zeros(Nx-2,1);
    f = e0; f(1) = L1*V(1,j-1); f(end) = R1*V(end,j-1);
    g = e0; g(1) = L*V(1,j); g(end) = R*V(end,j);
    V(2:Nx-1,j) = UUU\(LLL\(B*V(2:Nx-1,j-1)+f-g)); % CN  
end
end