% MUSI 6202 HW1(i) Time domain convolution
% Created by Chih-Wei Wu at GTCMT 2015
% Last update: 2015.01.07
% objective: This part is to implement time domain convolution
% y = myTimeConv(x, h)
% x: L*1 vector of input sequence
% h: M*1 vecotr of impulse response
% y: (L+M-1)*1 vector of output sequence

function y = myTimeConv(x, h)

% initialization 
L = size(x, 1);
M = size(h, 1);
y = zeros((L+M-1), 1);
h = flipud(h); %flip the signal for convolution

x = [zeros(M,1); x; zeros(M,1)];

for i=1:L+M-1
    y(i) = sum(x(i+1:i+1+M-1).*h);
end

% ==== write your codes here:











