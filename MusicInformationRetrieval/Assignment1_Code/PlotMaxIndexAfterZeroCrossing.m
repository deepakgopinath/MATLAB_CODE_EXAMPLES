%Function to take a file, windowSize and hopSize, calculate the correlation
%function using the freqDomainACF function and then calculate the index for
%the max value after the first zero crossing for each block.

%Submitted by Deepak Gopinath -  903014581

function [ output_args ] = PlotMaxIndexAfterZeroCrossing( file, windowSize, hopSize )


ACFMatrix = freqDomainACF(file, windowSize, hopSize); %ACFMatrix - number of rows = number of blocks, 
                                                                                    %ACFMatrix - number
                                                                                    %of columns =
                                                                                    %windowSize-1 Only
                                                                                    %one side of the
                                                                                    %correlation matrix
                                                                                    %is required for peak
                                                                                    %calc because of the
                                                                                    %symmetry about 0.
[indexArray, rows] = MaxValueCalcAfterFirstZeroCrossing(ACFMatrix);
samples = audioread(file);
L = length(samples);
x = (0:1:rows-1);

figure;
plot(x,indexArray, 'Color', 'red');
xlabel('Block number')
ylabel('Max value index after 1st crossing');
end

