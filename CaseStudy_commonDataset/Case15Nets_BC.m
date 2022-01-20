% Calibration Datasets
load('training_data_sets.mat');
MNoInt=[Traindata_nointerp.train_input'; Traindata_nointerp.val_input'];
MNoInt(:,end+1)=[Traindata_nointerp.train_target';Traindata_nointerp.val_target'];
Ccalibration(1)={MNoInt};
MLinInt=[MNoInt(:,1:end-1);Traindata_Linearinterp.train_input'; Traindata_Linearinterp.val_input'];
MLinInt(:,end+1)=[MNoInt(:,end);Traindata_Linearinterp.train_target';Traindata_Linearinterp.val_target'];
Ccalibration(2)={MLinInt};
MSplineInt=[MNoInt(:,1:end-1);Traindata_Cubicinterp.train_input'; Traindata_Cubicinterp.val_input'];
MSplineInt(:,end+1)=[MNoInt(:,end);Traindata_Cubicinterp.train_target';Traindata_Cubicinterp.val_target'];
Ccalibration(3)={MSplineInt};

LposteriorData=1; 
McalibrationData=Ccalibration{LposteriorData};

%Blind Cases
MTest=[xlsread('C:\workspace\SMARTool\Data\BlindCase3.xlsx','A3:AK224'),75*ones(224-2,1)];
MTest(end+1:end+269,:)=[xlsread('C:\workspace\SMARTool\Data\BlindCase4.xlsx','A3:AL271'),50*ones(271-2,1)];
MTest(end+1:end+268,:)=[xlsread('C:\workspace\SMARTool\Data\BlindCase5.xlsx','A1:AL268'),160*ones(268,1)];
MTestInput=MTest(:,1:37)';
MtestOutput=MTest(:,38)./200;
MOutput=MTest(:,38);

load('Model_common_test.mat');
%% Create additional dataset GM enriched to build posterior
% Import Nets
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

CXann={ANN_2HL_Original,ANN_1HL_OriginalFULL,ANN_1HL_OriginalPRUNED,ANN_GMDH_Original,...
    ANN_2HL_Linear,ANN_1HL_LinearFULL,ANN_1HL_LinearPRUNED,ANN_GMDH_Linear,...
    ANN_1HL_CubicSplineFULL,ANN_2HL_CubicSpline,ANN_1HL_CubicSplinePRUNED,ANN_GMDH_CubicSpline};

mapping=[1,1,1,1,2,2,2,2,3,3,3,3];
figure

%% CASE1: PRIOR=UNIFORM, POSTERIOR=EMPIRICAL 
subplot(2,2,1)
% Build Cposterior: PRIOR=UNIFORM, POSTERIOR=EMPIRICAL
[Vrobust_U2E, Vlower_U2E, Vupper_U2E,~,CPostDist_U2E]=applyAdaptiveBMSspecial('CXann',CXann,...
    'Ccalibration',Ccalibration,'Vmapping',mapping,'alpha',1.96,'Minputdata',MTestInput,...
    'Lgraph',true,'Lsort',false,'Sprior','uniform','Sposterior','empirical');
