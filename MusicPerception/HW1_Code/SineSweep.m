function Y = SineSweep(fstart, fstop, length, method, fs, bits, PHI)
%SINESWEEP Creates a custom sine wave sweep.
%   SineSweep(fstart, fstop, length, [method], [fs], [bits], [PHI])
%   fstart (Hz) - instantaneous frequency at time 0
%   fstop (Hz) - instantaneous frequency at time length
%   length (s) - the length of time to perform the sweep
%   method - 'quadratic', 'logarithmic', or 'linear' (default)
%   fs (Hz) - the sampling frequency (default = 48KHz)
%   bits - bit depth of each sample 8, 16 (default), 24, or 32
%   PHI (deg) - initial phase angle. cos = 0, sin = 270 (default)

%check and set missing parameters
if exist('method','var') ~= 1
    method = 'linear';
end
if exist('fs','var') ~= 1
    fs = 48000;
end
if exist('bits','var') ~= 1
    bits = 16;
end
if bits ~= 8 && bits ~= 16 && bits ~= 24 && bits ~= 32
    bits = 16;
end
if exist('PHI','var') ~= 1
    PHI = 270;
end

%make sure start and stop frequencies are valid
if fstop < fstart
    temp = fstart;
    fstart = fstop;
    fstop = temp;
end

%avoid aliasing
if fstart > fs/2
    fstart = fs/2;
end
if fstop > fs/2
    fstop = fs/2;
end

%create time vector
t = 0:(1/fs):length;

%scale to avoid clipping due to rounding error
Y = 0.9999*chirp(t,fstart,length,fstop, method, PHI);

%play the sound
% sound(Y,fs);

%store sweep to wav file
% wavwrite(Y,fs,bits,'SineSweep.wav');

end