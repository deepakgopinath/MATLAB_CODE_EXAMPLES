clear;
clc;
close all;

%Create the 4 by 4 grid_world
init_grid_world;
policy = 0.25*ones(length(S), length(A));
delta = 0;
maxIter = 6000;
eps = 0.01;
gamma = 1;
for i=1:maxIter
    delta = 0;
    for j=1:length(S)%in-place policy evaluation for all states in S and not S+
        v = V(j+1); %jth
        vtemp = 0;
        for k=1:length(A) %for all actions. 
            [nS,r] = grid_world_transition_reward(j, A{k});
            vtemp = vtemp + policy(j, k)*(1*(r + gamma*V(nS+1))); % r is the expect reward, nS is s'. Since this is a deterministic system. There is no summation over s'
            Q(j+1, k) = 1*(r + gamma*V(nS+1)); 
        end
        V(j+1) = vtemp;
        delta = max(delta, abs(v - V(j+1)));
    end
    if delta < eps
        break;
    end
end

%optimal policy from Q(s,a)
maxQ =  max(Q, [], 2);
policyCell = cell(length(maxQ),1);
for i=2:length(maxQ)-1
    policyCell{i} =  find(Q(i,:) == maxQ(i));
end
