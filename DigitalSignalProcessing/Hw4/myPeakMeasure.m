% MUSI 6202 HW4 - level measurement: peak measurement
% CW @ GTCMT 2015
% objective: implement a PEAK measurement (envelope detector/follower)
% xPeak = myPeakMeasure(x, ta, tr)
% x = float N*1 vector, input signal
% ta = float, attack time (ms)
% tr = float, release time (ms)
% xPeak = float N*1 vector, output signal

function xPeak = myPeakMeasure(x, fs, ta, tr)

% initialization 
% write your code here
Ts = 1/fs;
N = length(x);

AT = 1 - exp((-2.2*Ts)/(ta/1000));
RT = 1 - exp((-2.2*Ts)/(tr/1000));

xPeak = zeros(N,1);
currPeakSample = 0;
prevPeakSample = 0;

for i=1:N
    if(abs(x(i)) > prevPeakSample)
        currPeakSample = (1 - AT)*prevPeakSample + AT*abs(x(i));
    else
        currPeakSample = (1 - RT)*prevPeakSample;
    end
    xPeak(i) = currPeakSample;
    prevPeakSample = currPeakSample;
end

end








