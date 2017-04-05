T = 200 *10^-6;
f = 1/T;
w = 2*pi*f;
C = 10^-6;
L = 1/(C*w^2);

kt = 25.7*10^-3;
R = 11.3;

km = kt/sqrt(R)
B = kt^2/R

Te = L/R

Io = 0.07;
Istall = 0.53
Tfric = kt*Io

eff = (1 - sqrt(Io/Istall))^2

V = 6;
Tcont = 0.003

V = 15; R = 3.28; kt = 28.6*10^-3;