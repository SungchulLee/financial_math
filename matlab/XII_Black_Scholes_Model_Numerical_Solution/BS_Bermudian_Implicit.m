function V = BS_Bermudian_Implicit(xspan,Nx,ic,bcl,bcr,ee,Tenor,Nt,r,v)

% xspan = [log(Smin) log(Smax)]; Log stock price ( x = log S ) interval
% Nx; Number of x nodes

% ic;  initial condition, i.e., payoff as a function form 
% bcl; boundary condition at left end as a function form 
% bcr; boundary condition at right end as a function form 
% ee;  early exercise payoff as a function form 

% Tenor = [t_1=0 t_2  t_3  ... t_n t_{n+1}=T]; Tenor structure 
% Nt; Number of t nodes between nodes

% r; interest
% v; volatility

x = linspace(xspan(1),xspan(2),Nx);
dx = x(2)-x(1);

n = length(Tenor)-1;

V = zeros(Nx,Nt,n);
V(:,1,1) = ic(x');  % initial condition, i.e., payoff

for jj=1:n
    t = linspace(Tenor(jj),Tenor(jj+1),Nt);
    dt = t(2)-t(1); 

    rho = dt/dx^2;

    L =          -   0.5*v^2*rho + (r-0.5*v^2)*(dt/(2*dx));
    C = (1+r*dt) + 2*0.5*v^2*rho;
    R =          -   0.5*v^2*rho - (r-0.5*v^2)*(dt/(2*dx));
    e1 = ones(Nx-2,1);
    LL = L*e1;
    CC = C*e1;
    RR = R*e1;

    D = [CC RR LL];
    d = [ 0  1 -1];
    A = spdiags(D,d,Nx-2,Nx-2);

    V(1,:,jj)  = bcl(t); % boundary condition at left end
    V(Nx,:,jj) = bcr(t); % boundary condition at right end

    for j=2:Nt
        e0 = zeros(Nx-2,1);
        f = e0; f(1) = L*V(1,j); f(end) = R*V(end,j);
        V(2:Nx-1,j,jj) = A\(V(2:Nx-1,j-1,jj)-f); % Implicit 
    end
    
    if jj<= n-1
        V(:,Nt,jj) = max(V(:,Nt,jj),ee(x'));
        V(:,1,jj+1) = V(:,Nt,jj);
    end
end
end

