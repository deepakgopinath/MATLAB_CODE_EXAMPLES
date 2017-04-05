t = Robot1_Groundtruth(:, 1); %time coordinate
x = Robot1_Groundtruth(:, 2); %x coordinate
y = Robot1_Groundtruth(:, 3); % y coordinate
theta = Robot1_Groundtruth(:, 4); %theta coordinate
offset = 10000;
tq = Robot1_Odometry(offset,1); %Query time point

%Queried x,y,and theta - starting point
xq = interp1(t,x,tq);
yq = interp1(t,y,tq);
thetaq = interp1(t,theta, tq);
pose = zeros(size(Robot1_Odometry,1), 3); %initialize with the 20000 points. If not sufficient the for loop will automatically append
pose(1,:) = [xq,yq,thetaq]; %This corresponds to the pose when the first odometry command was issued. This was obtained by linear interpolation from the Ground Truth data. 


for i=1:size(Robot1_Odometry, 1) - 1 - offset
    x = pose(i,1);
    y = pose(i,2);
    theta = pose(i,3);

    v = Robot1_Odometry(i + offset,2);
    w = Robot1_Odometry(i + offset,3);
    dt = Robot1_Odometry(i+1+ offset,1) - Robot1_Odometry(i+ offset,1);
    
    s_x = data_scale_single(x, minmax_input(1,1), minmax_input(1,2), 0, 1);
    s_y = data_scale_single(y, minmax_input(2,1), minmax_input(2,2), 0, 1);
    s_theta = data_scale_single(theta, minmax_input(3,1), minmax_input(3,2), 0, 1);
    s_v = data_scale_single(v, minmax_input(4,1), minmax_input(4,2), 0, 1);
    s_w = data_scale_single(w, minmax_input(5,1), minmax_input(5,2), 0, 1);
    
    in = [s_x, s_y, s_theta, s_v, s_w]'; %normalized input for NNs 5 by 1
    
    xn = feed_forward(in, final_w_nn1, final_b_nn1, 6);
    xn = data_scale_single(xn, 0, 1, minmax_y_ns(1,1), minmax_y_ns(1,2));
    yn = feed_forward(in, final_w_nn2, final_b_nn2, 6);
    yn = data_scale_single(yn, 0, 1, minmax_y_ns(2,1), minmax_y_ns(2,2));
    thetan = feed_forward(in, final_w_nn3, final_b_nn3, 6);
    thetan = data_scale_single(thetan, 0, 1, minmax_y_ns(3,1), minmax_y_ns(3,2));
    
    if thetan > 2*pi
        thetan = thetan - 2*pi;
    end
    if thetan < 0
        thetan = thetan + 2*pi;
    end
   
    pose(i+1, :) = [xn,yn,thetan];
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


