function [VrobustOutput, VlowerBound, VupperBound, CXann,CPostDist]=applyAdaptiveBMSspecial(varargin)
% % Function of the SMARTool for building and/or computing the robust
% % response and the associated uncertainty of the SMART neural network.
% %


% Default values
Nnets           = 20;       % dimension of network set
alpha           = 1.95;     % parameter for confidence bounds (1-alpha=condifence bounds)  %% TODO CHECK IT!
CXann=cell(1,Nnets);        % initialise ANN set
McalibrationData= [];       % calibration data
MvalidationData = [];       % validation data
VhiddenNodes    = [19,26];  % architecture of the network
Lset2build      = true;     % flag: false if the net set has been implemented already
Lgraph          = false;
CPostDist       = [];
Lpost2compute   = true;
Lsort           = false;
Lprior          = 1;        % default prior set to uniform
Lpost           = 0;        % default posterior set to empirical
threshold       = 0;      % low information threshold
for k=1:2:length(varargin)
    switch lower(varargin{k})
        case 'cxann' % Pre-built net set
            CXann   = varargin{k+1};
            Nnets   = max(size(CXann));
            Lset2build= false;
        case 'sprior' % Pre-built net set
            if strcmpi(varargin{k+1},'uniform')
                Lprior   = 1;
            elseif sum(strcmpi(varargin{k+1},{'gaussianmixture','gm'}))
                Lprior   = 0;
            end
        case 'sposterior' % Pre-built net set
            if strcmpi(varargin{k+1},'empirical')
                Lpost   = 0;
            elseif sum(strcmpi(varargin{k+1},{'gaussianmixture','gm'}))
                Lpost   = 1;
            end
        case 'lposteriordataset' % ONLY FOR SMART JOURNAL APPLICATION
                LpostData   = varargin{k+1};                
        case {'mcalibrationdata','mcalibration'} % preferred size Nsamples x Ninput (assuming Nsamples>Ninput)
            McalibrationData  = varargin{k+1};
            if issorted(size(McalibrationData))
                McalibrationData=McalibrationData';
            end
        case {'lsort'}
            Lsort=varargin{k+1};
        case {'cposterior','cpdf'}
            CPostDist=varargin{k+1};
            Lpost2compute=false;
        case {'mvalidationdata', 'mvalidation','mtest'} % preferred size Nsamples x Ninput (assuming Nsamples>Ninput)
            MvalidationData  = varargin{k+1};
            if issorted(size(MvalidationData))
                MvalidationData=MvalidationData';
            end
        case 'alpha'
            alpha           = varargin{k+1};
        case 'threshold'
            threshold       = varargin{k+1};
        case 'minputdata' % Data to compute
            MData2compute          = varargin{k+1};
        case 'ccalibration' % Data to compute
            Ccalibration          = varargin{k+1};    
        case 'vmapping' % Data to compute
            mapping          = varargin{k+1};    
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


if Lset2build
    CXann=cell(1,Nnets);
else
    assert(max(size(CXann))==Nnets,...
        'SMARTool:applyBMS',...
        'Number of Nets must be coherent with the net set introduced')
end


