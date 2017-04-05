function [ new_state, reward ] = grid_world_transition_reward( currS, action)
%The input currS is from set S
%new_state is from S+

UNo = [1,2,3];
DNo = [12,13,14];
LNo = [4,8,12];
RNo = [3,7,11];
switch action
    case 'up'
        if(~any(currS == UNo))
            new_state = currS - 4;
        else
            new_state = currS;
        end
    case 'down'
        if(~any(currS ==  DNo))
            new_state = currS + 4;
        else
            new_state = currS;
        end
    case 'left'
        if(~any(currS == LNo))
            new_state = currS - 1;
        else
            new_state = currS;
        end
    case 'right'
        if(~any(currS == RNo))
            new_state = currS + 1;
        else
            new_state = currS;
        end
end
reward = -1;
end

