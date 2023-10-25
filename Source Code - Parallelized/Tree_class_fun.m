function MCE = Tree_class_fun(XTRAIN,ytrain,XTEST,ytest)
   % Function called by sequentialfs that fits a binary classification 
   % decision tree to the input data and calculates the overall accuracy, 
   % which is used by sequentialfs as the criterion used to select features. 
   % The algorithm used for the best categorical split is the 'Exact' method,
   % which compares all combinatiosn. Other methods and parameters can be 
   % specified - see fitctree for details. 
   
    model = predict(fitctree(XTRAIN, ytrain), XTEST); 
    MCE = sum(model ~= ytest);
    
end

