function res = iterSequantialfs_v2(data, class_label, funType, c_partitions, direction, alg_options, max_iterations, UseParallel)
% widely-used filter method for bioinformatics data is to apply a
% univariate criterion separately on each feature, assuming that there is
% no interaction between features.  
%inmodel = sequentialfs(fun,X,y) selects a subset of features from the data
%matrix X that best predict the data in y by sequentially selecting
%features until there is no improvement in prediction. Rows of X correspond
%to observations; columns correspond to variables or features. y is a
%column vector of response values or class labels for each observation in X    

%INPUT: 
%   data - numeric array, where columns are samples and rows are features
%   class_labels - binary vector indicating 2 types of classes (0 and 1)
%   funType - classification function to run, options are: 'quadratic',
%           'tree', 'lda', 'ensbl', 'svm' and 'knn'
%   c - cvpartition for cross-validation
%   direction - forward or backwards for sequentialfs
%   alg_options - settins for the sequentialfs
%   max_iterations - number of times to run the sequentialfs
%   UseParallel - boolean to use parallel processors

%OUTPUT:
%   res     - results of the sequentialfs give the input parameters
%
% Required functions:
%   Tree_class_fun, LDA_class_fun, Ensembl_class_fun, SVM_class_fun and
%   KNN_class_fun
%
% Required toolboxes:
%   Statistics and Machine Learning toolbox
%   Parallel Computing Toolbox
%
% AUTHOR: Kathrin Tyryshkin
% Date: May 6th, 2018
% Version: 3


%check input
if strcmpi(direction, 'backward')
    direction = 'backward';
else
    direction = 'forward';
end

res = zeros(size(data, 2), 1);

switch funType
    case 'quad_lda'
        fun = @(x_train,y_train,x_test,y_test)LDA_class_fun(x_train,y_train,x_test,y_test, 'pseudoQuadratic');
    case 'tree'
        fun = @(x_train,y_train,x_test,y_test)Tree_class_fun(x_train,y_train,x_test,y_test);
    case 'lin_lda'
        fun = @(x_train,y_train,x_test,y_test)LDA_class_fun(x_train,y_train,x_test,y_test, 'linear');
    case 'ensbl'
        class_label = double(class_label);
        fun = @(x_train,y_train,x_test,y_test)Ensembl_class_fun(x_train,y_train,x_test,y_test);
    case 'svm'
        kernel = 'rbf';
        rbf_sigma = 1;
        boxconstraint = 1;
        fun = @(x_train,y_train,x_test,y_test)SVM_class_fun(x_train,y_train,x_test,y_test,kernel,rbf_sigma,boxconstraint);
    case 'knn'
        fun = @(x_train,y_train,x_test,y_test)KNN_class_fun(x_train,y_train,x_test,y_test);
%         fun = @(XT,yT,Xt,yt)(sum((yt ~= predict(fitcknn(XT,yT), Xt))));
    otherwise
        fun = @(x_train,y_train,x_test,y_test)KNN_class_fun(x_train,y_train,x_test,y_test);
end

%run the sequentialfs max_interations times - because often it selects different
%subset %By setting maxdev to chi2inv(.95,1), makes sequentialfs to continue
        %adding features so long as the change in deviance is more than would
        %be expected by random chance.
        %maxdev = chi2inv(.95,1);
        %opts = statset('display','iter', 'TolFun', maxdev,'TolTypeFun','abs');
if UseParallel
    parfor i=1:max_iterations    
        warning off;
        [fs,~] = sequentialfs(fun,data,class_label,'cv',c_partitions,...
            'direction', direction, 'options',alg_options);
        res = res+fs';
    end
else
    parfor i=1:max_iterations
        warning off;
        [fs,~] = sequentialfs(fun,data,class_label,'cv',c_partitions,...
            'direction', direction, 'options',alg_options);
        res = res+fs';
    end
end
% res = res./max_interations;





