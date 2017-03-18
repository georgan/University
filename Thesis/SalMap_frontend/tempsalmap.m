function [ featmap ] = tempsalmap( s, varargin )
%EXTRACT1D Computes Temporal Saliency Maps.
%   MAP = EXTRACT1D(S) cumputes the temporal saliency map of the vector S.
%   If S is a matrix, then EXTRACT1D operates along the rows of S. Each row
%   of MAP is the saliency curve of the corresponding row of S.
%   
%   MAP = EXTRACT1D(S, 'Param1',Value1, 'Param2',Value2, ...) allows further
%   control of EXTRACT1D by parameter name/value pairs. Parameters are:
% 
%   'scales' - An integer scalar for the number of scales in multiscale
%               analysis. Default value is min(floor(log2(size(S,2))), 6).
%   
%   'center' - Center scales for scale differences. It must be a vector of
%               integers with maximum value less than the number of scales.
%               Default value is 1:min(N-1,3), where N is the number of
%               scales.
% 
%   'scaledif' - Scale difference between center and surround scales.
%                Default value is [1,2].
% 
%   'method' - Normalization method. Choices are:
%       'dog' - iterative normalization using Difference of Gaussians
%               filter (the default).
%       'none' - no normalization applied.
% 
%   If the normalization method is 'dog', then control of the normalization
%   is possible by the following parameters:
% 
%   'win' - length of the DoG filter (in samples).
%           Default value is min(size(s,2),15).
%   'iter' - an integer for the number of iterations to perform
%            (default 15).
%   'sigmas' - A two elements vector, showing the standard deviations of
%               the Gaussians. The values must be real positives and not
%               equal each other (default [1/5 1/20]).
%               Note: the Gaussians are defined on the [0,1] interval with
%               center at 0.5, so sigmas must be chosen properly.
%   'inhibit' - a real scalar for the inhibition used (default 0).
%
% 
%   Example:
%       [s, fs] = wavread('chirp_modelexample.wav');
%       nrg = stnrg(s,fs);
%       rough = roughness(s,fs);
%       feat = scale([nrg; rough]); % scale to [0,1]
%       
%       curves = extract1D(feat, 'scales', 6, 'center', [2 3 4],...
%       'scaledif', [1 2]);
% 
%       figure;
%       subplot(211), plot(feat');
%       title('Feature Curves');
% 
%       subplot(212), plot(curves');
%       title('Saliency Curves');
% 
%   See also dognorm, centerSurroundDif



if ~isnumeric(s)
    error('s must be a numeric array.');
end

if length(size(s))>2
    error('s must not have more than two dimensions.');
end

if size(s, 2) == 1
    s = s';
    flag = 1;
else
    flag = 0;
end


N = max(min(5, floor(log2(size(s,2)))), 1);
win = min(size(s,2)/2, 15);
scaleDif = [1 2];
prcnt = 0;
Niter = 15;
sigmas = [1/5 1/20];
method = 'dog';


numargin = length(varargin);

if mod(numargin,2)
    error('Property Name-Value input arguments must come in pairs.');
end

for i = 1:2:numargin
    property = varargin{i};
    if ~ischar(property)
        error('Property names must be strings.');
    end
    
    value = varargin{i+1};
    switch property
        case 'scales'
%             varbl = 'N';
            N = value;
        case 'center'
%             varbl = 'center';
            center = value;
        case 'scaledif'
%             varbl = 'scaleDif';
            scaleDif = value;
        case 'win'
%             varbl = 'win';
            win = value;
        case 'iter'
%             varbl = 'Niter';
            Niter = value;
        case 'inhib'
%             varbl = 'prcnt';
            prcnt = value;
        case 'sigmas'
%             varbl = 'sigmas';
            sigmas = value;
        case 'method'
            method = value;
        otherwise
            error(['Invalid Property Name: ''' property '''.']);
    end
%     eval([varbl ' = ' num2str(value)]);
    
end

if ~exist('center','var')
    center = 1:min(N-1,3);
end



%%%%%%% DO THE JOB %%%%%%%%%%%

g = [1 5 10 5 1]; g = g/sum(g(:));
lg = length(g);
feat = cell(N, 1);
featSize = size(s);


feat{1} = s;
for i = 2:N
    feat{i} = cropsig(conv2(1, g, extendsig(feat{i-1},lg), 'same'),lg); % does not work for lg > length(feat{i})
    feat{i} = feat{i}(:,2:2:end);
end


for i = 1:N
    feat{i} = imresize(feat{i}, featSize);
end

pyr = centerSurroundDif(feat, center, scaleDif);


featmap = 0;
if strcmp(method, 'dog')
    expr = 'a = dognorm(pyr{i}, Niter, win, prcnt, sigmas);';
elseif isempty(method) || strcmp(method, '') || strcmp(method, 'none')
    expr = 'a = pyr{i};';
else
    error(['Invalid method' method '.']);
end


for i = 1:length(pyr)
    eval(expr);
    featmap = featmap + a;
end

if flag
    featmap = featmap';
end


end


function sig = extendsig(sig, n)

sig = [sig(:,n:-1:1) sig sig(:,end:-1:end-n+1)];

end

function sig = cropsig(sig, n)

sig = sig(:,n+1:end-n);

end

