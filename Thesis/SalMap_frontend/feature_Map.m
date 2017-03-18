function [featmap] = feature_Map(img, varargin)
%SALIENCYMAP Computes Saliency Map
%   FEATMAP = FEATURE_MAP(IMG) computes saliency map of the two
%   dimensional representation IMG. IMG must be a matrix of type double.
%   FEATMAP is a structure where each field is a matrix of the same size as
%   IMG, and corresponds to a feature map. The field names of FEATMAP are 
%   eo, esi, epi after the three filters used to produce them, which are
%   the following:
%       - EO. excitatory-only filters
%       - ESI. excitatory plus inhibitory side-flanks 
%       - EPI. excitatory plus  post-inhibition
% 
%   FEATMAP = FEATURE_MAP(IMG, 'Param1', Value1, 'Param2', Value2,...) 
%   allows further control of FEATURE_MAP by parameter name/value pairs.
%   Parameters are:
% 
%   'scales' - An integer scalar for the number of scales in multiscale
%               analysis. Default value is min(floor(log2(min(size(IMG))), 6).
%   
%   'center' - Center scales for scale differences. It must be a vector of
%               integers with maximum value less than the number of scales.
%               Default value is 1:min(N-1,3), where N is the number of
%               scales.
% 
%   'scaledif' - Scale difference between center and surround scales.
%                Default value is [1,2].
% 
%   'win' - Window length in samples to perform normalization. Default
%          value is size(IMG,2).
% 
%   'filter' - Allows the user to give as input the filters that will be
%               used to produce the feature maps. It must be a structure,
%               where each field is a matrix. In this case, FEATMAP's field
%               names will be those of the filters. By default it uses eo,
%               esi, epi filters (see above).
% 
% 
%   Example:
%       fs = 16000; % sampling frequency
%       dur = 2;
%       x = zeros(1,dur*fs);
%       s = sin(2*pi*500*(1:fs)/fs); % create a tone
%       x(.5*fs+1:1.5*fs) = s;
%       x = x+rand(1,dur*fs); % add noise
% 
%       spec = spectrogram(x, 320, 240, 512, fs);
%       map = feature_Map(abs(spec), 'scales', 5, 'center', [1 2 3], 'scaledif', [1 2]);
%       salmap = map.eo+map.esi+map.epi;
% 
%       filt.deriv = [1 0 -1];
%       map2 = feature_Map(abs(spec), 'filters', filt);
%       salmap2 = map2.deriv;
% 
%       figure; imagesc([0 2], [0 fs/2], salmap);
%       figure; imagesc([0 2], [0 fs/2], salmap2);
% 
%   See also centerSurroundDif, normlz, auditory_RF.


%   Adapted and Extended from Kayser's code [1].
%   [1] C. Kayser, C. I. Petkov, M. Lippert, and N. K. Logothetis, "Mechanisms for
%       allocating auditory attention: an auditory saliency map," Current Biology, vol. 15,
%       no. 21, pp. 1943–1947, 2005.



N = max(min(5, floor(log2(min(size(img))))), 1);
win = size(img,2);
scalesdif = [1 2];
filtfun = 'auditory_RF';
Filter.eo  = feval(filtfun, 0, 0);
Filter.esi = feval(filtfun, 1, 0);
Filter.epi = feval(filtfun, 0, 1);


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
            N = value;
        case 'center'
            center = value;
        case 'scaledif'
            scalesdif = value;
        case 'win'
            win = value;
        case 'filters'
            
            if ~isstruct(value)
                error('Value must be a structure for "filters" parameter.');
            end
            filternames = fieldnames(value);
            clear('Filter');
            
            for j = 1:length(filternames)
                filtj = value.(filternames{j});
                if ~isnumeric(filtj)
                    error('Filter must be of numeric type.');
                end
                if length(size(filtj)) > 2
                    error('Filters must not have more than two dimensions.');
                end
                Filter.(filternames{j}) = filtj;
            end
            
        otherwise
            error(['Invalid Property Name: ''' property '''.']);
    end
    
end

if ~exist('center','var')
    center = 1:min(N-1,3);
end



% insert an image border to avoid edge artifacts
img2 = replicate_img(img);
% resample spectrogram on different scales
for n=1:N
    IMG{n} = imresize(img2,1/(2^(n-1)),'nearest');
    % IMG{n} = imresize(img2,1/(2^(n-1)));
end
% the size at which the maps are stored
MapSize = size(img);


filt = fieldnames(Filter);


feat = cell(N, 1);


for i = 1:length(filt)
    
    for n=1:N
        feat{n} = abs(conv2(IMG{n},Filter.(filt{i}),'same'));
        feat{n} = imresize(cropimg(feat{n}),MapSize,'nearest');
    end
    
    csfeat = centerSurroundDif(feat, center, scalesdif);
    
    a = zeros(size(csfeat{1}));
    for j = 1:length(csfeat)

        csfeat{j} = normlz(csfeat{j}, win);
        a = a + csfeat{j};
    end
    featmap.(filt{i}) = a;
    
% % %     if nargout == 2
% % %         gist_vector.(filt{i}) = makegrid(csfeat, gridsize(1), gridsize(2), fun);
% % %     end
end



return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Local functions

function out = cropimg(img)
% crop the image border. Undo replicate_img
% the input consists of 0.5,1,0.5 times the real image.
s = ceil(size(img)/4);
out = img(s(1)+1:end-s(1)+1,s(2)+1:end-s(2)+1);
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = replicate_img(img)
% replicate the image to its borders to later avoid
% edge artifacts. This is undone by cropimg
out = zeros(size(img,1)*3,size(img,2)*3,size(img,3));
S = size(img);
if length(S)==2
  S(3) = 1;
end

for s=1:S(3)
  % top
  k=1; out([1:S(1)],[1:S(2)]+(S(2)*(k-1)),s) = fliplr(flipud(img(:,:,s)));
  k=3; out([1:S(1)],[1:S(2)]+(S(2)*(k-1)),s) = fliplr(flipud(img(:,:,s)));
  k=2; out([1:S(1)],[1:S(2)]+(S(2)*(k-1)),s) = (flipud(img(:,:,s)));
  % bottom
  k=2;  out([1:S(1)]+(S(1)*2),[1:S(2)]+(S(2)*(k-1)),s) = flipud(img(:,:,s));
  k=1;  out([1:S(1)]+(S(1)*2),[1:S(2)]+(S(2)*(k-1)),s) = fliplr(flipud(img(:,:,s)));
  k=3;  out([1:S(1)]+(S(1)*2),[1:S(2)]+(S(2)*(k-1)),s) = fliplr(flipud(img(:,:,s)));
  % left right
  k=1;  out([1:S(1)]+(S(1)),[1:S(2)],s) = fliplr(img(:,:,s));
  k=3;  out([1:S(1)]+(S(1)),[1:S(2)]+(S(2)*(k-1)),s) = fliplr(img(:,:,s));
  out([1:S(1)]+S(1),[1:S(2)]+S(2),s) = img(:,:,s);
end
out = out(ceil(S(1)/2):end-ceil(S(1)/2)+1,ceil(S(2)/2):end-ceil(S(2)/2)+1,:);
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
