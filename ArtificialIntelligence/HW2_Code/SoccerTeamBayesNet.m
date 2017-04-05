% bayes net implementation of soccer teams

clear all;

N = 6; % 6 variables
dag = zeros(N,N); % to determine the connections between the nodes. 

qA = 1; qB = 2; qC = 3; Oab = 4; Obc = 5; Oac = 6; %ids for the variables
node_names = {'QualityA', 'QualityB', 'QualityC', 'OutcomeAB', 'OutcomeBC', 'OutcomeAC'}; %the outcome variable shows the probability of the first team in the pair winning, drawing or losing.
% list of connections between the nodes. 

dag(qA, Oab) = 1; 
dag(qA, Oac) = 1;
dag(qB, Oab) = 1;
dag(qB, Obc) = 1;
dag(qC, Obc) = 1;
dag(qC, Oac) = 1;

discrete_nodes = 1:N; % all the nodes are discrete random variables
node_sizes = [4 4 4 3 3 3]; %quality can take 4 discrete values (0 1 2 3) and the outcome can take 3 discrete values (W, D, L)
bnet = mk_bnet(dag, node_sizes, 'discrete', discrete_nodes, 'names', node_names);


PqA = [0.1 0.35 0.45 0.1]; % probability tables for the qualities. arbitrarily assigned by me.
PqB = [0.05 0.4 0.4 0.15];
PqC = [0.1 0.2 0.3 0.4];

%the CPT for each outcome is the same and will contain 16 rows with 3
%entries each. only 7 unique rows are present as the conditional
%probability only depends on the differences. The possible differences are
%-3,-2, -1, 0, 1,2,3
POGivenQualities = [1/3 0.2 0.1 0.01 0.6 1/3 0.2 0.1 0.7 0.6 1/3 0.2 0.9 0.7 0.6 1/3 1/3 0.2 0.2 0.09 0.2 1/3 0.2 0.2 0.2 0.2 1/3 0.2 0.09 0.2 0.2 1/3 1/3 0.6 0.7 0.9 0.2 1/3 0.6 0.7 0.1 0.2 1/3 0.6 0.01 0.1 0.2 1/3]; 

bnet.CPD{qA} = tabular_CPD(bnet, qA , PqA);
bnet.CPD{qB} = tabular_CPD(bnet, qB, PqB);
bnet.CPD{qC} = tabular_CPD(bnet, qC, PqC);
bnet.CPD{Oab} = tabular_CPD(bnet, Oab, POGivenQualities);
bnet.CPD{Obc} = tabular_CPD(bnet, Obc, POGivenQualities);
bnet.CPD{Oac} = tabular_CPD(bnet, Oac, POGivenQualities);

% Draw the graph.
G = bnet.dag;
draw_graph(G);

% exact inference engine used is the junction tree engine

%P(Obc = 1 | Oab = 1, Oac = 2) 

% engine = jtree_inf_engine(bnet);
engine = var_elim_inf_engine(bnet); % using variable elimination inference engine
evidence = cell(1,N);
evidence{Oab} = 1;
evidence{Oac} = 2;
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [Obc], 1);
Prob = m.T(:);
%exact inference

for i=1:3
    fprintf('P(Obc = %d| Oab = 1, Oac = 2)  = %f\n', i, Prob(i));
end

% gibbs sampling

% random start state
currentState = [2 3 1 1 2 2]; % evidence variables are variable 4 and 6, query variable is 5
nonEvidence = [1 2 3 5]; % non evidence variables, 4 and 6 are evidence given to us
mbCell = cell(length(nonEvidence), 1); % for markov blanket of the non evidence variables
for i=1:length(nonEvidence)
    mbCell{i,1} = mb(dag, nonEvidence(i)); % calculate the markov blanket once and for all
end
evidence = cell(1,N); % enter the given evidence
evidence{Oab} = 1; % win
evidence{Oac} = 2; % draw
 
% query variable is Obc
varCounter = zeros(node_sizes(Obc), 1); % to keep track of the values generated for the query variable

max_iter = 100000;

