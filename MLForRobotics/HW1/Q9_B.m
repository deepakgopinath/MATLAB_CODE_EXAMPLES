xRange = -2:5;
yRange = -6:6;
grids = cell(length(yRange) - 1, length(xRange) - 1);
occ_grid = zeros(length(yRange) - 1, length(xRange) - 1);
xValues = xRange + 0.5; 
xValues(end) = [];
yValues = yRange + 0.5;
yValues(end) = [];
rad = 0.3;
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

%Draw the world
for i=1:size(Landmark_Groundtruth,1)
    xL = Landmark_Groundtruth(i, 2);
    yL = Landmark_Groundtruth(i,3);
    obsX = xRange(find(xRange < xL, 1, 'last' ));
    obsY = yRange(find(yRange < yL, 1, 'last' ));
    rectangle('Position',[obsX, obsY, 1,1], 'FaceColor', 'k');
end
xlabel('World X Axis (m)');
ylabel('World Y Axis (m)');
title('Occupancy Grid and Paths - Q9');
setActions;

for m=1:3
     replan_index = 1;
    [curr_loc, goal_loc] = assignStartEndLocs(m);
    makeOccGridAndGridObjects;
%     [curr_ind, goal_ind] = getStartEndIndicesQ3_func(grids, curr_loc, goal_loc);
    curr_ind = getindices(xValues, yValues, curr_loc);
    goal_ind = getindices(xValues, yValues, goal_loc);
   
    while sum(curr_ind == goal_ind) ~= 2 %has not reached goal yet. 

        %plan path from current path to goal. 
        current = curr_ind;
        explored = [];
        nbors = [];
        while sum(goal_ind == current) ~= 2 %has not reached goal yet
            explored = [explored; current];
            nbors = neighbors(current, actions);
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
        explored = [explored; current];
        if replan_index == 1
            scatter(grids{curr_ind(1), curr_ind(2)}.xLoc, grids{curr_ind(1), curr_ind(2)}.yLoc, 20.5, 'b', 'filled');
            scatter(grids{goal_ind(1), goal_ind(2)}.xLoc, grids{goal_ind(1), goal_ind(2)}.yLoc, 20.5, 'g', 'filled');
            for i=1:length(explored)-1
                xpoints = [grids{explored(i,1), explored(i,2)}.xLoc,grids{explored(i+1,1), explored(i+1,2)}.xLoc];
                ypoints = [grids{explored(i,1), explored(i,2)}.yLoc,grids{explored(i+1,1), explored(i+1,2)}.yLoc];
                line(xpoints, ypoints, 'LineWidth', 2.0, 'Color', 'r');
            end
        end
        %check for nodes that are obstacles while replanning.



        rem_ind = [];
        for i=1:size(explored,1)
            if occ_grid(explored(i,1), explored(i,2)) == 1
                rem_ind = [rem_ind i];
            end
        end
        explored(rem_ind, :) = [];
        if replan_index ~= 1 && ~isempty(rem_ind)
            [temp_v, temp_w] = ik_controller(curr_loc(1), curr_loc(2), curr_angle, grids{explored(1,1), explored(1,2)}.xLoc, grids{explored(1,1), explored(1,2)}.yLoc );
            temp_cl = [temp_v', temp_w'];
            temp_traj = curr_loc;
            temp_traj(1,3) = deg2rad(curr_angle);
            temp_i = 1;
            for j=1:size(temp_cl,1)-1
                [temp_traj(temp_i+1, 1),temp_traj(temp_i+1,2),temp_traj(temp_i+1, 3)] = motion_model_stochastic(temp_traj(temp_i, 1),temp_traj(temp_i, 2),temp_traj(temp_i, 3), temp_cl(j,1), temp_cl(j,2), dt);
                 curr_loc = temp_traj(temp_i+1, 1:2);
                 curr_angle = rad2deg(temp_traj(temp_i+1, 3)); %degree
                temp_i = temp_i+1;
            end
            for i=1:size(temp_traj,1)-1
                xpoints = [temp_traj(i,1) temp_traj(i+1,1)];
                ypoints = [temp_traj(i,2) temp_traj(i+1,2)];
                line(xpoints, ypoints, 'LineWidth', 2.0, 'Color', 'b');
            end
        end
        %make the waypoints
        waypoints = zeros(size(explored,1), 2);
        for i=1:size(explored,1)
            waypoints(i, :) = [grids{explored(i,1), explored(i,2)}.xLoc, grids{explored(i,1), explored(i,2)}.yLoc];
        end
        
        %if upon moving the robot actually drifts and the grid it ends up
        %being is no longer the current path, then recompute the path by
        %updating the current grid. 
        if replan_index ~= 1
            waypoints(1,:) = [];
            waypoints = [curr_loc; waypoints];
        end
        dt = 0.1;
        wayposes = waypoints;
        index = 1;
        traj= wayposes(1,:);
        control_list = [];
        if replan_index == 1
            curr_angle = -90; %in rad
        end
        traj(1,3) = deg2rad(curr_angle);
        isReplan = false;
        for i=1:size(wayposes, 1)-1
            [v,w] = ik_controller(wayposes(i,1), wayposes(i,2), curr_angle, wayposes(i+1,1), wayposes(i+1,2));
            control_list = [v', w'];
            %draw a circle with correct heading at the beginning of each chunk
            xc = traj(index, 1); yc =traj(index, 2);
            blx =  xc - rad; bly = yc - rad;
            pos = [blx, bly, 2*rad,2*rad];
            rectangle('Position',pos,'Curvature',[1 1], 'LineWidth', 2.0);
            line([xc, xc + rad*cos(deg2rad(curr_angle))], [yc, yc + rad*sin(deg2rad(curr_angle))], 'LineWidth', 2.0, 'Color', 'k');
           
            
            for j=1:size(control_list,1)
                [traj(index+1, 1),traj(index+1,2),traj(index+1, 3)] = motion_model_stochastic(traj(index, 1),traj(index, 2),traj(index, 3), control_list(j,1), control_list(j,2), dt);
                traj_index = getindices(xValues, yValues,traj(index, 1:2));
                curr_loc = traj(index+1, 1:2);
                curr_angle = rad2deg(traj(index+1, 3)); %degrees
                if ismember(traj_index, explored, 'rows') == 0
                    isReplan = true;
                    replan_index = replan_index + 1;
                    break;
                end
                index = index + 1;
            end
            
            if isReplan
                break;
            end
        end

        for i=1:size(traj,1)-1
            xpoints = [traj(i,1) traj(i+1,1)];
            ypoints = [traj(i,2) traj(i+1,2)];
            line(xpoints, ypoints, 'LineWidth', 2.0, 'Color', 'b');
        end
        curr_ind = getindices(xValues, yValues, curr_loc);

    end
end