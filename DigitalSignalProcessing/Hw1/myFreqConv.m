% MUSI 6202 HW1(ii) Frequency domain convolution
% Created by Chih-Wei Wu at GTCMT 2015
% Last update: 2015.01.07
% objective: This part is to implement frequency domain convolution 
% y = myFreqConv(x, h)
% x: L*1 vector of input sequence
% h: M*1 vecotr of impulse response
% y: (L+M-1)*1 vector of output sequence

function y = myFreqConv(x, h)

% initialization 
tic;
L = size(x, 1);
M = size(h, 1);
y = zeros((L+M-1), 1);

h = [h ; zeros(L-1,1)];
x = [x ; zeros(M-1,1)];

fftX = fft(x);
fftH = fft(h);

fftY = fftX.*fftH;
y = ifft(fftY);
toc;
% ==== write your codes here:
