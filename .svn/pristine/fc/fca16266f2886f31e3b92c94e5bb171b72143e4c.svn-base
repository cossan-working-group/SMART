%% SMART APPLICATION JOURNAL
% ANN SET with 15 nets: 
% -5 architectures
% -3 training set option per architecture (no interp, linear, cubic spline)
% -15 networks 


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

%% Import Datasets
% Calibration Datasets
load('Model_common_test.mat');
MTestOutput=input_test;
MTestInput=target_test;

%% Create additional dataset GM enriched to build posterior
%% Import Nets
%% MLP 1HL
ANN_1HL_OriginalFULL        = {RR11.NetDef,RR11.W1,RR11.W2,'nneval_tian'};
ANN_1HL_LinearFULL          = {RR12.NetDef,RR12.W1,RR12.W2,'nneval_tian'};      
ANN_1HL_CubicSplineFULL     = {RR13.NetDef,RR13.W1,RR13.W2,'nneval_tian'};      
% pruned
ANN_1HL_OriginalPRUNED      = {RR11.obsNetDef,RR11.obsW1,RR11.obsW2	,'nneval_tian'};
ANN_1HL_LinearPRUNED        = {RR12.obsNetDef,RR12.obsW1,RR12.obsW2,'nneval_tian'};      
ANN_1HL_CubicSplinePRUNED   = {RR13.obsNetDef,RR13.obsW1,RR13.obsW2,'nneval_tian'};      

%% MLP 2HL
ANN_2HL_Original        = RR21.net;
ANN_2HL_Linear          = RR22.net;      
ANN_2HL_CubicSpline     = RR23.net;      

%% GMDH
ANN_GMDH_Original       = {RR31.model,'gmdhpredict'};
ANN_GMDH_Linear         = {RR32.model,'gmdhpredict'};
ANN_GMDH_CubicSpline    = {RR33.model,'gmdhpredict'};

CXann={ANN_2HL_Original,ANN_2HL_Linear,ANN_2HL_CubicSpline,...
    ANN_1HL_OriginalFULL,ANN_1HL_LinearFULL,ANN_1HL_CubicSplineFULL,...
    ANN_1HL_OriginalPRUNED,ANN_1HL_LinearPRUNED,ANN_1HL_CubicSplinePRUNED,...
    ANN_GMDH_Original,ANN_GMDH_Linear,ANN_GMDH_CubicSpline};

figure

%% CASE1(C) 
subplot(2,2,1)
% Build Cposterior: PRIOR=UNIFORM, POSTERIOR=EMPIRICAL
[Vrobust_U2E, Vlower_U2E, Vupper_U2E,~,CPostDist_U2E]=applyAdaptiveBMS('CXann',CXann,...
    'Mcalibrationdata',McalibrationData,'alpha',1.96,'Minputdata',MTest(:,1:37),...
    'Lgraph',true,'Lsort',false,'Sprior','uniform','Sposterior','empirical','Lposteriordataset',LposteriorData);
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

%% CASE2(C) 
subplot(2,2,2)
% Build Cposterior: PRIOR=GM, POSTERIOR=EMPIRICAL
[Vrobust_GM2E, Vlower_GM2E, Vupper_GM2E,~,CPostDist_GM2E]=applyAdaptiveBMS('CXann',CXann,...
    'Mcalibrationdata',McalibrationData,'alpha',1.96,'Minputdata',MTest(:,1:37),...
    'Lgraph',true,'Lsort',false,'Sprior','gm','Sposterior','empirical','Lposteriordataset',LposteriorData);
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
title('(b)')
grid off
%% CASE3(C) 
subplot(2,2,3)
% Build Cposterior: PRIOR=GM, POSTERIOR=GM
[Vrobust_GM2GM, Vlower_GM2GM, Vupper_GM2GM,~,CPostDist_GM2GM]=applyAdaptiveBMS('CXann',CXann,...
    'Mcalibrationdata',McalibrationData,'alpha',1.96,'Minputdata',MTest(:,1:37),...
    'Lgraph',true,'Lsort',false,'Sprior','gm','Sposterior','gm','Lposteriordataset',LposteriorData);
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

