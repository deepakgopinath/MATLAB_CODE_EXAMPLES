%Simple Moving Average Filter - Q 2 a,b,c
%Submitted by Deepak Gopinath - 903014581

function [ output_args ] = MovingAverageFilter(samples, J)
%Implementation of Moving Average Filter using MatLab's mean function;

%samples = rand(44100*2, 1); %2 seconds of white noise in samples. %column
%J is the block size.
L = length(samples);
n = 1;

output = [];
zeropad = zeros(J-1, 1); %column vector

paddedSamples = [zeropad;samples]; %column vector, prepend input vector with J-1 zeros
%
while n <= L 
    output(n) = mean(paddedSamples(n:n+J-1));
    n = n+1;
end

%Hear the unfiltered noise and filter noise one after the other

sound(samples, 44100);
pause on;
pause(3); %assuming the input sample is 2 seconds long. 
sound(output, 44100);
pause(3);
pause off;

output_args = output;
end



