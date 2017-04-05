clear; clc; close all;

%porblem as an undiscounted episodic finite MDP

S = (1:99)'; %Gambler's capital from 1$ to 99$. 
Splus = (0:100)'; % 0 and 100$ are the terminal states. 

%when the coin comes up head, he wins whats at stake and he loses his
%stake. 

V = zeros(length(Splus), 1);
Q = cell(length(Splus), 1);
actions = cell(length(Splus), 1);

for i=2:length(actions) - 1
    actions{i} = (1:min(i-1, 100-(i-1)))';
end

maxIter = 10000;
delta = 0;
eps = 10^-8;
 policy = zeros(length(S), 1);
 index = 0; maxPI = 1000;
while index < maxPI
    while 1
        delta = 0;
        for j=1:length(S)
            v = V(j+1); %for comparison
            vtemp = 0;
            currActList = actions{j+1}; %get the list of actions for current state (j). 
            Qtemp = []; %Q value for current state. Temporary array
            for k=1:length(currActList)
               currA = currActList(k);
               Qtemp(k) = bellman_rhs(j, currA, V);%j is the current state
            end
            Q{j+1} = Qtemp; %Qvalue array for each state. 
            V(j+1) = max(Qtemp); %get the maximum Q value and assign it as state value function for state j;
            delta = max(delta, abs(v - V(j+1)));
        end
        if delta < eps
            disp('break');
            break;
        end
    end


    for j=1:length(S)
        Qtemp = [];
        currActList = actions{j+1};
        for k=1:length(currActList)
            currA = currActList(k);
            Qtemp(k) = bellman_rhs(j, currA, V); %We have the "converged" V for this policy 
        end
        Q{j+1} = Qtemp;
    end
    %output deterministic policy from V
   
    for i=1:length(S)
        currQ = Q{i+1};
        currAct = actions{i+1};
        maxQ = max(currQ);
        argmaxQ = find(currQ == max(currQ));
        policy(i) = argmaxQ(1); %break ties using the first element
    end
    index = index + 1;
end

stairs(policy);
figure;
plot(V);