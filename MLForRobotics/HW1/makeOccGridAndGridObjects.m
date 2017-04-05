%make occupancy grid
for i=1:size(Landmark_Groundtruth,1)
    xL = Landmark_Groundtruth(i, 2);
    yL = Landmark_Groundtruth(i,3);
    obsY_ind = find(xRange < xL, 1, 'last' );
    obsX_ind = length(yValues) - find(yRange < yL, 1, 'last' ) + 1;
    occ_grid(obsX_ind, obsY_ind) = 1;
end
%make grid objects. 
for i=1:size(grids,1)
    for j=1:size(grids,2)
        grids{i,j} = Grid();
        grids{i,j}.setLocsAndH(xValues(j), yValues(length(yValues) - i + 1));
        grids{i,j}.setHval(goal_loc(1), goal_loc(2));
        grids{i,j}.setCost(occ_grid(i,j));
%         text(grids{i,j}.xLoc, grids{i,j}.yLoc, num2str(grids{i,j}.h_val), 'HorizontalAlignment', 'center');
    end
end