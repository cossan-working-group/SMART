% clearvars;clc;close all
blind4 = xlsread('C:\Users\TianX\Google Drive\Tian\0 Neural network programs with blind data\Blind Case 3_Smart.xlsx','Sheet1','A3:AK372');
blind3 = xlsread('C:\Users\TianX\Google Drive\Tian\0 Neural network programs with blind data\Blind Case 4_Smart.xlsx','Sheet1','A3:AK372');
blind5 = xlsread('C:\Users\TianX\Google Drive\Tian\0 Neural network programs with blind data\Blind Case 5_Smart.xlsx','Sheet1','A3:AK372');
tstTgt = [0 40 50 75 160];
tstTargets3 = ones(1,length(blind3))*tstTgt(3);
tstTargets4 = ones(1,length(blind4))*tstTgt(4);
tstTargets5 = ones(1,length(blind5))*tstTgt(5); 

load('Model_common_test.mat')
%% MLP 1HL
RR = RR11;
NetDef = RR.NetDef;
W1 = RR.W1;
W2 = RR.W2;
obsNetDef = RR.obsNetDef;
obsW1 = RR.obsW1;
obsW2 = RR.obsW2;
input = blind3';
tstOutputs = nneval_tian(NetDef,W1,W2,input);
Model11_output_blinddata3 = tstOutputs*200;

OBStstOutputs = nneval_tian(obsNetDef,obsW1,obsW2,input); % prunned network
Model12_output_blinddata3 = OBStstOutputs*200;
MSE(1,1) = mean(((tstOutputs*200 - tstTargets3)/200).^2);
MSE(4,1) = mean(((OBStstOutputs*200 - tstTargets3)/200).^2);
input = blind4';
tstOutputs = nneval_tian(NetDef,W1,W2,input);
Model11_output_blinddata4 = tstOutputs*200;
OBStstOutputs = nneval_tian(obsNetDef,obsW1,obsW2,input); % prunned network
Model12_output_blinddata4 = OBStstOutputs*200;
MSE(1,2) = mean(((tstOutputs*200 - tstTargets4)/200).^2);
MSE(4,2) = mean(((OBStstOutputs*200 - tstTargets4)/200).^2);
input = blind5';
tstOutputs = nneval_tian(NetDef,W1,W2,input);
Model11_output_blinddata5 = tstOutputs*200;
OBStstOutputs = nneval_tian(obsNetDef,obsW1,obsW2,input); % prunned network
Model12_output_blinddata5 = OBStstOutputs*200;
MSE(1,3) = mean(((tstOutputs*200 - tstTargets5)/200).^2);
MSE(4,3) = mean(((OBStstOutputs*200 - tstTargets5)/200).^2);
% MSE(:,4) = mean(MSE,2)

%%
RR = RR12;
NetDef = RR.NetDef;
W1 = RR.W1;
W2 = RR.W2;
obsNetDef = RR.obsNetDef;
obsW1 = RR.obsW1;
obsW2 = RR.obsW2;
input = blind3';
tstOutputs = nneval_tian(NetDef,W1,W2,input);
Model13_output_blinddata3 = tstOutputs*200;
OBStstOutputs = nneval_tian(obsNetDef,obsW1,obsW2,input); % prunned network
Model14_output_blinddata3 = OBStstOutputs*200;
MSE(2,1) = mean(((tstOutputs*200 - tstTargets3)/200).^2);
MSE(5,1) = mean(((OBStstOutputs*200 - tstTargets3)/200).^2);
input = blind4';
tstOutputs = nneval_tian(NetDef,W1,W2,input);
Model13_output_blinddata4 = tstOutputs*200;
OBStstOutputs = nneval_tian(obsNetDef,obsW1,obsW2,input); % prunned network
Model14_output_blinddata4 = OBStstOutputs*200;
MSE(2,2) = mean(((tstOutputs*200 - tstTargets4)/200).^2);
MSE(5,2) = mean(((OBStstOutputs*200 - tstTargets4)/200).^2);
input = blind5';
tstOutputs = nneval_tian(NetDef,W1,W2,input);
Model13_output_blinddata5 = tstOutputs*200;
OBStstOutputs = nneval_tian(obsNetDef,obsW1,obsW2,input); % prunned network
Model14_output_blinddata5 = OBStstOutputs*200;
MSE(2,3) = mean(((tstOutputs*200 - tstTargets5)/200).^2);
MSE(5,3) = mean(((OBStstOutputs*200 - tstTargets5)/200).^2);

