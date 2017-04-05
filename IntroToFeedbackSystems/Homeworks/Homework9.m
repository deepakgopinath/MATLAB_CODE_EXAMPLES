clear; 
clc;
 s = tf('s');
%Q1


%zero at 10, poles at 0, +1, 100
% N = 100*((s/10) + 1);
% D = s*((s/1) - 1)*((s/100) + 1);
% Gs = N/D;
% bode(Gs);
% grid on;
% % figure;
% % nyquist(Gs);
% K = 1;
% figure;
% step(feedback(K*Gs, 1));
% K = 0.01;
% figure;
% step(feedback(K*Gs, 1));
% figure;
% rlocus(Gs);
% rltool(Gs)

% Q2
% tm = 0.5;
% tr = 4;
% b = 1;
% J = tr*b;
% K = 13.2857; % steady state value is at 0.93
% t1 = 1;
% H1 = K/(t1*s + 1);
% H2 = 1/(J*s + b);
% H3 = 1/(tm*s + 1);
% H = feedback(H1*H2, H3);
% step(H);figure;
% margin(H1*H2*H3);
%  [Gm,Pm,Wgm,Wpm]  = margin(H1*H2*H3)
%Q3
% K = 0.0421; % 0.2 was unstable. 0.0421 pushes the crossover freq to the left thereby making the phase margin positive.
% % K = 0.2;
% N = K*(-(s/0.142) + 1);
% D = s*(s/0.325 + 1)*((s/0.0362) + 1);
% H = N/D;
% margin(H);
%  [Gm,Pm,Wgm,Wpm] = margin(H)
% figure;
% % nyquist(H);
% step(feedback(H,1));

%Q4

N = 20*(s + 0.01);
D = s*(s^2 + 0.01*s + 0.0025);

H = N/D;
% K = 1/866;
% % K = 1;
% H1 = K*H;
% [Gm,Pm,Wgm,Wpm] = margin(H1);
% % margin(H1);
% % Wpm
% % figure;
% % nyquist(H1)
% % figure;
% rlocus(H);
% rltool(H)
% figure;
% step(feedback(H1,1));
% %Close loop poles for K= 1/866 are -0.00906, -0.00047 +/- 0.163i
% 
% wc = 0.16;
% alpha = 0.1; %z/p = alpha
% %sqrt(zp) = wc
% p = wc/sqrt(alpha);
% z = p*alpha;
% Cs = (s/z + 1)/(s/p + 1);
% margin(Cs*H)
% % 
% % figure;
% Cs1 = (K/3.1623)*Cs;
% H1 =H;
% % margin(H1);hold on;
% margin(Cs1*H);
% 
% rltool(Cs*H)

Gs = 13.3/((s+1)*(4*s+1)*(0.5*s+1))
margin(Gs)