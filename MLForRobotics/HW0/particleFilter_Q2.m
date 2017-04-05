% prepareData;
% sparse_odom;

%Particle Filter. 
% loadMRCLAMdataSet;figure;
figure;
num_commands = 5;
command = zeros(num_commands, 3);
M = 1000;
%fill in commands from question
command(1,:) = [0.5, 0, 1];
command(2,:) = [0, -1/(2*pi), 1];
command(3,:) = [0.5, 0, 1];
command(4,:) = [0, 1/(2*pi), 1];
command(5,:) = [0.5, 0, 1];

M = 800;
x_min = min(Robot1_Groundtruth(:,2)) - 0.1; x_max = max(Robot1_Groundtruth(:,2)) + 0.1;
y_min = min(Robot1_Groundtruth(:,3)) - 0.1; y_max = max(Robot1_Groundtruth(:,3)) + 0.1;
theta_min = min(Robot1_Groundtruth(:,4)); theta_max = max(Robot1_Groundtruth(:,4));

%initialize belief/particle set. Uniform distribution. The ranges for the state
%variables were obtained from the GroundTruth Data
X = zeros(M, 3);
X = [(x_max - x_min).*rand(M,1) + x_min, (y_max-y_min).*rand(M,1) + y_min, (theta_max-theta_min).*rand(M,1) + theta_min];

mod_odom = command; clear command;
mod_odom = [mod_odom ones(size(mod_odom,1),1)];
%Particle set init
X_bar = zeros(M, 3);
weights = ones(M,1);

mean_pose = zeros(length(mod_odom), 3); %for tracking purposes. 
%params for the motion model and the measurement model
params = 0.2*ones(6,1); %6 params [0.2 0.2 0.2 0.2 0.1 0.1]
% meas_params = [0.135006686926265;0.130532485788769]; % 2params, variance in r and phi. 
meas_params = [0.135006686926265; 0.0125];

for i=1:length(mod_odom)-1
    %predict. forward sim using v =mod_odom(i,2), w = mod_odom(i,3) and dt = mod_odom(i+1,1) - mod_odom(i,1) 
    %if mod_odom(i+1,4) == 0 then we have a measurement at mod_odom(i+1,1).
    %Therefore do measurement update. from the original Robot1_Measruement
    %for the timetamp = mod_odom(i+1, 1). retrieve ALL the measurements.
    %Compute the weight by multiplying each one of the p(z|x). If a
    %Then perform resampling. and modify the step. 
    
    
%     scatter3(X(:,1), X(:,2), X(:,3)); grid on;
    scatter(X(:,1),X(:,2)); grid on; axis([x_min-0.5 x_max+0.5 y_min-0.5 y_max+0.5]); hold on;
%     close all;


    fprintf('Time stamp number %d \n', i);
    mean_pose(i, :) = mean(X); %for plotting purposes. 
    isMeas = false;
    dt = mod_odom(i+1,1) - mod_odom(i,1); 
    v = mod_odom(i,2); w = mod_odom(i,3);
    if mod_odom(i+1, 4) == 0 %check if measurement happened in the next timestamp
        isMeas = true; %then perform measurement update as well.
        m_ind = find(Robot1_Measurement(:,1) == mod_odom(i+1,1)); %indices of all the measurements with time stamp at mod_odom(i+1,1)
        all_z = Robot1_Measurement(m_ind,:); %all the measurements at timestamp mod_odom(i+1,1)
        weights = ones(M,1); %initialize weights for each particle to be one. 
    end
    
    if isMeas
        for j=1:M
            %predict step
            x = X(j,1); y = X(j,2); theta = X(j, 3);
            [X_bar(j, 1),X_bar(j, 2),X_bar(j, 3)] = motion_model_stochastic(x,y,theta, v, w, dt, params);
            
            %Measurement update
            for k=1:size(all_z,1) %for all measurements obtained at that time stamp
                ml_id = all_z(k,2); mr = all_z(k,3); mphi = all_z(k,4); %the actual measurements and id obtained
                
                %retrieve landmark position for kth measurement
                landmark_num = find(Barcodes(:,2) == ml_id);
                gt_index = find(Landmark_Groundtruth(:,1) ==  landmark_num);
                landmark_pose = [Landmark_Groundtruth(gt_index, 2), Landmark_Groundtruth(gt_index, 3)];
                measurement = [mr, mphi];
                
                %compute weights. 
                weights(j) = weights(j)*p_of_z_given_x(measurement, landmark_pose, X_bar(j,:), meas_params);
            end
%             disp(weights(j));
        end
        
        %normalize Weights before using it for resampling
        weights = weights/sum(weights);
        %resampling
        for j=1:M
            %implement low variance resampler. 
            X = low_variance_resampler_udacity(X_bar, weights);
        end
    else %only prediction no measurement update
        for j=1:M
            x = X(j,1); y = X(j,2); theta = X(j, 3);
            [X_bar(j, 1),X_bar(j, 2),X_bar(j, 3)] = motion_model_stochastic(x,y,theta, v, w, dt, params);
        end
        %no weight calculation, no resampling. Just forward propogate and
        %for the next time step this is the new belief. 
        X = X_bar;
        
    end
end
grid on; xlabel('X World Frame');
ylabel('Y World Frame');
title('Particles in XY plane Q2 commands');
