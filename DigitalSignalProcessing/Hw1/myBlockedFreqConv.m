% MUSI 6202 HW1(iv) signal blocked Freq domain convolution 
% Created by Chih-Wei Wu at GTCMT 2015
% Last update: 2015.01.07
% objective: This part is to implement frequency domain convolution 
%            with signal partitioned into non-overlapping blocks 
% y = myTimeConv(x, h)
% x: N*1 vector of input sequence
% h: M*1 vecotr of impulse response
% y: (N+M-1)*1 vector of output sequence

function y = myBlockedFreqConv(x, h)

% initialization 
tic;
L = size(x, 1);
M = size(h, 1);
y = zeros((L+M-1), 1);

numLastBlock = mod(L,M); %to check for the last block. 
if(numLastBlock ~= 0)
   x = [x ; zeros(M - numLastBlock, 1)]; %zero pad to complete the last block
end
y = zeros((length(x) + M - 1), 1);
xBlock = zeros(2*M - 1, 1); % preallocate blocked signal
h = [h ; zeros(M-1,1)]; %zero pad impulse
fftH = fft(h); %calculate fft of impulse once and for all.

index = 1;
for i=1:M:length(x)
    xBlock(1:M) = x(i:i+M-1); %populate the first M samples of the vector with the block. 
    fftXBlock = fft(xBlock);
    fftYBlock = fftXBlock.*fftH;
    yBlock = ifft(fftYBlock);
    y(M*(index-1) + 1: M*(index+1) - 1) = y(M*(index-1) + 1: M*(index+1) - 1) + yBlock;
    index = index + 1;
end
y = y(1:L+M-1); %remove trailing zeros;
toc;
end
% ==== write your codes here:












