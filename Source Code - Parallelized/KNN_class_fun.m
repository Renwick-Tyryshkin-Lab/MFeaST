function MCE = KNN_class_fun(x_train,y_train,x_test,y_test)

% Train the classifier
knn = fitcknn(x_train,y_train,'Distance','seuclidean');

% Make a prediction for the test set
Y_knn = knn.predict(x_test);

% % Compute the confusion matrix
% C = confusionmat(y_test,Y_knn);
% 
% N = sum(sum(C));
% MCE = N - sum(diag(C)); % No. misclassified sample
% %MCE = Y_knn;

MCE = sum(Y_knn ~= y_test);

end

