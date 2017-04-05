function [ r, phi ] = measurement_model(x,y,theta,landmark_pose)
%This function takes in the current robot pose [x,y,theta and the
%landmark_pose and then outputs the deterministic measurements. This is
%purely based on geometrical consideration. during the implementation of
%the full filter, the randomness in the sensors will be captured by adding
%noise to the model. The variance of this noise can be computed by looking
%at the statistics of the error in the measurements and ground truth.



%The range and the bearing can be computed using the following formula
%which can easily be derived using trig and geometry.


r = sqrt((landmark_pose(1) - x)^2 + (landmark_pose(2) - y)^2);
phi = atan2(landmark_pose(2) - y, landmark_pose(1) - x) - theta;

end

