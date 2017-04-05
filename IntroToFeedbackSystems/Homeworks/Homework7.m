clear all; clc;

s = tf('s');

% N = 1
% D = (s+2)*(s+3);
% H = N/D;
% rlocus(H)
% 
% N = 10;
% D = s*(s+1)*(s+10);
% H = N/D;
% % rlocus(H);
% rltool(H);
% 
% % 
% % K = 11.5;
% % z = 0.2174;
% % p = 0.05;
% % 
% % K*z/p

%*************************Q3
% mp = 1; mc = 5*mp;
% beta = 3*mp/(4*(mc+mp));
% %inner loop
% N = 1;
% D = s^2 - 1;
% sys = N/D;
% % rlocus(H);
% % % rltool(sys);
% 
% 
% Ds = 41*(s+1)/(s + 9);
% Ps = 1/(s^2 - 1);
% Gs = (s^2 - 1 + beta)/s^2;
% L = Ps*Gs/(1 + Ps*Ds);
% L = minreal(L);
% % rlocus(sys2);
% % rlocus(sys2);
% % rltool(L);
% % % N2 = s^1 - 1 + beta;
% % % D2 = (s^2)*(s^2 - 1);
% % % H2 = N2/D2;
% % 
% Kc =tf(-0.03);
% Cs = (20*s + 1)/(s*0.667 + 1);
% H = -Kc*L/(Gs*(1 + Kc*Cs*L));
% step(H);


Gd = -0.0184*(s + 0.0068)/(s*(s + 0.2647)*(s + 0.0063));
Gw = 0.0000064/(s*(s+0.2647)*(s+0.0063));

K =  tf(-1.4157);
Cs = (1+0.28*s)/(1+0.012*s);
Ds = K*Cs;

sys = feedback(Gw, Ds)
% step(sys)
rltool(Gw);
% rltool(Gw);

