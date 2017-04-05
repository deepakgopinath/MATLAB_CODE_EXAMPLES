function [ new_state, reward ] = state_transition_reward (currS, action)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

%special states
A = [1,2];
B = [1,4];

%check for special states right away. 
if(currS(1) == A(1) && currS(2) == A(2)) %in A now. For any action next state is 5,2 and reward is +10
    new_state = [5,2];
    reward = 10;
    return;
end

if(currS(1) == B(1) && currS(2) == B(2)) %in A now. For any action next state is 5,2 and reward is +10
    new_state = [3,4];
    reward = 5;
    return;
end

%edge cases;

switch action
    case 'north'
        disp('action is north');
        %Check if the currS is first row. Then next state is same as curr
        %state and reward is -1
        if(currS(1) == 1)
            new_state = currS;
            reward = -1;
            return;
        end
    case 'south'
        disp('action is south');
        if(currS(1) == 5) %is it the bottom row
            new_state = currS;
            reward = -1;
            return;
        end
    case 'east'
        disp('action is east');
        if(currS(2) == 5) % is it right most column
            new_state = currS;
            reward = -1;
            return;
        end
    case 'west'
        disp('action is west');
        if(currS(2) == 1) % is it the left most column
            new_state = currS;
            reward = -1;
            return;
        end
end

%now the all the remaining valid cases.
switch action
    case 'north'
        new_state = [currS(1) - 1, currS(2)];
        reward = 0;
        return;
    case 'south'
        new_state = [currS(1) + 1, currS(2)];
        reward = 0;
        return;
    case 'east'
        new_state = [currS(1), currS(2) + 1];
        reward = 0;
        return;
    case 'west'
        new_state = [currS(1), currS(2) - 1];
        reward = 0;
        return;
end
% new_state = [1,1];
% reward = -1;
end

