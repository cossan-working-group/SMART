load('Model_1HLMLP_Noninterpolation.mat')

NetDef = tr.NetDef;
W1 = tr.W1;
W2 = tr.W2;

obsNetDef = tr.obsNetDef;
obsW1 = tr.obsW1;
obsW2 = tr.obsW2;

input = blind3';
tstOutputs = nneval_tian(NetDef,W1,W2,input);

