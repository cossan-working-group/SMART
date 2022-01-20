%% SMART APPLICATION JOURNAL
% ANN SET D: 
% -5 architectures
% -only best training option for each architecture (all cubic spline)
% -5 networks 


%% Import Datasets
% Calibration Datasets
load('C:\workspace\SMART\SMARTool\Networks and data\TrainingData_Noninterp_NoiseFree');
CMcalibration{1}=[Traindata(1).input;Traindata(1).targets]';
load('C:\workspace\SMART\SMARTool\Networks and data\TrainingData_Interp1BL_Liner_NoiseFree')
CMcalibration{2}=[Traindata(1).input;Traindata(1).target]';
load('C:\workspace\SMART\SMARTool\Networks and data\TrainingData_Interp1BL_spline_NoiseFree')
CMcalibration{3}=[Traindata(1).input;Traindata(1).target]';
% Test Datasets (BlindCases)
MTest=[xlsread('C:\workspace\SMART\SMARTool\Data\BlindCase3.xlsx','A3:AK224'),75*ones(224-2,1)];
MTest(end+1:end+269,:)=[xlsread('C:\workspace\SMART\SMARTool\Data\BlindCase4.xlsx','A3:AL271'),50*ones(271-2,1)];
MTest(end+1:end+268,:)=[xlsread('C:\workspace\SMART\SMARTool\Data\BlindCase5.xlsx','A1:AL268'),160*ones(268,1)];

% choose which dataset to build posterior: 
% 1=OriginalDataset, 2=LinearInterpolation, 2=CubicSplineInterpolation
LposteriorData=2; 
McalibrationData=CMcalibration{LposteriorData};

