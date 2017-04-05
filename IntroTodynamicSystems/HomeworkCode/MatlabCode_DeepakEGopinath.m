%Code to plot the consitutive relations for Question 2, homework #2. by
%Deepak Edakkattil Gopinath (2909041);

%Part c
clear;
clc;
x = 0:0.01:4;
y1 = (2*x - 0.5*(x.^2)).*(2-x);
figure;
plot(x,y1);
xlabel('x');
ylabel('Phi(x)');
title('Constitutive Relation');

%Part d

y2 = (2*x - 0.5*(x.^2) - 1).*(2-x);
figure;
plot(x, y2);
xlabel('x');
ylabel('Phi(x)');
title('New Constitutive Relation');
