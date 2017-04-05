function [ v_new ] = v_gen( v_curr, a, dt )
%input: current  velocity - v_curr,  accel - a and
%duration - dt
%output: new  velocity

v_new = v_curr + a*dt;
end