%% Create additional dataset GM enriched to build posterior
% MDataGMPosterior=createSMARTdataset('Mdata',Mcalibration_Original',...
%     'TrainSetDim',1,'TestSetDim',0,'ValSetDim',0,'Nsamples',1000');


%% Import Datasets
% Calibration Datasets
load('Model_common_test.mat');
MTestOutput=input_test;
MTestInput=target_test;

%% Import Nets
%% MLP 1HL 
ANN_1HL_CubicSplineFULL     = {RR13.NetDef,RR13.W1,RR13.W2,'nneval_tian'};      
% pruned 
ANN_1HL_CubicSplinePRUNED   = {RR13.obsNetDef,RR13.obsW1,RR13.obsW2,'nneval_tian'};      
%% MLP 2HL   
ANN_2HL_CubicSpline     = RR23.net;      
%% GMDH
ANN_GMDH_CubicSpline    = {RR33.model,'gmdhpredict'};

CXann={ANN_2HL_CubicSpline,ANN_1HL_CubicSplineFULL,...
    ANN_1HL_CubicSplinePRUNED,ANN_GMDH_CubicSpline};

treshold=0.9;
figure
title('CASE II')
%% CASE1(D) 
subplot(2,2,1)
% Build Cposterior: PRIOR=UNIFORM, POSTERIOR=EMPIRICAL
[Vrobust_U2E, Vlower_U2E, Vupper_U2E,~,CPostDist_U2E]=applyAdaptiveBMS('CXann',CXann,...
    'Mcalibrationdata',McalibrationData,'alpha',1.96,'Minputdata',MTest(:,1:37),'threshold',treshold,...
    'Lgraph',false,'Lsort',false,'Sprior','uniform','Sposterior','empirical','Lposteriordataset',LposteriorData);
hold on 
h1=plot(1:length(MTest(:,38)),Vrobust_U2E.*200,'color',[0.000000 0.270000 0.130000]); %
h2=plot(1:length(MTest(:,38)),Vlower_U2E.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
h3=plot(1:length(MTest(:,38)),Vupper_U2E.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
ylim([-10,210])
xlabel('Samples')
ylabel('BreakLevel')
h4=plot(1:length(MTest(:,38)),(MTest(:,38)),'-.r','LineWidth',1);
% title('CASE1D: Prior=Uniform, Posterior=Empirical, Best 5 networks')
legend([h1, h2, h4],{'Model Output','Confidence Bounds','Experimental Data'},'location','southeast')
legend boxoff 
title('(a)')
grid off
%% CASE2(D) 
subplot(2,2,2)
% Build Cposterior: PRIOR=GM, POSTERIOR=EMPIRICAL
[Vrobust_GM2E, Vlower_GM2E, Vupper_GM2E,~,CPostDist_GM2E]=applyAdaptiveBMS('CXann',CXann,...
    'Mcalibrationdata',McalibrationData,'alpha',1.96,'Minputdata',MTest(:,1:37),'threshold',treshold,...
    'Lgraph',true,'Sprior','gm','Sposterior','empirical','Lposteriordataset',LposteriorData);
hold on 
plot(1:length(MTest(:,38)),(MTest(:,38)),'-.r','LineWidth',1)
% title('CASE2D: Prior=GM, Posterior=Empirical, Best 5 networks')
legend([h1, h2, h4],{'Model Output','Confidence Bounds','Experimental Data'},'location','southeast')
legend boxoff 
title('(b)')
grid off
%% CASE3(D) 
subplot(2,2,3)
% Build Cposterior: PRIOR=GM, POSTERIOR=GM
[Vrobust_GM2GM, Vlower_GM2GM, Vupper_GM2GM,~,CPostDist_GM2GM]=applyAdaptiveBMS('CXann',CXann,...
    'Mcalibrationdata',McalibrationData,'alpha',1.96,'Minputdata',MTest(:,1:37),'threshold',treshold,...
    'Lgraph',true,'Sprior','gm','Sposterior','gm','Lposteriordataset',LposteriorData);
hold on 
h1=plot(1:length(MTest(:,38)),Vrobust_GM2E.*200,'color',[0.000000 0.270000 0.130000]); %
h2=plot(1:length(MTest(:,38)),Vlower_GM2E.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
h3=plot(1:length(MTest(:,38)),Vupper_GM2E.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
ylim([-10,210])
xlabel('Samples')
ylabel('BreakLevel')
h4=plot(1:length(MTest(:,38)),(MTest(:,38)),'-.r','LineWidth',1);
legend([h1, h2, h4],{'Model Output','Confidence Bounds','Experimental Data'},'location','southeast')
legend boxoff 
title('(c)')
grid off
% title('CASE3D: Prior=Uniform, Posterior=GM, Best 5 networks')
%% CASE4(D)
subplot(2,2,4)
% Build Cposterior: PRIOR=UNIFORM, POSTERIOR=GM
[Vrobust_U2GM, Vlower_U2GM, Vupper_U2GM,~,CPostDist_U2GM]=applyAdaptiveBMS('CXann',CXann,...
    'Mcalibrationdata',McalibrationData,'alpha',1.96,'Minputdata',MTest(:,1:37),'threshold',treshold,...
    'Lgraph',true,'Sprior','uniform','Sposterior','gm','Lposteriordataset',LposteriorData);
hold on 
h1=plot(1:length(MTest(:,38)),Vrobust_U2GM.*200,'color',[0.000000 0.270000 0.130000]); %
h2=plot(1:length(MTest(:,38)),Vlower_U2GM.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
h3=plot(1:length(MTest(:,38)),Vupper_U2GM.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
ylim([-10,210])
xlabel('Samples')
ylabel('BreakLevel')
h4=plot(1:length(MTest(:,38)),(MTest(:,38)),'-.r','LineWidth',1);
legend([h1, h2, h4],{'Model Output','Confidence Bounds','Experimental Data'},'location','southeast')
legend boxoff 
title('(d)')
grid off
% title('CASE4D: Prior=Uniform, Posterior=GM, Best 5 networks')

% %% BMS
% Build Cposterior: PRIOR=UNIFORM, POSTERIOR=GM
[Vrobust_BMS, Vlower_BMS, Vupper_BMS]=applyBMSpecial('CXann',CXann,...
    'Mcalibrationdata',McalibrationData,'alpha',1.96,'Minputdata',MTest(:,1:37),...
    'Lgraph',true,'Lposteriordataset',LposteriorData);
hold on 
plot(1:length(MTest(:,38)),(MTest(:,38)),'r')
title('d')

%%  COMPARE PERFORMANCE
% CASE 1D
accuracy_Case1D=1-(sum(Vupper_U2E.*200<MTest(:,38))+sum(Vlower_U2E.*200>MTest(:,38)))/length(Vlower_U2E);
ERR_CASE1D=((Vrobust_U2E-MTest(:,38)./200)).^2;
BoundWidth_CASE1D=(Vupper_U2E-Vlower_U2E).*200;
% CASE 2D
accuracy_Case2D=1-(sum(Vupper_GM2E.*200<MTest(:,38))+sum(Vlower_GM2E.*200>MTest(:,38)))/length(Vlower_GM2E);
ERR_CASE2D=((Vrobust_GM2E-MTest(:,38)./200)).^2;
BoundWidth_CASE2D=(Vupper_GM2E-Vlower_GM2E).*200;
% CASE 3C
accuracy_Case3D=1-(sum(Vupper_GM2GM.*200<MTest(:,38))+sum(Vlower_GM2GM.*200>MTest(:,38)))/length(Vlower_GM2GM);
ERR_CASE3D=((Vrobust_GM2GM-MTest(:,38)./200)).^2;
BoundWidth_CASE3D=(Vupper_GM2GM-Vlower_GM2GM).*200;
% CASE 4C
accuracy_Case4D=1-(sum(Vupper_U2GM.*200<MTest(:,38))+sum(Vlower_U2GM.*200>MTest(:,38)))/length(Vlower_U2GM);
ERR_CASE4D=((Vrobust_U2GM-MTest(:,38)./200)).^2;
BoundWidth_CASE4D=(Vupper_U2GM-Vlower_U2GM).*200;
% % CASE BMS
accuracy_BMS=1-(sum(Vupper_BMS.*200<MTest(:,38))+sum(Vlower_BMS.*200>MTest(:,38)))/length(Vlower_BMS);
ERR_BMS=((Vrobust_BMS-MTest(:,38)./200)).^2;
BoundWidth_BMS=(Vupper_BMS-Vlower_BMS).*200;


disp(['AccuracyABMS_1D  ',num2str(accuracy_Case1D),'  MSE_1D  ',num2str(mean(ERR_CASE1D)),'  STDSE_1D  ',num2str(std(ERR_CASE1D))]);
disp(['AccuracyABMS_2D  ',num2str(accuracy_Case2D),'  MSE_2D  ',num2str(mean(ERR_CASE2D)),'  STDSE_2D  ',num2str(std(ERR_CASE2D))]);
disp(['AccuracyABMS_3D  ',num2str(accuracy_Case3D),'  MSE_3D  ',num2str(mean(ERR_CASE3D)),'  STDSE_3D  ',num2str(std(ERR_CASE3D))]);
disp(['AccuracyABMS_4D  ',num2str(accuracy_Case4D),'  MSE_4D  ',num2str(mean(ERR_CASE4D)),'  STDSE_4D  ',num2str(std(ERR_CASE4D))]); 
disp(['AccuracyBMS',num2str(accuracy_BMS),'  MSE_BMS  ',num2str(mean(ERR_BMS)),'  STDSE_BMS  ',num2str(std(ERR_BMS))]); 
disp(['MeanWidth_1D  ', num2str(mean(BoundWidth_CASE1D)),'  MaxWidth_1C  ',num2str(max(BoundWidth_CASE1D)),'  STDWidth_1C  ',num2str(std(BoundWidth_CASE1D))]);
disp(['MeanWidth_2D  ', num2str(mean(BoundWidth_CASE2D)),'  MaxWidth_2C  ',num2str(max(BoundWidth_CASE2D)),'  STDWidth_2C  ',num2str(std(BoundWidth_CASE2D))]);
disp(['MeanWidth_3D  ', num2str(mean(BoundWidth_CASE3D)),'  MaxWidth_3C  ',num2str(max(BoundWidth_CASE3D)),'  STDWidth_3C  ',num2str(std(BoundWidth_CASE3D))]);
disp(['MeanWidth_4D  ', num2str(mean(BoundWidth_CASE4D)),'  MaxWidth_4C  ',num2str(max(BoundWidth_CASE4D)),'  STDWidth_4C  ',num2str(std(BoundWidth_CASE4D))]);
disp(['MeanWidth_BMS  ', num2str(mean(BoundWidth_BMS)),'  MaxWidth_BMS  ',num2str(max(BoundWidth_BMS)),'  STDWidth_BMS  ',num2str(std(BoundWidth_BMS))]);


%% compare only response accuracy with single models
[bestMSE,BestABMSet]=min([mean(ERR_CASE1D),mean(ERR_CASE2D),mean(ERR_CASE3D),mean(ERR_CASE4D)]);
VERRstd=[std(ERR_CASE1D),std(ERR_CASE2D),std(ERR_CASE3D),std(ERR_CASE4D)];
Mrobust=[Vrobust_U2E,Vrobust_GM2E,Vrobust_GM2GM,Vrobust_U2GM];
V2HL_Out=transpose(ANN_2HL_CubicSpline(MTest(:,1:37)'));
ERR_2HL=(V2HL_Out-MTest(:,38)./200).^2;
V1HLfull_Out=nneval_tian(tr.NetDef,tr.W1,tr.W2,(MTest(:,1:37)'));
ERR_V1HLfull=(V1HLfull_Out'-MTest(:,38)./200).^2;
V2HLpruned_Out=nneval_tian(tr.obsNetDef,tr.obsW1,tr.obsW2,(MTest(:,1:37)'));
ERR_V2HLpruned=(V2HLpruned_Out'-MTest(:,38)./200).^2;
GMDH_Out=gmdhpredict(model,(MTest(:,1:37)));
ERR_GMDH=(GMDH_Out-MTest(:,38)./200).^2;

% disp(['  MSE_BMS  ',num2str(mean(ERR_BMS)),'  STDSE_BMS  ',num2str(std(ERR_BMS))]); 
disp(['MSE_bestABMS  ',num2str(bestMSE),'  STDSE_bestABMS  ',num2str(VERRstd(BestABMSet))]); 
disp(['MSE_2HL  ',num2str(mean(ERR_2HL)),'  STDSE_2HL  ',num2str(std(ERR_2HL))]); 
disp(['MSE_1HLfull  ',num2str(mean(ERR_V1HLfull)),'  STDSE_1HLfull  ',num2str(std(ERR_V1HLfull))]); 
disp(['MSE_1HLpruned  ',num2str(mean(ERR_V2HLpruned)),'  STDSE_1HLpruned  ',num2str(std(ERR_V2HLpruned))]); 
disp(['MSE_GMDH  ',num2str(mean(ERR_GMDH)),'  STDSE_GMDH  ',num2str(std(ERR_GMDH))]); 



figure
subplot(2,1,1)
hold all
% plot(1:length(MTest(:,38)),Vrobust_BMS*200,'LineWidth',3);
plot(1:length(MTest(:,38)),Mrobust(:,BestABMSet)*200,'LineWidth',3);
plot(1:length(MTest(:,38)),V2HL_Out.*200);
plot(1:length(MTest(:,38)),V1HLfull_Out.*200);
plot(1:length(MTest(:,38)),V2HLpruned_Out.*200);
plot(1:length(MTest(:,38)),GMDH_Out.*200);
plot(1:length(MTest(:,38)),MTest(:,38));
ylim([-10,210])
xlabel('Samples')
ylabel('BreakLevel')
grid on
legend('ABMS','2HL','1HL','1HLpruned','GMDH','Experimental Data')

subplot(2,1,2)
hold all
% plot(1:length(MTest(:,38)),(Vrobust_BMS-MTest(:,38)./200).^2,'LineWidth',3);
plot(1:length(MTest(:,38)),(Mrobust(:,BestABMSet)-MTest(:,38)./200).^2,'LineWidth',3);
plot(1:length(MTest(:,38)),ERR_2HL);
plot(1:length(MTest(:,38)),ERR_V1HLfull);
plot(1:length(MTest(:,38)),ERR_V2HLpruned);
plot(1:length(MTest(:,38)),ERR_GMDH);
xlabel('Samples')
ylabel('Square Error')
grid on
% title('Square Error')
legend('ABMS','2HL','1HL','1HLpruned','GMDH')
