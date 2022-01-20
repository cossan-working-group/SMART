%% Tutorial SMARTool
% see comments for methods and options available
clear variables
%% IMPORT DATA
currentpath=pwd;
% Import Experimental Datasets
% Calibration Datasets
MdataInput(1,:)=[1.00E+02,8.70E+01,1.00E+02,8.70E+01,-1.30E+01,-1.30E+01,6.01088,294.366,250.602,294.366,...
        250.602,294.362,250.606,294.362,250.606,43.764,43.764,43.756,43.756,91.6735,91.6735,91.6575,91.6575,...
        251.411,294.523,251.416,287.191,1764.06,18.5515,2.85E-04,32.222,15,59.9997,7.54E+02,-4.13E-05,0,0,0];
if ispc  % this is to write the right part according to the OS used
    MdataInput(end+1:end+541,:)=xlsread('Data\20.xlsx','20%Time','A3:AL543');
    MdataInput(end+1:end+541,:)=xlsread('Data\60.xlsx','60%F','A3:AL543');
    MdataInput(end+1:end+541,:)=xlsread('Data\120.xlsx','120%F','A3:AL543');
    MdataInput(end+1:end+541,:)=[xlsread('Data\200.xlsx','200%F','A1:AK541'),200*ones(541,1)];
else
    MdataInput(end+1:end+541,:)=xlsread('Data/20.xlsx','20%Time','A3:AL543');
    MdataInput(end+1:end+541,:)=xlsread('Data/60.xlsx','60%F','A3:AL543');
    MdataInput(end+1:end+541,:)=xlsread('Data/120.xlsx','120%F','A3:AL543');
    MdataInput(end+1:end+541,:)=[xlsread('Data/200.xlsx','200%F','A1:AK541'),200*ones(541,1)];
end

% IMPORT BLIND CASES DATA (only input)
if ispc 
    MBlindCase3=[xlsread([currentpath,'\Data\BlindCase3.xlsx'],'A3:AK224'),75*ones(224-2,1)];
    MBlindCase4=[xlsread([currentpath,'\Data\BlindCase4.xlsx'],'A3:AL271'),50*ones(271-2,1)];
    MBlindCase5=[xlsread([currentpath,'\Data\BlindCase5.xlsx'],'A1:AL268'),160*ones(268,1)];
else
    MTest=[xlsread([currentpath,'/Data/BlindCase3.xlsx'],'A3:AK224'),75*ones(224-2,1)];
    MTest(end+1:end+269,:)=[xlsread([currentpath,'/Data/BlindCase4.xlsx'],'A3:AL271'),50*ones(271-2,1)];
    MTest(end+1:end+268,:)=[xlsread([currentpath,'/Data/BlindCase5.xlsx'],'A1:AL268'),160*ones(268,1)];
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
    load([currentpath,'\Networks and data\LeedsModels\netreg_23feb18'])
    LeedsNet1=net;
    LeedsNet1.userdata='Lnorm';
    load([currentpath,'\Networks and data\LeedsModels\netreg_26feb18'])
    LeedsNet2=net;
    LeedsNet2.userdata='Lnorm';
    load([currentpath,'\Networks and data\LeedsModels\netreg_27feb18'])
    LeedsNet3=net;
    LeedsNet3.userdata='Lnorm';
else
    load([currentpath,'/Networks and data/GMDH/Model_GMDH_Cubicinterpolation'])
    load([currentpath,'/Networks and data/LeedsModels/netreg_23feb18'])
    LeedsNet1=net;    
    LeedsNet1.userdata='Lnorm';
    load([currentpath,'/Networks and data/LeedsModels/netreg_26feb18'])
    LeedsNet2=net;
    LeedsNet2.userdata='Lnorm';
    load([currentpath,'/Networks and data/LeedsModels/netreg_27feb18'])
    LeedsNet3=net;
    LeedsNet3.userdata='Lnorm';
end
ANN_GMDH_CubicSpline={model,'gmdhpredict'};
% Build a CELL ARRAY containing the imported networks
CXann={ANN_2HL_CubicSpline,ANN_1HL_CubicSplineFULL,ANN_1HL_CubicSplinePRUNED,ANN_GMDH_CubicSpline,LeedsNet1,LeedsNet2,LeedsNet3};