%% CASE4(C)
subplot(2,2,4)
% Build Cposterior: PRIOR=UNIFORM, POSTERIOR=GM
[Vrobust_U2GM, Vlower_U2GM, Vupper_U2GM,~,CPostDist_U2GM]=applyAdaptiveBMS('CXann',CXann,...
    'Mcalibrationdata',McalibrationData,'alpha',1.96,'Minputdata',MTest(:,1:37),...
    'Lgraph',true,'Lsort',false,'Sprior','uniform','Sposterior','gm','Lposteriordataset',LposteriorData);
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

%% BMS
[Vrobust_BMS, Vlower_BMS, Vupper_BMS]=applyBMSpecial('CXann',CXann,...
    'Mcalibrationdata',McalibrationData,'alpha',1.96,'Minputdata',MTest(:,1:37),...
    'Lgraph',false,'Lposteriordataset',LposteriorData);
%%  COMPARE PERFORMANCE
% CASE 1C
accuracy_Case1C=1-(sum(Vupper_U2E.*200<MTest(:,38))+sum(Vlower_U2E.*200>MTest(:,38)))/length(Vlower_U2E);
ERR_CASE1C=((Vrobust_U2E-MTest(:,38)./200)).^2;
BoundWidth_CASE1C=(Vupper_U2E-Vlower_U2E).*200;
% CASE 2C
accuracy_Case2C=1-(sum(Vupper_GM2E.*200<MTest(:,38))+sum(Vlower_GM2E.*200>MTest(:,38)))/length(Vlower_GM2E);
ERR_CASE2C=((Vrobust_GM2E-MTest(:,38)./200)).^2;
BoundWidth_CASE2C=(Vupper_GM2E-Vlower_GM2E).*200;
% CASE 3C
accuracy_Case3C=1-(sum(Vupper_GM2GM.*200<MTest(:,38))+sum(Vlower_GM2GM.*200>MTest(:,38)))/length(Vlower_GM2GM);
ERR_CASE3C=((Vrobust_GM2GM-MTest(:,38)./200)).^2;
BoundWidth_CASE3C=(Vupper_GM2GM-Vlower_GM2GM).*200;
% CASE 4C
accuracy_Case4C=1-(sum(Vupper_U2GM.*200<MTest(:,38))+sum(Vlower_U2GM.*200>MTest(:,38)))/length(Vlower_U2GM);
ERR_CASE4C=((Vrobust_U2GM-MTest(:,38)./200)).^2;
BoundWidth_CASE4C=(Vupper_U2GM-Vlower_U2GM).*200;
% BMS
accuracy_BMS=1-(sum(Vupper_BMS.*200<MTest(:,38))+sum(Vlower_BMS.*200>MTest(:,38)))/length(Vlower_BMS);
ERR_BMS=((Vrobust_BMS-MTest(:,38)./200)).^2;
BoundWidth_BMS=(Vupper_BMS-Vlower_BMS).*200;

