%create action list for changin indices
actions = cell(8,1); %define actions in terms of strings. 
actions{1} = [0, 1]; %right r
actions{2} = [0, -1]; %left l
actions{3} = [-1, 0]; %up u
actions{4} = [1, 0]; %down d
actions{5} = [-1, 1]; %top right ur
actions{6} = [-1, -1]; %top left ul
actions{7} = [1,-1]; %bottom left bl
actions{8} = [1, 1]; %bottom right  br