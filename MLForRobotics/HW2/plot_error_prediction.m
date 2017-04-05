out = zeros(size(test,1), 1);
x = zeros(size(test,1), 1); 
y = zeros(size(test,1), 1);
for i=1:size(test,1)
    x(i, :) = test{i,1}';
    out(i) = feed_forward(x(i, :)', final_w,final_b,length(num_neuron_layers));
    y(i) = test{i,2};
end
figure;
hold on; grid on;
scatter(x(:,1), y,'k'); hold on;
title('Training (Black) and Predictions (Red)');
xlabel('X');
ylabel('Y');
scatter(x(:,1), out, 'r'); 


figure;
plot(error);
title('Cross Entropy Error in Prediction');
xlabel('Epoch Number');
ylabel('Error');
grid on;


