xRange = -2:0.1:5;
yRange = -6:0.1:6;
grids = cell(length(yRange) - 1, length(xRange) - 1);
occ_grid = zeros(length(yRange) - 1, length(xRange) - 1);
xValues = xRange + 0.05; 
xValues(end) = [];
yValues = yRange + 0.05;
yValues(end) = [];


figure; hold on;
b = [min(yRange) max(yRange)];
for i=1:length(xRange)
    line( [xRange(i) xRange(i)],b, 'LineWidth', 0.8);   
end
a = [min(xRange), max(xRange)];
for i=1:length(yRange)
    line(a, [yRange(i), yRange(i)], 'LineWidth', 0.8)
end
axis([-3 6 -7 7]); 
axis square;
grid on;
%draw test rectangle
% rectangle('Position', [-1 -5 1,1], 'FaceColor', 'k');



for i=1:size(Landmark_Groundtruth,1)
    xL = Landmark_Groundtruth(i, 2);
    yL = Landmark_Groundtruth(i,3);
    obsX = xRange(find(xRange < xL, 1, 'last' ));
    obsY = yRange(find(yRange < yL, 1, 'last' ));
    for j=-3:3
        for k=-3:3
            rectangle('Position',[obsX + j*0.1, obsY+k*0.1, 0.1,0.1], 'FaceColor', 'k');
        end
    end
    
end
xlabel('World X Axis (m)');
ylabel('World Y Axis (m)');
title('Occupancy Grid and Paths - Q7');
setActions;



for m=1:3
    [start_loc, goal_loc] = assignStartEndLocs_Q5(m);
    makeOccGridAndGridObjects_Q5;
    getStartEndIndices_Q5;


    scatter(grids{start_ind(1), start_ind(2)}.xLoc, grids{start_ind(1), start_ind(2)}.yLoc, 20.5, 'b', 'filled');
    scatter(grids{goal_ind(1), goal_ind(2)}.xLoc, grids{goal_ind(1), goal_ind(2)}.yLoc, 20.5, 'g', 'filled');

    current = start_ind;
    explored = [];
    nbors = [];
    while sum(goal_ind == current) ~= 2 %has not reached goal yet
        explored = [explored; current];
        nbors = neighbors_Q5(current, actions);
        nbors = unique(nbors,'rows');
        %remove those cells from neighbors that have already been explored. ?
        nbors = remove_explored(nbors, explored);
        cost = zeros(size(nbors,1), 1);
        for i=1:size(nbors, 1) %for all neighbors current state
           cost(i) = grids{nbors(i,1), nbors(i,2)}.cost + grids{nbors(i,1), nbors(i,2)}.h_val;
        end
        mincost_index = find(cost == min(cost));
        mincost_index = mincost_index(1); %pick one in case of tie.
        current = nbors(mincost_index, :);
    end

    explored = [explored; current]; %append the last one
    % disp(~isempty(frontier))

    hold on;
    %draw the path
    for i=1:length(explored)-1
        xpoints = [grids{explored(i,1), explored(i,2)}.xLoc,grids{explored(i+1,1), explored(i+1,2)}.xLoc];
        ypoints = [grids{explored(i,1), explored(i,2)}.yLoc,grids{explored(i+1,1), explored(i+1,2)}.yLoc];
        line(xpoints, ypoints, 'LineWidth', 2.0, 'Color', 'r');
    end
    waypoints = zeros(length(explored), 2);
    for i=1:length(explored)
        waypoints(i, :) = [grids{explored(i,1), explored(i,2)}.xLoc, grids{explored(i,1), explored(i,2)}.yLoc];
    end
    
    %drive paths
    drive_paths;
end
text(3, 6.8, '\bullet - Start Point', 'Color', 'b', 'FontSize', 8);
text(3, 6.4, '\bullet - Goal Point', 'Color', 'g','FontSize', 8);
