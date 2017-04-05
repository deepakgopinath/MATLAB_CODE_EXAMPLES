%Assignment 1 - Part A+B - submitted by Deepak E. Gopinath (2909041)

clc; clear; close all;
addpath('ds0');
loadMRCLAMdataSet


Q2_A; %script to run Question 2 in Part A
Q3_A; %script to run Question 3 in Part A
Q5_A; %script to estimate the measurement noise by comparing the 
%output of a deterministic measurement model with ground truth data


particleFilter_Q2;

%PARTICLE FILTER Robot DATA-  TAKES A LOT OF TIME for the entire data set!!!!

particleFilter; %This will take a LONG TIME!!!! Comment this and the next line out if not needed.
save('tracking_data.mat', mean_pose); %assumes that particleFilter.m was run


%compare ground truth data and the filter tracking. 
compare_gt_pf; %if particleFilter.m was not run, this will plot the stored data in tracking_data.mat

% clear all; %Clean up memory. 