clear;
clc;


T = 2;
t = (0:0.01:T)';
y = CubicTimeScaling(T, t);
y2 = QuinticTimeScaling(T, t);

N= 101;
T = 2;
num_joints = 6;
t_s = 0.1*ones(num_joints,1);
t_e = (pi/2)*ones(num_joints,1);
tsMethod = 3;
cubictraj = JointTrajectory(t_s, t_e, T, N, tsMethod);
plot(cubictraj(:,1));

tsMethod = 5;
quintictraj = JointTrajectory(t_s, t_e, T, N, tsMethod);
hold on; 
plot(quintictraj(:,1), 'r');
