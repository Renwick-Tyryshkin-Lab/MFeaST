function MCE = KNNSpearman_class_fun(x_train,y_train,x_test,y_test)
k=3;      
% Train the classifier
knn = fitcknn(x_train,y_train,'Distance', 'Spearman', ...
            'Exponent', [], ...
            'NumNeighbors', k, ...
            'DistanceWeight', 'Equal');

% Make a prediction for the test set
Y_knn = knn.predict(x_test);
MCE = sum(Y_knn ~= y_test);

end

