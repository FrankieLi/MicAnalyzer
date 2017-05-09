function processed = Cu_histogramModification(image)
% Cu_histogramModification - 
%   
%   USAGE:
%
%   [processed] = Cu_histogramModification(image)
%
%   INPUT:
%
%   image is m x n,
%       is the image to be cleaned up by modifying its histogram
%
%   OUTPUT:
%
%   processed is m x n,
%       is the cleaned up image after histogram modification
%
%   NOTES:  
%
%   The original histogram is fit to two gaussian distributions. One of
%   these is noise centered around zero while the other is the signal
%   corresponding to the actual image. The noise gaussian is compressed
%   around zero to make the image sharper and make the noise less
%   noticeable.
%
    [y1, x1] = hist(reshape(image, [], 1), 500);
    options = fitoptions('gauss2');
    options.Lower = [-inf, -10, -inf, -inf, -10, -inf];
    options.Upper = [inf, 10, inf, inf, 10, inf];
    cf = fit(x1', y1', fittype('gauss2'), options);
    coeff = coeffvalues(cf);
    standDev = coeff(6)/sqrt(2);
    mean = coeff(5);
    cutOff = mean + 3*standDev;
    ind = (image <= cutOff);
    image(ind) = 0;
    [y1, x1] = hist(reshape(image(~ind), [], 1), 500);
    options = fitoptions('gauss2');
    options.Lower = [-inf, -10, -inf, -inf, -10, -inf];
    options.Upper = [inf, 10, inf, inf, 10, inf];
    cf = fit(x1', y1', fittype('gauss2'), options);
    coeff = coeffvalues(cf);
    if( coeff(5) >= coeff(2) )
        standDev = coeff(6)/sqrt(2);
        mean = coeff(5);
        cutOff = mean - 4*standDev;
        ind = (image <= cutOff);
        image(ind) = 0;
        processed = image;
    else
        standDev = coeff(3)/sqrt(2);
        mean = coeff(2);
        cutOff = mean - 4*standDev;
        ind = (image <= cutOff);
        image(ind) = 0;
        processed = image;        
    end
end