function filtLayer2 = medianFilter3d(layer1, layer2, layer3)
% medianFilter3d - 
%   
%   USAGE:
%
%   [filtLayer2] = medianFilter3d(layer1, layer2, layer3)
%
%   INPUT:
%
%   layer1 is m X n,
%       is a layer of a sequence of closely related images to be filtered.
%   layer2 is m X n,
%       is a layer of a sequence of closely related images to be filtered.
%   layer3 is m X n,
%       is a layer of a sequence of closely related images to be filtered.
%
%   OUTPUT:
%   
%   filtLayer2 is m X n,
%       is the result of applying a 3d median filter to the three image
%       layers provided.
%
%   NOTES:  
%
%   * For each pixel in the second layer, the median filter acts upon every
%   pixel that it shares a vertex with, 27 pixels in total. The median of
%   this set of pixels is then used for the value of the pixel in the
%   filtered image.
%
    xDim = size(layer2, 1);
    yDim = size(layer2, 2);
    % Pad edges with zeros
    stack = zeros(xDim+2, yDim+2, 3);
    stack(2:(end-1), 2:(end-1), 1) = layer1;
    stack(2:(end-1), 2:(end-1), 2) = layer2;
    stack(2:(end-1), 2:(end-1), 3) = layer3;
    data = zeros(xDim, yDim, 27);
    %Center
    data(:,:,1:3) = stack(2:(end-1), 2:(end-1), :);
    %Top
    data(:,:,4:6) = stack(2:(end-1), 3:(end), :);
    %Top Right
    data(:,:,7:9) = stack(3:(end), 3:(end), :);
    %Right
    data(:,:,10:12) = stack(3:(end), 2:(end-1), :);
    %Bottom Right
    data(:,:,13:15) = stack(3:(end), 1:(end-2), :);
    %Bottom
    data(:,:,16:18) = stack(2:(end-1), 1:(end-2), :);
    %Bottom Left
    data(:,:,19:21) = stack(1:(end-2), 1:(end-2), :);
    %Left
    data(:,:,22:24) = stack(1:(end-2), 2:(end-1), :);
    %Top Left
    data(:,:,25:27) = stack(1:(end-2), 3:(end), :);
    % Take median
    filtLayer2 = median(data, 3);
end