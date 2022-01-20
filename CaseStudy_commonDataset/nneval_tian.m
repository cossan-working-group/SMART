function [out] = nneval_tian(NetDef,W1,W2,PHI)
% NNEVAL
% ------
%         Validation of ordinary feedforward neural networks.
%
% The predictions are compared to the true outputs, a histogram is shown
% for the prediction errors, and the autocorrelation coefficients for 
% the prediction error is plotted.
%
% CALL:
%        [Yhat,E,NSSE] = nneval(NetDef,W1,W2,PHI,Y)
%
%
% INPUTS:
%        See for example one of the functions MARQ, RPE, BATBP, INCBP
%
% OUTPUTS:
%         Yhat - Network predictions.
%         E    - Prediction errors.
%         NSSE - Normalized sum of squared errors.

% Written by : Magnus Norgaard, IAU/IMM Technical University of Denmark
% LastEditDate  : Jan. 23, 2000
% [outputs,N] = size(Y);
outputs = 1;
N = length(PHI);
[layers,dummy] = size(NetDef);        % Number of hidden layers
L_hidden = find(NetDef(1,:)=='L')';   % Location of linear hidden units
H_hidden = find(NetDef(1,:)=='H')';   % Location of tanh hidden units
L_output = find(NetDef(2,:)=='L')';   % Location of linear output units
H_output = find(NetDef(2,:)=='H')';   % Location of tanh output units
[hidden,inputs] = size(W1);
inputs   = inputs-1;
y1       = zeros(hidden,N);
out   = zeros(outputs,N);


% ---  Compute network output ---
h1 = W1*[PHI;ones(1,N)];
y1(H_hidden,:) = pmntanh(h1(H_hidden,:));
y1(L_hidden,:) = h1(L_hidden,:);

h2 = W2*[y1;ones(1,N)];
out(H_output,:) = pmntanh(h2(H_output,:));
out(L_output,:) = h2(L_output,:);


function t=pmntanh(x)
% PMNTANH
% -------
% Fast hyperbolic tangent function to be used in
% neural networks instead of the tanh provided by MATLAB
t=1-2./(exp(2*x)+1);