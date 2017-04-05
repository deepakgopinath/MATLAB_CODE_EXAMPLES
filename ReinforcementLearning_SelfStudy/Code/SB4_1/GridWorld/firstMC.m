clear;
clc;
close all;

init_grid_world;
policy = 0.25*ones(length(S), length(A)); %given policy. Evaluate this using First MC

returns = cell(length(S), 1); % for each state s in S there will be a list.Therefore make a cells

maxIter = 20000;
index = 0;

while index < maxIter
    %Generate an episode
    episode = []; %list of states in the current episode. 
    currS = randi([1, length(S)],1,1); %start state for episode.

    episode = [episode currS];
    reward_episode = [];
    while currS ~= 0 && currS ~= 15 %when state becomes 0 or 15 we have reached the terminal sttae and the episode is over.
        choice = rand; %pick an action based on the probabilistic policy
        if choice <= 0.25
            currA = A{1};
        elseif choice <= 0.5
            currA = A{2};
        elseif choice <= 0.75
            currA = A{3};
        else
            currA = A{4};
        end
        [nS, r] = grid_world_transition_reward(currS, currA);
        episode = [episode nS];
        reward_episode = [reward_episode r]; %this is the reward obtained when currS transitioned to nS
        currS = nS;
    end
    
    states_in_episode = unique(episode);
%     if states_in_episode(1) == 0
%         states_in_episode(1) = [];
%     elseif states_in_episode(end) == 15
%         states_in_episode(end) = [];
%     end
    for i=1:length(states_in_episode)
        currS = states_in_episode(i);
        if currS == 0 || currS == 15
            continue;
        end
        first_currS = find(currS == episode, 1);
        currS_Return = sum(reward_episode(first_currS:end));
        RTemp = returns{currS};
        RTemp = [RTemp currS_Return];
        returns{currS} = RTemp;
        V(currS + 1) = mean(returns{currS});
    end
    index = index + 1;
end