NinputSamples = max(size(MData2compute));     % number of input data to compute
if Lpost2compute
    % Initialize loop variables
    VsquareError    = cell(1,Nnets);
   
    Vvariance       = cell(1,Nnets);
    Mlikelihood     = cell(1,Nnets);
    MPosteriorSamples= Mlikelihood;
    MPnorm          = Mlikelihood;
    McalOutput      = cell(1,Nnets);
    CPostDist       = cell(1,Nnets);
    
    for inet=1:Nnets
            BreakSizes1      = Ccalibration{mapping(inet)};
            VbreakSize      = unique(BreakSizes1(:,38));
        if ~isempty(McalibrationData)
            MdataIN=[McalibrationData;MvalidationData];
        else
            MdataIN=Ccalibration{mapping(inet)};
            
        end
            [MBSSorted,indSort]     = sort(MdataIN(:,38));
            [~,~, Vbs]=unique(MBSSorted);
        if Lset2build     % build net set
            CXann{1,inet}           = feedforwardnet(VhiddenNodes); % build net obj
            CXann{1,inet}.divideFcn = 'divideind';
            CXann{1,inet}.divideParam.trainInd = 1:size(McalibrationData,1);
            CXann{1,inet}.divideParam.valInd = size(McalibrationData,1)+1:size(McalibrationData,1)+size(MvalidationData,1);
            CXann{1,inet}.divideParam.testInd = size(McalibrationData,1)+size(MvalidationData,1):size(MdataIN,1);
            CXann{1,inet}           = train(CXann{1,inet},MdataIN(:,1:37)',MdataIN(:,38)'); % train net
        end
        if isa(CXann{1,inet},'network')
            McalOutput{inet}      = transpose(CXann{1,inet}(MdataIN(indSort,1:37)'));
        elseif strcmp(CXann{1,inet}{end},'nneval_tian')
            McalOutput{inet}      = nneval_tian(CXann{1,inet}{1},CXann{1,inet}{2},CXann{1,inet}{3},MdataIN(indSort,1:37)');
        elseif strcmp(CXann{1,inet}{end},'gmdhpredict')
            McalOutput{inet}       = gmdhpredict(CXann{1,inet}{1}, MdataIN(indSort,1:37));
        elseif strcmp(CXann{1,inet}{end},'precomputedoutput')    
            McalOutput{inet}      = CXann{1,inet}{LpostData}';
        end
        VsquareError{inet}     = (MBSSorted-(reshape(McalOutput{inet},size(MBSSorted)))).^2;
        Vvariance{inet}         = 20.*ones(length(VbreakSize),1);
        if Lprior
            Vprior              = 1/(200.*Nnets);
        else
            gm                  = gmdistribution(VbreakSize,reshape(Vvariance{inet} ,[1,1,length(VbreakSize)]));
            Vprior              = (gm.pdf(reshape(McalOutput{inet},size(MBSSorted))).*Nnets);
        end
        Variance=Vvariance{inet} ;
        Mlikelihood{inet}     = (1./sqrt(2*pi.*Variance(Vbs))).*(exp(-VsquareError{inet}./(2*Variance(Vbs))));       
        tempP                   =  accumarray(Vbs,Mlikelihood{inet}.*Vprior);
        MPnorm{inet}          =  tempP(Vbs);
        MPosteriorSamples{inet}= (Mlikelihood{inet}.*Vprior)./MPnorm{inet};
        
        if Lpost %&& length(VbreakSize)<=8
            %             Mcoeff=reshape(coeffvalues(fit(McalOutput(:,inet),MPosteriorSamples(:,inet),['gauss',num2str(length(VbreakSize))])),[3,length(VbreakSize)])';
            %             CPostDist{inet}=gmdistribution(Mcoeff(:,2),reshape(Mcoeff(:,3),[1,1,8]));
            %         elseif Lpost && length(VbreakSize)>8
            %             %             [~,ind]=unique(McalOutput(:,inet));
            %             CPostDist{inet}=fit(McalOutput(ind,inet),MPosteriorSamples(ind,inet),'linearinterp','Normalize','on');
            fun=@(x,y)coeffvalues(fit(x,y,'gauss1'));
            Mcoeff=splitapply(fun,reshape(McalOutput{inet},size(MBSSorted)),MPosteriorSamples{inet},Vbs);
            CPostDist{inet}=gmdistribution(Mcoeff(:,2),reshape(Mcoeff(:,3),[1,1,length(VbreakSize)]));
        end
    end
end

% initialise loop variables
MOutput         = zeros(NinputSamples,Nnets); % Cell is necessary if there is more than one output
MnetP           = zeros(NinputSamples, Nnets);

% compute Data of interest
for inet=1:Nnets
    if isa(CXann{1,inet},'network')
        MOutput(:,inet)         = transpose(CXann{1,inet}(MData2compute));
    elseif strcmp(CXann{1,inet}{end},'nneval_tian')
        MOutput(:,inet)         = nneval_tian(CXann{1,inet}{1},CXann{1,inet}{2},CXann{1,inet}{3},MData2compute);
    elseif strcmp(CXann{1,inet}{end},'gmdhpredict')
        MOutput(:,inet)         = gmdhpredict(CXann{1,inet}{1},MData2compute');
    elseif strcmp(CXann{1,inet}{end},'precomputedoutput')    
        MOutput(:,inet)         = CXann{1,inet}{4};
    end
    if Lpost
        MnetP(:,inet)           = CPostDist{inet}.pdf(MOutput(:,inet));
    else
        [Mcal,ind]=unique(McalOutput{inet});
        MPS= MPosteriorSamples{inet};
        MnetP(:,inet)           = interp1(Mcal,MPS(ind),MOutput(:,inet));
    end
end

%%  COMPUTE ROBUST RESPONSE
Vcertainty=nansum(MnetP,2);
MnetP=MnetP./Vcertainty;
% if no enough info is available, look at the neighbour
V=[-inf;VbreakSize;inf];
underThreshold=sum(Vcertainty<threshold);
UpPeak = sum(repmat(V',[underThreshold,1])>repmat(max(MOutput(Vcertainty<threshold,:),[],2),[1,length(V)]),2);%repmat(V',[underThreshold,1])>repmat(max(MOutput(Vcertainty<threshold,:),[],2),[1,length(V)]),2);
LowPeak= sum(repmat(V',[underThreshold,1])<repmat(min(MOutput(Vcertainty<threshold,:),[],2),[1,length(V)]),2);
V=[0;VbreakSize;200];
for i=1:Nnets
    if Lpost
        MnetP(Vcertainty<threshold,i)=mean([CPostDist{i}.pdf([V(LowPeak):V(length(V)+1-UpPeak)]')],1);
    else
        Mcal=McalOutput{inet};
        MPS= MPosteriorSamples{inet};
        MnetP(Vcertainty<threshold,i)=mean(interp1(Mcal(ind),MPS(ind),[V(LowPeak):V(length(V)+1-UpPeak)]));
    end
end
MnetP=MnetP./sum(MnetP,2);
% MnetP(sum(MnetP<0,2)>0,:)=0;
MnetP(sum(isnan(MnetP),2)==Nnets,:)=1/Nnets;
[~,VbestNet]   =nanmax(MnetP,[],2);
VBestInd = sub2ind(size(MOutput), [1:size(MOutput,1)]', VbestNet);
AdjustmentFactor_mu = nansum(MnetP.*(MOutput-repmat(MOutput(VBestInd),[1,Nnets])),2);
VrobustOutput       = MOutput(VBestInd)+AdjustmentFactor_mu;
AdjustmentFactor_var= nansum(MnetP.*(MOutput-repmat(VrobustOutput,[1,Nnets])).^2,2);
VlowerBound         = VrobustOutput-(alpha*sqrt(AdjustmentFactor_var));
VupperBound         = VrobustOutput+(alpha*sqrt(AdjustmentFactor_var));

if Lgraph
%     figure
    hold all
    if Lsort
        [~,indSorted]=sort(VrobustOutput);
    else
        indSorted=1:length(VrobustOutput) ;
    end
    plot((1:NinputSamples),VrobustOutput(indSorted).*200,'color',[0.000000 0.270000 0.130000]); %
    plot((1:NinputSamples),VlowerBound(indSorted).*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
    plot((1:NinputSamples),VupperBound(indSorted).*200,':w','color',[0.9100    0.4100    0.1700],'LineWidth',1.5);
    ylim([-10,210])
    xlabel('Samples')
    ylabel('BreakLevel')
    grid on
    title('Adaptive BMS Results')
    legend('Model Output','Confidence Bounds','location','best')
end

end