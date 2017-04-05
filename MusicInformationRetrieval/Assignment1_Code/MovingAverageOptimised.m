%Q2- 1e
%submitted by Deepak Gopinath - 903014581


function output_args = MovingAverageOptimised(samples, J)

%optimised implementation of the moving average filter in which the mean is
%not calculated for the entire block. This is a recursive implementation.
% J is the block size

L = length(samples);
b = 1/J;
n = 1;
output = [];

zeropad = zeros(J-1, 1); %column vector
paddedSamples = [zeropad;samples];%column vector

while n <= L

    if(n == 1)
        output(n) = mean(paddedSamples(n:n+J-1));
    else
        output(n) = (paddedSamples(n+J-1) - paddedSamples(n-1))*b + output(n-1);
    end
    
    n = n+1;
end

%Listen to the filtered and unfiltered sounds

sound(samples, 44100);
pause on;
pause(3); %assumes the input is two second long. 
sound(output, 44100);
pause(3);
pause off;

output_args = output;


end

