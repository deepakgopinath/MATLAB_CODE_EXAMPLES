%Script for generating straight line joint space trajectories. 

clear;
run('robot-9.10/rvctools/startup_rvc.m') % you only have to run this once
mdl_ur5

ur5

t_s = 0.1*ones(6,1);
t_end = (pi/2)*ones(6,1);
T = 2;
N = 101;
tsMethodC = 3;
tsMethodQ = 5;
trajCubic = JointTrajectory(t_s,t_end, T, N, tsMethodC);
trajQuintic = JointTrajectory(t_s,t_end,T,N,tsMethodQ);

n = ur5.n;
k = 10;
Q = trajQuintic;

% Q:5-i
plot(trajCubic(:,1),'r'); title('Cubic Time Scaling'); xlabel('time point'); ylabel('theta 1')

%Q:5-ii
figure;
plot(trajQuintic(:,1),'b'); title('Quintic Time Scaling'); xlabel('time point'); ylabel('theta 1')
figure;
ur5.plot(Q);
% For snapshots
% pos = [1,26,51,76,101];
% for i=1:length(pos)
%     ur5.plot(Q(pos(i),:));
%     pause;
% end