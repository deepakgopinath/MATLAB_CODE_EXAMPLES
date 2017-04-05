%Filtering - Q2-c

%Testing the Single pole IIR Filter with various parameters

%submitted by Deepak Gopinath - 903014581

x1 = rand(44100*2,1); %Generate 2 seconds of white noise

y1 = SinglePoleIIR(1, 0, x1); %Call the filter functions
y2 = SinglePoleIIR(0.5, -0.5, x1);
y3 = SinglePoleIIR(0.1, -0.9, x1);

subplot(3,1,1);
spectrogram(y1, hamming(256), 256-128);

subplot(3,1,2);
spectrogram(y2, hamming(256), 256-128);

subplot(3,1,3);
spectrogram(y3, hamming(256), 256-128);
