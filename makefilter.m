function w = makefilter( l, fs, cf, bw, type )
%UNTITLED Summary of this function goes here
%   Returns a column vector of length l.

r = l/fs;
switch type
    
    case 'rect'
        w = ones(l, 1);
        w(floor(cf*r+1):floor((cf+bw)*r)) = 0;
        w(l - (floor(cf*r+1):floor((cf+bw)*r))) = 0;
        
    case 'gauss'
        w = ones(l, 1);
        trans = min(floor(bw*r), 40);
        g = exp(-((1:trans)/trans - .5).^2/(2*(1/7)^2));
        lg = length(g);
        w1 = ones(floor(bw*r), 1);
        w1(1:round(lg/2)) = g(1:round(lg/2));
        w1(end-round(lg/2)+1:end) = g(end-round(lg/2)+1:end);
        w1 = 1-w1;
%         w(floor(cf*r+1):floor((cf+bw)*r)) = w1;
%         w(l - (floor(cf*r+1):floor((cf+bw)*r))) = w1(end:1);
% %         g = exp(-((1:round(bw*r))/round(bw*r) - .5).^2/(2*(1/6)^2))';
        v = round(cf*r+1):round((cf+bw)*r);
        if length(v) > length(w1)
            w1 = [w1; w1(end)];
        elseif length(v) < length(w1)
            w1 = w1(1:end-1);
        end
        
        w(v) = w1;
        w(l - v) = w1;
        
    otherwise
        error('Not valid filter type.');
end

end

