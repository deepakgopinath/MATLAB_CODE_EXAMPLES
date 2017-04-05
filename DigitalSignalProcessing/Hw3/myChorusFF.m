% MUSI 6202 HW3 - Chorus (feedforward)
% CW @ GTCMT 2015
% objective: Implement Chorus effect based on MUSI6202-slides-8.pdf p.39
% y = myChorusFF(x, fs, BL, FF1, FF2)
% x = N*1 vector, input signal
% fs = float, sampling frequency in Hz
% BL = float, blend gain
% FF1 = float, feedforward gain1
% FF2 = float, feedforward gain2

function y = myChorusFF(x, fs, BL, FF1, FF2)

% initialization 
N = length(x);
y = zeros(N, 1);

%% parameters for listening: 
delayInSec1 = 0.029;
delayInSec2 = 0.037;
widthInSec1 = 0.002;
widthInSec2 = 0.003;
modFreqInHz1 = 0.7;
modFreqInHz2 = 1.3;

%% parameters for testing:
% delayInSec1 = 0.001;
% delayInSec2 = 0.001;
% widthInSec1 = 0;
% widthInSec2 = 0;
% modFreqInHz1 = 0;
% modFreqInHz2 = 0;

%% write your code here

M1 = ceil(delayInSec1*fs);
M2 = ceil(delayInSec2*fs);
W1 = ceil(widthInSec1*fs);
W2 = ceil(widthInSec2*fs);
L1 = M1 + W1 + 1;
L2 = M2 + W2 + 1;
ringBuff1 = zeros(L1, 1);
ringBuff2 = zeros(L2, 1);
wIdx1 = M1 + W1 + 1; rIdx1 = W1 + 1;
wIdx2 = M2 + W2 + 1; rIdx2 = W2 + 1;

lfo1 = modFreqInHz1/fs;
lfo2 = modFreqInHz2/fs;
for i=1:N
    
    eRIdx1 = rIdx1 + W1*sin(2*pi*lfo1*(i-1)); %fractional Index delay line 1
    eRIdx2 = rIdx2 + W2*sin(2*pi*lfo2*(i-1)); %fractional index delay line 2
    
    %delay line 1
    lowerIdx1 = floor(eRIdx1);
    frac1 = eRIdx1 - lowerIdx1;
    higherIdx1 = ceil(eRIdx1);
    while (lowerIdx1 <= 0) %make sure negative indices are wrapped around into the right range
        lowerIdx1 = lowerIdx1 + L1;
    end
    while (higherIdx1 <= 0)
        higherIdx1 = higherIdx1 + L1;
    end
    lowerIdx1 = mod(lowerIdx1, L1) + double(mod(lowerIdx1, L1) == 0)*L1;
    higherIdx1 = mod(higherIdx1, L1) + double(mod(higherIdx1, L1) == 0)*L1;
    
    %delay line 2
    lowerIdx2 = floor(eRIdx2);
    frac2 = eRIdx2 - lowerIdx2;
    higherIdx2 = ceil(eRIdx2);
    while (lowerIdx2 <= 0)
        lowerIdx2 = lowerIdx2 + L2;
    end
    while (higherIdx2 <= 0)
        higherIdx2 = higherIdx2 + L2;
    end
    lowerIdx2 = mod(lowerIdx2, L2) + double(mod(lowerIdx2, L2) == 0)*L2;
    higherIdx2 = mod(higherIdx2, L2) + double(mod(higherIdx2, L2) == 0)*L2;
    
    %the interpolated values 
    val1 = ringBuff1(higherIdx1)*frac1 + ringBuff1(lowerIdx1)*(1-frac1);
    val2 = ringBuff2(higherIdx2)*frac2 + ringBuff2(lowerIdx2)*(1-frac2);
   
    %the chorus
    y(i) = BL*x(i) + FF1*val1 + FF2*val2;
   
    %update read pointer. 
    rIdx1 = mod(rIdx1,L1) + 1; rIdx2 = mod(rIdx2,L2) + 1;
    %write into buffer. 
    ringBuff1(wIdx1) = x(i);
    ringBuff2(wIdx2) = x(i);
    %update write ppointer
    wIdx1 = mod(wIdx1,L1) + 1; wIdx2 = mod(wIdx2,L2) + 1;
    
end


end


