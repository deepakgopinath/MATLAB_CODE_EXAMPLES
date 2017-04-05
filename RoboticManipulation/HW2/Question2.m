
clear;
clc;

disp('Question i');
disp(' ');
q = [3,0,0]'; s = [0,0,1]; h = 2;
disp('The screw axis corresponding to q, s, h is')
disp(ScrewToAxis(q,s,h));

disp('Question ii');
disp(' ');
S =[0, 1/sqrt(2), 1/sqrt(2), 1,2,3]'*1;
disp('The T matrix corresponding to the screw axis S and theta = 1 is');
disp(MatrixExp6(S));

disp('Question iii');
T = [1,0,0,0; 0,0,-1,0;0,1,0,3;0,0,0,1];
mLog6 =  MatrixLog6(T);
disp('The matrix log of T is');
disp(mLog6);

disp('Questions iv and v (combined)');
%Parameters of the robot
L0 = 4;
L1 = 3;
L2 = 2;
L3 = 1;
h = 0.1;

%T_sb when joint angles are 0
T = [-1, 0, 0, 0;
      0, 1, 0, L0 + L2;
      0, 0, -1, L1 - L3;
      0, 0, 0, 1 ];

  %Screw Axis
S1 = [0,0,1,L0, 0, 0]';
S2 = [0,0,0,0,1,0]';
S3 = [0,0,-1,-(L0+L2), 0, -h]';

S = [S1,S2,S3];
M = T;
theta = [pi/2, 3, pi];
resTS = FKinFixed(M, S, theta);

B1 = [0,0,-1,L2, 0, 0]';
B2 = [0,0,0,0,1,0]';
B3 = [0,0,1,0,0,h]';
B = [B1, B2, B3];
resTB = FKinBody(M, B, theta);

disp('The following two transformation matrices are identical. The first one came from product of exponentials in fixed frame, whereas the latter came from product of exponentials in body frame');
disp(resTS);
disp(resTB);
