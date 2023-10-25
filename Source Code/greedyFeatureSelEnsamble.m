function S = greedyFeatureSelEnsamble(ranks)
%each column has ranking for each feature (rows) from high to low
%assumes the ranking is standardized between 0 and 1, where 1 indicates
%high rank.

N = size(ranks, 1);
F = 1:1:N; %indices to all set of parameters
S = []; %the selected parameters
alpha = 1; %weight of the class-mi
betta = 0; %weight of feature-mi

if N == 0
    return;
end
%compute first part of the sum:
%firstPart = (alpha.*mi_class);
% firstPart = sum(ranks, 2);
firstPart = nanmean(ranks, 2);

%initialize S - insert the first parameter with maximum mi
%and remove it from F
[~, f] = nanmax(firstPart);
S = [S f(1)];
F(f(1)) = [];
%Greedy 
for i=2:N
   %select mi between variables in S and in F = I(c,f)
   %sum and multiply by betta
   %temp_mi = sum(mi_vars(S,F), 1).* betta;
   %temp_mi = temp_mi'; 
   
   %diff_vector = firstPart(F) - temp_mi;
   diff_vector = firstPart(F);
   
   %select the f with maximum 
   [~, ind1] = nanmax(diff_vector);
   f = F(ind1);
   S = [S f(1)]; %add new feature
   F(F==f(1)) = []; %remove it from F
end