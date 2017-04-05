clear;
clc;

% H =tf([170], [1,4,85]); %Transfer function
% 
% [w, z] = damp(H); % natural frequency and damping ratio
% step(H); %step response

Hbase = tf([25],[1,6,25]);
step(Hbase);
hold on;
H = tf([[],-25,25], [1, 6, 25])
step(H)