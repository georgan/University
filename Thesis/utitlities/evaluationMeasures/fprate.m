function [ falsepr ] = fprate( data, truthdata )
%FPRATE Computes False Positive Rate
%   data: the predicted class after classification
%   truthdata: the ground truth class

data = double(data(:)); truthdata = double(truthdata(:));

fp = data'*(1-truthdata); tn = (1-data)'*(1-truthdata);
falsepr = fp/(fp+tn);

end

