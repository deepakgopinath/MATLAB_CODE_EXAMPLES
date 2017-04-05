% MUSI 6202 HW1(vi) Fast Convolution
% Created by Chih-Wei Wu at GTCMT 2015
% Last update: 2015.01.07
% objective: This part is to implement fast convolution 
%            as described in Zolzer 2008 p165
% y = myFastConv(x, h, M)
% x: xLen*1 vector of input sequence
% h: hLen*1 vecotr of impulse response
% y: (xLen+hLen-1)*1 vector of output sequence

function y = myFastConv(x, h, b)

% initialization 
tic;
y = [];
if(b <= 0 || (floor(b) == b) ~= 1) %check for negative or non-integer blocklengths
   disp('Please enter a valid blockLength');
   return;
end
L = size(x, 1);
M = size(h, 1);
originalL = L; %needed for final truncation of trailing zeros
originalM = M;

if(b > L) %the case when the block lentgh if greater than the signal length
   x = [ x ; zeros(b-L, 1)];
   L = size(x, 1);
end

if(b > M) %the case when the block length is greater than IR length
   h = [h ; zeros(b-M, 1)];
   M = size(h, 1);
end

numLastBlock = mod(L,b); %to check for the last block. 
if(numLastBlock ~= 0)
   x = [x ; zeros(b - numLastBlock, 1)]; %zero pad to complete the last block
end

numLastBlock = mod(M,b);
if(numLastBlock ~= 0)
   h = [h ; zeros(b - numLastBlock, 1)]; %zero pad to complete the last block
end

if(mod(size(x,1)/b, 2) ~= 0)
    x = [x ; zeros(b, 1)]; %to make sure there are even number of blocks so that when making a complex number there are enough blocks
end
L = size(x, 1);
M = size(h, 1);
y = zeros((L + M -1), 1);

hBlockFFT = [];
%store blocked impulse response ffts;
for i=1:b:M
    hBlock = [h(i:i+b-1); zeros(b-1,1)];
    hBlockFFT = [hBlockFFT fft(hBlock)]; % each column corresponds to the fft of each block of the impulse response. 
end

for m=1:L/2/b
    index = 2*m - 1;
    lBlock = x(b*(index-1) + 1: b*index);
    lPlus1Block = x(b*(index)+1:b*(index+1));
    zBlock = complex(lBlock, lPlus1Block);
    zBlock = [zBlock ; zeros(b-1, 1)];
    zBlockFFT = fft(zBlock);
    fDomainMult = repmat(zBlockFFT, 1, M/b).*hBlockFFT;
    fDomainMultIFFT = ifft(fDomainMult);
    for j=0:M/b-1
       y(b*(j+index-1)+1 : b*(j+index+1)-1) = y(b*(j+index-1)+1 : b*(j+index+1)-1) + real(fDomainMultIFFT(:,j+1));
       y(b*(j+1+index-1)+1 : b*(j+1+index+1)-1) = y(b*(j+1+index-1)+1 : b*(j+1+index+1)-1) + imag(fDomainMultIFFT(:,j+1));
    end
end
y = y(1:originalL + originalM - 1); %remove trailing zeros
toc;

% ==== write your codes here:


    
    
    
    