hold on 
h1=plot(1:length(MTestOutput),Vrobust_U2E.*200,'color',[0.000000 0.270000 0.130000]); %
h2=plot(1:length(MTestOutput),Vlower_U2E.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
h3=plot(1:length(MTestOutput),Vupper_U2E.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
ylim([-10,210])
xlabel('Samples')
ylabel('BreakLevel')
h4=plot(1:length(MTestOutput),(MOutput),'-.r','LineWidth',1);
% title('CASE1D: Prior=Uniform, Posterior=Empirical, Best 5 networks')
legend([h1, h2, h4],{'Model Output','Confidence Bounds','Experimental Data'},'location','southeast')
legend boxoff 
title('(a)')
grid off

%% CASE2: PRIOR=GM, POSTERIOR=EMPIRICAL
subplot(2,2,2)
% Build Cposterior: 
[Vrobust_GM2E, Vlower_GM2E, Vupper_GM2E,~,CPostDist_GM2E]=applyAdaptiveBMSspecial('CXann',CXann,...
    'Ccalibration',Ccalibration,'Vmapping',mapping,'alpha',1.96,'Minputdata',MTestInput,...
    'Lgraph',true,'Lsort',false,'Sprior','gm','Sposterior','empirical');
hold on 
h1=plot(1:length(MTestOutput),Vrobust_GM2E.*200,'color',[0.000000 0.270000 0.130000]); %
h2=plot(1:length(MTestOutput),Vlower_GM2E.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
h3=plot(1:length(MTestOutput),Vupper_GM2E.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
ylim([-10,210])
xlabel('Samples')
ylabel('BreakLevel')
h4=plot(1:length(MOutput),(MOutput),'-.r','LineWidth',1);
legend([h1, h2, h4],{'Model Output','Confidence Bounds','Experimental Data'},'location','southeast')
legend boxoff 
title('(b)')
grid off
%% CASE3: PRIOR=GM, POSTERIOR=GM
subplot(2,2,3)
% Build Cposterior: 
[Vrobust_GM2GM, Vlower_GM2GM, Vupper_GM2GM,~,CPostDist_GM2GM]=applyAdaptiveBMSspecial('CXann',CXann,...
    'Ccalibration',Ccalibration,'Vmapping',mapping,'alpha',1.96,'Minputdata',MTestInput,...
    'Lgraph',true,'Lsort',false,'Sprior','gm','Sposterior','gm');
hold on 
h1=plot(1:length(MOutput),Vrobust_GM2E.*200,'color',[0.000000 0.270000 0.130000]); %
h2=plot(1:length(MOutput),Vlower_GM2E.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
h3=plot(1:length(MOutput),Vupper_GM2E.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
ylim([-10,210])
xlabel('Samples')
ylabel('BreakLevel')
h4=plot(1:length(MOutput),(MOutput),'-.r','LineWidth',1);
legend([h1, h2, h4],{'Model Output','Confidence Bounds','Experimental Data'},'location','southeast')
legend boxoff 
title('(c)')
grid off

%% CASE4: PRIOR=UNIFORM, POSTERIOR=GM
subplot(2,2,4)
% Build Cposterior: 
[Vrobust_U2GM, Vlower_U2GM, Vupper_U2GM,~,CPostDist_U2GM]=applyAdaptiveBMSspecial('CXann',CXann,...
    'Ccalibration',Ccalibration,'Vmapping',mapping,'alpha',1.96,'Minputdata',MTestInput,...
    'Lgraph',true,'Lsort',false,'Sprior','uniform','Sposterior','gm');
hold on 
h1=plot(1:length(MOutput),Vrobust_U2GM.*200,'color',[0.000000 0.270000 0.130000]); %
h2=plot(1:length(MOutput),Vlower_U2GM.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
h3=plot(1:length(MOutput),Vupper_U2GM.*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
ylim([-10,210])
xlabel('Samples')
ylabel('BreakLevel')
h4=plot(1:length(MOutput),(MOutput),'-.r','LineWidth',1);
legend([h1, h2, h4],{'Model Output','Confidence Bounds','Experimental Data'},'location','southeast')
legend boxoff 
title('(d)')
grid off

%% BMS
[Vrobust_BMS, Vlower_BMS, Vupper_BMS]=applyBMSpecial('CXann',CXann,...
    'Mcalibrationdata',McalibrationData,'alpha',1.96,'Minputdata',MTestInput,...
    'Lgraph',false,'Lposteriordataset',LposteriorData);
%  COMPARE PERFORMANCE
%CASE 1

accuracy_Case1C=1-(sum(Vupper_U2E.*200<MOutput)+sum(Vlower_U2E.*200>MOutput))/length(Vlower_U2E);
ERR_CASE1C=((Vrobust_U2E-MOutput./200)).^2;
BoundWidth_CASE1C=(Vupper_U2E-Vlower_U2E).*200;
% CASE 2
accuracy_Case2C=1-(sum(Vupper_GM2E.*200<MOutput)+sum(Vlower_GM2E.*200>MOutput))/length(Vlower_GM2E);
ERR_CASE2C=((Vrobust_GM2E-MOutput./200)).^2;
BoundWidth_CASE2C=(Vupper_GM2E-Vlower_GM2E).*200;
% CASE 3
accuracy_Case3C=1-(sum(Vupper_GM2GM.*200<MOutput)+sum(Vlower_GM2GM.*200>MOutput))/length(Vlower_GM2GM);
ERR_CASE3C=((Vrobust_GM2GM-MOutput./200)).^2;
BoundWidth_CASE3C=(Vupper_GM2GM-Vlower_GM2GM).*200;
% CASE 4
accuracy_Case4C=1-(sum(Vupper_U2GM.*200<MOutput)+sum(Vlower_U2GM.*200>MOutput))/length(Vlower_U2GM);
ERR_CASE4C=((Vrobust_U2GM-MOutput./200)).^2;
BoundWidth_CASE4C=(Vupper_U2GM-Vlower_U2GM).*200;
% % BMS
accuracy_BMS=1-(sum(Vupper_BMS.*200<MOutput)+sum(Vlower_BMS.*200>MOutput))/length(Vlower_BMS);
ERR_BMS=((Vrobust_BMS-MOutput./200)).^2;
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