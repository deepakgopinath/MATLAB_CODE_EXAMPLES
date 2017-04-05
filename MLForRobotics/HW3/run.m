% ASSIGNMENT2 - CODE A and B;
% SUBMITTED BY DEEPAK E GOPINATH (2909041);

clear;clc;
close all;

addpath('ds0');
loadMRCLAMdataSet;


fprintf('PREPARE ROBOT TRAINING DATA - Q1_A\n');
fprintf('##############################\n\n');
Prepare_Data_New; %Prepare training data


% gen_test_data;
% fprintf('##############################\n\n');
% fprintf('TRAIN ANN ON A SIMPLE POLYNOMIAL (CUBIC) WITH` GAUSSIAN NOISE - Q2_A\n');
% fprintf('##############################\n\n');
% Q2_A;
% plot_error_prediction;

fprintf('##############################\n\n');
fprintf('TRAIN ANN ON ROBOT TRAINING DATA\n');
fprintf('##############################\n\n');
% load_training_data;
%Six different NNs are trained one each for mean(deltax), mean(deltay),
%mean(deltatheta), std(deltax), std(deltay), std(deltatheta); In order for
%shorter execution time, only std(deltax) net is being trained in this
%submission. The others have been commented out. 
% Q3_B;

net_structure_search;


