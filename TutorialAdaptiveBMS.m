%% ADAPTIVE BMS TUTORIAL
% Tutorial for AdaptiveBMS method of SMARTool
%
%
% Details:
% - 4 networks selected by Tian on the basis of the computed performance  
% - training dataset considered is that enriched with linear interpolation 
%   
% For more details on networks & data see folder <Path2SMARTool>\Networks and data of the SMARTool

%% This part is only functional for running the tutorial, not important to understand how to use the method 
% This is just to find the right path for the architectures/networks/data
% we need:
currentpath=pwd;
% Import (Linear Interpolated) Datasets
% Calibration Datasets
if ispc  % this is to write the right part according to the OS used
    load([currentpath,'\Networks and data\TrainingData_Interp1BL_Liner_NoiseFree'])
else
    load([currentpath,'/Networks and data/TrainingData_Interp1BL_Liner_NoiseFree'])
end
CalibrationDataset=[Traindata(1).input;Traindata(1).target]';
% Test Datasets (from BlindCases)
if ispc 
    MTest=[xlsread([currentpath,'\Data\BlindCase3.xlsx'],'A3:AK224'),75*ones(224-2,1)];
    MTest(end+1:end+269,:)=[xlsread([currentpath,'\Data\BlindCase4.xlsx'],'A3:AK271'),50*ones(271-2,1)];
    MTest(end+1:end+268,:)=[xlsread([currentpath,'\Data\BlindCase5.xlsx'],'A1:AK268'),160*ones(268,1)];
    MTest(end+1:end+541,:)=[xlsread([currentpath,'\Data\20.xlsx'],'A3:AK543'),20*ones(543-2,1)];
    MTest(end+1:end+448,:)=[xlsread([currentpath,'\Data\100.xlsx'],'A3:AK450'),100*ones(450-2,1)];
    MTest(end+1:end+541,:)=[xlsread([currentpath,'\Data\60.xlsx'],'A3:AK543'),60*ones(543-2,1)];
    MTest(end+1:end+541,:)=[xlsread([currentpath,'\Data\200.xlsx'],'A1:AK541'),60*ones(541,1)];
    
else
    MTest=[xlsread([currentpath,'/Data/BlindCase3.xlsx'],'A3:AK224'),75*ones(224-2,1)];
    MTest(end+1:end+269,:)=[xlsread([currentpath,'/Data/BlindCase4.xlsx'],'A3:AK271'),50*ones(271-2,1)];
    MTest(end+1:end+268,:)=[xlsread([currentpath,'/Data/BlindCase5.xlsx'],'A1:AK268'),160*ones(268,1)];
    MTest(end+1:end+541,:)=[xlsread([currentpath,'\Data\20.xlsx'],'A3:AK543'),20*ones(543-2,1)];
    MTest(end+1:end+448,:)=[xlsread([currentpath,'\Data\100.xlsx'],'A3:AK450'),100*ones(450-2,1)];
    MTest(end+1:end+541,:)=[xlsread([currentpath,'\Data\60.xlsx'],'A3:AK543'),60*ones(543-2,1)];
    MTest(end+1:end+541,:)=[xlsread([currentpath,'\Data\200.xlsx'],'A1:AK541'),60*ones(541,1)];
end

%% Import the 4 selected networks
% 2 Hidden Layer MLP
if ispc 
    load([currentpath,'\Networks and data\MLP_2HL\Model_2HLMLP_Cubicinterpolation'],'net')
else
    load([currentpath,'/Networks and data/MLP_2HL/Model_2HLMLP_Cubicinterpolation'],'net')
end
ANN_2HL_CubicSpline=net;

% 1 Hidden Layer MLP (FULL CONNECTED)
if ispc 
    load([currentpath,'\Networks and data\MLP_1HL\Model_1HLMLP_Cubicinterpolation'])
else
    load([currentpath,'/Networks and data/MLP_1HL/Model_1HLMLP_Cubicinterpolation'])
end
ANN_1HL_CubicSplineFULL={tr.NetDef,tr.W1,tr.W2,'nneval_tian'};

% 1 Hidden Layer MLP (PRUNED)
if ispc 
    load([currentpath,'\Networks and data\MLP_1HL\Model_1HLMLP_Cubicinterpolation'])
else
    load([currentpath,'/Networks and data/MLP_1HL/Model_1HLMLP_Cubicinterpolation'])
end
ANN_1HL_CubicSplinePRUNED={tr.obsNetDef,tr.obsW1,tr.obsW2,'nneval_tian'};

% GMDH
if ispc 
    load([currentpath,'\Networks and data\GMDH\Model_GMDH_Cubicinterpolation'])
else
    load([currentpath,'/Networks and data/GMDH/Model_GMDH_Cubicinterpolation'])
end
ANN_GMDH_CubicSpline={model,'gmdhpredict'};

% Build a CELL ARRAY containing the imported networks
CXann={ANN_2HL_CubicSpline,ANN_1HL_CubicSplineFULL,ANN_1HL_CubicSplinePRUNED,ANN_GMDH_CubicSpline};


%% RUN THE METHOD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This is really all you need %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% run with different option to visualize the differences
% options specified in comments for each entry

[Vrobust, Vlower, Vupper]=applyAdaptiveBMS('CXann',CXann,... %cell array of imported networks (to look inside remember to use curly brakets)
    'Mcalibrationdata',CalibrationDataset,...   % Calibration Data (linearly interpolated) defined in line 15
    'alpha',1.96,...                            % Accuracy of the confidence interval (1.96 >> 95% confidence interval)
    'Minputdata',MTest(:,1:37),...              % Online-monitoring data (37 signals) for which we want to compute the prediction
    'threshold',0.90,...                        % Value of posterior under which the probability punctual value is substituted by averaged value    
    'Lgraph',true,...                           % do you want a graphical representation of the solution? 
    'Lsort',true,...                            % do you want your graph to show the results sorted?
    'Sprior','gm',...                      % choose between 'uniform' or 'gm'
    'Sposterior','gm');                  % choose betweeen 'empirical' or 'gm'