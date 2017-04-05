function [ output_args ] = testConvCorr( file)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

x = audioread(file);
L = length(x);

y = conv(x,x);


X = fft(x);

Y = X.*X;

xx = real(ifft(Y));
figure;
plot(x/44100.0);
hold on;
plot(y,'r');
hold off;
title('Signal and filtered signal');
end

