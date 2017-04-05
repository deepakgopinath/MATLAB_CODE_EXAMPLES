
%Remove other robots from the measurment data
robot_ids = Barcodes(1:5,2);
for i=1:length(robot_ids)
    Robot1_Measurement(find(Robot1_Measurement(:,2) == robot_ids(i)), :) = [];
end
%time stamps for odometry and measurements
t_Odom = Robot1_Odometry(:,1);
t_Meas = Robot1_Measurement(:,1);

%Odometery sampling rate is higher than measurement. And there is a
%mistmatch between the starting points. 
ptrO = 1;

%skip all the control velocities immediately before the first measurement. No point in simply forward propagating unirand samples 
remove_index = max(find(t_Odom < t_Meas(1))) - 1;
t_Odom(1:remove_index) = [];

M = 800;
x_min = min(Robot1_Groundtruth(:,2)) - 0.1; x_max = max(Robot1_Groundtruth(:,2)) + 0.1;
y_min = min(Robot1_Groundtruth(:,3)) - 0.1; y_max = max(Robot1_Groundtruth(:,3)) + 0.1;
theta_min = min(Robot1_Groundtruth(:,4)); theta_max = max(Robot1_Groundtruth(:,4));

%initialize belief/particle set. Uniform distribution. The ranges for the state
%variables were obtained from the GroundTruth Data
X = zeros(M, 3);
X = [(x_max - x_min).*rand(M,1) + x_min, (y_max-y_min).*rand(M,1) + y_min, (theta_max-theta_min).*rand(M,1) + theta_min];

%combine and organize the time stamps for u and z.

ut_Meas =  unique(t_Meas); %remove duplicate measurement time stamps. Can be retrieved during query time
%combine the Odom and MEas time stamps
odo = [t_Odom ones(length(t_Odom), 1)]; %second column is for tagging whether it was a control or measurement data that was avaiable
mea = [ut_Meas zeros(length(ut_Meas), 1)];
com = [odo;mea]; %stack both odo and meas on top of each other. 
com = sortrows(com, 1);  %sort the entire list according to time stamps. Now odom and measurements are mixed
clear odo; clear mea; %make space by clearing unecessary variable.s 

%make a modified odom data, by filling the odom values for the timestamps
%correposnding to measurements. by copying the recent previous odom values
mod_odom =  zeros(length(com), 3); %t,v,w
mod_odom(:,1) = com(:,1); %copy ALL the interleaved and sorted timestamps, that is the first column 
ptrO = remove_index + 1; %offset. pointer to the first control data point. 

%initialize the first control data point
mod_odom(1,2:3) = Robot1_Odometry(ptrO, 2:3);
ptrO = ptrO + 1;

%make the modified (interleaved) odom data
for i=1:length(mod_odom)-1
    if com(i+1,2) == 0 %if the next one is a pure measurement step, copy the previous control command
        mod_odom(i+1, 2:3) = mod_odom(i, 2:3);
    elseif com(i+1, 2) == 1%if the next one is a new control command, copy the next control command from original odom array
        mod_odom(i+1, 2:3) = Robot1_Odometry(ptrO, 2:3);
        ptrO = ptrO + 1; %increment the counter in the original odom array. 
    end
end
mod_odom = [mod_odom com(:,2)]; %combine odom data and tags for whether at a timstamp there was a measurement or not. 
%mod_odom consists of time, v, w, tags
clear com;

