function [ v, w ] = ik_controller( x_c, y_c, theta_c, x_g, y_g )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Input = current pose -x_c,y_c,theta_c (in degrees)
%output position = x_g, y_g

%Output = List of v and omega (in rad/s) that will achieve this at a sampling rate of
%dt =0.1
v = [];
w = [];
%setup waypoints
waypoints = zeros(2,2); %for start and end positions
waypoints(1,:) = [x_c,y_c];
waypoints(2,:) = [x_g,y_g];
angles = zeros(2,1);
angles(1) = theta_c;
angles(2) = rad2deg(atan2(waypoints(2,2) - waypoints(1,2), waypoints(2,1) - waypoints(1,1)));

dt = 0.1; %to be used later. 
alpha_max = 5.579*0.02; %rad/s^2
a_max = 0.288; %m/s^2 %given

%check if the current heading is already in the direction of x_g,y_g, if so
%only translational is required. 

if rad2deg(atan2(y_g - y_c, x_g - x_c)) == theta_c
    trans_dist = norm([x_g, y_g] - [x_c, y_c]);
    ind = 1;
    v(ind) = 0; w(ind) = 0;
    T = 2*sqrt((trans_dist)/(a_max));
    curr_t = 0;
    while curr_t < T %make piecewise linear vel profile
        if curr_t < (T/2)
            v(ind+1) = v_gen(v(ind), a_max, dt); %bang up
        else
            v(ind+1) = v_gen(v(ind), -a_max, dt); %bang down
        end
        w(ind+1) = 0; %no rotation
        ind = ind + 1; 
        curr_t = curr_t + dt;
    end
else
    %compute intermediate poses
    angles = [angles, angles]';
    angles = angles(:);
    angles(1) = [];
    wp_temp = kron(waypoints, ones(2,1));
    wp_temp(end, :) = [];
    final_wp = [wp_temp, angles];
    trans_dist = zeros(size(final_wp, 1) -1 , 1);
    rot_dist = zeros(size(final_wp, 1)-1,1);
    for i=1:size(final_wp,1)-1
        trans_dist(i) = norm(final_wp(i+1,1:2) - final_wp(i,1:2));
        rot_dist(i) = final_wp(i+1,3) - final_wp(i,3);
    end
    comb_list = [trans_dist, rot_dist];
    comb_list = comb_list(any(comb_list,2), :); %remove empty rows
    ind = 1;
    v(ind) = 0; w(ind) = 0;

    
    for i=1:size(comb_list,1)
        curr_t = 0;
        if comb_list(i,1) == 0 %pure rotation
            s = sign(comb_list(i,2));
            T = 2*sqrt(deg2rad(comb_list(i,2))/(s*alpha_max)); %Time for application of pure rotation
            while curr_t < T
                if curr_t < (T/2)
                    w(ind+1) = w_gen(w(ind), s*alpha_max, dt); %bang up
                else
                    w(ind+1) = w_gen(w(ind), -s*alpha_max, dt); %bang down
                end
                v(ind+1) = 0; %no translation
                ind = ind + 1;
                curr_t = curr_t + dt;
            end
        end
        if comb_list(i,2) == 0 %pure translation
            s = sign(comb_list(i,1));
            T = 2*sqrt(comb_list(i,1)/(s*a_max));
            while curr_t < T
                if curr_t < (T/2)
                    v(ind+1) = v_gen(v(ind), s*a_max, dt); %bang up
                else
                    v(ind+1) = v_gen(v(ind), -s*a_max, dt); %bang down
                end
                w(ind+1) = 0; %no rotation
                ind = ind + 1; 
                curr_t = curr_t + dt;
            end
        end
        
    end
%     disp('Heading not aligned in the direction of goal');
    
end


end

