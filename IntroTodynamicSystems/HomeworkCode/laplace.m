%Homework #5 submitted by Deepak Edakkattil Gopinath (2909041);
clear;
clc;

R = 10^6;
C = 1*10^-9;

a = -1/(R*C);
b = 1/R;
c = 1/C
d =[];

x0 = 2*10^-9;

%Parameters of the system
% a = -2;
% b = 5;
% c = 2;
% d = 1;

% x0 = 1; %initial condition
sys = ss(a,b,c,d);
initial(sys, x0);
figure;
step(sys);
