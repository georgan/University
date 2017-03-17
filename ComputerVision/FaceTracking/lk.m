function [ d_x, d_y ] = lk( I1, I2, rho, epsilon, d_x0, d_y0 )
%LK Detects motion between two images
%   [d_x, d_y] = lk(I1, I2, rho, epsilon, d_x0, d_y0) applies Lucas-Kanade
%   algorithm for motion detection between same size images I1 and I2. A 
%   Gaussian ofdeviation rho is used as windowed function. epsilon is small
%   constant that improves detection results in smooth regions. dx_0 and
%   dy_0 are the initial displacements estimation, of size equal to
%   image's size, for each pixel in the images.

I1 = im2double(rgb2gray(I1));   %convert images from RGB to Gray
I2 = im2double(rgb2gray(I2));
[r, c] = size(I1);
n=ceil(3*rho)*2+1;                   %gaussian size
G = fspecial('gaussian', n, rho);    %create gaussian
[x_0, y_0] = meshgrid(1:size(I1, 2), 1:size(I1,1)); %grid positions

n = 10;             %number of repetitions
dx_i = d_x0;        %dispacement estimation in i-th repetition
dy_i = d_y0;
for i = 1:n
    I_inter = interp2(I1, x_0+dx_i, y_0+dy_i, 'linear', 0); %calculate image and
    [A1 A2] = gradient(I_inter);    %derivative values in intermediate grid positions
    E = I2 - I_inter;
    
    A = imfilter(A1.^2, G, 'conv', 'same')+epsilon;
    B = imfilter(A1.*A2, G, 'conv', 'same');
    C = imfilter(A2.^2, G, 'conv', 'same')+epsilon;
    D1 = imfilter(A1.*E, G, 'conv', 'same');
    D2 = imfilter(A2.*E, G, 'conv', 'same');
    
    for j = 1:r
        for k = 1:c
            u = inv([A(j,k) B(j,k); B(j,k) C(j,k)])*[D1(j,k); D2(j,k)];
            dx_i(j,k) = dx_i(j,k) + u(1);   %calculate new displacement estimation
            dy_i(j,k) = dy_i(j,k) + u(2);
        end
    end
end


d_x = dx_i;
d_y = dy_i;

end

