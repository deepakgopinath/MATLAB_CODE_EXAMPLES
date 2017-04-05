clear;
clc;
close all;

init_grid_world;

maxPEval = 1000;
delta = 0;
gamma = 1;
eps = 0.001;

for i=1:maxPEval
    delta = 0;
    for j=1:length(S)
        v = V(j+1);
        for k=1:length(A)
            [nS, r] = grid_world_transition_reward(j, A{k});
            Q(j+1, k) = 1*(r + gamma*V(nS+1)); %Q function
        end
        V(j+1) = max(Q(j+1, :)); %
        delta = max(delta, abs(v - V(j+1)));
    end
    if delta < eps
        break;
    end
end

%output deterministic policy from V

maxQ =  max(Q, [], 2);
policy = zeros(length(Splus), 1);
for i=2:length(maxQ)-1
    argmaxA = find(Q(i,:) == maxQ(i));
    policy(i) =  argmaxA(1);
end
    