function [ w_matrix, b_matrix, error] = neural_network(num_neuron_layers, training_data, test_data, epochs, eta)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    num_layers = length(num_neuron_layers);
    error = zeros(epochs, 1); %for storing average error for every epoch. 
    %initialize random biases and weights
    b_cells = cell(1, num_layers-1);
    for i=1:size(b_cells,2) %start counting the bias index form layer 2. layer 2 is cell 1
        b_cells{i} = randn(num_neuron_layers(i+1), 1); 
    end
    w_cells = cell(1, num_layers-1);
    for i=1:size(w_cells, 2)
        w_cells{i} = randn(num_neuron_layers(i+1), num_neuron_layers(i));
    end
    y_cap = zeros(size(test_data,1),1);
    err_list = zeros(size(test_data,1),1);
    
    for k=1:epochs
        training_data = training_data(randperm(size(training_data,1)), :); %shuffle the training data every epoch
        for i=1:size(training_data,1)
            x = training_data{i, 1};
            y = training_data{i, 2};
            %back propagation
            [d_nb, d_nw] =  backprop(x,y,w_cells, b_cells, num_layers, num_neuron_layers); %Compute gradients using backpropagation
            %update the weights and biases after every sample. 
            for j=1:num_layers-1
                b_cells{j} = b_cells{j} - eta*d_nb{j};
                w_cells{j} = w_cells{j} - eta*d_nw{j};
            end
        end
        w_matrix = w_cells;
        b_matrix = b_cells;
        
        %evaluate on test data. 
        for i=1:size(test_data, 1)
            y = feed_forward(test_data{i,1}, w_cells, b_cells, num_layers);
            err_list(i) = (y - test_data{i,2}).^2; %Uncomment for mean
%             squared error. 
%             err_list(i) = -test_data{i,2}*log(y) - (1 - test_data{i,2})*log(1-y);  %cross entropy cost function
        end
        error(k) = mean(err_list);
        fprintf('Epoch %d, Mean Error = %9.8f \n', k, error(k));
    end
end


function [d_nb, d_nw] = backprop(x,y, w_cells, b_cells, num_layers, num_neuron_layers) %for one example. Need the current weights and biases. 
    %x will be k by 1 
    % y will be real
    nabla_b = cell(1, num_layers-1); %gradients
    nabla_w = cell(1, num_layers-1);
    for j=1:num_layers-1
        nabla_b{j} = zeros(num_neuron_layers(j+1), 1);
        nabla_w{j} = zeros(num_neuron_layers(j+1), num_neuron_layers(j));
    end
    %forward pass
    
    acts = cell(1, num_layers);
    acts{1} = x; % k by 1
    act = x;
    zs = cell(1, num_layers-1);
    for i=1:num_layers-1
        b = b_cells{i};
        w = w_cells{i};
        z = w*act + b;
        zs{i} = z;
        act = sigmoid(z); 
        acts{i+1} = act;
    end
    
    
    %backward pass
    delta = (acts{end} - y).*sigmoid_prime(zs{end}); %outer layer delta. 
    nabla_b{end} = delta;
    nabla_w{end} = delta*acts{end-1}';
    for j=1:num_layers-2
        z = zs{end-j};
        sp = sigmoid_prime(z);
        delta = (w_cells{end-j+1}'*delta).*sp;
        nabla_b{end-j} = delta;
        nabla_w{end-j} = delta*acts{end-j-1}';
    end
    d_nb = nabla_b;
    d_nw = nabla_w;
    
end

function sigz = sigmoid(z)
    sigz = 1.0./(1.0 +  exp(-z));
end

function sigpz = sigmoid_prime(z)
    sigpz = sigmoid(z).*(1 - sigmoid(z));
end
