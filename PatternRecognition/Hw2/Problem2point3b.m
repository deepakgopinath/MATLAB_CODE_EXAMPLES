clear all

syms x y
f(x,y) = (abs(x)^3 + abs(y)^3)^(1/3.0);
g(x,y) = (abs(x-1)^3 + abs(y-1)^3)^(1/3.0);
disp('Plotting the decision boundary');

ezplot(f == g)