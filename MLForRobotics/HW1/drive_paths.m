

dt = 0.1;
rad = 0.11;
wayposes = waypoints; %from the planner.
index = 1; %traj index
traj= wayposes(1,:);
control_list = []; %list of velocties
curr_angle = deg2rad(-90); %starting heading, in radians. 
traj(1,3) = curr_angle;

%Generate velocities and then forward simulate through motion model. 
for i=1:size(wayposes, 1)-1
    [v,w] = ik_controller(wayposes(i,1), wayposes(i,2), rad2deg(curr_angle), wayposes(i+1,1), wayposes(i+1,2));
    control_list = [v', w'];
    %draw a circle with correct heading at the beginning of each chunk
    xc = traj(index, 1); yc =traj(index, 2);
    blx =  xc - rad; bly = yc - rad;
    pos = [blx, bly, 2*rad,2*rad];
    rectangle('Position',pos,'Curvature',[1 1], 'LineWidth', 2.0);
    line([xc, xc + rad*cos(curr_angle)], [yc, yc + rad*sin(curr_angle)], 'LineWidth', 2.0, 'Color', 'k');
    for j=1:size(control_list,1)
        %stochasticity can be changed from within the
        %motion_model_stochastic function. Currently stochasticity is set
        %at 0.0
        [traj(index+1, 1),traj(index+1,2),traj(index+1, 3)] = motion_model_stochastic(traj(index, 1),traj(index, 2),traj(index, 3), control_list(j,1), control_list(j,2), dt);
        curr_angle = traj(index+1,3); %radians
        index = index + 1;
    end
end

hold on;

%draw the trajectory.
for i=1:size(traj,1)-1
    xpoints = [traj(i,1) traj(i+1,1)];
    ypoints = [traj(i,2) traj(i+1,2)];
    line(xpoints, ypoints, 'LineWidth', 2.0, 'Color', 'b');
end

