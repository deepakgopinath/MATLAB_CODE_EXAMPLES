% Q2 - 1 c,d, f

%Script to compare the two different implementations of Moving Average
%Filter. Tested with three different block sizes. 5 , 10, 200.

%Submitted by Deepak Gopinath- 903014581

x1 = rand(44100*2,1);
y1 = MovingAverageFilter(x1,5);
y1O = MovingAverageOptimised(x1, 5);

y2 = MovingAverageFilter(x1,10);
y2O = MovingAverageOptimised(x1, 10);

y3 = MovingAverageFilter(x1,200);
y3O = MovingAverageOptimised(x1, 200);

% y2 = MovingAverageOptimised(rand(44100*2,1), 10);
% y3 = MovingAverageOptimised(rand(44100*2,1), 200);

%Xaxis  = 0:1:44100*2;

subplot(3,2,1);
spectrogram(y1, hamming(256), 256-128);
subplot(3,2,2);
spectrogram(y1O, hamming(256), 256-128);
subplot(3,2,3);
spectrogram(y2, hamming(256), 256-128);
subplot(3,2,4);
spectrogram(y2O, hamming(256), 256-128);
subplot(3,2,5);
spectrogram(y3, hamming(256), 256-128);
subplot(3,2,6);
spectrogram(y3O, hamming(256), 256-128);
% subplot(3,1,2);
% spectrogram(y2, hamming(256), 256-128);
% subplot(3,1,3);
% spectrogram(y3, hamming(256), 256-128);
