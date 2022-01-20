function [VrobustOutput, VlowerBound, VupperBound, CXann]=applyBMSpecial(varargin)
% % Function of the SMARTool for building and/or computing the robust
% % response and the associated uncertainty of the SMART neural network.
% %
% % For more info regarding the method please refer to:
% %
% % U. Oparajia, R.-J. Sheu, M. Bankhead, J. Austin, and E. Patelli,
% % “Robust artificial neural network for reliability and sensitivity analysis
% % of complex non-linear systems,” To be published in Neural Networks,
% % vol. Accepted on May 25th., 2017.
% %
%

% Default values
Nnets           = 20;       % dimension of network set
alpha           = 1.95;     % parameter for confidence bounds (1-alpha=condifence bounds)  %% TODO CHECK IT!
CXann=cell(1,Nnets);        % initialise ANN set
McalibrationData= [];       % calibration data
MvalidationData = [];       % validation data
MtestData       = [];       % test data
VhiddenNodes    = [19,26];  % architecture of the network
Lset2build      = true;    % flag: false if the net set has been implemented already
Lgraph          = false;
Lsort           = false;


for k=1:2:length(varargin)
    switch lower(varargin{k})
        case 'cxann' % Pre-built net set
            CXann   = varargin{k+1};
            Nnets   = max(size(CXann));
            Lset2build= false;
        case 'lposteriordataset' % ONLY FOR SMART JOURNAL APPLICATION
                LpostData   = varargin{k+1};         
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
        case {'lsort'}
            Lsort=varargin{k+1};
        case {'mtestdata','mtest'} % preferred size Nsamples x Ninput (assuming Nsamples>Ninput)
            MtestData  = varargin{k+1};
            if issorted(size(MtestData))
                MtestData=MtestData';
            end
        case 'alpha'
            alpha           = varargin{k+1};
        case 'minputdata' % Data to compute
            MData2compute          = varargin{k+1};
        case 'vhiddennodes'
            VhiddenNodes    = varargin{k+1};
        case 'nnets'
            Nnets           = varargin{k+1};
        case 'lgraph'
            Lgraph          = varargin{k+1};
        otherwise
            error('SMARTool:applyBMS',...
                ['Input argument (' varargin{k} ') not allowed'])
    end
end

%% BUILD BMS model
assert(~isempty(McalibrationData), ...
    'SMARTool:applyBMS',...
    'Training data must be provided!');

% Merge the initial datasets
MdataIN=[McalibrationData;MvalidationData]; %do not change the order! ;MtestData

if Lset2build
    CXann=cell(1,Nnets);
else
    assert(max(size(CXann))==Nnets,...
        'SMARTool:applyBMS',...
        'Number of Nets must be coherent with the net set introduced')
end

% NTrainSamples = max(size([McalibrationData;MvalidationData])); % number of samples in the training set
NTrainSamples = max(size(MdataIN)); % number of samples in the training set
NinputSamples = max(size(MData2compute));     % number of input data to compute

% Initialize loop variables
VsquareError    = zeros(NTrainSamples,Nnets);
Vvariance       = zeros(1,Nnets);
MOutput         = zeros(NinputSamples,Nnets); % Cell is necessary if there is more than one output
McalOutput      = zeros(NTrainSamples,Nnets);
for inet=1:Nnets
    if Lset2build     % build net set
        CXann{1,inet}           = feedforwardnet(VhiddenNodes); % build net obj
        CXann{1,inet}.divideFcn = 'divideind';
        CXann{1,inet}.divideParam.trainInd = 1:size(McalibrationData,1);
        CXann{1,inet}.divideParam.valInd = size(McalibrationData,1)+1:size(McalibrationData,1)+size(MvalidationData,1);
        CXann{1,inet}.divideParam.testInd = size(McalibrationData,1)+size(MvalidationData,1):size(MdataIN,1);
        CXann{1,inet}           = train(CXann{1,inet},MdataIN(:,1:37)',MdataIN(:,38)'); % train net
    end
    if isa(CXann{1,inet},'network')
        McalOutput(:,inet)      = transpose(CXann{1,inet}(MdataIN(:,1:37)'));
    elseif strcmp(CXann{1,inet}{end},'nneval_tian')
        McalOutput(:,inet)      = nneval_tian(CXann{1,inet}{1},CXann{1,inet}{2},CXann{1,inet}{3},MdataIN(:,1:37)');
    elseif strcmp(CXann{1,inet}{end},'gmdhpredict')
        McalOutput(:,inet)      = gmdhpredict(CXann{1,inet}{1}, MdataIN(:,1:37));
    elseif strcmp(CXann{1,inet}{end},'precomputedoutput')    
            McalOutput(:,inet)      = CXann{1,inet}{LpostData};    
    end
    VsquareError(:,inet)    = (MdataIN(:,38)-(McalOutput(:,inet))).^2;
    Vvariance(inet)         = 1/size(MdataIN(:,38),1)*sum(VsquareError(:,inet),1);
    if isa(CXann{1,inet},'network')
        MOutput(:,inet)         = transpose(CXann{1,inet}(MData2compute));
    elseif strcmp(CXann{1,inet}{end},'nneval_tian')
        MOutput(:,inet)         = nneval_tian(CXann{1,inet}{1},CXann{1,inet}{2},CXann{1,inet}{3},MData2compute);
    elseif strcmp(CXann{1,inet}{end},'gmdhpredict')
        MOutput(:,inet)         = gmdhpredict(CXann{1,inet}{1},MData2compute');
    elseif strcmp(CXann{1,inet}{end},'precomputedoutput')    
        MOutput(:,inet)         = CXann{1,inet}{4};    
    else
    end
end

% MpointEstimate=OutNN;
VpartialP_1  = 1./(sqrt(2*pi*Vvariance));
VpartialP_2  = exp(-VsquareError./repmat(2*Vvariance,[NTrainSamples,1]));
VpartialP_3  = sum(VpartialP_2,1)./NTrainSamples;
VposteriorP  =((VpartialP_1.*VpartialP_3)/Nnets)/sum((VpartialP_1.*VpartialP_3)/Nnets, 2);
[~, bestNet] = max(VposteriorP);
%%  COMPUTE ROBUST RESPONSE
AdjustmentFactor_mu = sum(repmat(VposteriorP,[NinputSamples,1]).*(MOutput-repmat(MOutput(:,bestNet),[1,Nnets])),2);
VrobustOutput       = MOutput(:,bestNet)+AdjustmentFactor_mu;
AdjustmentFactor_var= sum(VposteriorP.*(MOutput-repmat(VrobustOutput,[1,Nnets])).^2,2);
VlowerBound         = VrobustOutput-(alpha*sqrt(AdjustmentFactor_var));
VupperBound         = VrobustOutput+(alpha*sqrt(AdjustmentFactor_var));
if Lgraph
    figure
    hold all
    if Lsort
        [~,indSorted]=sort(VrobustOutput);
    else
        indSorted=1:length(VrobustOutput) ;
    end
    plot((1:NinputSamples),VrobustOutput(indSorted).*200,'color',[0.000000 0.270000 0.130000]);
    plot((1:NinputSamples),VlowerBound(indSorted).*200,'color',[0.9100    0.4100    0.1700]);
    plot((1:NinputSamples),VupperBound(indSorted).*200,'color',[0.9100    0.4100    0.1700]);
    ylim([-10,210])
    xlabel('Samples')
    ylabel('BreakLevel')
    grid on
    title('BMS Results')
    legend('Robust BMS Output','Confidence Bounds','location','best')
end

end





