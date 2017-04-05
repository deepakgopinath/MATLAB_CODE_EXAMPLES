% CS 8803 Introduction to Probabilistic Graphical Models
% Spring 2014
% Georgia Tech
% Instructor: Jim Rehg
% 
% Matlab code examples for Lecture 2, Bayes Nets
% This example illustrates several basic functions in Kevin Murphy's
% Bayes Net Toolkit (BNT): Creating and printing models, computing joint
% and marginal distributions.
% 
% Copyright Jim Rehg, Georgia Tech, 2013.

clear all;

% Slide 8, build a model for the factorization P(AB) = P(B|A)P(A)
% 
% Initialize a Bayes net model. See
% http://bnt.googlecode.com/svn/trunk/docs/usage.html for details
N = 2;
dag = zeros(N,N);
A = 1; B = 2; % Topological order
dag(A,B) = 1; %Make the connection between node A and B. By setting that value to be 1.
b = 2; % Binary nodes. //A and B are discrete variables and each would take 2 values
node_sizes = [b b];
bnet = mk_bnet(dag, node_sizes, 'discrete', 1:N);
% Initialize CPT for P(B|A) - To understand why the parameters are entered
% this way see the Parameters section of usage.html
% By adopting the convention in slide for laying out the CPTs, we
% ensure that the columns can be stacked to initialize the model.
bnet.CPD{B} = tabular_CPD(bnet, B, 'CPT', [0.4 0.7 0.6 0.3]);

% Check that this table is correct
tbl = CPD_to_CPT(bnet.CPD{B}) % print this to see if the table was added properly. columns first
% Pretty print it
showCPT(bnet, [B]);

% Now add the prior on A
bnet.CPD{A} = tabular_CPD(bnet, A, 'CPT', [0.2 0.8]);

% Pretty print the model
fprintf(1, '\nFinal Model P(A)P(B|A):\n');
showCPT(bnet);

% Now compute the joint
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
[engine, ll] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [A B]);
% Display the joint, note that A is rows and B is columns
fprintf(1, '\nJoint distribution P(A,B):\n');
m.T

% Now compute the marginal for B
m = marginal_nodes(engine, [B]);
fprintf(1, '\nMarginal distribution P(B):\n');
m.T

% Use Bayes Rule (Bayesian inference) to obtain the posterior P(A|B)
post = zeros(node_sizes);
for i=1:node_sizes(B), %Go through the different discrete possible value for node B
    evidence{B} = i; %Set that the observed value for B is i. that if after the loop, we would have taken into account all the possible value for the node B
    [engine, ll] = enter_evidence(engine, evidence);
    m = marginal_nodes(engine, [A]);
    post(i,:) = m.T;
end
fprintf(1, '\nPosterior distribution P(A|B):\n');
post
