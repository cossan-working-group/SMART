function [VXnetOutput, VlowerBound, VupperBound, XnetERROR]=applyEESA(Xnet, varargin)

% initialize variables
VXnetOutput         = [];
LnetERR2implement   = true;
Lgraph              = false;

for k=1:2:length(varargin)
    switch lower(varargin{k})
        case {'errornet','errorpredictor'} % pre built model 
            XnetERROR   = varargin{k+1};
            LnetERR2implement = false;
        case 'mdatainput' % Input to compute
            MdataInput   = varargin{k+1};
       case {'mcalibrationdata','mcalibration'} % preferred size Nsamples x Ninput (assuming Nsamples>Ninput)       
            McalibrationData  = varargin{k+1};
            if issorted(size(McalibrationData))
                McalibrationData=McalibrationData';
            end
        case {'mvalidationdata', 'mvalidation'} % preferred size Nsamples x Ninput (assuming Nsamples>Ninput)       
            MvalidationData  = varargin{k+1};
            if issorted(size(MvalidationData))
                MvalidationData=MvalidationData';
            end
        case {'mtestdata','mtest'} % preferred size Nsamples x Ninput (assuming Nsamples>Ninput)       
            MtestData  = varargin{k+1};
            if issorted(size(MtestData))
                MtestData=MtestData';
            end
        case {'mdataoutput', 'primaryoutput','networkoutput'} % Output of the primary network for the MdataInput
            VXnetOutput   = varargin{k+1};    
        case 'lgraph'
            Lgraph          = varargin{k+1};    
        otherwise
            error('SMARTool:applyEESA',...
                ['Input argument (' varargin{k} ') not allowed'])
    end
end

if LnetERR2implement
    % Build the new Dataset for the Error Prediction network
    Xnet_calibrationData =  [McalibrationData;MvalidationData;MtestData];
    Xnet_calibrationOut =   Xnet(Xnet_calibrationData(:,1:37)');
    MERRCalibrationOut  =   (Xnet_calibrationOut)./200-Xnet_calibrationData(:,38)'./200;
    MERRCalibrationIn   =   [Xnet_calibrationData(:,1:37),(Xnet_calibrationOut./200)'];

    %% BUILD ERROR PREDICTION NETWORK
    XnetERROR               = Xnet;
    XnetERROR.inputs{1}.size= Xnet.inputs{1}.size+1;
    % Ensure the total dataset is divided coherently with respect to the user input
    XnetERROR.divideFcn = 'divideind';
    XnetERROR.divideParam.trainInd  = 1:size(McalibrationData,1);
    XnetERROR.divideParam.valInd    = size(McalibrationData,1)+1:size(McalibrationData,1)+size(MvalidationData,1);
    XnetERROR.divideParam.testInd   = size(McalibrationData,1)+size(MvalidationData,1):size(MERRCalibrationIn,1);
    XnetERROR                       = train(XnetERROR,MERRCalibrationIn',MERRCalibrationOut);
end

if isempty(VXnetOutput)
    VXnetOutput         = Xnet(MdataInput');
end

%% Compute Response
MnewInput      = [MdataInput,(VXnetOutput./200)'];
VpredictedERR  = XnetERROR(MnewInput');
% Rearrange output
VXnetOutput    = VXnetOutput.*200; 
VlowerBound    = VXnetOutput-abs(VpredictedERR).*200;
VupperBound    = VXnetOutput+abs(VpredictedERR).*200;
if Lgraph
    figure
    hold all
    plot(1:length(VXnetOutput),VXnetOutput,'color',[0.000000 0.270000 0.130000]);
    plot((1:length(VXnetOutput)),VlowerBound,'color',[0.9100    0.4100    0.1700]);
    plot((1:length(VXnetOutput)),VupperBound,'color',[0.9100    0.4100    0.1700]);
    ylim([-10,210])
    xlabel('Samples')
    ylabel('BreakLevel')
    grid on
    title('EESA Results')
    legend('Network Output','Predicted Error Bounds','location','best')
    hold off
end

end
