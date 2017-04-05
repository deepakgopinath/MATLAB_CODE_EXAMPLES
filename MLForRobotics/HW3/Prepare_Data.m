t = Robot1_Groundtruth(:,1);
x = Robot1_Groundtruth(:,2);
y = Robot1_Groundtruth(:,3);
theta = Robot1_Groundtruth(:,4);
theta(theta < 0) = theta(theta<0) + 2*pi; %make angles from 0 to 2pi

%Odometry time stamps and velocities
tq = Robot1_Odometry(:,1);
v = Robot1_Odometry(:,2);
w = Robot1_Odometry(:,3);
deltat = diff(tq); %get the dts for each control signal

%Grab groudn truth data at odom time stamps. 
xq = interp1(t,x,tq);
yq = interp1(t,y,tq);
thetaq = zeros(length(tq),1);

%detect wrap arounds and perform interpolation properly and explicitly 
for i=1:length(tq)
    qx = tq(i); %current query point
    indl = find(t <= qx, 1, 'last' );
    indh = indl + 1;
    xl = t(indl); %find lower index 
    yl = theta(indl);
    xh = t(indh); %find higher index. 
    yh = theta(indh);
    alpha = (qx - xl)/(xh - xl);
    if abs(yh - yl) < 6
        qy = (1 - alpha)*yl + alpha*yh;
    else
        %make the larger angle wrapped back. 
        fprintf('Theta needs wrap around at data point %d\n',i);
        if yl > pi
            yl = yl - 2*pi;
        end
        if yh > pi
            yh = yh - 2*pi;
        end

        qy = (1 - alpha)*yl + alpha*yh;
        if qy < 0
            qy = qy + 2*pi;
        end
    end
    thetaq(i) = qy;
end


%Generate error in the motion model by using the deterministic motion model
%and ground truth. 
err = zeros(length(deltat), 3); 
datann1 = cell(length(deltat),2);
datann2 = cell(length(deltat),2);
datann3 = cell(length(deltat),2);
datann4 = cell(length(deltat),2);
datann5 = cell(length(deltat),2);
datann6 = cell(length(deltat),2);

for i=1:length(deltat)
    [x_new, y_new, theta_new] = motion_model(xq(i), yq(i), thetaq(i), v(i), w(i), deltat(i));
    err(i,1) = x_new - xq(i+1); err(i,2) = y_new - yq(i+1); 
    
    %compute theta error properly
    if abs(theta_new - thetaq(i+1)) < pi %no wrap around has happened. 
        err(i,3) = theta_new - thetaq(i+1); %straightforward error
    else
        temp = thetaq(i+1);
        if theta_new > 6 
            theta_new = theta_new - 2*pi;
        end
        if thetaq(i+1) > 6
            temp = temp - 2*pi;
        end
        err(i,3) = theta_new - temp ;
    end
end


%Store the ranges for the input. NEeded for query side. 
minmax_input = [min(xq) max(xq);
                min(yq) max(yq);
                min(thetaq) max(thetaq);
                min(v) max(v);
                min(w) max(w);
                min(deltat) max(deltat)];
            
%Scale all input and output in the range 0 to 1.             
xq = data_scale(xq, 0, 1.0);
yq = data_scale(yq, 0, 1.0);
thetaq = data_scale(thetaq, 0, 1.0);
v = data_scale(v, 0, 1.0);
w = data_scale(w, 0, 1.0);
deltat = data_scale(deltat, 0, 1.0);

minmax_y_err = [min(err(:,1)), max(err(:,1));
                min(err(:,2)), max(err(:,2));
                min(err(:,3)), max(err(:,3))];
            
            
err(:,1) = data_scale(err(:,1), 0, 1.0);
err(:,2) = data_scale(err(:,2), 0, 1.0);
err(:,3) = data_scale(err(:,3), 0, 1.0);



td = zeros(size(datann1,1), 6); %for multivariate historgram
%collect all variables into the data cell structure. 
for i=1:length(deltat)
    datann1{i, 1} = [xq(i), yq(i), thetaq(i), v(i), w(i), deltat(i)]';
    datann2{i, 1} = [xq(i), yq(i), thetaq(i), v(i), w(i), deltat(i)]';
    datann3{i, 1} = [xq(i), yq(i), thetaq(i), v(i), w(i), deltat(i)]';
    datann4{i, 1} = [xq(i), yq(i), thetaq(i), v(i), w(i), deltat(i)]';
    datann5{i, 1} = [xq(i), yq(i), thetaq(i), v(i), w(i), deltat(i)]';
    datann6{i, 1} = [xq(i), yq(i), thetaq(i), v(i), w(i), deltat(i)]';

    datann1{i, 2} = err(i,1)';
    datann2{i, 2} = err(i,2)';
    datann3{i, 2} = err(i,3)';
    
    td(i, :) = datann1{i, 1}'; %for multivaritae histogram purposes. 
end

%multivariate histogram
[counts,edges,mid,locs] = histcn(td);
u_locs = unique(locs, 'rows'); %identify unique bins in which there are non-zero data points
u_std = zeros(length(u_locs), 3); %for each error. 
ind_cell = cell(length(u_locs), 1);
std_data = zeros(length(td), 3); %for assisgning a variance for each error for each data points
for i=1:length(u_locs)
    index = find(ismember(locs, u_locs(i,:), 'rows')); %all the data_indices in the same voxel
    ind_cell{i} = index;
    if length(index) ~= 1
        u_std(i,:) = std(err(index, :)); %compute std of all y values belonging to one voxel. This value of std is then assigned to each one of the data points belonging to this voxel
    else
        u_std(i,:) = zeros(1,3);
    end
    std_data(index, :) = repmat(u_std(i,:), length(index), 1);
end

minmax_y_std = [min(std_data(:,1)), max(std_data(:,1));
                min(std_data(:,2)), max(std_data(:,2));
                min(std_data(:,3)), max(std_data(:,3));];
std_data(:,1) = data_scale(std_data(:,1), 0, 1.0);
std_data(:,2) = data_scale(std_data(:,2), 0, 1.0);
std_data(:,3) = data_scale(std_data(:,3), 0, 1.0);

for i=1:length(deltat)
    datann4{i, 2} = std_data(i,1)';
    datann5{i, 2} = std_data(i,2)';
    datann6{i, 2} = std_data(i,3)';
end

% save('Training_Data_nn1.mat', 'datann1');
% save('Training_Data_nn2.mat', 'datann2');
% save('Training_Data_nn3.mat', 'datann3');
% save('Training_Data_nn4.mat', 'datann4');
% save('Training_Data_nn5.mat', 'datann5');
% save('Training_Data_nn6.mat', 'datann6');
% clear data;
% save('Range_Values.mat', 'minmax_input', 'minmax_y_err', 'minmax_y_std');
