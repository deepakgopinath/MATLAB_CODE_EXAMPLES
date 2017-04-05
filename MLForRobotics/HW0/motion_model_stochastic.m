function [ x_new, y_new, theta_new ] = motion_model_stochastic(x,y,theta, v, w, dt, params)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    if dt == 0 %when the time duraction is 0, nothing has changed
        x_new = x;
        y_new = y;
        theta_new = theta;
        return;
    end
    a = zeros(length(params),1);
    for i=1:length(params)
        a(i) = params(i);
    end

    v_bar = v + sample(a(1)*v^2 + a(2)*w^2);
    w_bar = w + sample(a(3)*v^2 + a(4)*w^2);
    gamma_bar = sample(a(5)*v^2 + a(6)*w^2);

    v = v_bar;
    w = w_bar;
    gamma = gamma_bar;

    if w ~= 0 %pure rotation and both trans and rotation
        x_new = x - (v/w)*sin(theta) + (v/w)*sin(theta + w*dt);
        y_new = y + (v/w)*cos(theta) - (v/w)*cos(theta + w*dt);
        theta_new = theta + w*dt + gamma*dt;
    else %pure translation w = 0
        x_new = x + v*dt*cos(theta);
        y_new = y + v*dt*sin(theta);
        theta_new = theta +gamma*dt;
    end
end

%normal distribution. can probably use normrnd directly. 
function a = sample(b_squared)
    b = sqrt(b_squared);
    a = 0.5*(sum(-b + (2*b)*rand(12,1)));
end

