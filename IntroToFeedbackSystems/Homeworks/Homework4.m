% J = 600000;
% B = 20000;
% 
% d = sqrt(1/((pi/log(10))^2 + 1));
% K = (B/(2*d*sqrt(J)))^2
% 
% K = J*(1.8/80)^2
% 
% K = [200, 400, 1000, 2000];
% H = cell(1, length(K))
% for i=1:length(K)
%     H{i} = tf([K(i)],[J, B, K(i)]);
% end
% 
% step(H{:});
% stepinfo(H{1})
% title('Step Response for K = 200,400,1000,2000');
% 
% clear;
% clc;
% k = 2.3:0.2:2.8;
% TF = cell(length(k),1);
% for i=1:length(k)
%     K = k(i);
%     H1 = zpk([-1, -2],[],50);
%     H2 = tf([1],[1,5,40]);
%     H3 = tf([1], [1, 0.03, 0.06]);
%     G = H1*H2*H3;
% 
%     D = zpk([-3],[-10],[K]);
%     TF{i} = feedback(D*G, 1);
% end
% step(TF{:});
% set(gca, 'Ytick', 0:0.1:2);
% set(gca, 'Xtick', 0:1:7);
% title('Question 4 - Step Response for 2.3 < K < 2.8');
% grid on;
% % 
% close all; 
% clear all;
% clc;
% 
% sigma = 4.6/1.5;
% dr = 0.8; % for proper working
% wn = sigma/dr;

% p1 = 2*sigma; %within 4 sigma for less overshoot and increase rise time
% z = 10*sigma; %much beyond 4 sigma for increase rise time and less overshoot
% p = 2*dr*wn + p1 - 3;
% K = wn^2 + 2*dr*wn*p1 - 3*p;
% z = p1*wn^2/K;
% 
% G = zpk([],[-3, 0 ],[1]);
% D = zpk([-z],[-p],[K]);
% 
% TF = feedback(D*G, 1);
% step(TF)
% set(gca, 'Ytick', 0:0.1:2);
% title('Question 3 -  Step Response');
% grid on;

