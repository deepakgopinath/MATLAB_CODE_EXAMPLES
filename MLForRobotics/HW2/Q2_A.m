% gen_test_data;
% gen_test_data_other;

%permute data set. 
data = data(randperm(size(data,1)), :);

%use 75% for training and 25% for testing. 
training = data(1:round(0.75*length(data)), :);
test = data(end-round(0.25*length(data)):end, :);

%3 layer network. 
num_neuron_layers = [1,10,1]; %specify net structure by a vector. Num of elements is the num of layers.
%ith element is the num of units in the ith layer. 

%train network and retrieve final weight and bias matrices. 500 epochs and
%3.0 is the learning rate. 
[final_w, final_b, error] = neural_network(num_neuron_layers, training, test, 1000, 3.0);

%plot error and prediction
% plot_error_prediction;