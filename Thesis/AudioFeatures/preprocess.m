function [ si ] = preprocess( x, N, Nolap, wname )
%PREPROCESS Preprocess signal
%     x: sound signal
%   N: length of frame, in samples)
%   Nolap: overlap between frames (in samples)
%   wname: the name of a filter that will be used to weight each frame. It
%   must be a string or a function handle.

x = x - mean(x);

x = x(:)';

x = [x x(end:-1:end-Nolap+1)];

si = buffer(x, N, Nolap, 'nodelay');

if ~strcmp(wname,'none')
    win = window(wname, N);
    % win = win/(sum(win));
    win = diag(win);
    si = win*si;
end


end

