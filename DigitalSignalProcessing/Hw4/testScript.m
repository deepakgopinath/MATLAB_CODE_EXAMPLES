% clear all;clc;
% %Q1
% %generate rectangular waveform of length 1s, at 44100Hz with 10%duty cycle
% sr = 44100;totalTime = 1;dutyCycle = 0.1;
% rectWave = ones(sr*totalTime,1);
% time = 0:1/sr:totalTime;time(end) = [];
% rectWave(dutyCycle*length(rectWave)+1:end) = 0;
% 
% rectWaveRMS = myRmsMeasure(rectWave,sr,100);
% figure;
% plot(time,rectWave);hold on; plot(time,rectWaveRMS,'r');
% 
% % Q2
% 
% [samples, sr] = audioread('sv44_short.wav');
% xPeak = myPeakMeasure(samples, sr, 1, 100);
% Flog = myStaticCurve(log2(xPeak), 1, -3);
% figure;
% plot(xPeak,'r');hold on;plot(2.^Flog);
% 
% %Q3
% figure;
% yLimiter = myDynamic(samples,sr,-3,1,1,100,0,'peak');
% plot(samples);hold on;plot(yLimiter,'r');

%Q4
figure;
[samplesStereo, sr] = audioread('sv_stereo_11sec.wav');
yLimiterStereo = myDynamicStereo(samplesStereo, sr, -3,1,1,100,0,'peak');
subplot(2,1,1);
plot(samplesStereo(:,1));hold on; plot(yLimiterStereo(:,1),'r');
subplot(2,1,2);
plot(samplesStereo(:,2)); hold on; plot(yLimiterStereo(:,2), 'r');
%Q5
% figure;
% yCompressor = myDynamic(samples,sr,-3,0.75,1,100,100,'rms');
% plot(samples);hold on; plot(yCompressor,'r');
