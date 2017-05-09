function [im3HistMedian] = Cu_ReconAlgorithm(im_layer_1, im_layer_2, im_layer_3, im_layer_4, im_layer_5)
% Cu_ReconAlgorithm - 
%   
%   USAGE:
%
%   [im3HistMedian] = Cu_ReconAlgorithm(im_layer_1, im_layer_2, im_layer_3,
%                                                   im_layer_4, im_layer_5)
%
%   INPUT:
%
%   im_layer_1 is m x n,
%       is a layer of the set of closely related images to be cleaned up.
%   im_layer_2 is m x n,
%       is a layer of the set of closely related images to be cleaned up.
%   im_layer_3 is m x n,
%       is a layer of the set of closely related images to be cleaned up.
%   im_layer_4 is m x n,
%       is a layer of the set of closely related images to be cleaned up.
%   im_layer_5 is m x n,
%       is a layer of the set of closely related images to be cleaned up.
%
%   OUTPUT:
%
%   im3HistMedian is m x n,
%       is the cleaned up image corresponding to im_layer_3.
%
%   NOTES:  
%
%   none
%
    % Use 3d median filter on layers 2, 3, 4
    im2Median = medianFilter3d(im_layer_1, im_layer_2, im_layer_3);
    im3Median = medianFilter3d(im_layer_2, im_layer_3, im_layer_4);
    im4Median = medianFilter3d(im_layer_3, im_layer_4, im_layer_5);
    clearvars im_layer_1 im_layer_2 im_layer_3 im_layer_4 im_layer_5;
    % Apply histogram modification to layers 2, 3, 4
    im2Hist = Cu_histogramModification(im2Median);
    im3Hist = Cu_histogramModification(im3Median);
    im4Hist = Cu_histogramModification(im4Median);
    clearvars im2Median im3Median im4Median;
    % Use 3d median filter on the new 3 layer
    im3HistMedian = medianFilter3d(im2Hist, im3Hist, im4Hist);
    clearvars im2Hist im3hist im4Hist;
end