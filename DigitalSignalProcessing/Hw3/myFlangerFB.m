% MUSI 6202 HW3 - Flanger (feedback)
% CW @ GTCMT 2015
% objective: Implement flanging effect based on based on
% MUSI6202-slides-8.pdf p.37
% y = myFlangerFB(x, fs, BL, FF, FB, delayInSec, widthInSec, modFreqInHz)
% x = N*1 vector, input signal
% fs = float, sampling frequency in Hz
% BL = float, blend gain
% FF = float, feedforward gain1
% FB = float, feedback gain2
% widthInSec = float, modulating depth in second
% modFreqInHz = float, modulating frequency in Hz

function y = myFlangerFB(x, fs, BL, FF, FB, delayInSec, widthInSec, modFreqInHz)

% initialization 
N = length(x);
y = zeros(N, 1);

%setup ring buffer;
% M = ceil(delayInSec*fs);
% W = ceil(widthInSec*fs);
% L = M + W + 1;
% ringBuff = zeros(L, 1);
% wIdx = M + W + 1; rIdx = W + 1;
% lfo = modFreqInHz/fs;
% 
% if(M ~= 0)
%     L2 = M+1;bRIdx = M+1; bWIdx = 1;
% else
%     L2 = L; bRIdx = rIdx; bWIdx = wIdx;
% end
% BLRingBuff = zeros(L2,1);

M = ceil(delayInSec*fs);
W = ceil(widthInSec*fs);

if (M~=0)
    L = M + W + 1;
    wIdx = M + W + 1; rIdx = W + 1;% to leave room for enough width
    L2 = M+1;bRIdx = 1; bWIdx = M+1;
else
    L = W + 2; %if delayInSec is zero, then have a delay at least as big as the modWidth
    wIdx = W + 2; rIdx = 1;
    L2 = L; bRIdx = rIdx; bWIdx = wIdx;
end
ringBuff = zeros(L, 1);
BLRingBuff = zeros(L2,1);
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
    lowerIdx = mod(lowerIdx, L) + double(mod(lowerIdx, L) == 0)*L; %make sure it is wrapped around right. 
    higherIdx = mod(higherIdx, L) + double(mod(higherIdx, L) == 0)*L;
    
    val = ringBuff(higherIdx)*frac + ringBuff(lowerIdx)*(1-frac);
    %ff fb chorus
    
    y(i) = FF*val + BLRingBuff(bRIdx); %the delay in the BL loop is after the BL block.
    
    %update read and write pointer for ring buffer AFTER writing into the
    %buffer
   
    ringBuff(wIdx) = x(i) + FB*ringBuff(rIdx); BLRingBuff(bWIdx) = BL*(x(i) + FB*ringBuff(rIdx));
    rIdx = mod(rIdx, L) + 1; bRIdx = mod(bRIdx, L2) + 1; 
    wIdx = mod(wIdx, L) + 1; bWIdx = mod(bWIdx, L2) + 1; 

end
end