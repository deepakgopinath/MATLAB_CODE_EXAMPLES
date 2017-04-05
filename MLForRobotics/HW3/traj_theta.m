t = Robot1_Groundtruth(1:100, 1); %time coordinate
x = Robot1_Groundtruth(1:100, 2); %x coordinate
y = Robot1_Groundtruth(1:100, 3); % y coordinate
theta = Robot1_Groundtruth(1:100, 4); %theta coordinate

tq = Robot1_Odometry(1,1); %Query time point

%Queried x,y,and theta - starting point
xq = interp1(t,x,tq);
yq = interp1(t,y,tq);
thetaq = interp1(t,theta, tq);
pose = zeros(size(Robot1_Odometry,1), 1); %initialize with the 20000 points. If not sufficient the for loop will automatically append
pose(1,:) = [thetaq];

for i=1:size(Robot1_Odometry, 1) - 1
    theta = pose(i,1);
    w = Robot1_Odometry(i,3);
    s_theta = data_scale_single(theta, minmax_input(3,1)-2, minmax_input(3,2)+2, 0, 1);
    s_w = data_scale_single(w, minmax_input(5,1)-2.5, minmax_input(5,2)+2.5, 0, 1);
    in = [s_theta, s_w]';
    
    thetan = feed_forward(in, final_w_nn1, final_b_nn1, 3);
    thetan = data_scale_single(thetan, 0, 1, minmax_y_ns(3,1)-2, minmax_y_ns(3,2)+2);
    
    if thetan > 2*pi
        thetan = thetan - 2*pi;
    end
    if thetan < 0
        thetan = thetan + 2*pi;
    end
     pose(i+1, :) = [thetan];
end