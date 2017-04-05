figure;
Prepare_Data_New;
load('520161081.mat');
curr_nn = [5,20,16,10,8,1];
x_coord = zeros(size(datann1,1),1);
x_pred = zeros(size(datann1,1),1);
for i=1:size(datann1,1)
    temp = datann1{i,2};
    x_coord(i) = temp(1);
    X = datann1{i,1};
    x_pred(i) = feed_forward(X, final_w_nn1,final_b_nn1,length(curr_nn));
end
plot(x_coord,'r', 'LineWidth', 2.5);
hold on;
plot(x_pred, 'b', 'LineWidth', 1.5);
xlabel('Time Index');
ylabel('x');
title('Groundtruth vs. Neural Net Prediction (x)');
legend('Groundtruth','Prediction');
R2 = 1- sum((x_coord - x_pred).^2)/sum((x_coord - mean(x_coord)).^2);
disp(R2);
figure;
for i=1:size(datann1,1)
    temp = datann2{i,2};
    x_coord(i) = temp(1);
    X = datann2{i,1};
    x_pred(i) = feed_forward(X, final_w_nn2,final_b_nn2,length(curr_nn));
end
plot(x_coord,'r', 'LineWidth', 2.5);
hold on;
plot(x_pred, 'b', 'LineWidth', 1.5);
xlabel('Time Index');
ylabel('y');
title('Groundtruth vs. Neural Net Prediction (y)');
legend('Groundtruth','Prediction');
R2 = 1- sum((x_coord - x_pred).^2)/sum((x_coord - mean(x_coord)).^2);
disp(R2);
figure;
for i=1:size(datann1,1)
    temp = datann3{i,2};
    x_coord(i) = temp(1);
    X = datann3{i,1};
    x_pred(i) = feed_forward(X, final_w_nn3,final_b_nn3,length(curr_nn));
end
plot(x_coord,'r', 'LineWidth', 2.5);
hold on;
plot(x_pred, 'b', 'LineWidth', 1.5);
xlabel('Time Index');
ylabel('\theta');
title('Groundtruth vs. Neural Net Prediction (\theta)');
legend('Groundtruth','Prediction');

R2 = 1- sum((x_coord - x_pred).^2)/sum((x_coord - mean(x_coord)).^2);
disp(R2);