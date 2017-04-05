
figure;
subplot(1,2,1);
%Ground Truth in BLue
x = Robot1_Groundtruth(:, 2);
y = Robot1_Groundtruth(:, 3);
scatter(x,y);
hold on;
plot(x(1), y(1), 'o', 'MarkerFaceColor', 'red');
plot(x(end), y(end), 'o', 'MarkerFaceColor', 'green');
 grid on; 
 xlabel('X World Frame');
ylabel('Y World Frame');
title('Trajectories in XY plane (Ground Truth)');
axis([0 5 -4 4])

% load('800_50.mat');
load('tracking_data.mat');
subplot(1,2,2);
x = mean_pose(:,1);
y = mean_pose(:,2);
scatter(x,y, 'r');
grid on; xlabel('X World Frame');
ylabel('Y World Frame');
title('Trajectories in XY plane (Filter)');