function [MTrainingData, MTestData, MValidationData, MNewsamples]=createSMARTdataset(varargin)

% Default values
leaveout            = nan;  % all data included
TrainSetDim         = 0.70; % 70% of total data used for training
TestSetDim          = 0.15; % dimension of test dataset
ValSetDim           = 0.15; % dimension of validation dataset
InterpolationType   = 0;    % Linear or Cubic Spline
Mdataset            = [];   % UserDefined Dataset 
Nsamples            = []; % number of samples to populate the dataset
LGM                 = false;% Flag for use of Gaussian Mixture RVset
VNewBreakSize       = [10, 40, 80, 110,160]; % Default Break Sizes 2 compute through interpolation
LnoWaste            = false;% Flag to avoid waste of data (all otherwise leaveout data go to testing, all otherwise wasted generated data go to training)  
MNewsamples         = [];   % Additional samples from interpolation or GM sampling
Vinput2visualize    = [];   % Input to visualize in the generated dataset

for k=1:2:length(varargin)
    switch lower(varargin{k})
        case 'mdata' % Initial Dataset introduced by the user         
            Mdataset     = varargin{k+1};
        case 'leaveout'         
            leaveout     = varargin{k+1};
            if isempty(leaveout)
                leaveout=nan;
            end
        case 'lnowaste'
            LnoWaste     = varargin{k+1};
        case {'vbreaksize2interpolate','vlevels','vnewbreaksize'}         
            VNewBreakSize = varargin{k+1};    
        case {'trainsetdim','traindata','train'}         
            TrainSetDim     = varargin{k+1}; 
        case {'testsetdim','testdata','test'}         
            TestSetDim     = varargin{k+1}; 
        case {'valsetdim','nvaldata','validation'}         
            ValSetDim     = varargin{k+1};                  
        case {'nsamplingdata','nsamples'}
            Nsamples     = varargin{k+1}; 
            if isnumeric(Nsamples)
                LGM      = 1; % Flag for use of GaussianMixture  
            elseif isempty(Nsamples)
                LGM      = 0;
            else
                error('SMARTool:createSMARTdataset',...
                'A valid number of samples must be provided') 
            end
                
        case {'visualize input','visualizeinput'} 
            Vinput2visualize = varargin{k+1}; 
         case 'sinterpolationtype' 
             if strcmp(varargin{k+1},'linear')
                InterpolationType   = 1;    % Type1= linear interpolation
             elseif any(strcmp(varargin{k+1},{'cubic spline', 'cubicspline','spline'}))
                InterpolationType   = 2;    % Type2= cubic spline interpolation   
             elseif isempty(varargin{k+1})
                InterpolationType   = 0;  
             else    
                error('SMARTool:createSMARTdataset',...
                'Interpolation type requested not implemented') 
             end
        otherwise
            error('SMARTool:createSMARTdataset',...
                ['Input argument (' varargin{k} ') not allowed'])
    end
end

assert(TrainSetDim+ValSetDim+TestSetDim==1, ...
    'SMARTool:createSMARTdataset',...
    'Percentages supplied for the creation of the training, validation and test datasets are not correct');

%% Load Data if not introduced by user
if isempty(Mdataset)
   error('SMARTool:createSMARTdataset',...
         ['Data don"t grow on trees! Input for the datasets organization must be provided!'])
