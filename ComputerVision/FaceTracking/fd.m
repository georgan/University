function boundingBox = fd( I, mu, cov )
%FD Detects human face in an image.
%   boundingBox = fd(I, mu, cov) detects human face in image I, of mean
%   value mu = [mcb mcr] in YCbCr color space, and covariance cov. cov is a
%   2-by-2 symmetric matrix. The return value of fd is a 1-by-4 matrix
%   [x y width height] where:
%
%               (x, y) are the coordinates of the left upper corner of the
%               box placed at face's position.
%               (width, height) are the width and height of the box,
%               respectively.

ICbCr = double(rgb2ycbcr(I));
Icb = ICbCr(:,:,2);
Icr = ICbCr(:,:,3);

P = mvnpdf([Icb(:) Icr(:)], mu, cov);       %gaussian distribution
P = P/max(P(:));                            %normalization in [0,1]
[m,n] = size(Icb);
P = reshape(P, m, n);                       %returns a m-by-n matrix of the distribution
figure, imshow(P), title('Skin Probability');

thres = .2;
P = (P > thres);
figure, imshow(P), title('Skin Image');

B1 = strel('disk', 2);                      %structing element-used in opening
B2 = strel('disk', 20);                     %structing element-used in closing

P = imopen(P, B1);
P = imclose(P, B2);
figure, imshow(P), title('Skin Image after proccessing');

P = bwlabel(P);                             %labels for the connected objects in P
r = regionprops(P, 'Area');                 %measures the area of each connected object
[MAX, k] = max([r.Area]);                   %returns the connected oblect k, having the largest area MAX
P = (P==k);

b = regionprops(P, 'BoundingBox');          %returns the bounding box of the kth object

figure; imshow(I), title('Frame 1');
hold on;
p1 = rectangle('Position', b.BoundingBox);
set(p1, 'EdgeColor', [1,0,0], 'LineWidth', 2);

x = b.BoundingBox(1);
y = b.BoundingBox(2);
width = b.BoundingBox(3);
height = b.BoundingBox(4);
boundingBox = [x y width height];
end

