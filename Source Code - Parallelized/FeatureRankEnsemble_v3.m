function [ranking_res, alg_names] = FeatureRankEnsemble_v3(data, class_label, selectedAlgs)
%FeatureRankEnsemble function that runs MATLAB feature ranking algorithms:
%rankfeatures with ROC criteria
%rankfeatures with Wilcoxon criteria
%relieff
%TreeBagger
% and a mutual information feature ranking algorithm
%INPUT
%   data - a numeric matrix(double), each row reprents a feature, each column is 
%           the observation/sample
%   class_label - a binary vector that 
%OUTPUT
%   ranking_res - a numeric matrix with a ranking between 1(highest) and
%       0(lowest) for each feature over the above ranking algorithms
%   alg_names - names of the algorithms used for ranking
%
% Required functions:
%   minmax_standardize (in Preprocessing)
%   computeMI_hist
%
% Required toolboxes:
%   Statistics and Machine Learning toolbox
%
% AUTHOR: Kathrin Tyryshkin
% Date: May 6th, 2018
% Version: 3
%
% Modified by: Yiheng Li
% Date: April 10th, 2023

%initialize
ranking_res = [];
alg_names = {};
order = 1:size(data,1); %array of 1,2,...,#features

num = 0;

parfor i = 1:length(selectedAlgs)
    % % %run MI between data and class_label
    % p = 8;
    % [mi_class, mi_class_corr] = computeMIclass(data, class_label, p);
    % res = [res 'MI'; num2cell(mi_class_corr)];
    %histogram-based method:
    if (selectedAlgs(i) == 'MI')
        [mi_class, mi_class_corr] = computeMI_hist(data', double(class_label));
        %minmax standardize between 0 and 1, 1 is the highest ranking - feature
        %with the highest MI and assign it to the results
        ranking_res = [ranking_res minmax_standardize(mi_class_corr, 1)];
        num = num + 1;
    end

    %rank features alg
    %[IDX, Z] = rankfeatures(X, Group) ranks the features in X using an
    %independent evaluation criterion for BINARY classification. X is a matrix
    %where every column is an observed vector and the number of rows
    %corresponds to the original number of features. Group contains the class
    %labels.
    if length(unique(class_label)) <= 2
        if (selectedAlgs(i) == 'RankFeaturesROC')
            [ind_roc, Z] = rankfeatures(data, class_label, 'Criterion', 'roc');
            curr_ranks = zeros(length(order),1);
            curr_ranks(ind_roc) = order;
            %minmax standardize between 0 and 1, 1 is the highest ranking feature
            %with ranking order of 1
            ranking_res = [ranking_res 1-minmax_standardize(curr_ranks,1)];
                    num = num + 1;

        end
        if (selectedAlgs(i) == 'RankFeaturesWil')
            [ind_wil, Z] = rankfeatures(data, class_label, 'Criterion', 'wilcoxon');
            curr_ranks = zeros(length(order),1);
            curr_ranks(ind_wil) = order;
            %minmax standardize between 0 and 1, 1 is the highest ranking feature
            %with ranking order of 1
            ranking_res = [ranking_res 1-minmax_standardize(curr_ranks,1)];
                    num = num + 1;

        end
    end

    %[RANKED,WEIGHT] = relieff(X,Y,K) computes ranks and weights of attributes
    %(predictors) for input data matrix X and response vector Y using the
    %ReliefF algorithm for classification with K nearest neighbors.
    %if class_label is numeric - regression, otherwise - classification
    %observations (rows), features (collumn)
    if (selectedAlgs(i) == 'Relieff')
        k=10; %must specify number of k neighbours
        [ranked,weight] = relieff(data',class_label,k, 'method', 'classification');
        curr_ranks = zeros(length(order),1);
        curr_ranks(ranked) = order;
        ranking_res = [ranking_res 1-minmax_standardize(curr_ranks,1)];
                num = num + 1;

    end

    %B = TreeBagger(NTrees,X,Y) creates an ensemble B of NTrees decision trees
    %for predicting response Y as a function of predictors X. X is a numeric
    %matrix of training data. Each row represents an observation and each
    %column represents a predictor or feature. Y is an array of true class
    %labels.
    if (selectedAlgs(i) == 'TreeBagger')
        NumTrees = 50;
        decTree = TreeBagger(NumTrees, data', class_label,...
            'OOBPredictorImportance', 'on', 'method','classification',...
            'PredictorSelection','curvature');
        ranking_res = [ranking_res minmax_standardize(abs(decTree.OOBPermutedVarDeltaError'))];
                num = num + 1;

    end
    % figure
    % plot(oobError(decTree));
    % xlabel 'Number of Grown Trees';
    % ylabel 'Out-of-Bag Mean Squared Error';
    %
    % figure
    % plot(oobMeanMargin(t));
    % xlabel('Number of Grown Trees');
    % ylabel('Out-of-Bag Mean Classification Margin');

    %run decision tree variable importance algorithm
    if (selectedAlgs(i) == 'TreeBagger')
        Mdl = fitctree(data',class_label,'PredictorSelection','curvature',...
            'Surrogate','on');
        imp = predictorImportance(Mdl);
        ranking_res = [ranking_res minmax_standardize(imp')];
                num = num + 1;

    end
    
end
alg_names = num;