% CS 8803 Introduction to Probabilistic Graphical Models
% Spring 2014
% Georgia Tech
% Instructor: Jim Rehg
% 
% Matlab code examples for Lecture 3 D-Separation
% 

clear all;

% Slide 6, Create a fully connected model for A, B, C
% A
% | \
% C<-B
% and choose parameters so that C cond-ind B | A
%
% Initialize a Bayes net model. See
% http://bnt.googlecode.com/svn/trunk/docs/usage.html for details
N = 3;
dag = zeros(N,N);
A = 1; B = 2; C = 3; % Topological order
dag(A,B) = 1;
dag(A,C) = 1;
dag(B,C) = 1;
b = 2; % Binary nodes
node_sizes = b*ones(1,N);
bnet = mk_bnet(dag, node_sizes, 'discrete', 1:N);

% We want:
% P(C|A) = 0.4 0.6
%          0.1 0.9
cpt = [0.4 0.1 0.6 0.9];
% but need to embed it such that P(C|A) = P(C|AB)
% So make two copies of P(C|A) and map B to the index that selects which
% copy you use, so that B has no effect
cptAB = permute(reshape([cpt cpt], [2 2 2]), [1 3 2]);
bnet.CPD{C} = tabular_CPD(bnet, C, 'CPT', cptAB);
% This is equivalent:
% bnet.CPD{C} = tabular_CPD(bnet, C, 'CPT', [0.4 0.1 0.4 0.1 0.6 0.9 0.6 0.9]);
% showCPT(bnet, [C]);
% Specify B and A
bnet.CPD{B} = tabular_CPD(bnet, B, 'CPT', [0.2 0.7 0.8 0.3]);
bnet.CPD{A} = tabular_CPD(bnet, A, 'CPT', [0.4 0.6]);
fprintf(1, 'Final model: P(C|A)P(B|A)P(A)\n');
showCPT(bnet);

% Compute marginals
engine = jtree_inf_engine(bnet);
evidence = cell(1,N);
evidence{A} = 1;
[engine, ll] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [B C]);
fprintf(1, '\nP(BC|A=0):\n');
m.T
BCf = m.T;
evidence{A} = 2;
[engine, ll] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [B C]);
fprintf(1, '\nP(BC|A=1):\n');
m.T
BCt = m.T;

% Make slices for the slide, P(A=i,B,C) = P(BC|A=i)P(A=i)
fprintf(1, '\nP(A=0, B, C):\n');
BCf .* 0.4

fprintf(1, '\nP(A=1, B, C):\n');
BCt .* 0.6



% % Calculate the prior for C based on uniform dist. over A and B
% h = zeros(1,b);
% m = 10;
% for i=1:m
%     for j=1:m
%         k = round((i+j)/b)+1;
%         h(k) = h(k)+1;
%     end
% end
% h = h/(m^2);
% bar(h);
% bnet.CPD{C} = tabular_CPD(bnet, C, 'CPT', h);

