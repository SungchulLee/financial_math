%% Delta

S=100; U=106.04/100; D=94.31/100; R=1.01;

q_u=(R-D)/(U-D); q_d=1-q_u;
pi_u=q_u/R; pi_d=q_d/R;

Payoff=[29.22; 16.04; 4.31; 0];
i=(0:2)'; 
Payoff_U=[29.22; 16.04; 4.31];
Payoff_D=[16.04; 4.31; 0];
Option_Price_U=sum(Payoff_U.*pi_u.^(2-i).*pi_d.^(i).*binomial(2,i));
Option_Price_D=sum(Payoff_D.*pi_u.^(2-i).*pi_d.^(i).*binomial(2,i));

Delta=(Option_Price_U-Option_Price_D)/(S*U-S*D) 