disp(['AccuracyABMS_1C  ',num2str(accuracy_Case1C),'  MSE_1C  ',num2str(mean(ERR_CASE1C)),'  STDSE_1C  ',num2str(std(ERR_CASE1C))]);
disp(['AccuracyABMS_2C  ',num2str(accuracy_Case2C),'  MSE_2C  ',num2str(mean(ERR_CASE2C)),'  STDSE_2C  ',num2str(std(ERR_CASE2C))]);
disp(['AccuracyABMS_3C  ',num2str(accuracy_Case3C),'  MSE_3C  ',num2str(mean(ERR_CASE3C)),'  STDSE_3C  ',num2str(std(ERR_CASE3C))]);
disp(['AccuracyABMS_4C  ',num2str(accuracy_Case4C),'  MSE_4C  ',num2str(mean(ERR_CASE4C)),'  STDSE_4C  ',num2str(std(ERR_CASE4C))]); 
disp(['AccuracyBMS',num2str(accuracy_BMS),'  MSE_BMS  ',num2str(mean(ERR_BMS)),'  STDSE_BMS  ',num2str(std(ERR_BMS))]);   
disp(['MeanWidth_1C  ', num2str(mean(BoundWidth_CASE1C)),'  MaxWidth_1C  ',num2str(max(BoundWidth_CASE1C)),'  STDWidth_1C  ',num2str(std(BoundWidth_CASE1C))]);
disp(['MeanWidth_2C  ', num2str(mean(BoundWidth_CASE2C)),'  MaxWidth_2C  ',num2str(max(BoundWidth_CASE2C)),'  STDWidth_2C  ',num2str(std(BoundWidth_CASE2C))]);
disp(['MeanWidth_3C  ', num2str(mean(BoundWidth_CASE3C)),'  MaxWidth_3C  ',num2str(max(BoundWidth_CASE3C)),'  STDWidth_3C  ',num2str(std(BoundWidth_CASE3C))]);
disp(['MeanWidth_4C  ', num2str(mean(BoundWidth_CASE4C)),'  MaxWidth_4C  ',num2str(max(BoundWidth_CASE4C)),'  STDWidth_4C  ',num2str(std(BoundWidth_CASE4C))]);
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

disp(['  MSE_BMS  ',num2str(mean(ERR_BMS)),'  STDSE_BMS  ',num2str(std(ERR_BMS))]); 
disp(['MSE_bestABMS  ',num2str(bestMSE),'  STDSE_bestABMS  ',num2str(VERRstd(BestABMSet))]); 
disp(['MSE_2HL  ',num2str(mean(ERR_2HL)),'  STDSE_2HL  ',num2str(std(ERR_2HL))]); 
disp(['MSE_1HLfull  ',num2str(mean(ERR_V1HLfull)),'  STDSE_1HLfull  ',num2str(std(ERR_V1HLfull))]); 
disp(['MSE_1HLpruned  ',num2str(mean(ERR_V2HLpruned)),'  STDSE_1HLpruned  ',num2str(std(ERR_V2HLpruned))]); 
disp(['MSE_GMDH  ',num2str(mean(ERR_GMDH)),'  STDSE_GMDH  ',num2str(std(ERR_GMDH))]); 



figure
subplot(2,1,1)
% hold all
% plot(1:length(MTest(:,38)),Vrobust_BMS*200,'LineWidth',3);
% plot(1:length(MTest(:,38)),Mrobust(:,BestABMSet)*200);
% plot(1:length(MTest(:,38)),V2HL_Out.*200);
% plot(1:length(MTest(:,38)),V1HLfull_Out.*200);
% plot(1:length(MTest(:,38)),V2HLpruned_Out.*200);
% plot(1:length(MTest(:,38)),GMDH_Out.*200);
% plot(1:length(MTest(:,38)),MTest(:,38));
% ylim([-10,210])
% xlabel('Samples')
% ylabel('BreakLevel')
% grid on
% legend('ABMS','BMS','2HL','1HL','1HLpruned','GMDH','DATA')
% 
% subplot(2,1,2)
% hold all
% plot(1:length(MTest(:,38)),(Vrobust_BMS-MTest(:,38)./200).^2,'LineWidth',3);
% plot(1:length(MTest(:,38)),(Mrobust(:,BestABMSet)-MTest(:,38)./200).^2);
% plot(1:length(MTest(:,38)),ERR_2HL);
% plot(1:length(MTest(:,38)),ERR_V1HLfull);
% plot(1:length(MTest(:,38)),ERR_V2HLpruned);
% plot(1:length(MTest(:,38)),ERR_GMDH);
% xlabel('Samples')
% ylabel('Square Error')
% grid on
% title('Square Error')
% legend('ABMS','BMS','2HL','1HL','1HLpruned','GMDH')
