function [ acc, prec, recl ] = eval_apr( data, truthData )
%EVAL_APR Evaluates accuracy, precision and recall.
%   data: predicted class
%   truthData: ground truth class

if length(data) ~= length(truthData)
    error('Input arguments must have the same length.');
end

data = double(data(:)); truthData = double(truthData(:));

acc = sum(data == truthData)/length(data);
prec = (data'*truthData)/sum(data);
recl = (data'*truthData)/sum(truthData);

if nargout < 2
    acc = [acc prec recl];
end

end

