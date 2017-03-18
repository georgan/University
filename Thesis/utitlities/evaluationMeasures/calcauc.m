function [ auc ] = calcauc( tpr, fpr )
%calcauc: calculate area under curve (AUC) in ROC analysis, using
%trapezoidal method.
% 
% Input:
%   tpr: vector of true positive rates.
%   fpr: vector of false positive rates.

[~, ind] = sort(fpr);
auc = trapz(fpr(ind), tpr(ind))-.5;

end

