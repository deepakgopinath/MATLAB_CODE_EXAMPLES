start_ind = [0 0];
goal_ind = [0 0];
for i=1:size(grids,1)
    for j=1:size(grids,2)
        if grids{i,j}.xLoc == start_loc(1) && grids{i,j}.yLoc == start_loc(2)
            start_ind = [i j];
        end% start_loc = [0.5, -1.5];
% goal_loc = [0.5, 1.5];

         if grids{i,j}.xLoc == goal_loc(1) && grids{i,j}.yLoc == goal_loc(2)
            goal_ind = [i j];
        end
    end
end