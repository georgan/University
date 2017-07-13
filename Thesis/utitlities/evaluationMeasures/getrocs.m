function [ tpr, fpr ] = getrocs( curve, td, thresh)
%getrocs returns True-Positive-Rate and False-Positive-Rate (tpr,fpr) pairs
%that can be used to create ROC curves.
% Input:
%   curve: the curve to threshold.
%   td: truth data, the same size as curve.
%   thresh: vector of thresholds with N elements to threshold the curve.
% 
% Output:
%   tpr, fpr: Nx1 vectors with true prositive rate and false positive rate,
%   respectively.


n = length(thresh);
fpr = zeros(n,1);
tpr = fpr;


for i = 1:n
    class = curve >= thresh(i);
    fpr(i) = fprate(class,td);
    [~,~,tpr(i)] = eval_apr(class,td);
    
end

end

