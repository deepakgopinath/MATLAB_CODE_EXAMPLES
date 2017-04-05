close all;
xRange = -2:5; %grid x range
yRange = -6:6; %grid y range

figure; hold on;

%draw the grid
b = [min(yRange) max(yRange)];
for i=1:length(xRange)
    line( [xRange(i) xRange(i)],b, 'LineWidth', 1.5);   
end
a = [min(xRange), max(xRange)];
for i=1:length(yRange)
    line(a, [yRange(i), yRange(i)], 'LineWidth', 1.5)
end
axis([-3 6 -7 7]); 
axis square;
grid on;

%mark landmarks in the world
for i=1:size(Landmark_Groundtruth,1)
    xL = Landmark_Groundtruth(i, 2);
    yL = Landmark_Groundtruth(i,3);
    obsX = xRange(find(xRange < xL, 1, 'last' ));
    obsY = yRange(find(yRange < yL, 1, 'last' ));
    rectangle('Position',[obsX, obsY, 1,1], 'FaceColor', 'k');
end
xlabel('World X Axis (m)');
ylabel('World Y Axis (m)');
title('Occupancy Grid and Paths - Q3');