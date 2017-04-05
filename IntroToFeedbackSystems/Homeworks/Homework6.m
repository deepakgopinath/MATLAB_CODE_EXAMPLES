clear all; clc;

s = tf('s');

% 5.20
% N = s+2;
% D = s*(s-2)*(s^2 + 2*s + 10);
% 
% H = N/D
% rlocus(H);
% title('Question 5.20');



% 5.22
% N = (s+1)*(s^2+81);
% D = (s+13)*(s^2 + 100)*s^2;
% 
% H = N/D;
% rlocus(H);
% title('Question 5.22');
% 
% Zeta = 0.707;
% wn = [0:10:1000];
% sgrid(Zeta, wn);
% figure;
% % [k, poles] = rlocfind(H);
% sys = feedback(32.4*H,1);
% step(sys);
% title('Step Response - Q. 5.22');

% % %5.10
% N = 9.8*(s^2 - 0.5*s + 6.3);
% D = (s + 0.66)*(s^2 - 0.24*s + 0.15);
% H = N/D;
% rlocus(H);
% title('Q 5.10 Root Locus');
% axis([-4 4 -3 3])
% sys = feedback(H, 1);
% [p,z] = pzmap(sys);
% % axis([-4 4 -3 3]);
% % figure;
% % N1 = 9.8*N;
% % H1 = N1/D;
% % rlocus(H1);axis([-4 4 -3 3]);

%5.12
N = s^2 + 9;
D = s*(s^2 + 144);
H = N/D;
rlocus(H);
title('Root Locus Q 5.12');
