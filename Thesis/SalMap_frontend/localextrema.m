function [Maxima,Minima] = localextrema(in)
%LOCALEXTREMA Finds local maxima and minima
%   [Maxima,Minima] = localextrema(in) find the local maxima and minima of
%   IN. IN can be a vector (for 1D signals) or a matrix (for 2D signals).


const = 0;

if numel(in) ~= length(in)

d1 = diff(in,1,1);
d2 = diff(in,1,2);

% find zeros by detecting zero crossings
dum1 = d1(1:end-1,:);
dum2 = d1(2:end,:);
% downwards
cross11 = (dum1>const).*(dum2<=0);
% upward crossing
cross21 =(dum1<const).*(dum2>=0);
dum1 = d2(:,1:end-1);
dum2 = d2(:,2:end);
% downwards
cross12 =(dum1>const).*(dum2<=0);
% upward crossing
cross22 = (dum1<const).*(dum2>=0);

s = size(in)-2;

cross11 = cross11([1:s(1)],[1:s(2)]);
cross12 = cross12([1:s(1)],[1:s(2)]);
cross21 = cross21([1:s(1)],[1:s(2)]);
cross22 = cross22([1:s(1)],[1:s(2)]);

cross11 = [zeros(s(1),1),cross11];
cross12 = [zeros(s(1),1),cross12];
cross11 = [zeros(1,s(2)+1);cross11];
cross12 = [zeros(1,s(2)+1);cross12];

cross21 = [zeros(s(1),1),cross21];
cross22 = [zeros(s(1),1),cross22];
cross21 = [zeros(1,s(2)+1);cross21];
cross22 = [zeros(1,s(2)+1);cross22];

% a local maximum occurs if both derivatives cross zero downwards
Maxima = cross11.*cross12;
Minima = cross21.*cross22;    

else
        
    if size(in,1) == 1
        flag = 0;
    else
        in = in';
        flag = 1;
    end
    
    d1 = diff(in, 1, 2);
    dum1 = d1(1:end-1);
    dum2 = d1(2:end);
    
    cross1 = (dum1 > const).*(dum2 <= 0);
    cross2 = (dum1 < const).*(dum2 >= 0);
    
    Maxima = [0 cross1 0]; Minima = [0 cross2 0];
    
    if flag
        Maxima = Maxima'; Minima = Minima';
%     else
%         Maxima = [0 cross1]; Minima = [0 cross2];
    end

end
