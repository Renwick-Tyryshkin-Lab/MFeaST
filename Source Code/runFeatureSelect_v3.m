function [ranked_features, celldata_ranked] = runFeatureSelect_v3(data2use, class_labels, validationtype,k, UseParallel, IS_max_iterations, selectedAlgs, isLogTransformed)
%function that performs an enseble of feature selections on the provided
%data. Currently only supporting binary classification
%The algorithms are:
%
%
%
%INPUT: 
%   data2use - cellarray, where columns are samples and rows are
%               features
%   class_labels - cellarray of 2 types of classes, e.g. cancer, control
%   validationtype - 'KFold','HoldOut','LeaveOut','resubstitution', default
%               is KFold
%   k         - relates to the validation type, default is 5 for kFold
%               for HoldOut  P is a scalar such that 0 < P < 1.
%   UseParallel - boolean to use parallel processors
%   IS_max_iterations - number of iterations to run the iterSequantialfs
%               algorithm
%   SelectedAlgs - algorithms to run, selected by the user
%OUTPUT:
%   ranked_features     - cellarray of ranked features, fold change, Cohen
%                       d (effect size) and Man Whitney p-value.
%   celldata_ranked     - the original data2use cellarray sorted by the
%                       ranking of the features
%
% Required functions:
%   run_featureRankEnsemble
%   computeFoldChange
%   
% Required toolboxes:
%   Statistics and Machine Learning toolbox
%   Parallel Computing Toolbox
%
% EXAMPLE %% UPDATE!
% [selection_frequency, selected_features] = runFeatureSelect_v3(celldata_miRNAs_norm,...
% patient_class, 'kfold', 5, true,2,{"MI", "RankFeaturesROC"},true);
%
% AUTHOR: Kathrin Tyryshkin
% Date: May 6th, 2018
% Version: 3
% Updated Feb 1 2022 by Tashifa Imtiaz


%__________________________________________________________________
%check input
%__________________________________________________________________
%data2use should have the same number of columns as className length
if length(data2use(1, 2:end)) ~= length(class_labels)
    error('the dataset should have the same number of columns as classLabels');
end
if ~ischar(validationtype)
    error('validationtype should be a string: KFold,HoldOut,LeaveOut, or resubstitution');
end
if ~islogical(UseParallel)
    error('UseParallel should be true or false');
end
if length(unique(class_labels)) ~= 2
    error('runFeatureSelect_v3 is for binary classification, the className should have labels for 2 classes');
end

%__________________________________________________________________
%initialize the variables
%__________________________________________________________________

switch lower(validationtype)
    case 'kfold'
        c = cvpartition(class_labels, 'kfold', k);
    case 'holdout' %not tested
        c = cvpartition(class_labels, 'HoldOut', k);
    case 'leaveout'
        c = cvpartition(class_labels, 'LeaveOut');        
    case 'resubstitution'  %not tested
        c = cvpartition(class_labels, 'resubstitution');  
    otherwise
        k = 5;
        c = cvpartition(class_labels, 'kfold', k);
        validationtype = 'kfold';        
end    

%__________________________________________________________________
%run feature selection using multiple algorithms
%__________________________________________________________________
data = cell2mat(data2use(2:end, 2:end));
class_groups = unique(class_labels);
classes = strcmpi(class_labels, class_groups(1));
[ranking_results, alg_names] = run_featureRankEnsemble(data, classes, c, UseParallel, IS_max_iterations, selectedAlgs);

%__________________________________________________________________
%assemble results and compute additional stats
%__________________________________________________________________

if isempty(ranking_results)
    ranked_features = cell(length(data2use(:, 1)), length(alg_names)+1);
    celldata_ranked = [];
    return;
end

if length(ranking_results(1, :)) ~= length(alg_names)
    disp(['length of results and length of algorithms are different !' num2str(length(ranking_results(1, :))) ' vs ' num2str(length(alg_names))]);
end

%sort the results in ranked order, the first column in the ranking
%resutls is the overall order
[~, ind] = sort(ranking_results(:,1));
ranking_results = ranking_results(ind, :);

%assemble  the results
ranked_features = cell(length(data2use(:, 1)), length(alg_names)+1);
ranked_features(:,1) = data2use([1;ind+1], 1);
ranked_features(1, 2:end) = alg_names;
ranked_features(2:end, 2:length(ranking_results(1, :))+1) = num2cell(ranking_results);

%place the data in ranked order
celldata_ranked = data2use([1;ind+1], :);
class_groups = unique(class_labels);
classes = strcmpi(class_labels, class_groups(1));
class1data = cell2mat(celldata_ranked(2:end, [false;classes]));
class2data = cell2mat(celldata_ranked(2:end, [false;~classes]));

%compute median expression
ranked_features(1, end+1) = {['median expr ' class_groups{1}]};
ranked_features(2:end, end) = num2cell(median(class1data,2));
ranked_features(1, end+1) = {['median expr ' class_groups{2}]};
ranked_features(2:end, end) = num2cell(median(class2data,2));

%compute foldchange
ranked_features(1, end+1) = {'fold change'};
ranked_features(1, end+1) = {'log2 fold change'};
ranked_features(1, end+1) = {'abs fold change'};

if isLogTransformed == true
    class1data_untransform = 2.^class1data; 
    class2data_untransform = 2.^class2data; 
    [foldChange, log2FC, foldChangeAbs] = computeFoldChange(class1data_untransform, class2data_untransform, 2);
else
    [foldChange, log2FC, foldChangeAbs] = computeFoldChange(class1data, class2data, 2);
end

ranked_features(2:end, end-2) = num2cell(foldChange);
ranked_features(2:end, end-1) = num2cell(log2FC);
ranked_features(2:end, end) = num2cell(foldChangeAbs);

%compute MannWhitney Utest
ranked_features(1, end+1) = {'MannWhitney Utest'};
ranked_features(1, end+1) = {'Effectsize r'};
n = size(class1data,2) + size(class2data,2);

for i=1:size(class1data,1)
%     ranked_features(i+1, end) = num2cell(kruskalwallis(t(i,:), grp, 'off'));
    [pval,~,stats] = ranksum(class1data(i,:)',class2data(i,:)');
    ranked_features(i+1, end-1) = num2cell(pval);  
    %compute effect size - r = Z/sqrt(n)
    if isfield(stats,'zval')
        ranked_features(i+1, end) = num2cell(stats.zval/sqrt(n));
    else
        ranked_features(i+1, end) = {'NA'};
    end
end



