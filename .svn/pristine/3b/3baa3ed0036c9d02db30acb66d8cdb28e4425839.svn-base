%% SMARTool TEST
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
    MBlindCase3=[xlsread([currentpath,'/Data/BlindCase3.xlsx'],'A3:AK224'),75*ones(224-2,1)];
    MBlindCase4=[xlsread([currentpath,'/Data/BlindCase4.xlsx'],'A3:AL271'),50*ones(271-2,1)];
    MBlindCase5=[xlsread([currentpath,'/Data/BlindCase5.xlsx'],'A1:AL268'),160*ones(268,1)];
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
CXAnn={ANN_2HL_CubicSpline,ANN_1HL_CubicSplineFULL,ANN_1HL_CubicSplinePRUNED,ANN_GMDH_CubicSpline};

%% TEST DATASET PRODUCTION
%% TEST_1: test linear interpolation (type 1)
[MTrainD_1,MTestD_1,MValD_1,MNewD_1]=createSMARTdataset('Mdata',MdataInput,...
    'TrainSetDim',0.70,'TestSetDim',0.15,'ValSetDim',0.15,'VisualizeInput',[4,8]);

%% TEST_2: test linear interpolation (type 1)
[MTrainD_2,MTestD_2,MValD_2,MNewD_2]=createSMARTdataset('Mdata',MdataInput,...
    'Vnewbreaksize',[10, 40, 80, 110,160],'SinterpolationType','linear','VisualizeInput',[4,8]);

%% TEST_3: test cubic spline interpolation (type 2)
[MTrainD_3,MTestD_3,MValD_3,MNewD_3]=createSMARTdataset('Mdata',MdataInput,...
    'Vnewbreaksize',[10, 40, 80, 110,160],'SinterpolationType','cubic spline','VisualizeInput',[4,8]);

%% TEST_4: test Gaussian Mixture Sampling 
[MTrainD_4,MTestD_4,MValD_4,MNewD_4]=createSMARTdataset('Mdata',MdataInput,...
    'Nsamples',10000,'VisualizeInput',[4,8]);

%% TEST_5:test leaveout 
[MTrainD_5,MTestD_5,MValD_5]=createSMARTdataset('Mdata',MdataInput,...
    'leaveout',20,'VisualizeInput',[4,8]);

%% TEST_4: test option Lnowaste (samples production+leaveout) 
[MTrainD_6,MTestD_6,MValD_6,MNewD_6]=createSMARTdataset('Mdata',MdataInput,'leaveout',120,...
    'Lnowaste',true,'Vnewbreaksize',[10, 40, 80, 110, 160],...
    'SinterpolationType','cubic spline','VisualizeInput',[4,8]);

%% BMS Uncertainty Quantification
% BMS Test1: BLIND CASE 3
[VrobustOut_BMS1, VlowerB_BMS1, VupperB_BMS1,~,MOutputNet]=applyBMS('CXann',CXAnn,...
    'Mvalidationdata',MValD_1,'Mtestdata',MTestD_1,'Mcalibrationdata',MTrainD_1,...
    'alpha',1.96,'Minputdata',MBlindCase3(:,1:37),'VhiddenNodes',[19,26],'Lgraph',true);

%% EESA Uncertainty Quantification
% load Tian's net for test (trained with original input)
if ispc 
    temp=load([currentpath,'\TestNets\MLP2HL_nets'],'net1');
else
    temp=load([currentpath,'/TestNets/MLP2HL_nets'],'net1');
end
Xnet=temp.net1;
% EESA: Test1
[VXnetOutput, VlowerBound, VupperBound, XnetERROR]=applyEESA(Xnet,'Mdatainput',MBlindCase3(:,1:37),...
    'Mvalidationdata',MValD_1,'Mtestdata',MTestD_1,'Mcalibrationdata',MTrainD_1,'Lgraph',true);  

%% BLIND CASES
% initialise loop variables
VblindCaseOutput=[75,50,160];
CBlindCaseData=cell(1,3);
VaccuracyEESA=zeros(1,3);
VaccuracyBMS=zeros(1,3);
NumberBlindCase=[3,4,5];
CBlindCaseData{1}=MBlindCase3;CBlindCaseData{2}=MBlindCase4;CBlindCaseData{3}=MBlindCase5;
if ispc 
    load([currentpath,'\TestNets\XERR_EESA_BasicData'],'XnetERROR');
    load([currentpath,'\TestNets/CXann_BMS20net_BasicData'],'CXann_BMS20net')
else
    load([currentpath,'/TestNets/XERR_EESA_BasicData'],'XnetERROR');
    load([currentpath,'/TestNets/CXann_BMS20net_BasicData'],'CXann_BMS20net')
end

for iBlindCase=1:3
% EESA
[VXnetOutput, VlowerB_EESA, VupperB_EESA]=applyEESA(Xnet,'Mdatainput',CBlindCaseData{iBlindCase}(:,1:37),...
    'Mvalidationdata',MValD_1,'Mtestdata',MTestD_1,'Mcalibrationdata',MTrainD_1,...
    'errornet',XnetERROR,'Lgraph',false);

figure
hold on
plot(1:length(VXnetOutput),VXnetOutput,'b')
plot(1:length(VXnetOutput),VlowerB_EESA,'g')
plot(1:length(VXnetOutput),VupperB_EESA,'g')
plot(1:length(VXnetOutput),VblindCaseOutput(iBlindCase).*ones(1,length(VXnetOutput)),'r')
VaccuracyEESA(iBlindCase)=1-(sum(VupperB_EESA<VblindCaseOutput(iBlindCase))+sum(VlowerB_EESA>VblindCaseOutput(iBlindCase)))/length(VXnetOutput);
title(['EESA for BlindCase',num2str(NumberBlindCase(iBlindCase))])
xlabel('Samples')
ylabel('BreakLevel')
grid on
legend('Predicted Break Size','Confidence Bounds','location','best')
% BMS 
% load previously trained nets
if ispc
    load([currentpath,'\TestNets\CXann_BMS20net_BasicData'],'CXann_BMS20net')
else
    load([currentpath,'/TestNets/CXann_BMS20net_BasicData'],'CXann_BMS20net')
end
[Vrobust_BMS, Vlower_BMS, Vupper_BMS]=applyBMS('CXann',CXann_BMS20net,...
    'Mvalidationdata',MValD_1,'Mtestdata',MTestD_1,'Mcalibrationdata',MTrainD_1,...
    'alpha',1.96,'Minputdata',CBlindCaseData{iBlindCase}(:,1:37),'Lgraph',false);
figure
hold on
plot(1:length(Vrobust_BMS),Vrobust_BMS,'b')
plot(1:length(Vrobust_BMS),Vlower_BMS,'g')
plot(1:length(Vrobust_BMS),Vupper_BMS,'g')
plot(1:length(Vrobust_BMS),VblindCaseOutput(iBlindCase).*ones(1,length(Vrobust_BMS)),'r') % visualize output BlindCase3
VaccuracyBMS(iBlindCase)=1-(sum(Vupper_BMS<VblindCaseOutput(iBlindCase))+sum(Vlower_BMS>VblindCaseOutput(iBlindCase)))/length(Vlower_BMS);
title(['BMS for BlindCase',num2str(NumberBlindCase(iBlindCase))])
xlabel('Samples')
ylabel('BreakLevel')
grid on
legend('Robust BMS Output','Confidence Bounds','location','best')
end
     


