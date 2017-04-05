t = Robot1_Groundtruth(1:100, 1); %time coordinate
x = Robot1_Groundtruth(1:100, 2); %x coordinate
y = Robot1_Groundtruth(1:100, 3); % y coordinate
theta = Robot1_Groundtruth(1:100, 4); %theta coordinate

tq = Robot1_Odometry(1,1); %Query time point

%Queried x,y,and theta
xq = interp1(t,x,tq);
yq = interp1(t,y,tq);
thetaq = interp1(t,theta, tq);
pose = zeros(20000, 3); %initialize with the 20000 points. If not sufficient the for loop will automatically append
pose(1,:) = [xq,yq,thetaq]; %This corresponds to the pose when the first odometry command was issued. This was obtained by linear interpolation from the Ground Truth data. 

for i=1:size(Robot1_Odometry, 1) - 1
    x = pose(i,1);
    y = pose(i,2);
    theta = pose(i,3);
    v = Robot1_Odometry(i,2);
    w = Robot1_Odometry(i,3);
    dt = Robot1_Odometry(i+1,1) - Robot1_Odometry(i,1);
    [x_new, y_new, theta_new] = motion_model(x,y,theta, v,w, dt);
    
    %Make sure theta_new is in 0 to 2pi
    if y_new > minmax_input(2,2)
        fprintf('Greater index y %d\n',i )
    end
    if y_new < minmax_input(2,1)
        fprintf('Lesser index y %d\n',i )
    end
    
    if x_new > minmax_input(1,2)
        fprintf('Greater index x %d\n',i )
    end
    if x_new < minmax_input(1,1)
        fprintf('Lesser index x %d\n',i )
    end
    %For using NN scale the input vector to 0 to 1 ranges. 
    s_x = data_scale_single(x, minmax_input(1,1), minmax_input(1,2), 0, 1);
    s_y = data_scale_single(y, minmax_input(2,1), minmax_input(2,2), 0, 1);
    s_theta = data_scale_single(theta, minmax_input(3,1), minmax_input(3,2), 0, 1);
    s_v = data_scale_single(v, minmax_input(4,1), minmax_input(4,2), 0, 1);
    s_w = data_scale_single(w, minmax_input(5,1), minmax_input(5,2), 0, 1);
    s_dt = data_scale_single(dt, minmax_input(6,1), minmax_input(6,2), 0, 1);
    
    in = [s_x, s_y, s_theta, s_v, s_w, s_dt]'; %normalized input for NNs
    %Use NN to retrieve variance for the input. Scale back the value to
    %original variance range for normalized error. 
    
    std_dx = feed_forward(in, final_w_nn4, final_b_nn4, 5);
    std_dx = data_scale_single(std_dx, 0, 1, minmax_y_std(1,1), minmax_y_std(1,2));
    
    std_dy = feed_forward(in, final_w_nn5, final_b_nn5, 5);
    std_dy = data_scale_single(std_dy, 0, 1, minmax_y_std(2,1), minmax_y_std(2,2));
    
    std_dtheta = feed_forward(in, final_w_nn6, final_b_nn6, 5);
    std_dtheta = data_scale_single(std_dtheta, 0, 1, minmax_y_std(3,1), minmax_y_std(3,2));
   
    %Use NN to retrieve mean error. Scale back the value to original error
    %range. 
    m_dx = feed_forward(in, final_w_nn1, final_b_nn1, 4);
    dx = normrnd(m_dx, std_dx); % gaussian noise in normalized range;
    dx = data_scale_single(dx, 0, 1, minmax_y_err(1,1), minmax_y_err(1,2));
    
    m_dy = feed_forward(in, final_w_nn2, final_b_nn2, 4);
    dy = normrnd(m_dy, std_dy);
    dy = data_scale_single(dy, 0, 1, minmax_y_err(2,1), minmax_y_err(2,2));
    
    m_dtheta = feed_forward(in, final_w_nn3, final_b_nn3, 6);
    dtheta = normrnd(m_dtheta, std_dy);
    dtheta = data_scale_single(dtheta, 0, 1, minmax_y_err(3,1), minmax_y_err(3,2));
    
    x_new = x_new - dx;
    y_new = y_new -  dy;
    theta_new = theta_new - dtheta;
    if theta_new > 2*pi
        theta_new = theta_new - 2*pi;
    end
    if theta_new < 0
        theta_new = theta_new + 2*pi;
    end
    
    pose(i+1, :) = [x_new, y_new, theta_new];
    
end

figure;
%Ground Truth in BLue
x = Robot1_Groundtruth(:, 2);
y = Robot1_Groundtruth(:, 3);
% y(y<0) = y(y<0) + 2*pi;
p1 = plot(x,y , 'LineWidth', 2.5);
hold on;
plot(x(1), y(1), 'o', 'MarkerFaceColor', 'red');
plot(x(end), y(end), 'o', 'MarkerFaceColor', 'green');


%Motion Model - in Violet
x = pose(:,1);
y = pose(:,2);
p2 = plot(x,y , 'LineWidth', 2.5);
plot(x(1), y(1), 'o', 'MarkerFaceColor', 'red');
plot(x(end), y(end), 'o', 'MarkerFaceColor', 'green');

grid on;
% axis square;
xlabel('X World Frame');
ylabel('Y World Frame');
title('Trajectories in XY plane');
legend([p1 p2],'Ground Truth', 'Motion Model');