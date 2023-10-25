function criterion = Ensembl_class_fun(XTRAIN,ytrain,XTEST,ytest)
% Function Ensembl_class_fun ois called by sequentialfs that trains a classification ensemble model
% object that is the result of boosting 100 classification trees using the
% input data and calculates the overall accuracy, which is used by sequentialfs
% as the criterion used to select features.
% The ensemble aggregation method used is 'LogitBoost', which is adaptive
% logistic regression. Other methods and parameters can be specified - see
% fitcensemble for details.
% inputs:
%     XTRAIN
%     ytrain
%     XTEST
%     ytest
% output:
%   criterion: clasification error, number of time where model prediction
%   was wrong

%check input
     arguments
         XTRAIN (:,:) {mustBeNumeric}
         ytrain (:,:) {mustBeNumeric}
         XTEST (:,:) {mustBeNumeric}
         ytest (:,:) {mustBeNumeric}
     end 

    model = predict(fitcensemble(XTRAIN, ytrain, 'Method','LogitBoost'), XTEST); 
    criterion = sum(model ~= ytest);
    
end

