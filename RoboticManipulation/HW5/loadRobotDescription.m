n = 6; %6 joints for UR5;

%Screw Axes
S1 = [0,0,1,0,0,0]';
S2 = [0,1,0,-0.089159, 0,0]';
S3 = [0,1,0,-0.089159, 0, 0.425]';
S4 = [0,1,0,-0.089159, 0, 0.81725]';
S5 = [0,0,-1, -0.10915, 0.81725, 0]';
S6 = [0,1,0,0.005491, 0, 0.81725]';

S = [S1, S2, S3, S4, S5, S6];

%Relative M matrices
M01 = [1,0,0,0;
       0,1,0,0;
       0,0,1,0.089159;
       0,0,0,1
        ];
M12 = [0,0,1,0.28;
       0,1,0,0.13585;
       -1,0,0,0;
       0,0,0,1;
        ];
M23 = [1,0,0,0;
       0,1,0,-0.1197;
       0,0,1,0.395;
       0,0,0,1
        ];
M34 = [0,0,1,0;
       0,1,0,0;
       -1,0,0,0.14225;
       0,0,0,1
    ];
M45 = [1,0,0,0;
       0,1,0,0.093;
       0,0,1,0;
       0,0,0,1];
M56 = [1,0,0,0;
       0,1,0,0;
       0,0,1,0.09465;
       0,0,0,1
        ];
    
M67 = [ 1,0,0,0;
        0,0,1,0.0823;
        0,-1,0,0;
        0,0,0,1;
        ];

 Mrel = zeros(4,4,n+1);
 Mrel(:,:,1) = M01; Mrel(:,:,2) = M12; Mrel(:,:,3) = M23;
 Mrel(:,:,4) = M34; Mrel(:,:,5) = M45; Mrel(:,:,6) = M56;
 Mrel(:,:,7) = M67;
 
 
 %M Matrices with respect to base frame. 
 
%  M1 = [1,0,0,0;
%        0,1,0,0;
%        0,0,1,0.089159;
%        0,0,0,1
%         ];
%  M2 = [0,0,1,0.28;
%        0,1,0,0.13585;
%        -1,0,0,0.089159;
%        0,0,0,1
%         ];
%  M3 = [0,0,1,0.675;
%        0,1,0,0.01615;
%        -1,0,0,0.089159;
%        0,0,0,1
%         ];
%  M4 = [-1,0,0,0.81725;
%         0,1,0,0.01615;
%         0,0,-1,0.089195;
%         0,0,0,1
%         ];
%  M5 = [-1,0,0,0.81725;
%         0,1,0,0.10915;
%         0,0,-1,0.089195;
%         0,0,0,1
%         ];
%  M6 = [-1,0,0, 0.81725;
%         0,1,0,0.10915;
%         0,0,-1,-0.005491;
%         0,0,0,1
%         ];
%     
%  M7 = [-1, 0,0, 0.81725;
%         0,0,1,0.1915;
%         0,1,0,-0.0055;
%         0,0,0,1
%      ];
%  
%  M = zeros(4,4,n);
%  M(:,:,1) = M1; M(:,:,2) = M2; M(:,:,3) = M3;
%  M(:,:,4) = M4; M(:,:,5) = M5; M(:,:,6) = M6;
 
%mass stuff. 

G1 = makeGMatrix(3.7, 0.010267495893, 0, 0, 0.010267495893, 0, 0.00666);
G2 = makeGMatrix(8.393, 0.22689067591, 0, 0, 0.22689067591, 0, 0.0151074);
G3 = makeGMatrix(2.275, 0.049443313556, 0, 0, 0.049443313556, 0, 0.004095);
G4 = makeGMatrix(1.219, 0.111172755531, 0, 0, 0.111172755531, 0, 0.21942);
G5 = makeGMatrix(1.219, 0.111172755531, 0, 0, 0.111172755531, 0, 0.21942);
G6 = makeGMatrix(0.1879, 0.0171364731454, 0, 0, 0.0171364731454, 0, 0.033822);
G = zeros(6,6,n);
G(:,:,1) = G1; G(:,:,2) = G2; G(:,:,3) = G3;
G(:,:,4) = G4; G(:,:,5) = G5; G(:,:,6) = G6;


 
 