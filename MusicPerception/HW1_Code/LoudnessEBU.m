function [LUFS,LU] = LoudnessEBU(cFilePathToInputFile)
%%
% Programme Loudness measurement function.
%
%
try
    [samples, sr] = audioread(cFilePathToInputFile);
catch err
    throw(err);
    return;
end
if sr ~= 48000
    disp('ERROR: The sample rate is not 48kHz.');
    return;
end
if size(samples, 2) > 2
    disp('ERROR: The number of audio channels is greater than 2.');
    return;
end


blockSize = sr*0.4; % 400ms blocksize
hopSize = sr*0.1; % 25% hopsize = 100ms

for i=1:size(samples, 2)
    samples(:,i) = PreFilter(samples(:,i));
end

rmsPerBlock = blockWiseRMS(samples, blockSize, hopSize); % rms for each channel
rmsPerBlock = rmsPerBlock.^2; % square to get mean square
loudnessPerBlock = -0.691 + 10*log10(sum(rmsPerBlock, 2)); % sum all channels per block

% plot(loudnessPerBlock); % loudness per block for the entire file
figure;
hist(loudnessPerBlock(2:end));  % plot histogram

%Gated Absolute Threshold
Ta = -70; % from the documents;
Jg = find(loudnessPerBlock > Ta); % indices of the blocks for the the loudness is greater than threshold
lengthJg = length(Jg); % number of such blocks
rmsPerJgBlock = rmsPerBlock(Jg, :); % subset of rmsMatrix 
LkgAbsolute = -0.691 + 10*log10(sum((sum(rmsPerJgBlock, 1))/lengthJg));


% Gated Relative Threshold.
Tr = LkgAbsolute - 10;
Jr = find(loudnessPerBlock > Tr);
lengthJr = length(Jr);
rmsPerJrBlock = rmsPerBlock(Jr, :);
LkgRelative =  -0.691 + 10*log10(sum((sum(rmsPerJrBlock, 1))/lengthJr));
LUFS = LkgRelative;
LU = LUFS + 23.0;

end