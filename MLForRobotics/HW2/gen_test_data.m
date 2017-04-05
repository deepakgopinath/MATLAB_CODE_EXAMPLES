%Script for generating a polynomial for training the net. 

x = linspace(-4*pi, 4*pi, 500);
y = x.^3  + 150*randn(size(x)); %cubic polynomial with gaussian noise. 
% y = sin(x) +0.2*randn(size(x));

%scale between 0-1
x = data_scale(x, 0, 1.0);
y =  data_scale(y, 0, 1.0);
% plot(x, y);
data = cell(length(x), 2);
for i=1:length(x)
    data{i, 1} = x(i);
    data{i, 2} = y(i);
end
