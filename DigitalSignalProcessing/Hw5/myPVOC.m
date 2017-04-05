% MUSI 6202 HW5 - Phase Vocoder
% CW @ GTCMT 2015
% objective: implement Phase Vocoder 
% yc = myPVOC(x, fs, windowSize, hopSize, se, pe, phaseMethod, numPeaks,
% spread)
% x = float, N1*1 vector of input signal
% fs = int, sampling frequency
% windowSize = int, window size in samples
% hopSize = int, hop size in samples
% se = float, external time stretching factor
% pe = float, external pitch shifting factor
% phaseMethod = string, 'naive', 'group', 'instant'
% numPeaks = int, number of peaks to track for phase grouping
% spread = int, number of spreading bins for phase grouping 
% yc = float, N2*1 vector of output signal

function [yc] = myPVOC(x, fs, windowSize, hopSize, se, pe, phaseMethod, numPeaks, spread)

if(hopSize > windowSize)
    disp('Error - Please enter a hopSize < windowSize');
    yc = 0;
    return;
end
overlap = windowSize - hopSize;

si = se*pe;

if(hopSize*si > windowSize)
   disp('Error - Please enter se and pe such that se times pe < windowSize/hopSize');
   yc = 0;
   return;
end

xmat = myBlocking(x,windowSize,hopSize);
window = hann(windowSize, 'symmetric');
xmatWindowed = xmat.*repmat(window, 1, size(xmat, 2));
xmatWindowed = fftshift(xmatWindowed, 1);
fftY = fft(xmatWindowed, windowSize);  
magMat = abs(fftY);
phaseMat = angle(fftY);
if(strcmp(phaseMethod,'group'))
    phasMat_new = myGroupPhase(phaseMat, hopSize, si, magMat, numPeaks, spread);
else
    phasMat_new = myNaivePhase(phaseMat, hopSize, si);
end

clear i;
newfftY = magMat.*(exp(1i.*phasMat_new));
newxmatW = real(ifft(newfftY));
newxmatW = ifftshift(newxmatW, 1);
yc = myReconstruct(newxmatW, windowSize, round(hopSize*si));
myWindowCompEnv = myWindowCompensation(windowSize, round(hopSize*si), size(newxmatW,2));
yc = yc./(myWindowCompEnv + realmin);

end


% 22 questions
