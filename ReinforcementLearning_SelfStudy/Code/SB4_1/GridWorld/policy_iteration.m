clear; clc; close all;

init_grid_world;

%Create a random deterministic policy for all states. 
policy = randi([1,length(A)], length(S), 1);
maxPIter = 1000;
maxPEval = 1000; 
delta = 0;
policyStable = false;
gamma = 1;
eps = 0.01;

%POlicy Iteration
for i=1:maxPIter
    %Policy Evaluation stage
    for j=1:maxPEval
        delta = 0;
        for k=1:length(S)
            v = V(k+1); %for comparison
            currA = A{policy(k)};
            [nS, r] = grid_world_transition_reward(k, currA); %grid world only knows about state numbers 1 to 14
            V(k+1) = 1*(r + gamma*V(nS+1)); %kth state is k+1 index in V array. V is wrt to current policy
            delta = max(delta, abs(v - V(k+1)));
        end
        if delta < eps
            break;
        end
    end
    
    %Policy improvement Stage
    policyStable = true;
    for k=1:length(S)
        b = policy(k); %action as a number;
        tempA = zeros(length(A),1); %to compute argmax a
        for m=1:length(A)
            [nS, r] = grid_world_transition_reward(k, A{m});
            tempA(m) = 1*(r + gamma*V(nS+1));
        end
        argmaxA = find(tempA == max(tempA));
        policy(k) = argmaxA(1); %break ties by picking the first element
        if b ~= policy(k)
            policyStable = false;
        end
    end
    if policyStable
        break; %has reached optimal policy
    end
end