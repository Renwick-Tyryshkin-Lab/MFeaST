function [d, sd_pooled] = ComputeCohenD(data1, data2)

n_a = length(data1);
n_b = length(data2);
sd_pooled = sqrt((sum(power(data1-mean(data1),2))+sum(power(data2-mean(data2),2)))/(n_a + n_b - 2));

d = (mean(data1)-mean(data2))/sd_pooled;