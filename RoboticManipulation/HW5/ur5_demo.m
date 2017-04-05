%Script for running the homework

clear;clc;
run('robot-9.10/rvctools/startup_rvc.m') % you only have to run this once
mdl_ur5 %load model of ur5
ur5
ur5Script;
n = ur5.n;
k = 10;
Q = theta_mat(1:k:end, :); %to speed up animation

figure;
% pause;
ur5.plot(Q);

