function MCE = LDA_class_fun(XTRAIN,ytrain,XTEST,ytest, type)
% Function called by sequentialfs that fits a linear discriminant analysis 
% model to the input data and calculates the overall accuracy, 
% which is used by sequentialfs as the criterion used to select features. 
% Other methods and parameters can be specified - see fitcdiscr for details.

    model = predict(fitcdiscr(XTRAIN, ytrain, 'Discrimtype',type), XTEST); 
    MCE = sum(model ~= ytest);
    
end
