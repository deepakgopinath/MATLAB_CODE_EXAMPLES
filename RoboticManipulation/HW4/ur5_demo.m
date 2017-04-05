%Script for running Cartesian trajectories

clear;
run('robot-9.10/rvctools/startup_rvc.m') % you only have to run this once
mdl_ur5

ur5
ur5TrajStuff;
n = ur5.n;
k = 10;
Q = t_List;


ur5.plot(Q);
%For snapshots
% pos = [1,26,51,76,101];
% for i=1:length(pos)
%     ur5.plot(Q(pos(i),:));
%     pause;
% end
