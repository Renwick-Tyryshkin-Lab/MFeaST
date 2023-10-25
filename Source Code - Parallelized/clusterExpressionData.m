function c = clusterExpressionData(datain, prcnt, options)
% CLUSTERCELLDATA(data) generates a clustergram from the expression data 
% with the specified options
%
% Inputs:
%   datain: MxN data matrix, numeric, NOT log transformed
%   prcnt: integer, % of top features to use in the clustergram
% Options
%   RowLabels: string array, row labels of the clustergam
%   ColumnLabels: string array, columns labels of the clustergam
%   RowPDist: string, similarity distance for the rows
%   ColumnPDist: string, similarity distance for the columns
%   Colormap: string, colormap function     
%   Linkage: string, hierarchical clustering linkage
%   DisplayRange: integer, color limit level
%   
% output:
%   c: clustergram object
%
% usage:
% rowDist, colDist, colorMap, linkage, displayRange, resultsPercent)
%     data = [1 2 3 4 5 -20 20];
%     alpha = 2.0;
%     samples = {'sample1' 'sample2' 'sample3' 'sample4' 'sample5' 'sample6' 'sample7'};
%     [outliers, high_outliers, low_outliers] = scatterplot_mark_outliers(data, ...
%         'Alpha', alpha, ...
%         'RowPDist', colDist, ...
%         'PlotTitle', 'Test plot', ...
%         'ylabel', 'placeholder y label'); 

% Author: Kathrin Tyryshkin

    %check input
    arguments
        datain (:,:) {mustBeNumeric}
        prcnt {mustBeInteger(prcnt), mustBeGreaterThan(prcnt,0), mustBeLessThan(prcnt,101)} = 100
        options.RowLabels (:,1) = {}
        options.ColumnLabels (:,1) = {}
        options.RowPDist string = 'Euclidean'
        options.ColumnPDist string = 'Spearman'
        options.Colormap string = 'jet'
        options.Linkage string = 'Average'
        options.DisplayRange {mustBeInteger(options.DisplayRange), mustBePositive(options.DisplayRange)} = 3
        options.Symmetric logical = false; 
    end
    
    [rows, ~] = size(datain);
    numRows = round(rows * (prcnt/100));
    t = datain(1:numRows, :);
    %check if there are negative values - the data might be log transformed
    %already
    
    t = log2(replaceZeros(t, 'lowval')); %log transform 
    t = t-median(median(t));%median center the data
    rowLabels = options.RowLabels(1:numRows);
  
    %create colours to display on the heatmap instead of labels
    labels = unique(options.ColumnLabels);
    clusterIDs = string(options.ColumnLabels);
    s = struct;
    lbl = cell(length(clusterIDs), 1);
    lbl(clusterIDs==labels{1}) = labels(1);
    lbl(clusterIDs==labels{2}) = labels(2);
    s.Labels = lbl;
    colorvec = cell(length(clusterIDs), 1);
    colorvec(clusterIDs==labels{2}) = {[1 0 0.5]};%red
    colorvec(clusterIDs==labels{1}) = {[0.43 0.71 1]}; %blue
    s.Colors = (colorvec);

%     clustering
    warning('off', 'bioinfo:HeatMap:set:ColumnLabelsColorDeprecation')
    c = clustergram(t, ...
        'ColumnLabels', options.ColumnLabels, 'RowLabels', rowLabels,...
        'RowPDist', options.RowPDist, 'ColumnPDist', options.ColumnPDist,...
        'Colormap', options.Colormap, 'DisplayRange', options.DisplayRange, ...
        'Linkage', options.Linkage, 'LabelsWithMarkers', true,'Symmetric',options.Symmetric);
    set(c, 'ColumnLabelsColor', s);
end