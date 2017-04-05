datann1 = datann1(randperm(size(datann1,1)), :);
datann2 = datann2(randperm(size(datann2,1)), :);
datann3 = datann3(randperm(size(datann3,1)), :);
% datann4 = datann4(randperm(size(datann4,1)), :);
% datann5 = datann5(randperm(size(datann5,1)), :);
% datann6 = datann6(randperm(size(datann6,1)), :);
% 
training_nn1 = datann1(1:round(0.75*length(datann1)), :);
test_nn1 = datann1(end-round(0.25*length(datann1)):end, :);
training_nn2 = datann2(1:round(0.75*length(datann2)), :);
test_nn2 = datann2(end-round(0.25*length(datann2)):end, :);
training_nn3 = datann3(1:round(0.75*length(datann3)), :);
test_nn3 = datann3(end-round(0.25*length(datann3)):end, :);

num_neuron_layers = {[5,20,1],[5,16,1],[5,10,1],[5,8,1], [5,20,16,1],[5,16,10,1],[5,10,8,1], [5,20,16,10,1], [5,16,10,8,1], [5,20,16,10,8,1]};
learning_rate = [0.1,1,3.0];
mse_err_list = zeros(size(num_neuron_layers,2),length(learning_rate), 3);
count = 1;
for i=1:size(num_neuron_layers,2)
    curr_nn = num_neuron_layers{i};
    for j=1:length(learning_rate)
        fprintf('################');
        fprintf('RUN NUMBER %d\n', count);
        count = count + 1;
        fprintf('################');
        %jumble data before every run
        datann1 = datann1(randperm(size(datann1,1)), :);
        datann2 = datann2(randperm(size(datann2,1)), :);
        datann3 = datann3(randperm(size(datann3,1)), :);
        training_nn1 = datann1(1:round(0.75*length(datann1)), :);
        test_nn1 = datann1(end-round(0.25*length(datann1)):end, :);
        training_nn2 = datann2(1:round(0.75*length(datann2)), :);
        test_nn2 = datann2(end-round(0.25*length(datann2)):end, :);
        training_nn3 = datann3(1:round(0.75*length(datann3)), :);
        test_nn3 = datann3(end-round(0.25*length(datann3)):end, :);

        eta = learning_rate(j);
        [final_w_nn1, final_b_nn1, error_nn1] = neural_network(curr_nn, training_nn1, test_nn1, 100, eta);
        [final_w_nn2, final_b_nn2, error_nn2] = neural_network(curr_nn, training_nn2, test_nn2, 100, eta);
        [final_w_nn3, final_b_nn3, error_nn3] = neural_network(curr_nn, training_nn3, test_nn3, 100, eta);
        
        mse_err_list(i,j,1) = error_nn1(end);
        mse_err_list(i,j,2) = error_nn2(end);
        mse_err_list(i,j,3) = error_nn3(end);
    end   
end
save('MSE_Values', 'mse_err_list');