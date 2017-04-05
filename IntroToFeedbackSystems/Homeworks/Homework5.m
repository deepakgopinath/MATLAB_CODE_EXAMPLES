J = 0.1;
b = 1;
K = 100;

H1 = tf(K);
H2 = tf([10],[0.5 1]);
H3 = tf([1],[J,b])

H = feedback(H1*H2*H3, 1);
zpk(H)
step(H)
pzmap(H);
[wn, zeta] = damp(H)
sigma = wn(1)*zeta(1)
wd = wn(1)*sqrt(1 - zeta(1)^2)

