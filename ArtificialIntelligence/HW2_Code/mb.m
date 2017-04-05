function [ markovBlanket ] = mb(dag, i)
% X - query variable whose posterior needs to be calculated
% N - is a zero vector whose length is same as the domain length of X
% dag - is the matrix which tells us the connection matrix. needed to
% determine the markov blanke

   mb = [];
   x = parents(dag, i); % extract the parents
   if(size(x, 2) ~= 0) % if there are parents append it.
    mb = [mb x]; 
   end
   y = children(dag, i); % if there are children append it
   if(size(y, 2) ~= 0)
    mb = [mb y];
   end
   for j=1:length(y) % extract children's parents besides itself
        z = parents(dag,y(j));
        z(z == i) = [];
        if(size(z, 2) ~= 0)
            mb = [mb z];  
        end
   end
   mb = unique(mb); % remove duplicates
%    fprintf('The markov blanket for %d is \n', i);
   markovBlanket = mb;

end

