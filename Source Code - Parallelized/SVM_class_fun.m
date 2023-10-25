function MCE = SVM_class_fun(x_train,y_train,x_test,y_test,kernel,rbf_sigma,boxconstraint)

% Train the classifier
svm =  fitcsvm(...
    x_train, ...
    y_train, ...
    'KernelFunction', kernel, ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', boxconstraint ...
);

% Make a prediction for the test set
Y_svm = svm.predict(x_test);

% C = confusionmat(y_test,y_fit);
% N = sum(sum(C));
% MCE = N - sum(diag(C)); % No. misclassified sample

MCE = sum(Y_svm ~= y_test);

end

% indices = crossvalind('Kfold',Labels,num_folds);
% Results = classperf(Labels, 'Positive', 1, 'Negative', 0);      % Initialize 
% 
% for i = 1:num_folds
%     test = (indices == i); train = ~test;
%     svmStruct = svmtrain(Data(train,Feature_select),Labels(train),'Kernel_Function','rbf','rbf_sigma',rbf_sigma,'boxconstraint',boxconstraint);      
%     class = svmclassify(svmStruct,Data(test,Feature_select));          
%   classperf(Results,class,test);  
% end
% Acc = Results.CorrectRate;      % Classification accuracy
% 
% end
