% datann1 = datann1(randperm(size(datann1,1)), :);
% datann2 = datann2(randperm(size(datann2,1)), :);
% datann3 = datann3(randperm(size(datann3,1)), :);
datann4 = datann4(randperm(size(datann4,1)), :);
% datann5 = datann5(randperm(size(datann5,1)), :);
% datann6 = datann6(randperm(size(datann6,1)), :);
% 
% training_nn1 = datann1(1:round(0.75*length(datann1)), :);
% test_nn1 = datann1(end-round(0.25*length(datann1)):end, :);
% training_nn2 = datann2(1:round(0.75*length(datann2)), :);
% test_nn2 = datann2(end-round(0.25*length(datann2)):end, :);
% training_nn3 = datann3(1:round(0.75*length(datann3)), :);
% test_nn3 = datann3(end-round(0.25*length(datann3)):end, :);

training_nn4 = datann4(1:round(0.75*length(datann4)), :);
test_nn4 = datann4(end-round(0.25*length(datann4)):end, :);
% training_nn5 = datann5(1:round(0.75*length(datann5)), :);
% test_nn5 = datann5(end-round(0.25*length(datann5)):end, :);
% training_nn6 = datann6(1:round(0.75*length(datann6)), :);
% test_nn6 = datann6(end-round(0.25*length(datann6)):end, :);


% %ANN 1 - FOR DELTAX LEARNING
% %input dimension is always going to be 6. output is  going to be 1.


% num_neuron_layers = [6,16,16,1]; %specify net structure by a vector. Num of elements is the num of layers.
% % ith element is the num of units in the ith layer. 

% [final_w_nn1, final_b_nn1, error_nn1] = neural_network(num_neuron_layers, training_nn1, test_nn1, 80, 3.0);
% plot_error(error_nn1, test_nn1, final_w_nn1, final_b_nn1, 1,2, num_neuron_layers); %x,y vs deltax
% save('6_16_16_1_err1_CE.mat', 'final_w_nn1', 'final_b_nn1', 'error_nn1');

% %ANN 2 - FOR DELTAY LEARNING
% % 
% [final_w_nn2, final_b_nn2, error_nn2] = neural_network(num_neuron_layers, training_nn2, test_nn2, 80, 4.0);
% plot_error(error_nn2, test_nn2, final_w_nn2, final_b_nn2, 1,2, num_neuron_layers);
% save('6_16_16_1_err2_CE.mat', 'final_w_nn2', 'final_b_nn2', 'error_nn2');
% 
% num_neuron_layers = [6,20,10,10,8,1]; 
% [final_w_nn3, final_b_nn3, error_nn3] = neural_network(num_neuron_layers, training_nn3, test_nn3, 150, 3.0);
% plot_error(error_nn3, test_nn3, final_w_nn3, final_b_nn3, 1,2, num_neuron_layers);
% save('6_20_10_10_8_1_err3_CE.mat', 'final_w_nn3', 'final_b_nn3', 'error_nn3');
% 
% 
num_neuron_layers = [6,10,10,8,1];
[final_w_nn4, final_b_nn4, error_nn4] = neural_network(num_neuron_layers, training_nn4, test_nn4, 200, 3.0);
plot_error(error_nn4, test_nn4, final_w_nn4, final_b_nn4, 1,2, num_neuron_layers);
% save('6_10_10_8_1_std1_CE.mat', 'final_w_nn4', 'final_b_nn4', 'error_nn4');

% [final_w_nn5, final_b_nn5, error_nn5] = neural_network(num_neuron_layers, training_nn5, test_nn5, 150, 3.0);
% plot_error(error_nn5, test_nn5, final_w_nn5, final_b_nn5, 1,2, num_neuron_layers);
% save('6_10_10_8_1_std2_CE.mat', 'final_w_nn5', 'final_b_nn5', 'error_nn5');
% 
% [final_w_nn6, final_b_nn6, error_nn6] = neural_network(num_neuron_layers, training_nn6, test_nn6, 150, 3.0);
% plot_error(error_nn6, test_nn6, final_w_nn6, final_b_nn6, 1,2, num_neuron_layers);
% save('6_10_10_8_1_std3_CE.mat', 'final_w_nn6', 'final_b_nn6', 'error_nn6');