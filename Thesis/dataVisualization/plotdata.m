function plotdata( a, b )
%PLOTDATA plots data points on a plane or on 3D space.
% Input:
%   a: data where each column contains an observation, each row a variable.
%   It must have two or three rows for 2D or 3D data respectively.
%   b: a vector with the class of each observation, and only two distinct
%   values (binary classification).


[ndims ntimes] = size(a);

classes = unique(b);
b = classes(1);

if ndims==1
    error('a has only one row.');
elseif ndims==2
%     figure
    plot(a(1,b),a(2,b), 'r.');
    hold on
    plot(a(1,~b),a(2,~b), 'b.');
    hold off
elseif ndims==3
%     figure
    plot3(a(1,b),a(2,b),a(3,b), 'r.');
    hold on
    plot3(a(1,~b),a(2,~b),a(3,~b), 'b.');
    hold off
else
    error('Number of dimensions is too large to plot.');
end

end

