function [ w_new ] = w_gen( w_curr, alpha, dt)
%input: current angular velocity - w_curr, angular accel - alpha and
%duration - dt
%output: new angular velocity

w_new = w_curr + alpha*dt;

end

