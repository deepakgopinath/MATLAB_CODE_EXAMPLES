function [ ] = plot_error(error, test, final_w, final_b, d1, d2, num_neuron_layers, z_label)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

out = zeros(size(test,1), 1);
x = zeros(size(test,1), 5); %always six dimensional
y = zeros(size(test,1), 1);
for i=1:round(0.8*size(test,1))
    x(i, :) = test{i,1}';
    out(i) = feed_forward(x(i, :)', final_w,final_b,length(num_neuron_layers));
    y(i) = test{i,2};
end
figure;
hold on; grid on;
scatter3(x(:,d1), x(:,d2), y, 'k'); hold on;
title('Test (Black) and Predictions (Red)');
xlabel('Theta');
ylabel('Omega');
zlabel(z_label);
scatter3(x(:,d1), x(:,d2), out, 'r'); 


figure;
plot(error);
title('MSE Error on Test Set');
xlabel('Epoch Number');
ylabel('Error');
grid on;
end

