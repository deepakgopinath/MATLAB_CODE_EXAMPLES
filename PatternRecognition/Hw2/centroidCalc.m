points = [-1, -1; -2, -2; -3, 0; 1, -2; 0, 1];
distanceMatrix = zeros(5,4);
for n=1:length(points)
    for m=1:length(points)
        if(m ~= n)
            distanceMatrix(n,m) = weightedL3(points(n,:), points(m,:));
        end
    end 
end
sumdistanceMatrix = sum(distanceMatrix, 2);
[val, index] = min(sumdistanceMatrix);

disp('The mean center is')
points(index, :)