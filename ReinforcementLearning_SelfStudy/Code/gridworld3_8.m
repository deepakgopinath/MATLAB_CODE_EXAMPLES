clear; 
clc;
close all;

%Setup the world. 
ws = 5;
world = zeros(ws,ws);
actions = {'north', 'south', 'east', 'west'};
currS = randi([1,ws],1,2); % random initial state. 

V = zeros(ws,ws); %initialize value function to random values. 
gamma = 0.9;

%for each state, the probability of taking one of the 4 actions is 0.25.
%The current policy is then pi(s,a) = 0.25 for all s and all a. 
policy = 0.25*ones(ws,ws,length(actions));
delta = 0;
maxIter = 10;
eps = 0.001;
for i=1:maxIter
    delta = 0;
    for j=1:ws
        for k=1:ws
            v = V(j,k);
            vtemp = 0;
            for p=1:length(actions)
                [nS_p, reward_p] = state_transition_reward([j,k], actions{p}); 
                vtemp = vtemp + policy(j,k,p)*(reward_p + gamma*V(nS_p(1), nS_p(2)));
            end
            V(j,k) = vtemp;
            delta = max(delta, abs(v - V(j+1)));
        end
    end
    if delta < eps
        break;
    end
end



