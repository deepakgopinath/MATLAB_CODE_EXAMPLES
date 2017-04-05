clear;
clc;
close all;

n = 512;
fs = 48000;
%% shelving filter

a1 = -1.69065929318241;
a2 = 0.73248077421585;

b0 = 1.53512485958697;
b1 = -2.69169618940638;
b2 = 1.19839281085285;

b = [b0, b1, b2];
a = [1, a1, a2];

[h,w] = freqz(b,a,n,fs);
semilogx(w/pi, 20*log10(abs(h)));
title('Stage 1: Shevling Filter');
xlabel('Frequency (Hz)');
ylabel('Relative level (dB)');
%% hi pass stage 

a1h = -1.99004745483398;
a2h = 0.99007225036621;
b0h = 1.0;
b1h = -2.0;
b2h = 1.0;


bh = [b0h, b1h, b2h];
ah = [1, a1h, a2h];

[h,w] = freqz(bh,ah,n,fs);
figure;
semilogx(w/pi, 20*log10(abs(h)));
title('Stage 2: High Pass Filter');
xlabel('Frequency (Hz)');
ylabel('Relative level (dB)');
%% K-Filter
ak = conv(a, ah);
bk = conv(b, bh);
[h,w] = freqz(bk,ak,n,fs);
figure;
semilogx(w/pi, 20*log10(abs(h)));
title('Combined: K Filter Transfer Function');
xlabel('Frequency (Hz)');
ylabel('Relative level (dB)');
%% white noise transfer function
whitenoise = WhiteNoise(fs);
whitenoise_f1 = filter(b, a, whitenoise);
whitenoise_tf1 = abs(fft(whitenoise_f1))./abs(fft(whitenoise));
figure;
semilogx(20*log10(whitenoise_tf1));
title('White Noise Transfer Function -- Shelving Filter');
xlabel('Frequency (Hz)');
ylabel('Relative level (dB)');
whitenoise_f2 = filter(bh, ah, whitenoise);
whitenoise_tf2 = abs(fft(whitenoise_f2))./abs(fft(whitenoise));
figure;
semilogx(20*log10(whitenoise_tf2));
title('White Noise Transfer Function -- High Pass Filter');
xlabel('Frequency (Hz)');
ylabel('Relative level (dB)');
whitenoise_f3 = filter(bh, ah, whitenoise_f1);
whitenoise_tf3 = abs(fft(whitenoise_f3))./abs(fft(whitenoise));
figure;
semilogx(20*log10(whitenoise_tf3));
title('White Noise Transfer Function -- K Filter');
xlabel('Frequency (Hz)');
ylabel('Relative level (dB)');
%% sine sweep transfer function
sinesweep = SineSweep(1, fs, 1);
sinesweep_f1 = filter(b, a, sinesweep);
sinesweep_tf1 = abs(fft(sinesweep_f1))./abs(fft(sinesweep));
figure;
semilogx(20*log10(sinesweep_tf1));
title('Sine Sweep Transfer Function -- Shelving Filter');
xlabel('Frequency (Hz)');
ylabel('Relative level (dB)');
sinesweep_f2 = filter(bh, ah, sinesweep);
sinesweep_tf2 = abs(fft(sinesweep_f2))./abs(fft(sinesweep));
figure;
semilogx(20*log10(sinesweep_tf2));
title('Sine Sweep Transfer Function -- High Pass Filter');
xlabel('Frequency (Hz)');
ylabel('Relative level (dB)');
sinesweep_f3 = filter(bh, ah, sinesweep_f1);
sinesweep_tf3 = abs(fft(sinesweep_f3))./abs(fft(sinesweep));
figure;
semilogx(20*log10(sinesweep_tf3));
title('Sine Sweep Transfer Function -- K Filter');
xlabel('Frequency (Hz)');
ylabel('Relative level (dB)');