plotterTracker = zeros(max_iter, 1); % to plot the convergence
for k=1:max_iter
    for i=1:length(nonEvidence)
        p = nonEvidence(i); 
        evidence = cell(1,N); % we have to reenter the evidence because in Gibb's sampling for every new sample we have to calculate a new conditional
        for j=1:length(mbCell{i,1}) % only enter evidence from the markov blanket of the current variable that is being sampled
            evidence{mbCell{i,1}(j)} = currentState(mbCell{i,1}(j));
        end
        [engine, loglik] = enter_evidence(engine, evidence);
        m = marginal_nodes(engine,p, 1);
        Prob = m.T(:); % vector of distributions
        if(p == qA || p == qB || p == qC)
            currentState(p) = str2num(randsample('1234', 1, true, m.T(:)')); % random sample from the weighted distribution. 
        else
            currentState(p) = str2num(randsample('123', 1, true, m.T(:)'));
        end
        if(p == Obc)
           varCounter(currentState(p)) = varCounter(currentState(p)) +  1; % keep track of which value of the query variable is being generated at every sample state
        end
        x = normalize(varCounter);
        plotterTracker(k) = x(1);
    end
end
fprintf('The probability distribution from Gibbs sampling is %f\n', normalize(varCounter));

plot(1:max_iter, plotterTracker); % plot convergence


% Metropolis hastings Algorithms

% define the state space. The proposal distributuion will be a uniform
% distribution. This will make it symmetric and make the acceptance
% probability calculation much simpler.

nonEvidence = [1 2 3 5];
lengthOfSampleWorld = prod(node_sizes(nonEvidence)); %4*4*4*3 = 192

%create all the configs of the nonEvidence Variables so that when sampling
%the samples can be picked as a lookup table. 
sampleWorld = zeros(lengthOfSampleWorld, 4);

%this works only for this particualr nonEvidence variable combination
for i=1:lengthOfSampleWorld
    sampleWorld(i,1) = floor((i-1)/(lengthOfSampleWorld/4)) + 1;
    sampleWorld(i,2) = mod((floor((i-1)/(lengthOfSampleWorld/16))),4) + 1;
    sampleWorld(i,3) = mod(floor((i-1)/(lengthOfSampleWorld/64)),4) + 1;
    sampleWorld(i,4) = mod(i-1,3) + 1;
end

% the proposal distribution is a transition probability table with 192 by
% 192 elements. If uniform is considered the values of the matrix are 1/192
% since the proposal distribution is uniform it is symmetric. Therefore it
% doesn't play a role in the acceptance probability calculation

qDistribution = (1/lengthOfSampleWorld)*ones(lengthOfSampleWorld, lengthOfSampleWorld);
varCounter = zeros(node_sizes(Obc), 1);
max_iter = 100000;
plotterTracker = zeros(max_iter, 1);
evidence = cell(1,N);
evidence{Oab} = 1; % win
evidence{Oac} = 2; % draw
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [qA qB qC Obc], 1); %P(x|e) do not change during the course of sampling. 
currentState = [2 3 1 1 2 2]; % random start state assigned by hand;

for iter=1:max_iter
    r = randi(lengthOfSampleWorld); % generate a new sample according a uniform proposal distribution
    xStar = sampleWorld(r,:); % go and pick the rth sample from the table
    piX = m.T(currentState(nonEvidence(1)),currentState(nonEvidence(2)),currentState(nonEvidence(3)),currentState(nonEvidence(4)));
    piXstar = m.T(xStar(1), xStar(2), xStar(3), xStar(4));
    alpha = min(1, piXstar/piX);
    u = rand();
    if u<=alpha % check if the sample should be accepted or not. If not leave current state unchanged
        currentState(nonEvidence) = xStar;
    end
    varCounter(currentState(Obc)) =  varCounter(currentState(Obc)) + 1; 
    x = normalize(varCounter);
    plotterTracker(iter) = x(1);
end
fprintf('The probability distribution from Metropolis Hastings sampling is %f\n', normalize(varCounter));
plot(1:max_iter, plotterTracker);

