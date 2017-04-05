function [isSame] = allExampleSameClassificationCheck( data )
%check if all the examples have the same label or not. returns true or
%false.

d = size(data,2) - 1;
labels = data(:,d+1);
if(length(unique(labels)) == 1)
    isSame = true;
else
    isSame = false;
end 

end

