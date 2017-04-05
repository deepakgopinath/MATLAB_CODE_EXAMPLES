% MUSI 6202 HW3 - Chorus (White)
% CW @ GTCMT 2015
% objective: Implement chorus effect based on MUSI6202-slides-8.pdf p.38
% y = myChorusFB(x, fs, BL, FF, FB, delayInSec, widthInSec, modFreqInHz)
% x = N*1 vector, input signal
% fs = float, sampling frequency in Hz
% BL = float, blend gain
% FF = float, feedforward gain1
% FB = float, feedback gain2
% widthInSec = float, modulating depth in second
% modFreqInHz = float, modulating frequency in Hz 

function y = myChorusFB(x, fs, BL, FF, FB, delayInSec, widthInSec, modFreqInHz)

% initialization 
N = length(x);
y = zeros(N, 1);
if delayInSec < widthInSec
    error('basic delay must be equal or greater than modulation width');
end
%setup ring buffer;
M = ceil(delayInSec*fs);
W = ceil(widthInSec*fs);
L = M + W + 1;
ringBuff = zeros(L, 1);
wIdx = M + W + 1; rIdx = W + 1;
lfo = modFreqInHz/fs;

for i=1:N
    eRIdx = rIdx + W*sin(2*pi*lfo*(i-1)); %fractional Index delay line 1
    
    %linear interpolation
    lowerIdx = floor(eRIdx);
    frac = eRIdx - lowerIdx;
    higherIdx = ceil(eRIdx);
    while (lowerIdx <= 0) %make sure negative indices are wrapped around into the right range
        lowerIdx = lowerIdx + L;
    end
    while (higherIdx <= 0)
        higherIdx = higherIdx + L;
    end
    lowerIdx = mod(lowerIdx, L) + double(mod(lowerIdx, L) == 0)*L;
    higherIdx = mod(higherIdx, L) + double(mod(higherIdx, L) == 0)*L;
    
    val = ringBuff(higherIdx)*frac + ringBuff(lowerIdx)*(1-frac);
    
    %ff fb chorus
      
    y(i) = FF*val + BL*(x(i) + FB*ringBuff(rIdx)); %feedback the unmodulated value
    
    %update read and write pointer for ring buffer.
    ringBuff(wIdx) = x(i) + FB*ringBuff(rIdx);
    rIdx = mod(rIdx,L) + 1;
    wIdx = mod(wIdx,L) + 1;
end


% write your code here

