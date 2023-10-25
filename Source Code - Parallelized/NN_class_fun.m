function MCE = NN_class_fun(x_train,y_train,x_test,y_test,hiddenLayerSize)

% Create a Pattern Recognition Network
net = patternnet(hiddenLayerSize);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
% Hide the training window
net.trainParam.showWindow = false;
% Making use of parallel computing
[net,~] = train(net,x_train,y_train);

% Test the Network
testres = net(x_test);
testres = round(testres);

% C = confusionmat(y_test,testres);
% N = sum(sum(C));
% MCE = N - sum(diag(C)); % No. misclassified sample

MCE = sum(testres ~= y_test);

end