%% TEST DATASET PRODUCTION
% Create Dataset: N.B. the entry of empty array [] means that the option is
% not selected (is redundant, you can just avoid to specify the entry
% altogether)

[MTrain,MTest,MVal]=createSMARTdataset('Mdata',MdataInput',... % experimental data: InputNumber X SamplesNumber
    'TrainSetDim',0.70,...  % size of the calibration dataset (default 0.70 >>70%)
    'TestSetDim',0.15,...   % size of the test dataset (default 0.15 >>15%)
    'ValSetDim',0.15,...    % size of the validation dataset (default 0.15 >>15%)
    'SinterpolationType','linear',...           % type of interpolation. Available options: 'linear'/'cubicspline'/[](none): N.B. if Nsamples not empty, is going to use GM sampling!
    'Vnewbreaksize',[10, 40, 80, 110, 160],...     % Break sizes 2 be interpolated (default [10, 40, 80, 110, 160])
    'Nsamples',[],...               % number of samples for use with gaussian mixture model N.B. if not empty overwrites SinterpolationType option
    'leaveout',[],...               % break size value to be left out from the dataset
    'VisualizeInput',[4,8,9,2],...  % Input to visualize (number according to experimental data)
    'Lnowaste',false);              % If true all (otherwise wasted) leaveout data go to testing, all (otherwise wasted) generated data go to training: N.B. changes user defined sizes of the datasets!!!!

%% BMS Uncertainty Quantification
% BMS Test: TEST data includes all Blind Cases
[VrobustOut_BMS1, VlowerB_BMS1, VupperB_BMS1, CXann,MnetOutputBMS]=applyBMS('Nnets',[],... % number of nets to be built from scratch for the ANN set
    'VhiddenNodes',[],...           % internal architecture of the ANNs to be build from scratch (only hidden nodes)
    'CXAnn',CXann,...               % use this option if you have already the ANNs ready to run (CXann must be a cell array)  
    'Mvalidationdata',MVal,...      % validation dataset
    'Mtestdata',MTest,...           % test dataset
    'Mcalibrationdata',MTrain,...   % calibration dataset
    'alpha',1.96,...                % accuracy of the confidence interval (alpha = 1.96 >> 95%)
    'Minputdata',MTest(:,1:37),...  % data for which we want to compute the prediction
    'Lgraph',true,...               % option to visualise the results
    'Lsort',true);                  % do you want to visualize your results sorted?

%% ABMS Uncertainty Quantification
[Vrobust, Vlower, Vupper,CXAnn,MnetOutputABMS]=applyAdaptiveBMS('CXann',CXann,... %cell array of imported networks (to look inside remember to use curly brakets)
    'Mcalibrationdata',[MVal;MTrain;MTest],...   % Calibration Data (linearly interpolated) defined in line 15
    'alpha',1.96,...                            % Accuracy of the confidence interval (1.96 >> 95% confidence interval)
    'Minputdata',MTest(:,1:37),...              % Online-monitoring data (37 signals) for which we want to compute the prediction
    'threshold',0,...                           % Value of posterior under which the probability punctual value is substituted by averaged value    
    'Lgraph',true,...                           % do you want a graphical representation of the solution? 
    'Lsort',true,...                            % do you want your graph to show the results sorted?
    'Sprior','uniform',...                      % choose between 'uniform' or 'gm'
    'Sposterior','empirical');                  % choose betweeen 'empirical' or 'gm'

%% EESA Uncertainty Quantification
% N.B. this is not going to work if you son't have the MATLAB neural
% network toolbox!
[VOutput, VlowerBound, VupperBound, XnetERROR]=applyEESA(CXann{1},... % this runs only with MATLAB NN objects (let me know if you want to modify it)
    'Mdatainput',MTest(:,1:37),...
    'Mvalidationdata',MVal,...
    'Mtestdata',MTest,...
    'Mcalibrationdata',MTrain,...
    'Lgraph',true);  
  


