%This script implements the sequential forward feature selection

% n is the nth feature under consideration 
% m variable controls the depth of the sequential forward selection tree
% structure. Maximum of m is 10 in our case.
% f is a combination of n features. 
% q is the most accurate feature combination for n - 1th iteration;

% for each n, the best combination's accuracy is noted and plotted. The
% average for each n was also plotted, but it made more sense to plot the
% accuracy for the best performing feature combination for each n;

f = [];
q = [];
maxRetVal = 0;
m = 1;
accumretVal = 0;
accuracyArray = [];
bestFeatureSelectionForEachDepth = [];
n = 1;
while n <= 10
    
    if(sum(n == q) == 0) % only if the new feature being picked is not in the alredy existing feature list
        
    f = [q n];
    retVal = TenFoldCrossValidation(randomizedA, f, 1, 0); %k = 1 %performs TenFold validation on each feature combination
    accumretVal = accumretVal + retVal;
        if(retVal > maxRetVal)
         maxRetVal = retVal; % At the end This contains the best feature subset for each size(f) = number of features used
         maxRetValIndex = n;
        end
    end
    if(n == 10 && m <= 10)
        n = 0; %reset the loop for within to keep going for the next layer of features; continue this until we get to the bottom of the tree etructure
        accuracyArray = [accuracyArray maxRetVal];%accumretVal/(10 - m + 1)]; % everytime the number of valus returned from 10-fold classification is one less
        maxRetVal %print the maximum accuracy value for each tree depth
        q = [q maxRetValIndex] %Pick the best feature combination from previous layer. 
        bestFeatureSelectionForEachDepth = [ bestFeatureSelectionForEachDepth ; [zeros(1,10 - size(q,2)) q]]; %to keep track of what feature combination gives best results for each tree depth
        %bestFeatureSelectionForEachDepth
        m = m + 1;
        maxRetVal = 0; %reset all the values for next iteration
        accumretVal = 0;
    end
    if(m == 11)
        break; %break from while
    end
    n = n + 1;
end

[so maxIndex] = find(accuracyArray == max(accuracyArray));

bestF = trimZeros(bestFeatureSelectionForEachDepth(maxIndex, :));



figure;
plot(accuracyArray*100); %In percent
xlabel('Number of features');
ylabel('Accuracy of best feature combination');
