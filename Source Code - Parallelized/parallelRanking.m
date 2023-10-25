function [result,ranked_features] = parallelRanking(c,data,classes,selectedAlgs,ranks,ranked_features)

    result = [];


for i=1:c.NumTestSets
    trainingset = training(c,i);
    currdata = data(:,trainingset);
    currclasses = classes(trainingset);
    [r_res, alg_names] = FeatureRankEnsemble_v3(currdata, currclasses, selectedAlgs);
    ranks = [ranks r_res];
end    

    totalNumRankAlg = length(alg_names);

    if totalNumRankAlg ~= 0 
        ranked_features = zeros(length(ranks(:, 1)), totalNumRankAlg);
        for i=1:totalNumRankAlg
            t = ranks(:, i:totalNumRankAlg:end);
            ranked_features(:, i) = mean(t,2);
        end
    else
        ranked_features = [];
    end
end