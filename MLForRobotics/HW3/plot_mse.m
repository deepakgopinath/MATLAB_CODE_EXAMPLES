load('MSE_Values.mat');
figure;
colors = {'r', 'g', 'b'};
for i=1:3
    plot(mse_err_list(:,i,1), colors{i}, 'LineWidth', 2.5); hold on; grid on;
end
title('MSE error on x prediction ');
xlabel('Architecture type index');
ylabel('MSE Error - x');
legend('\eta = 0.1','\eta = 1.0','\eta = 3.0');
figure;
for i=1:3
    plot(mse_err_list(:,i,2), colors{i},'LineWidth', 2.5); hold on; grid on;
end
title('MSE error on y prediction ');
xlabel('Architecture type index');
ylabel('MSE Error - y');
legend('\eta = 0.1','\eta = 1.0','\eta = 3.0');
figure;
for i=1:3
    plot(mse_err_list(:,i,3), colors{i},'LineWidth', 2.5); hold on; grid on;
end
title('MSE error on \theta prediction');
xlabel('Architecture type index');
ylabel('MSE Error - theta');
legend('\eta = 0.1','\eta = 1.0','\eta = 3.0');