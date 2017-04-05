
grids = cell(length(yRange) - 1, length(xRange) - 1);
occ_grid = zeros(length(yRange) - 1, length(xRange) - 1);
xValues = xRange + 0.5; %mid points of the grid cells
xValues(end) = [];
yValues = yRange + 0.5;
yValues(end) = [];

%Make a Grid class which represent a grid cell. The member vars can be the
%actual X value, Y value, Heuristic to the goal, and maybe even g(s)? and
%maybe even f(s). 

%in the main function create a 2d array of objects of type Grid. The array
%index does not have anything to do with the "actual" position of the
%robot. However "transitions between grids can be in the terms of array
%indices. 1,1 being the top left and 12,7 being bottom right
waypoints = [];
for m=1:3 %for each start end pair
    [start_loc, goal_loc] = assignStartEndLocs(m);
    makeOccGridAndGridObjects; %this is necessary every time because heuristics change
    getStartEndIndices; %get indices for start and end goal
    setActions;

    %mark start and goal points
    scatter(grids{start_ind(1), start_ind(2)}.xLoc, grids{start_ind(1), start_ind(2)}.yLoc, 100.5, 'b', 'filled');
    scatter(grids{goal_ind(1), goal_ind(2)}.xLoc, grids{goal_ind(1), goal_ind(2)}.yLoc, 100.5, 'g', 'filled');
    
    %Online A*
    current = start_ind;
    explored = [];
    nbors = []; %for every step

    while sum(goal_ind == current) ~= 2 %has not reached goal yet
        explored = [explored; current];
        nbors = neighbors(current, actions);
        nbors = unique(nbors,'rows');
        %remove those cells from neighbors that have already been explored. 
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
        line(xpoints, ypoints, 'LineWidth', 2.5, 'Color', 'r');
    end
    waypoints = zeros(length(explored), 2);
    for i=1:length(explored)
        waypoints(i, :) = [grids{explored(i,1), explored(i,2)}.xLoc, grids{explored(i,1), explored(i,2)}.yLoc];
    end
   
end




text(3, 6.8, '\bullet - Start Point', 'Color', 'b', 'FontSize', 8);
text(3, 6.4, '\bullet - Goal Point', 'Color', 'g','FontSize', 8);


