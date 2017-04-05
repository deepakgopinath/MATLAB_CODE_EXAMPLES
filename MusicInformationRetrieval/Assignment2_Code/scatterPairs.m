function [ output_args ] = scatterPairs( A, i, j, xl, yl )

figure;

scatter(A(1:100, i), A(1:100, j), '+', 'b');  %Each genre gets a color!
hold on;

scatter(A(101:200, i), A(101:200, j), '+', 'g');
hold on;

scatter(A(201:300, i), A(201:300, j), '+', 'black');
hold on;

scatter(A(301:400, i), A(301:400, j), '+', 'yellow');
hold on;

scatter(A(401:500, i), A(401:500, j), '+', 'magenta');


xlabel(xl);
ylabel(yl);
end

