% clear all;close all;clc
% results*.test_output, predicting output for test data
% results*.blind3_output, predicting output for blind case 3
% results*.blind4_output, predicting output for blind case 4
% results*.blind5_output, predicting output for blind case 5

% Non interpolation
filename1 = 'Model_Noninterp_case01_imont01_6432_TS01.h5';
filename2 = 'Results_Noninterp_case01_imont01_6432_TS01.mat';
[~, commandOut] = system(['LSTMpredict.py ', filename1, ' ', filename2]);
results1 = load('temp.mat');

% linear interpolation
filename3 = 'Model_LinearBS10_case01_imont01_6432_TS01.h5';
filename4 = 'Results_LinearBS10_case01_imont01_6432_TS01.mat';
[~, commandOut] = system(['LSTMpredict.py ', filename3, ' ', filename4]);
results2 = load('temp.mat');

% Cubic spline interpolation
filename5 = 'Model_SplineBS10_case01_imont01_6432_TS01.h5';
filename6 = 'Results_SplineBS10_case01_imont01_6432_TS01.mat';
[~, commandOut] = system(['LSTMpredict.py ', filename5, ' ', filename6]);
results3 = load('temp.mat');