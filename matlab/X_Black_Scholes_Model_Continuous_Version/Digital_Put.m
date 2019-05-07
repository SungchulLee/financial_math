function Digital_P = Digital_Put(S,K,T,r,v,d)
    if (nargin<=5), d = 0; end;
    d1 = (log(S/K)+(r-d+0.5*v^2)*T)/(v*sqrt(T));
    d2 = d1-v*sqrt(T);
    Digital_P = exp(-r*T)*normcdf(-d2,0,1);
end
