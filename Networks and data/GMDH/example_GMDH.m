load('Model_GMDH_Noninterpolation.mat')
input = blind3;
tstOutputs = gmdhpredict(model, input);
Model31_output_blinddata3 = tstOutputs'*200;


