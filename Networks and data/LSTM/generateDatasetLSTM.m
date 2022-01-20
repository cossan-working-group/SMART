%linear LSTM
load('C:\workspace\SMART\SMARTool\Networks and data\LSTM\Outputs_Model_Linearinterp_Data_Linearinterp_SmartTool')
MLinearLSTM_LinearDataset=outputs;
load('C:\workspace\SMART\SMARTool\Networks and data\LSTM\Outputs_Model_Linearinterp_Data_Noninterp_SmartTool')
MLinearLSTM_OriginalDataset=outputs;
load('C:\workspace\SMART\SMARTool\Networks and data\LSTM\Outputs_Model_Linearinterp_Data_Splineinterp_SmartTool')
MLinearLSTM_CubicSplineDataset=outputs;
MblindData=[blinddata3_output;blinddata4_output;blinddata5_output];
save('C:\workspace\SMART\SMARTool\Networks and data\LSTM\Outputs_Linearinterp_SmartTool','MLinearLSTM_OriginalDataset',...
    'MLinearLSTM_LinearDataset','MLinearLSTM_CubicSplineDataset','MblindData')

%original LSTM
load('C:\workspace\SMART\SMARTool\Networks and data\LSTM\Outputs_Model_Noninterp_Data_Linearinterp_SmartTool')
MNointerpLSTM_LinearDataset=outputs;
load('C:\workspace\SMART\SMARTool\Networks and data\LSTM\Outputs_Model_Noninterp_Data_Noninterp_SmartTool')
MNointerpLSTM_OriginalDataset=outputs;
load('C:\workspace\SMART\SMARTool\Networks and data\LSTM\Outputs_Model_Noninterp_Data_Splineinterp_SmartTool')
MNointerpLSTM_CubicSplineDataset=outputs;
MblindData=[blinddata3_output;blinddata4_output;blinddata5_output];
save('C:\workspace\SMART\SMARTool\Networks and data\LSTM\Outputs_Nointerp_SmartTool','MNointerpLSTM_OriginalDataset',...
    'MNointerpLSTM_LinearDataset','MNointerpLSTM_CubicSplineDataset','MblindData')



%cubic spline LSTM
load('C:\workspace\SMART\SMARTool\Networks and data\LSTM\Outputs_Model_Splineinterp_Data_Linearinterp_SmartTool')
MCubicSplineLSTM_LinearDataset=outputs;
load('C:\workspace\SMART\SMARTool\Networks and data\LSTM\Outputs_Model_Splineinterp_Data_Noninterp_SmartTool')
MCubicSplineLSTM_OriginalDataset=outputs;
load('C:\workspace\SMART\SMARTool\Networks and data\LSTM\Outputs_Model_Splineinterp_Data_Splineinterp_SmartTool')
MCubicSplineLSTM_CubicSplineDataset=outputs;
MblindData=[blinddata3_output;blinddata4_output;blinddata5_output];
save('C:\workspace\SMART\SMARTool\Networks and data\LSTM\Outputs_CubicSpline_SmartTool',...
    'MCubicSplineLSTM_OriginalDataset','MCubicSplineLSTM_LinearDataset','MCubicSplineLSTM_CubicSplineDataset','MblindData')
