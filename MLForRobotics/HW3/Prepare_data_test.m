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

next_state = zeros(length(deltat), 3); %x'y,y',theta'
datann1 = cell(length(deltat),2); %one for each x', y', theta'
datann2 = cell(length(deltat),2);
datann3 = cell(length(deltat),2);

for i=1:length(deltat)
    next_state(i,1) = xq(i+1); next_state(i,2) = yq(i+1); next_state(i,3) = thetaq(i+1);
end

minmax_input = [min(xq) max(xq);
                min(yq) max(yq);
                min(thetaq) max(thetaq);
                min(v) max(v);
                min(w) max(w)
                ];
            
minmax_y_ns = [min(next_state(:,1)), max(next_state(:,1));
                min(next_state(:,2)), max(next_state(:,2));
                min(next_state(:,3)), max(next_state(:,3))];
            
%Scale all input and output in the range 0 to 1.             
% xq = data_scale(xq, 0, 1.0);
% yq = data_scale(yq, 0, 1.0);
% thetaq = data_scale(thetaq, 0, 1.0);
% v = data_scale(v, 0, 1.0);
% w = data_scale(w, 0, 1.0);

thetaq = data_scale_new(thetaq, min(thetaq) - 2, max(thetaq)+2, 0, 1);
w = data_scale_new(w, min(w) - 2.5, max(w) + 2.5, 0, 1.0);

% next_state(:,1) = data_scale(next_state(:,1), 0, 1.0);
% next_state(:,2) = data_scale(next_state(:,2), 0, 1.0);
% next_state(:,3) = data_scale(next_state(:,3), 0, 1.0);

next_state(:,3) = data_scale_new(next_state(:,3), min(next_state(:,3)) - 2, max(next_state(:,3))+2, 0, 1);

for i=1:length(deltat)
    datann1{i, 1} = [thetaq(i),w(i)]';
    
    
    datann1{i, 2} = next_state(i,3)';
%     datann2{i, 2} = next_state(i,2)';
%     datann3{i, 2} = next_state(i,3)';
end
