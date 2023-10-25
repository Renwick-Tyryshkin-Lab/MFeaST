function [mi, mi_corr] = computeMI_hist(series1, series2)
%computeMI_hist computes Mutual Information (MI) between series1 and
%series2 using the histogram method
% inputs:
%     series1
%     series2
% output:
%   mi: mutual information
%   mi_corr: normalized mutual information

    %check input
        arguments
            series1 (:,:) {mustBeNumeric}
            series2 (:,:) {mustBeNumeric}
        end

    %initialize
    [~,m1] = size(series1);
    [~,m2] = size(series2);
    mi = zeros(m1, m2);
    mi_corr = zeros(m1, m2);
    k=1;
    for i=1:m1
    %     disp(['curr level: ' num2str(i)]);
        for j=k:m2
            curr_series1 = series1(:, i);
            curr_series2 = series2(:, j);
            %compute mi
            [mi(i, j), ~, ~, ~, mi_corr(i, j)] = mutualInfo(curr_series1, curr_series2);
        end
        %compute for diagonal only - to save time
        if m2 > 1
            k=k+1;
        end
    end
    % %copy the  upper triangular matrix to lower triangular part of matrix
    % mi = mi + triu(mi,1).';
    % mi_corr = mi_corr + triu(mi_corr,1).';
end