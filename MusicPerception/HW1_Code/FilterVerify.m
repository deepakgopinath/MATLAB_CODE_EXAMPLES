clear all;


n= 512; 
sr = 48000;
iBlockLength = 4096;
iHopSize = 1024;

a0 = 1;
a1 = -1.69065929318241;
a2 = 0.73248077421585;

b0 = 1.53512485958697;
b1 = -2.69169618940638;
b2 = 1.19839281085285;
b = [b0, b1, b2];
a = [a0, a1, a2];

[h,w] = freqz(b,a,n);

semilogx(w/pi, 20*log10(abs(h)));
title('Stage 1: Shelving Filter');

a0h = 1;
a1h = -1.99004745483398;
a2h = 0.99007225036621;
b0h = 1.0;
b1h = -2.0;
b2h = 1.0;

bh = [b0h, b1h, b2h];
ah = [a0h,a1h, a2h];

[h,w] = freqz(bh, ah, n);
figure;
semilogx(w/pi, 20*log10(abs(h)));
title('Stage 2: High Pass Filter');

ac = conv(a,ah);
bc = conv(b, bh);
[h,w] = freqz(bc, ac, n);
figure;
semilogx(w/pi, 20*log10(abs(h)));
title('Stage 3 : Combined');
%pass signal and then test.

% whitenoise = rand(48000,1);
% whiteNoiseI = filter(b,a,whitenoise);
% whiteNoiseII = filter(bh,ah, whitenoise);
% [X, f, t] = spectrogram(whitenoise, hann(iBlockLength, 'periodic'), iBlockLength-iHopSize, iHopSize, sr);
% X = abs(X).^2;
% [XI,fI,tI] = spectrogram(whiteNoiseI, hann(iBlockLength, 'periodic'), iBlockLength-iHopSize, iHopSize, sr);
% XI = abs(XI).^2;
% [XII, fII, tII] = spectrogram(whiteNoiseII, hann(iBlockLength, 'periodic'), iBlockLength-iHopSize, iHopSize, sr);
% XII = abs(XII).^2;
% ratioFI = XI./X;
% ratioFII = XII./X;
% 
% ratioFI = mean(ratioFI, 2);
% ratioFII = mean(ratioFII, 2);
% figure;
% semilogx(20*log(ratioFI));
% figure;
% semilogx(20*log(ratioFII));

% sinesweep

% sinesweep = SineSweep(500, 10000, 3);
% sinesweepI = filter(b,a, sinesweep);
% sinesweepII = filter(bh, ah, sinesweep);
% [X, f, t] = spectrogram(sinesweep, hann(iBlockLength, 'periodic'), iBlockLength-iHopSize, iHopSize, sr);
% X = abs(X).^2;
% [XI,fI,tI] = spectrogram(sinesweepI, hann(iBlockLength, 'periodic'), iBlockLength-iHopSize, iHopSize, sr);
% XI = abs(XI).^2;
% [XII, fII, tII] = spectrogram(sinesweepII, hann(iBlockLength, 'periodic'), iBlockLength-iHopSize, iHopSize, sr);
% XII = abs(XII).^2;
% ratioFI = XI./X;
% ratioFII = XII./X;
% ratioFI = mean(ratioFI, 2);
% ratioFII = mean(ratioFII, 2);
% figure;
% semilogx(ratioFI);
% figure;
% semilogx(ratioFII);
fftSize= 2048;

t = 0:1/48000:1;
y = chirp(t,0,0.5,5000);

spectrogram(y1,256,250,256,48000, 'yaxis');
