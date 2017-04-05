% MUSI 6202 HW5 - My blocking 
% CW @ GTCMT 2015
% objective: partition your signal into overlapping blocks
% xmat = myBlocking(x, windowSize, hopSize)
% x = float, N*1 vector of input signal
% windowSize = int, window size in samples
% hopSize = int, hop size in samples
% xmat = float, windowSize*numBlocks matrix of signal

function [xmat] = myBlocking(x, windowSize, hopSize)

L = length(x);

% index = 1;
% for i=1:hopSize:L - windowSize + 1
%     startIndex = i;
%     endIndex = min(L, i+windowSize-1);
%     if((endIndex - startIndex + 1) ~= windowSize)
%         x =[x ; zeros(windowSize - (endIndex - startIndex + 1) ,1)];
%         endIndex = startIndex+windowSize-1;
%         xmat(:,index) = x(startIndex:endIndex);
%         break;
%     end
%     xmat(:,index) = x(startIndex:endIndex);
%     index = index + 1;
% end

startIndex = 1;
index = 1;
while(1)
    if(L - startIndex + 1 <= windowSize)
       x = [x; zeros(windowSize - (L - startIndex + 1), 1)];
       endIndex = startIndex + windowSize - 1;
       xmat(:, index) = x(startIndex:endIndex);
       break;
    end
    endIndex = min(L, startIndex + windowSize -1);
    xmat(:, index) = x(startIndex:endIndex);
    startIndex = startIndex + hopSize;
    index = index + 1;
end
end

