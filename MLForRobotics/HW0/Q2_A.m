
num_commands = 5;
command = zeros(num_commands, 3);

%fill in commands from question
command(1,:) = [0.5, 0, 1];
command(2,:) = [0, -1/(2*pi), 1];
command(3,:) = [0.5, 0, 1];
command(4,:) = [0, 1/(2*pi), 1];
command(5,:) = [0.5, 0, 1];
pose = zeros(num_commands, 3); %[robot starts at origin pointing in the WORLD x direction]
% pose(1,:) = [0,0,1/(2*pi)]; %Alternate test pose.
params = 0.01*ones(6,1); %6 params
%Run the commands
for i=1:num_commands
%     [pose(i+1, 1), pose(i+1,2), pose(i+1, 3)] = motion_model_stochastic(pose(i,1), pose(i,2), pose(i,3), command(i,1), command(i,2), command(i,3), params);
    [pose(i+1, 1), pose(i+1,2), pose(i+1, 3)] = motion_model(pose(i,1), pose(i,2), pose(i,3), command(i,1), command(i,2), command(i,3));

end

%plot stuff
% figure;
plot(pose(:,1), pose(:,2), 'LineWidth', 2.5);
hold on;
plot(pose(1,1), pose(1,2), 'o', 'MarkerFaceColor', 'red');
plot(pose(end,1), pose(end, 2), 'o', 'MarkerFaceColor', 'green');

title('Vehicle Trajectory in XY Plane');
xlabel('X World Frame');
ylabel('Y World Frame');
grid on;
% axis square;
% axis([-0.1,2,-0.1,0.03])

