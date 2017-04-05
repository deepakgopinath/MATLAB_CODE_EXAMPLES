% clear; 
% clc;
% syms t st T
loadRobotDescription;
n = 6;
theta_s = zeros(n,1);
theta_end = (pi/2)*ones(6,1);
T = 1;
N = 1001; %for a timestep of 0.001
step = T/(N-1);
t = (0:step:T)';
tsMethod = 5 ; %Quintic;

%Hard coding Quintic velocities and Accelerations
velScale = ((30/(T^3))*(t.^2) + (-60/(T^4))*(t.^3) + (30/(T^5))*(t.^4));
velScale = repmat(velScale, 1, n);
accelScale = ((60/(T^3))*(t.^1) + (-180/(T^4))*(t.^2) + (120/(T^5))*(t.^3));
accelScale = repmat(accelScale, 1, n);
diffAngMatrix = repmat((theta_end-theta_s)', size(velScale, 1), 1);

jAng = JointTrajectory(theta_s, theta_end, T, N, tsMethod);
jVel = velScale.*diffAngMatrix;
jAccel = accelScale.*diffAngMatrix;

%Q3, position, velocity and accelerations of joint
plot(jAng(:,1)); %this is a row vector, but will be made into a col vector in the inversedynamics function
title('Joint Angle Trajectory'); xlabel('Time steps'); ylabel('Angle in rad');
figure;
plot(jVel(:,1));
title('Joint Angle Velocity'); xlabel('Time steps'); ylabel('Velocity in rad/s');
figure;
plot(jAccel(:,1));
title('Joint Angle Accelerations'); xlabel('Time steps'); ylabel('Accelerations in rad/s^2');

g =[0,0,-9.81];
FTipList = zeros(N, 6); %row vector of spatial force

torqueMat = InverseDynamicsTrajectory(jAng, jVel, jAccel, FTipList,g,Mrel,G, S);
figure;
for i=1:n
    hold on;
    plot(torqueMat(:,i), 'Color', rand(3,1)); 
end
title('Joint Torques for UR5'); xlabel('Time steps'); ylabel('Joint Torques in Nm');
%test individual components
% massMatrix = InertiaMatrix(jAng(300, :), Mrel, G, S);
% cf = CoriolisForces(jAng(300,:), jVel(300,:), Mrel, G,S);
% gf = GravityForces(jAng(300,:), g, Mrel, G, S);
% eef = EndEffectorForces(jAng(300,:),2*ones(6,1), Mrel, G, S);


%Q4
torqueMat = 2*ones(N, n); %Set torques 2 Nm for each joint
[theta_mat, thetad_mat] = ForwardDynamicsTrajectory(jAng(1,:), jVel(1,:), torqueMat, FTipList, Mrel, G, S, T);
figure;
for i=1:n
    hold on;
    plot(theta_mat(:,i), 'Color', rand(3,1)); 
end
title('Joint Angles for 2Nm torque'); xlabel('Time steps'); ylabel('Angle in rad');
