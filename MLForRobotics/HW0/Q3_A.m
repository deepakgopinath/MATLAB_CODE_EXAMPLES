% loadMRCLAMdataSet; %This data loading script was downloaded from the website provided in the assigmemtn

%Robot_GroundTruth is at 100Hz and Odometry is recorded at 67Hz, at least
%according to the wesbite

%There is a mismatch between the time at which the control data is applied
%and the Groundtruth data. In order to find the starting pose of the robot
%at the time the controls are applied, I used a simple linear interpolation

%Interpolation stuff (just consider the first 100 points, for interpolation
%purposes)
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

for i=1:length(Robot1_Odometry(:,1))-1
    v = Robot1_Odometry(i,2);
    w = Robot1_Odometry(i,3);
    dt = Robot1_Odometry(i+1,1) - Robot1_Odometry(i,1);
    [pose(i+1, 1), pose(i+1,2), pose(i+1, 3)] = motion_model(pose(i,1), pose(i,2), pose(i,3), v,w, dt);
end

%Plot Stuff
figure;
%Ground Truth in BLue
x = Robot1_Groundtruth(:, 2);
y = Robot1_Groundtruth(:, 3);
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


%It can be seen that there is huge divergence between the data generated
%using the motion model and the odometry data and this is completely
%expected. The model is able to follow the odometry data somewhat closely
%in the initial stages but then begins to diverge very quickly. 
%The motion model that is used is a deterministic motion model.
%Adding Gaussian noise to model the stochasticity in the system is not
%necessarily going to generate trajectories that will be close to the
%odometry data. However, doing so will help in improving the performance
%once the entire filter is implemented. 



