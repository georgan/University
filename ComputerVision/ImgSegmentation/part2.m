close all;
clear all;
g = imread('prostate.png');
figure, imshow(g), title('Input Image');

%-------------Smooth image-----------------------
n = 5;                                      %smoothing scale
im = g;
for r = 1:n
    B = strel('disk', r);
    im = imreconstruct(imerode(im, B), im); %apply reconstruction opening
    im = rec_clo(imdilate(im, B), im);      %apply reconstruction closing
end

f = im;                                     %smoothed image
figure, imshow(f), title('Smoothed Image');

%--------Inside Markers of Smoothed Image--------
B = strel('disk', 4); B1 = strel('disk', 2);%structuring elements
h = 50;
RegMin = rec_clo(f+h, f) - f;               %calculate domes of f
M_in = (RegMin >= h/2);                     %apply thresholding
M_in = imerode(imdilate(M_in, B1), B);      %erosion of dilation
figure, imshow(M_in), title('M_i_n');

%-------Outside Markers of Smoothed Image--------
m = imimposemin(f, M_in);       %impose min at position of M_in
M_out = watershed(m)==0;        %outside markers: watershed transform
figure, imshow(M_out), title('M_o_u_t');
markers = M_in | M_out;         %union of inside and outside markers
figure, imshow(markers), title('Set of Markers(white)');

%--------------Segmantation of Image-------------
B = strel('diamond', 1);                    %structuring element
magnitude = imdilate(f, B) - imerode(f, B); %gradient magnitude of f
figure, imshow(magnitude), title('Gradient Magnitude');
hom = imimposemin(magnitude, markers);  %impose min at position of markers
final = watershed(hom);                 %apply watershed trasnform
s = find(final == 0);                   %points where final equals to zero
segm = g;
segm(s) = 255;                          %add segmentation result to the image
figure, imshow(segm), title('Segmented Image');