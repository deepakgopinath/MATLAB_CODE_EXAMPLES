
clear; clc;
%Parameters of the system
Le = 120 * 10^-3;
W = 80 * 10^-3;
H = 0.5* 10^-3;
rho = 2400;
V = Le*W*H;
M = (rho*V)*0.5;
wn = 35000 * 2*pi;
K = (wn^2)*M;
Cp = 20*10^-9;
Q = 70;
B = sqrt(M*K)/Q;
n = 0.268;
A1= [-B/M -K; 1/M 0];
B1 = [n;0];
C1 = [0 1];
D1 = [0];

H1 = ss(A1,B1,C1,D1);
TF1 = tf(H1);

bode (H1);
[g, p] = getPeakGain(H1); % resonant frequency
disp(['b. The magnitude response for the second order system is ', num2str(3*g/10^-6), ' microns'
    ]);
disp('    This amplitude is not sufficient');


%Get the resonant frequency of the first system. Make L such that the
%resonant frequency of the LC system is the resonant freq of the first system
L = 1/(Cp*p^2);

%***************

A2 = [0 -1/Cp 0 0;
      1/L 0 -n/M 0;
      0 n/Cp -B/M -K;
      0 0 1/M 0];

B2 = [1,0,0,0]';
C2 = [0,0,0,1];
D2 = [0];
H2 = ss(A2,B2,C2,D2);
TF2 = tf(H2);
figure;
bode(H2);

[g,p] = getPeakGain(H2);
disp('    ');
disp(['d. The magnitude response for the fourth order system is ', num2str(3*g/10^-6), ' microns and this is within operating range'
    ]);
disp('  ');
disp('Part E: The heat dissipated from the piezo has not be taken into account in the previous model. This resistive element will make the piezo system ');
disp('an LRC system. This means the resonance peak will be actually lower than a pure LC system. If we go about modeling the system');
disp('as a pure LC system, we will be getting underwhelming results. The critical element missing in this model is the resistive element');
disp('associated with the piezo ');
disp('   ');
disp('Part F: From the state equations we can see that the displacement of the mass will be greater if the voltage across the ');
disp('capacitor. However, we cannot change the source voltage. Therefore in order to increase the voltage across the');
disp('capacitor we can probably add a transformer between the 1 and 0 junctions (shown in the figure');

