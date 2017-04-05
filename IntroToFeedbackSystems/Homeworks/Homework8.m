clear;
clc;

s = tf('s');
a = [0.01, 0.1, 1, 10, 100];

% %6.11
H = cell(5,1);
D = s^2 + s + 1;
for i=1:5
    N = (s/a(i)) + 1;
    H{i} = N/D;
end

step(H{1},H{2},H{3},H{4},H{5});
os = zeros(5,1);
mr = zeros(5,1);
for i=1:5
    temp = stepinfo(H{i});
    os(i) = temp.Peak
    mr(i) = getPeakGain(H{i}); 
end
figure;
bode(H{1},H{2},H{3},H{4},H{5});

%6.12
% H = cell(6,1);
% D1 = s^2 + s + 1;
% for i=1:5
%     D2 = (s/a(i)) + 1;
%     H{i} = 1/(D1*D2);
% end
% H{6} = 1/D1;
% bwvec = zeros(6,1);
% for i=1:6
%     bwvec(i) = bandwidth(H{i});
% end
% bode(H{1},H{2},H{3},H{4},H{5}, H{6});
% grid on;
% title('Bode Plot - Q-6.12');
%6.13
% d = linspace(0,1,1000);
% wbw = zeros(length(d),1);
% for i=1:length(d)
%     a = d(i);
%     wbw(i) = sqrt(1 - 2*a^2  + sqrt(2 + 4*a^4 - 4*a^2));
% end
% plot(d,wbw)
% xlabel('damping ratio')
% ylabel('bandwidth (rad/s)');
% title('Bandwidth vs. damping ratio')
% grid on;

%6.21

N = 1;
D = (s+1)*(s^2 + 2*s + 2);
H = N/D;
bode(H);
title('Bode Plot - Q-6.21');
figure;
nyquist(H);