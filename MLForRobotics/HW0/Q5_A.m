
%assumes loadMRCLAMdataSet.m has been run before.

%for interpolation of robot poses
t = Robot1_Groundtruth(:,1); %t coordinates
x = Robot1_Groundtruth(:, 2); %x coordinate
y = Robot1_Groundtruth(:, 3); % y coordinate
theta = Robot1_Groundtruth(:, 4); %theta coordinate

%arrays for collecting error stats
err_r = [];
err_phi = [];

robot_ids = Barcodes(1:5,2);

for i=1:size(Robot1_Measurement,1)
    %Measurement data
    mt = Robot1_Measurement(i,1);
    ml_id = Robot1_Measurement(i,2);
    mr = Robot1_Measurement(i,3);
    mphi = Robot1_Measurement(i,4);
    
    %Use ground truth data to see where the robot was at time mt
    x_mt = interp1(t,x,mt);
    y_mt = interp1(t,y,mt);
    theta_mt = interp1(t, theta, mt);
    
    if sum(find(robot_ids==ml_id)) == 0 %collect error stats only if the id is NOT that of another robot
    %Compute the pose of the landmark that was detected in this measurement
        landmark_num = find(Barcodes(:,2) == ml_id);
        gt_index = find(Landmark_Groundtruth(:,1) ==  landmark_num);
        landmark_pose = [Landmark_Groundtruth(gt_index, 2), Landmark_Groundtruth(gt_index, 3)];
        
        %Use measurement model to see what is to be expected.
        [r,phi] = measurement_model(x_mt, y_mt, theta_mt, landmark_pose);
        err_r = [err_r, mr - r];
        err_phi = [err_phi, mphi - phi];
    end
end

%Plot histogram of errors. 
figure;
histogram(err_r - mean(err_r), 50);
grid on;
title('Histogram of error in range measurements');
xlabel('Meters');
ylabel('Measurements count');
% figure;
% % hold on;
% x = -1.0:0.05:0.4;
% norm = normpdf(x,0,std(err_r - mean(err_r)));
% plot(x, norm, 'r');


figure;
histogram(err_phi - mean(err_phi), 50);
grid on;
title('Histogram of error in bearing measurements');
xlabel('Radians');
ylabel('Measurements count');
% figure;
% grid on;
% x = -6:0.01:6;
% norm =normpdf(x,0,0.2*std(err_phi - mean(err_phi)));
% plot(x, norm, 'r');

%This error stats can be used to estimate the measurement noise (modeled as a Gaussian probably)which can
%then be added to the detrministic measurement model. This is necessary
%when computing the likelihood p(z|x) during the filter implementation. 