else % ensure the dataset is the right size!
    VsizeData=size(Mdataset);
    assert(any(VsizeData==38), ...
    'SMARTool:createSMARTdataset',...
    'The size of the dataset provided is not correct');
    if VsizeData(2)==38
        NoverallData=VsizeData(1);
        MdataInput=Mdataset;
        Mbounds=minmax(MdataInput');
        Mbounds(38,:)=[0,200];
    else
        NoverallData=VsizeData(2);
        MdataInput=Mdataset';
        Mbounds=minmax(MdataInput');
        Mbounds(38,:)=[0,200];
    end
end

%% LEAVEOUT (for Data Generation)
% Leaveout Validation
MkeptData=MdataInput;
if ~isnan(leaveout)
    MkeptData(MkeptData(:,38)==leaveout,:)=[];
end

%% DATASET REPOPULATION: create MNewsamples
if LGM==1 % Gaussian Mixture Sampling
        %build the Gaussian Mixture on the data
        R=cov(MkeptData);
        [u_vec, ~ ] = eig(R);      
        r1 = MkeptData*u_vec;
        % standard deviation by ksdensity
        MR=zeros(38); %38 = number of variables (including output)
        for irv=1:38
            [~,~, Vbandwidth]=ksdensity(r1(:,irv));
            MR(:,irv)=u_vec(:,irv)*Vbandwidth*(1+3*(1-0.05^(1/NoverallData)));
        end
        MGMcovariance=MR*MR';
        GM=gmdistribution(MkeptData,MGMcovariance);          
        % Sample from the GMRV
        MNewsamples=random(GM,Nsamples);
        % Reject not plausible inputs
        MNewsamples(sum((MNewsamples'>repmat(Mbounds(:,2),1,size(MNewsamples,1)))+(MNewsamples'<repmat(Mbounds(:,1),1,size(MNewsamples,1))),1)~=0,:)=[];
elseif InterpolationType==1 % Linear Interpolation  
    [~,indEqualBreakSize]=unique(MkeptData(2:end,end));
    NsamplesBS=unique(diff(indEqualBreakSize));
    assert(length(NsamplesBS)==1, ...
    'SMARTool:createSMARTdataset',...
    'To interpolate the data the number of samples for each break size must be coherent');
    MNewsamples=zeros(length(VNewBreakSize)*NsamplesBS,38);
    InputBreakSize=unique(MkeptData(:,38));
    for In=1:38 
        VnewData=interp1(InputBreakSize,[repmat(MkeptData(1,In),[NsamplesBS,1]),reshape(MkeptData(2:end,In),[NsamplesBS,length(InputBreakSize)-1])]',VNewBreakSize');
        MNewsamples(:,In)=reshape(VnewData,[NsamplesBS*length(VNewBreakSize),1]);
    end 
elseif InterpolationType==2 % Cubic Spline Interpolation
    [~,indEqualBreakSize]=unique(MkeptData(2:end,end));
    NsamplesBS=unique(diff(indEqualBreakSize));
    assert(length(NsamplesBS)==1, ...
    'SMARTool:createSMARTdataset',...
    'To interpolate the data the number of samples for each break size must be coherent');
    MNewsamples=zeros(length(VNewBreakSize)*NsamplesBS,38);
    InputBreakSize=unique(MkeptData(:,38));
     for In=1:38 
        VnewData=spline(InputBreakSize,[repmat(MkeptData(1,In),[NsamplesBS,1]),reshape(MkeptData(2:end,In),[NsamplesBS,length(InputBreakSize)-1])],VNewBreakSize');
        MNewsamples(:,In)=reshape(VnewData,[NsamplesBS*length(VNewBreakSize),1]);
    end 
end
    
%% Build Function Output
MoverallDataset     = [MNewsamples;MdataInput];
NoverallData        = size(MoverallDataset,1);
NValData            = round(ValSetDim*NoverallData);
NTestData           = round(TestSetDim*NoverallData);
DataIndex           = randperm(NoverallData);
IndexAdditionalData = 1:size(MNewsamples,1);
% TRAINING SET DATA
%validation
MValidationData     = MoverallDataset(DataIndex(1:NValData),:);
MLeaveOutWaste      = MValidationData((MValidationData(:,38)==leaveout),:);
MValidationData((MValidationData(:,38)==leaveout),:)=[]; % Clear TrainingData from LeaveOutValidation Data
%training
MTrainingData       = MoverallDataset(DataIndex(NValData+NTestData+1:end),:);
MLeaveOutWaste      = [MLeaveOutWaste; MTrainingData((MTrainingData(:,38)==leaveout),:)];
MTrainingData((MTrainingData(:,38)==leaveout),:) = [];
% TEST DATA
IndexTestData       = DataIndex(NValData+1:NValData+NTestData);
MTestData           = MoverallDataset(setdiff(IndexTestData,IndexAdditionalData),:);
MAdditionalDataWaste= MoverallDataset(intersect(IndexTestData,IndexAdditionalData),:); % Data Generated and thrown away from training set

if LnoWaste
    MTestData=[MTestData;MLeaveOutWaste];
    MTrainingData=[MTrainingData;MAdditionalDataWaste];
end

for igraph=1:length(Vinput2visualize)
    figure
    hold all
    scatter(MTrainingData(:,38),MTrainingData(:,Vinput2visualize(igraph)),'y')
    scatter(MTestData(:,38),MTestData(:,Vinput2visualize(igraph)),'r')
    scatter(MValidationData(:,38),MValidationData(:,Vinput2visualize(igraph)),'g')
    ylabel(['Input',num2str(Vinput2visualize(igraph))])
    xlabel('BreakSize')
    grid on
    title('createSMARTdataset')
    legend('Training Data','Testing Data','Validation Data','Location','best')
end

