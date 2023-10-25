function [CohenD, GlassDelta, HedgesG] = computeEffectSize(data1, data2)
% Description:
%   Purpose: To compute Cohen D effect size
%   INPUT:
%        data1 - a vector of type double for set 1
%        data2 - a vector of type double for set 2
%   OUTPUT:
%       CohenD - Cohen d effect size: (mean(d1) - mean(d2))/ SDpooled 
%       GlassDelta - Glass delta: (mean(d1) - mean(d2))/ SDcontrol (when variances in two sets are not equal) 
%       HedgesG - (mean(d1) - mean(d2))/ SDpooled* (when sample size in two data sets is different) 
%   
%   Author: Kathrin Tyryshkin    

%check input arguments
arguments
    data1 (:,1) {mustBeNumeric}; 
    data2 (:,1) {mustBeNumeric};
end

n_a = length(data1);
n_b = length(data2);
std_a = std(data1);
std_b = std(data2);

%compute Cohen D
sd_pooled = sqrt((std_a^2 + std_b^2)/2);
CohenD = (mean(data1)-mean(data2))/sd_pooled;

%compute Glass Delta
GlassDelta = (mean(data1)-mean(data2))/std_a;

%compute HedgesG
sd_pooled = sqrt((sum(power(data1-mean(data1),2))+sum(power(data2-mean(data2),2)))/(n_a + n_b - 2));
HedgesG = (mean(data1)-mean(data2))/sd_pooled;