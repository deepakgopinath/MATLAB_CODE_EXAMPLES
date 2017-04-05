function [x_new, y_new, theta_new] = motion_model(x,y,theta, v, w, t)
%Inputs - Current pose - x,y,theta, Control Velocities - v
%(translational),w (rotational) and Time for which the control is applied
%-t

%Outputs - The new pose x_new, y_new, theta_new

%This motion model right now is deterministic. Will be made stochastic
%when the complete filter is implemented. 

if t == 0 %when the time duraction is 0, nothing has changed
    x_new = x;
    y_new = y;
    theta_new = theta;
    return;
end

if w ~= 0 %pure rotation and both trans and rotation
    x_new = x - (v/w)*sin(theta) + (v/w)*sin(theta + w*t);
    y_new = y + (v/w)*cos(theta) - (v/w)*cos(theta + w*t);
    theta_new = theta + w*t;
else %pure translation w = 0
    x_new = x + v*t*cos(theta);
    y_new = y + v*t*sin(theta);
    theta_new = theta;
end
    


end

