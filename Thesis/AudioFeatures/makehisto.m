function [ h ] = makehisto( id, centers, dur, olap, norm )
%MAKEHISTO Creates histograms based on the classification of feature
%vectors by the k-Means algorithm (the cluster that each feature vector
%has been assigned to).
% Input:
%   id: a vector of indices what show the cluster to which each feature
%   vector is assigned to.
%   centers: a matrix with the centers as they are returned by kmeans. Each
%   row contains a center.
%   dur: window length in samples, that specifies how many feature vectors
%   will be considered for the creation of each histogram.
%   olap: overlap between successive windows, in samples (optional, default
%   0).
%   norm: normalization of the histograms (optional). Choises are:
%       'sum' - the sum of the heights of the bars equals one (default).
%       'max' - the maximum height of the bars equals one.
%       'none' - no normalization applied.
% 
% Output:
%   h: a matrix where each column contains a histogram. The number of rows
%   of h, equals size(centers,1) (number of centers). The number of columns
%   equals round(length(id)/dur).
% 

if nargin < 4
    olap = 0;
end

if nargin < 5
    norm = 'sum';
end

ncenters = size(centers,1);


id = concvec(id, dur, olap);

h = histc(id, 1:ncenters, 1);

if strcmp(norm,'sum')
    h = h/dur; % sum normalization
elseif strcmp(norm,'max')
    hmax = max(h);
    h = h./(ones(ncenters,1)*hmax);
else
    if ~strcmp(norm, 'none')
        error(['Invalid normalization method: ' norm]);
    end
end


end

