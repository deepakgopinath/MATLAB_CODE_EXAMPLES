% MUSI 6202 HW3 Noise generation (rectangular/triangular/hp method)
% Created by Chih-Wei Wu at GTCMT 2015
% Last update: 2015.02.04
% objective: This function is to generate a noise signal with
%            rectangular or triangular pdf 
% y = myNoiseGen(numSamples, noiseType)
% numSamples = integer, the length of your noise signal
% noiseType  = string, 'rect', 'tri', 'hp'
% w = integer, word length of noise signal
% y = numSamples * 1 vector of noise signal

function y = myNoiseGen(numSamples, w, noiseType)

% initialization
if ~(strcmp(noiseType, 'rect') || strcmp(noiseType, 'tri') || strcmp(noiseType, 'hp'))
   error('Error: noise type is not supported'); 
end
y = zeros(numSamples, 1);
% Write your code here

delta = 1/(2^(w-1));
if(strcmp(noiseType,'rect'))
    a = -delta/2; b= delta/2;
    y =  a + (b-a).*rand(numSamples,1);
elseif(strcmp(noiseType, 'tri'))
    a = -delta; b = delta;
    y1 = a + (b-a).*rand(numSamples,1); y2 = a + (b-a).*rand(numSamples,1);
    y = y1+y2;
elseif(strcmp(noiseType,'hp'))
    a = -delta; b = delta;
    y = a + (b-a).*rand(numSamples+1,1);
    y = diff(y);
end



