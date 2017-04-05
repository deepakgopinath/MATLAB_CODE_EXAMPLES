function [ res ] = remove_explored(nbors, explored)
%input = neighbor list, explored list
%output - neighbors - explored

remove_index = [];
for i=1:size(nbors,1 )
    if ismember(nbors(i,:), explored, 'rows')
        remove_index = [remove_index i];
    end
end
nbors(remove_index, :) = [];
res = nbors;

end

