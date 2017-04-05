% Before running, follow these instructions to install BNT 1.0.4:
%  1. open Matlab
%  2. goto the directory this file is in. eg,"cd Documents/CS8803_PGM/BNT"
%  3. goto the FullBNT-1.0.4 directory by typing "cd FullBNT-1.0.4"
%  4. type: "addpath(genpathKPM(pwd))"
%     this may produce warnings, they are okay.

% Student graphical model from:
%   pg. 53 in Probabilistic Graphical Models, by D. Koller and N. Friedman
% Bayes Net Toolbox by Ken Murphy:
%   http://people.cs.ubc.ca/~murphyk/Software/BNT/bnt.html

clear all;

% create Bayes graph structure
N = 5; 
dag = zeros(N,N);
Diff = 1; Intel = 2; Grade = 3; Sat = 4; Letter = 5;
node_names = {'Diff', 'Intel', 'Grade', 'Sat', 'Letter'};
dag(Diff, Grade) = 1;
dag(Intel, [Grade Sat]) = 1;
dag(Grade, Letter) = 1;

% create structure of each node
discrete_nodes = 1:N;
node_sizes = [2 2 3 2 2]; % number of discrete value the nodes can take
bnet = mk_bnet(dag, node_sizes, 'discrete', discrete_nodes, 'names', node_names);

% define parameters
bnet.CPD{Diff} = tabular_CPD(bnet, Diff, [0.6 0.4]);
bnet.CPD{Intel} = tabular_CPD(bnet, Intel, [0.7 0.3]);
bnet.CPD{Grade} = tabular_CPD(bnet, Grade, [0.3 0.05 0.9 0.5 0.4 0.25 0.08 0.3 0.3 0.7 0.02 0.2]);
bnet.CPD{Sat} = tabular_CPD(bnet, Sat, [0.95 0.2 0.05 0.8]);
bnet.CPD{Letter} = tabular_CPD(bnet, Letter, [0.1 0.4 0.99 0.9 0.6 0.01]);

% draw graph
G = bnet.dag;
draw_graph(G);

% compute P(letter=1)
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [Letter], 1);
Prob = m.T(1);
fprintf('P(letter=1) = %f\n',Prob);

% compute P(letter=2)
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [Letter], 1);
Prob = m.T(2);
fprintf('P(letter=2) = %f\n',Prob);

% compute P(letter=2|intel=1)
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
evidence{Intel} = 1;
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [Letter], 1);
Prob = m.T(2);
fprintf('P(letter=2|intel=1) = %f\n',Prob);

% compute P(intel=2|grade=3)
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
evidence{Grade} = 3;
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [Intel], 1);
Prob = m.T(2);
fprintf('P(intel=2|grade=3) = %f\n',Prob);

% compute P(intel=2|grade=3,letter=1)
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
evidence{Grade} = 3;
evidence{Letter} = 1;
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [Intel], 1);
Prob = m.T(2);
fprintf('P(intel=2|grade=3,letter=1) = %f\n',Prob);

% compute P(diff=2)
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [Diff], 1);
Prob = m.T(2);
fprintf('P(diff=2) = %f\n',m.T(2));

% compute P(diff=2|grade=3)
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
evidence{Grade} = 3;
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [Diff], 1);
Prob = m.T(2);
fprintf('P(diff=2|grade=3) = %f\n',Prob);

% compute P(intel=2|letter=1)
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
evidence{Letter} = 1;
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [Intel], 1);
Prob = m.T(2);
fprintf('P(intel=2|letter=1) = %f\n',Prob);

% compute P(intel=2|grade=3,sat=2)
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
evidence{Grade} = 3;
evidence{Sat} = 2;
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [Intel], 1);
Prob = m.T(2);
fprintf('P(intel=2|grade=3,sat=2) = %f\n',Prob);

% compute P(intel=2|grade=3,diff=2)
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
evidence{Grade} = 3;
evidence{Diff} = 2;
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [Intel], 1);
Prob = m.T(2);
fprintf('P(intel=2|grade=3,diff=2) = %f\n',Prob);

% compute P(intel=2|grade=2)
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
evidence{Grade} = 2;
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [Intel], 1);
Prob = m.T(2);
fprintf('P(intel=2|grade=2) = %f\n',Prob);

% compute P(intel=2|grade=2,diff=2)
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
evidence{Grade} = 2;
evidence{Diff} = 2;
[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [Intel], 1);
Prob = m.T(2);
fprintf('P(intel=2|grade=2,diff=2) = %f\n',Prob);
