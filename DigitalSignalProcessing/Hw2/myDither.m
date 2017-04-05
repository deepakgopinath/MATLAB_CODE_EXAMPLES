% MUSI 6202 HW3 Dither
% Created by Chih-Wei Wu at GTCMT 2015
% Last update: 2015.02.04
% objective: implement dither + quantization 
% y = myDither(x, nbits, noiseType)
% x = N*1 vector of signal
% w = integer, target word length
% noiseType = string, available options: 'rect', 'tri', 'hp'

function y = myDither(x, w, noiseType)

% initialization 
N = length(x);
y = zeros(N, 1);
ditherNoise = myNoiseGen(N, w, noiseType);
x = x + ditherNoise;
y = myQuantize(x, w);
% write your code here


