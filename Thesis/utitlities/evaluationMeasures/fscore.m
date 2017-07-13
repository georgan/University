function [ score ] = fscore( prec, rec, beta )
%FSCORE computes f-score
%   SCORE = FSCORE(PREC,REC) computes the f-score SCORE of a classification
%   with precision PREC and recall REC. PREC and REC are arrays of the same
%   dimensions. SCORE is an array of the same dimension as PREC and REC
%   where each element is computed from the elements at the corresponding
%   positions in PREC and REC.
% 
%   SCORE = FSCORE(PREC,REC,BETA) computes f_beta score where scalar BETA
%   controls the weighting of precision and recall. Larger values of BETA
%   give larger weight to precision (default 1).

if nargin < 3
    beta = 1;
end

if any(size(prec)~=size(rec))
    error('prec and rec are arrays of the same dimension.');
end

beta = beta^2;
score = (1+beta)*prec.*rec./(beta*prec+rec);

end

