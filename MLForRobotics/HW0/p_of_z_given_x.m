function [ q ] = p_of_z_given_x( measurement, landmark_pose, current_pose, meas_params)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

x = current_pose(1); y = current_pose(2); theta = current_pose(3);
r = measurement(1); phi = measurement(2);

%the values the sensors are SUPPOSED to see
r_cap = sqrt((landmark_pose(1) - x)^2 + (landmark_pose(2) - y)^2); 
phi_cap = atan2(landmark_pose(2) - y, landmark_pose(1) - x) - theta;

%likelihood of the sensor seeing r and phi is q. 
pr = prob(r-r_cap, meas_params(1));
pphi = prob(phi-phi_cap, meas_params(2));
q = pr*pphi;

end

function p = prob(a, sigma)
    p = (1/sqrt(2*pi*sigma^2))*exp((-1/2.0)*(a^2/sigma^2));
end

% function p = prob(a, sigma)
%     if abs(a) > 0
%         p = 0;
%     else
%         p = (sqrt(6*sigma^2) - abs(a))/(6*sigma^2);
%         
%     end
% end