%%
RR = RR13;
NetDef = RR.NetDef;
W1 = RR.W1;
W2 = RR.W2;
obsNetDef = RR.obsNetDef;
obsW1 = RR.obsW1;
obsW2 = RR.obsW2;
input = blind3';
tstOutputs = nneval_tian(NetDef,W1,W2,input);
Model15_output_blinddata3 = tstOutputs*200;
OBStstOutputs = nneval_tian(obsNetDef,obsW1,obsW2,input); % prunned network
Model16_output_blinddata3 = OBStstOutputs*200;
MSE(3,1) = mean(((tstOutputs*200 - tstTargets3)/200).^2);
MSE(6,1) = mean(((OBStstOutputs*200 - tstTargets3)/200).^2);
input = blind4';
tstOutputs = nneval_tian(NetDef,W1,W2,input);
Model15_output_blinddata4 = tstOutputs*200;
OBStstOutputs = nneval_tian(obsNetDef,obsW1,obsW2,input); % prunned network
Model16_output_blinddata4 = OBStstOutputs*200;
MSE(3,2) = mean(((tstOutputs*200 - tstTargets4)/200).^2);
MSE(6,2) = mean(((OBStstOutputs*200 - tstTargets4)/200).^2);
input = blind5';
tstOutputs = nneval_tian(NetDef,W1,W2,input);
Model15_output_blinddata5 = tstOutputs*200;
OBStstOutputs = nneval_tian(obsNetDef,obsW1,obsW2,input); % prunned network
Model16_output_blinddata5 = OBStstOutputs*200;
MSE(3,3) = mean(((tstOutputs*200 - tstTargets5)/200).^2);
MSE(6,3) = mean(((OBStstOutputs*200 - tstTargets5)/200).^2);
MSE(:,4) = mean(MSE,2);
% figure(1),clf
% subplot(3,1,1)
% plot(tstTargets3)
% hold on;grid on
% plot(Model13_output_blinddata3)
% plot(Model14_output_blinddata3)
% ylim([0 200])
% subplot(3,1,2)
% plot(tstTargets4)
% hold on;grid on
% plot(Model13_output_blinddata4)
% plot(Model14_output_blinddata4)
% ylim([0 200])
% subplot(3,1,3)
% plot(tstTargets5)
% hold on;grid on
% plot(Model13_output_blinddata5)
% plot(Model14_output_blinddata5)
% ylim([0 200])

%% MLP 2HL
net = RR21.net; 
input = blind3';
tstOutputs = net(input);
Model21_output_blinddata3 = tstOutputs*200;
input = blind4';
tstOutputs = net(input);
Model21_output_blinddata4 = tstOutputs*200;
input = blind5';
tstOutputs = net(input);
Model21_output_blinddata5 = tstOutputs*200;
MSE(7,1) = mean(((Model21_output_blinddata3 - tstTargets3)/200).^2);
MSE(7,2) = mean(((Model21_output_blinddata4 - tstTargets4)/200).^2);
MSE(7,3) = mean(((Model21_output_blinddata5 - tstTargets5)/200).^2);

net = RR22.net; 
input = blind3';
tstOutputs = net(input);
Model22_output_blinddata3 = tstOutputs*200;
input = blind4';
tstOutputs = net(input);
Model22_output_blinddata4 = tstOutputs*200;
input = blind5';
tstOutputs = net(input);
Model22_output_blinddata5 = tstOutputs*200;
MSE(8,1) = mean(((Model22_output_blinddata3 - tstTargets3)/200).^2);
MSE(8,2) = mean(((Model22_output_blinddata4 - tstTargets4)/200).^2);
MSE(8,3) = mean(((Model22_output_blinddata5 - tstTargets5)/200).^2);

net = RR23.net; 
input = blind3';
tstOutputs = net(input);
Model23_output_blinddata3 = tstOutputs*200;
input = blind4';
tstOutputs = net(input);
Model23_output_blinddata4 = tstOutputs*200;
input = blind5';
tstOutputs = net(input);
Model23_output_blinddata5 = tstOutputs*200;
MSE(9,1) = mean(((Model23_output_blinddata3 - tstTargets3)/200).^2);
MSE(9,2) = mean(((Model23_output_blinddata4 - tstTargets4)/200).^2);
MSE(9,3) = mean(((Model23_output_blinddata5 - tstTargets5)/200).^2);
MSE(:,4) = mean(MSE,2);
%% GMDH


model = RR31.model;
input = blind3;
tstOutputs = gmdhpredict(model, input);
Model31_output_blinddata3 = tstOutputs'*200;
input = blind4;
tstOutputs = gmdhpredict(model, input);
Model31_output_blinddata4 = tstOutputs'*200;
input = blind5;
tstOutputs = gmdhpredict(model, input);
Model31_output_blinddata5 = tstOutputs'*200;

MSE(10,1) = mean(((Model31_output_blinddata3 - tstTargets3)/200).^2);
MSE(10,2) = mean(((Model31_output_blinddata4 - tstTargets4)/200).^2);
MSE(10,3) = mean(((Model31_output_blinddata5 - tstTargets5)/200).^2);


model = RR32.model;
input = blind3;
tstOutputs = gmdhpredict(model, input);
Model32_output_blinddata3 = tstOutputs'*200;
input = blind4;
tstOutputs = gmdhpredict(model, input);
Model32_output_blinddata4 = tstOutputs'*200;
input = blind5;
tstOutputs = gmdhpredict(model, input);
Model32_output_blinddata5 = tstOutputs'*200;

MSE(11,1) = mean(((Model32_output_blinddata3 - tstTargets3)/200).^2);
MSE(11,2) = mean(((Model32_output_blinddata4 - tstTargets4)/200).^2);
MSE(11,3) = mean(((Model32_output_blinddata5 - tstTargets5)/200).^2);


model = RR33.model;
input = blind3;
tstOutputs = gmdhpredict(model, input);
Model33_output_blinddata3 = tstOutputs'*200;
input = blind4;
tstOutputs = gmdhpredict(model, input);
Model33_output_blinddata4 = tstOutputs'*200;
input = blind5;
tstOutputs = gmdhpredict(model, input);
Model33_output_blinddata5 = tstOutputs'*200;

MSE(12,1) = mean(((Model33_output_blinddata3 - tstTargets3)/200).^2);
MSE(12,2) = mean(((Model33_output_blinddata4 - tstTargets4)/200).^2);
MSE(12,3) = mean(((Model33_output_blinddata5 - tstTargets5)/200).^2);

MSE(:,4) = mean(MSE(:,1:3),2)