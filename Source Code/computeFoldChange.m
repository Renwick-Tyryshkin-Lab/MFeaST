function [foldChange, log2FC, foldChangeAbs] = computeFoldChange(data1, data2, dim)
%computes fold change between two datasets
%
% Description:
%   Purpose: computes median fold change between two groups. First it
%   computes median expression for each feature, then computes the fold
%   change, the log fold change and absolute fold change. The data must be
%   normalized and NOT log transformed
%   INPUT:
%       data1 - a 2D martix of type double  where each column is a sample and each row is a feature
%       data2 - a 2D martix of type double  where each column is a sample and each row is a feature
%       dim - dimention along which to compute the fold change, across
%       columns dim =1, across rows dim = 2       
%   OUTPUT:
%       foldChange = median_data1 / median_data2;
%       log2FC = log2(foldChange);
%       foldChangeAbs = median_data1 / median_data2 if median_data1 >
%       median_data2, median_data2 / median_data1 otherwise
%   
%   Author: Kathrin Tyryshkin    

%check input arguments
arguments
    data1 (:,:) {mustBeNumeric}; 
    data2 (:,:) {mustBeNumeric};    
    dim {mustBeInteger, mustBeGreaterThanOrEqual(dim,1), mustBeLessThanOrEqual(dim,2), mustBeEqualLength(data1, data2, dim)}
end

if any(data1<0) 
    data1 = data1 - min(min(data1));
end
if any(data2<0)
    data2 = data2 - min(min(data2));
end

%replace zeros with low number
infLow = 0.00000000001;
data1(data1==0) = infLow;
data2(data2==0) = infLow;

%compute median of the data
median_data1 = median(data1, dim);
median_data2 = median(data2, dim);

%compute fold change
foldChange = median_data1 ./ median_data2;
log2FC = log2(foldChange);
foldChangeAbs = foldChange;
flag = foldChangeAbs<1;
foldChangeAbs(flag) = 1./foldChangeAbs(flag);

%make sure the output is a vertical vector
if ~iscolumn(foldChange)
    foldChange = foldChange';
    log2FC = log2FC';
    foldChangeAbs = foldChangeAbs';
end

end

% Custom validation function
function mustBeEqualLength(a,b, dim)
    % Test if a and b have equal number of columns 
    if size(a, 3-dim)~=size(b, 3-dim)
        error(['data1 and data2 should be of the same length across dimension ' num2str(dim)]);
    end
end