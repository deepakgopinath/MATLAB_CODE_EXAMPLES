x = [0 0; 1 0; 0 1];
y = [ 1 1; 2 0; 2 2];
scatter(x(:,1), x(:,2), 'o', 'r');
hold on;
scatter(y(:,1), y(:,2), '+', 'b');
hold on;
line([1.5, 0], [0, 1.5]);
line([1,0], [0,1]);
line([2,0], [0, 2]);