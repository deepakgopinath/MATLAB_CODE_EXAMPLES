clear all
syms x y
f(x,y) = ((abs(x-1))^3 + 8*(abs(y-0.5)^3))^(1/3.0)
g(x,y) = (abs(x+1)^3 + 8*(abs(y+0.5))^3)^(1/3.0)
hold on
for n=1:10
    ezplot(f == n)
    ezplot(g == n)

end

ezplot(f == g)