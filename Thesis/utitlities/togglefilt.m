function [ outimg ] = togglefilt( img, SE )
%TOGGLEFILT Toggle filtering
%   OUTIMG = TOGGLEFILT(IMG,SE) applies toggle filtering to image IMG using
%   structuring element SE, and returns the result on OUTIMG.

imgdil = imdilate(img, SE);
imgero = imerode(img, SE);

dilpoints = ((img - imgero) > (imgdil - img));

outimg = dilpoints.*imgdil + (1-dilpoints).*imgero;

end

