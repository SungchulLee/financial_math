%% Computing time comparison with and without LU decomposition

clear all; close all; clc;

fprintf('Case Method        Without LU     With LU\n')

time_without_LU=zeros(2,9);
time_with_LU=zeros(2,9);

for i=1:9
    
% Choose an experiment
experiment = i;
switch experiment
    case 1; Smin=1; K=50; T=1; r=0.1; v=0.40; 
            Smax=K*exp((r-0.5*v^2)*T+3*v*sqrt(T));
            ic  = @(x) max(exp(x)-K,0);
            bcl = @(t) 0;
            bcr = @(t) Smax - K*exp(-r*t);
    case 2; Smin=1; K=50; T=1; r=0.1; v=0.40; 
            Smax=K*exp((r-0.5*v^2)*T+3*v*sqrt(T));
            ic  = @(x) max(K-exp(x),0); 
            bcl = @(t) K*exp(-r*t) - Smin; 
            bcr = @(t) 0; 
    case 3; Knock_Out_Barrier_Bottom = 10;
            Smin = Knock_Out_Barrier_Bottom; K=50; T=1; r=0.1; v=0.40;
            Knock_Out_Barrier_Top = 100; Smax = Knock_Out_Barrier_Top;
            ic  = @(x) max(exp(x)-K,0);
            bcl = @(t) 0; % Due to Knock_Out_Barrier_Bottom
            bcr = @(t) 0; % Due to Knock_Out_Barrier_Top
    case 4; Knock_Out_Barrier_Bottom = 10;
            Smin = Knock_Out_Barrier_Bottom; K=50; T=1; r=0.1; v=0.40;
            Knock_Out_Barrier_Top = 100; Smax = Knock_Out_Barrier_Top;
            ic  = @(x) max(K-exp(x),0); % This line is modified
            bcl = @(t) 0; % Due to Knock_Out_Barrier_Bottom
            bcr = @(t) 0; % Due to Knock_Out_Barrier_Top
    case 5; Smin=1; K=50; T=1; r=0.1; v=0.40; 
            Knock_Out_Barrier_Top = 100; Smax = Knock_Out_Barrier_Top;
            ic  = @(x) max(exp(x)-K,0);
            bcl = @(t) 0; 
            bcr = @(t) 0; % Due to Knock_Out_Barrier_Top 
    case 6; Smin=1; K=50; T=1; r=0.1; v=0.40; 
            Knock_Out_Barrier_Top = 100; Smax = Knock_Out_Barrier_Top;
            ic  = @(x) max(K-exp(x),0); % This line is modified
            bcl = @(t) K*exp(-r*t) - Smin; % This line is modified
            bcr = @(t) 0; % Due to Knock_Out_Barrier_Top 
    case 7; Knock_Out_Barrier_Bottom = 10;
            Smin = Knock_Out_Barrier_Bottom; K=50; T=1; r=0.1; v=0.40;
            Smax = K*exp((r-0.5*v^2)*T+3*v*sqrt(T));
            ic  = @(x) max(exp(x)-K,0);
            bcl = @(t) 0; % Due to Knock_Out_Barrier_Bottom
            bcr = @(t) Smax - K*exp(-r*t); 
    case 8; Knock_Out_Barrier_Bottom = 10;
            Smin = Knock_Out_Barrier_Bottom; K=50; T=1; r=0.1; v=0.40;
            Smax = K*exp((r-0.5*v^2)*T+3*v*sqrt(T));
            ic  = @(x) max(K-exp(x),0); % This line is modified
            bcl = @(t) 0; % Due to Knock_Out_Barrier_Bottom
            bcr = @(t) 0;  % This line is modified 
    case 9; Smin=1; K=50; T=1; r=0.1; v=0.40; 
            Smax=K*exp((r-0.5*v^2)*T+3*v*sqrt(T));
            ic  = @(x) max(exp(x)-K,0);
            bcl = @(t) 0;
            bcr = @(t) Smax - K*exp(-r*t);
            ee  = @(x) max(exp(x)-K,0);
end

xspan=[log(Smin),log(Smax)]; xspan = real(xspan); Nx=20;           
tspan=[0,T]; Nt=50;

% Choose a watch
watch = i;
switch watch
case 1; tic; V1 = BS_Implicit(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(1,i) = toc;
        tic; V2 = BS_CN(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(2,i) = toc;
        tic; V3 = BS_Implicit_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(1,i) = toc;
        tic; V4 = BS_CN_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(2,i) = toc;
case 2; tic; V1 = BS_Implicit(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(1,i) = toc;
        tic; V2 = BS_CN(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(2,i) = toc;
        tic; V3 = BS_Implicit_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(1,i) = toc;
        tic; V4 = BS_CN_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(2,i) = toc;
case 3; tic; V1 = BS_Implicit(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(1,i) = toc;
        tic; V2 = BS_CN(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(2,i) = toc;
        tic; V3 = BS_Implicit_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(1,i) = toc;
        tic; V4 = BS_CN_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(2,i) = toc;
case 4; tic; V1 = BS_Implicit(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(1,i) = toc;
        tic; V2 = BS_CN(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(2,i) = toc;
        tic; V3 = BS_Implicit_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(1,i) = toc;
        tic; V4 = BS_CN_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(2,i) = toc;
case 5; tic; V1 = BS_Implicit(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(1,i) = toc;
        tic; V2 = BS_CN(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(2,i) = toc;
        tic; V3 = BS_Implicit_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(1,i) = toc;
        tic; V4 = BS_CN_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(2,i) = toc;
case 6; tic; V1 = BS_Implicit(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(1,i) = toc;
        tic; V2 = BS_CN(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(2,i) = toc;
        tic; V3 = BS_Implicit_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(1,i) = toc;
        tic; V4 = BS_CN_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(2,i) = toc;
case 7; tic; V1 = BS_Implicit(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(1,i) = toc;
        tic; V2 = BS_CN(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(2,i) = toc;
        tic; V3 = BS_Implicit_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(1,i) = toc;
        tic; V4 = BS_CN_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(2,i) = toc;
case 8; tic; V1 = BS_Implicit(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(1,i) = toc;
        tic; V2 = BS_CN(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_without_LU(2,i) = toc;
        tic; V3 = BS_Implicit_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(1,i) = toc;
        tic; V4 = BS_CN_LU(xspan,Nx,ic,bcl,bcr,tspan,Nt,r,v);
        time_with_LU(2,i) = toc;
case 9; tic; V1 = BS_American_Implicit(xspan,Nx,ic,bcl,bcr,ee,tspan,Nt,r,v);
        time_without_LU(1,i) = toc;
        tic; V2 = BS_American_CN(xspan,Nx,ic,bcl,bcr,ee,tspan,Nt,r,v);
        time_without_LU(2,i) = toc;
        tic; V3 = BS_American_Implicit_LU(xspan,Nx,ic,bcl,bcr,ee,tspan,Nt,r,v);
        time_with_LU(1,i) = toc;
        tic; V4 = BS_American_CN_LU(xspan,Nx,ic,bcl,bcr,ee,tspan,Nt,r,v);
        time_with_LU(2,i) = toc;
end

fprintf('%g    Implicite     %g     %g\n',i,time_without_LU(1,i),time_with_LU(1,i))
fprintf('%g    CN            %g     %g\n',i,time_without_LU(2,i),time_with_LU(2,i))

end