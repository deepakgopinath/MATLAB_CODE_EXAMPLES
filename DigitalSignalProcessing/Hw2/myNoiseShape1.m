% MUSI 6202 HW3 1st order noise shaping
% Created by Chih-Wei Wu at GTCMT 2015
% Last update: 2015.02.04
% objective: implement 1st order noise shaping
% y = myNoiseShape1(x, nbits, noiseType)
% x = N*1 vector, input signal
% w = integer, target word length
% noiseType = string, 'rect', 'tri', 'hp'

function y = myNoiseShape1(x, w, noiseType)

% initialization 
N = length(x);
y = zeros(N, 1);
%this is all wrong...
% % ditherNoise = myNoiseGen(N+1,w,noiseType);
% ditherNoise = myNoiseGen(N, w, noiseType);
% ditherNoise = [ditherNoise(1); ditherNoise];
% filtereddNoise = diff(ditherNoise);
% qX = myQuantize(x, w);
% q = qX - x; %this is wrong, because the quantization error is also dependent on the output
% % q = [q(1);q]; q = diff(q);
% q = [q(1);q]; q = diff(q);
% y = x + q + filtereddNoise;
d = myNoiseGen(N,w,noiseType);
e = zeros(N,1);
y(1) = myQuantize(x(1) + d(1), w);
e(1) = y(1)-x(1);
for i=2:N
     y(i) = myQuantize(x(i) + d(i) - e(i-1) - d(i-1), w);
     e(i) = y(i) - x(i);   
end
end
% write your code here



