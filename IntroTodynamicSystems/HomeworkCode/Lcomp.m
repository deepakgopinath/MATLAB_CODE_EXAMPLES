clear;
M = 1;
K = 100;
B = 1;

A = [0, 1/M; -K, -B/M];
B = [0;1];
C = [0, 1/M];
D = [0];

H = ss(A,B,C,D);
tf(H)
bode(H)
[m,p] = bode(H, 1);
m = 20*log10(m)
p