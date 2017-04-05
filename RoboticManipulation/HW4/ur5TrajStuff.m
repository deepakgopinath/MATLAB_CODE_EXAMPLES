clc;
L1 = 0.425;
L2 = 0.392;
W1 = 0.109;
W2 = 0.082;
H1 = 0.089;
H2 = 0.095;

epsw = deg2rad(0.1);
epsv = 0.0005;
Tsd = [ 0,1,0,-0.6;
        0,0,-1,0.1;
        -1,0,0,0.1;
        0,0,0,1
        ];

M = [   1, 0,0, -(L1+L2);
        0,0,-1, -(W1+W2);
        0,1,0, H1-H2;
        0,0,0,1
    ];

B1 = [0,1,0,(W1+W2), 0, L1+L2]';
B2 = [0,0,1,H2,-(L1+L2),0]';
B3 = [0,0,1,H2, -L2, 0]';
B4 = [0,0,1,H2, 0,0]';
B5 = [0, -1, 0, -W2, 0, 0]';
B6 = [0,0,1,0,0,0]';
B = [B1, B2, B3, B4, B5, B6];

S1 = [0,0,1,0,0,0]';
S2 = [0,-1,0,H1, 0,0]';
S3 = [0, -1, 0, H1, 0, L1]';
S4 = [0, -1, 0, H1, 0, L1+L2]';
S5 = [0, 0, -1, W1, -(L1+L2), 0]';
S6 = [0, -1, 0, H1-H2, 0, L1+L2]';
S = [S1, S2, S3, S4, S5, S6];

% 
% theta0 = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1]';
t_s = 0.1*ones(6,1);
t_end = (pi/2)*ones(6,1);

X_s = FKinFixed(M, S, t_s);
X_end = FKinFixed(M, S, t_end);
T = 2; N= 101; num_joints = 6;
tsMethod = 5; % Quintic Method

SE_List =CartesianTrajectory(X_s, X_end, T, N, tsMethod);

t_List = zeros(N, num_joints); %For each SE(3) in SE_List there will be a corresponding theta_i
t_List(1,:) = t_s';

for i=2:N
    localIKList = IKinFixed(S,M,SE_List(:,:,i), t_List(i-1, :), epsw, epsv); %localIKlist is the iteration list. We are interested in the last row of this matrix
    t0 = localIKList(end,:);
%     disp(t0);
    t_List(i,:) = t0;
end
% 
% for i=1:6
%     plot(t_List(:,i)); hold on;
% end
% JMatFixedUR5 = IKinFixed(S, M, Tsd, theta0, epsw, epsv);
% JMatBodyUR5 = IKinBody(B, M, Tsd, theta0, epsw, epsv);