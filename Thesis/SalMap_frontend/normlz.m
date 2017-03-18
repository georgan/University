function [ out ] = normlz( feat, win )
%NORMLZ Normalize feature
%   OUT = NORMLZ(FEAT) Multiplies FEAT by the square of the difference
%   between the global max of FEAT, and the mean value of local max of FEAT.
%   FEAT can be a numeric vector or a matrix.
% 
%   OUT = NORMLZ(FEAT,WIN) applies the normalization locally on windows of
%   WIN samples (default is size(feat,2) for matrices, and length(feat) for
%   vectors).

%   Adapted from Kayser.

% TODO: A smoothing of the input may be good...

feat = feat - min(feat(:));

if size(feat, 2) == 1
    feat = feat';
    flg = 1;
else
    flg = 0;
    if numel(feat) ~= length(feat)
        scale = 2;
        h = hanning(2*scale); h = h(:);
        mask = ones(size(feat));
        mask(1:scale,:) = h(1:scale)*mask(1,:); mask(end-scale+1:end,:) = h(scale+1:end)*mask(1,:);
        mask(:,1:scale) = mask(:,1)*h(1:scale)'; mask(:,end-scale+1:end) = mask(:,1)*h(scale+1:end)';
        feat = feat.*mask;
    end
end


if nargin < 2
    win = size(feat,2);
end


winNum = ceil(size(feat, 2)/win);
points = win*(0:winNum); points(end) = size(feat, 2);

allpoints = win*(-1/2:1/2:winNum); % win/2 overlap with the previous window
allpoints = round(allpoints);
allpoints(1) = 0; allpoints(allpoints > size(feat, 2)-1) = size(feat, 2)-1; %allpoints(end-1) = size(feat, 2)-1;


out = zeros(size(feat));
[localM, ~] = localextrema(feat); % it's not the same dimensions as feat


for i = 1:winNum
    i_win = (points(i)+1):points(i+1);
    i_all = (allpoints(2*i-1)+1):allpoints(2*i+2); %2*i+3: +win/2
    
    data = feat(:,i_all); % error occurs for some values of win(e.g. win=30, 100 points map)
    max_data = max(data(:));
    max_data = max_data > 0;
    data = data/max_data;
    
    localMax = localM(:,i_all);
    localMax = data(localMax > 0);
%     localMax = localMax(localMax ~= 1);
    localMax = localMax(localMax ~= max(data(:)));
    
    if isempty(localMax)
        display('No local maxima...');
        
        if max_data > 0
            out(:,i_win) = feat(:,i_win)/max_data;
        else
            out(:,i_win) = feat(:,i_win);
        end
        
    else
        out(:,i_win) = feat(:,i_win)/max_data;
%         out(:,i_win) = out(:,i_win)*(1-mean(localMax))^2;
        out(:,i_win) = out(:,i_win)*(max(data(:))-mean(localMax))^2;
    end
end


if flg
    out = out';
end

end

