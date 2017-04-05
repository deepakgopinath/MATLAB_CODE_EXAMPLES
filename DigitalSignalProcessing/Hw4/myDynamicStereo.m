% MUSI 6202 HW4 - Dynamic Range Control(stereo)
% CW @ GTCMT 2015
% objective: implement a limiter according to Fig 7.15 p237. (Zoler 2008) 
% y = myDynamicStereo(x, fs, LT, LS, ta, tr)
% x = float N*2 vector, input signal
% ta = float, attack time (ms)
% tr = float, release time (ms)
% tm = float, averaging time (ms)
% levelMethod = string, 'peak' or 'rms'

function y = myDynamicStereo(x, fs, LT, LS, ta, tr, tm, levelMethod)


% initialization 
N = length(x);
y = zeros(N, 2);
xSum = sum(x,2); %downmix without scaling;
% xSum = max(x');xSum = xSum';
xEnv = zeros(N,1);
delay = 1;
if(strcmp(levelMethod,'peak'))
    xEnv = myPeakMeasure(xSum,fs,ta,tr);
elseif(strcmp(levelMethod,'rms'))
    xEnv = myRmsMeasure(xSum,fs,tm);
end
xEnvLog = log2(xEnv);
FGain = myStaticCurve(xEnvLog,LS,LT);
fn = 2.^FGain;
gn = myPeakMeasure(fn,fs,ta,tr); %smooth
for i=1:2 %for each channel;
    y(:,i) = gn.*[zeros(delay,1);x(1:N-delay,i)];
end

% write your code here
