% MUSI 6202 HW4 - Dynamic Range Control
% CW @ GTCMT 2015
% objective: implement a limiter according to Fig 7.8 p232. (Zoler 2008) 
% y = myDynamic(x, fs, LT, LS, ta, tr, tm, 'levelMethod')
% x = float N*1 vector, input signal
% ta = float, attack time (ms)
% tr = float, release time (ms)
% tm = float, averaging time (ms)
% levelMethod = string, 'peak' or 'rms'

function y = myDynamic(x, fs, LT, LS, ta, tr, tm, levelMethod)

% initialization 
N = length(x);
y = zeros(N, 1);
xEnv = zeros(N,1);
delay = 1;
if(strcmp(levelMethod,'peak'))
    xEnv = myPeakMeasure(x,fs,ta,tr);
elseif(strcmp(levelMethod,'rms'))
    xEnv = myRmsMeasure(x,fs,tm);
end

xEnvLog = log2(xEnv);
FGain = myStaticCurve(xEnvLog,LS,LT);
fn = 2.^FGain;
gn = myPeakMeasure(fn,fs,ta,tr); %smooth
y = gn.*[zeros(delay,1);x(1:N-delay)]; %multiply with delayed signal.
% write your code here


