function processed = NiMnGa_histogramModification(image)
% NiMnGa_histogramModification - 
%   
%   USAGE:
%
%   [processed] = NiMnGa_histogramModification(image)
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
%   The original histogram is fit to three gaussian distributions. One of
%   these distributions corresponds to the signal of the true image. By
%   compressing the other gaussians, it is possible to sharpen the image
%   and reduce the noise in the image.
%
    temp = reshape(image, [], 1);
    [y1, x1] = hist(temp, 500);
    cf = fit(x1', y1', fittype('gauss3'));
    coeff = coeffvalues(cf);
    if( (coeff(2) <= coeff(8)) && (coeff(5) <= coeff(8)) )
        % This means the third gaussian is the farthest to the right,
        % making it the signal
        if( coeff(1) <= coeff(4) )
            % This means the second gaussian is the spike due to zeros
            newCf = cfit( fittype('gauss3'), coeff(1)*10, coeff(2), coeff(3)/10, coeff(4), coeff(5), coeff(6), coeff(7), coeff(8), coeff(9));
        else
            % This means the first gaussian is the spike due to zeros
            newCf = cfit( fittype('gauss3'), coeff(1), coeff(2), coeff(3), coeff(4)*10, coeff(5), coeff(6)/10, coeff(7), coeff(8), coeff(9));
        end
    elseif( (coeff(2) <= coeff(5)) && (coeff(8) <= coeff(5)) )
        % This means the second gaussian is the farthest to the right,
        % making it the signal
        if( coeff(1) <= coeff(7) )
            % This means the third gaussian is the spike due to zeros
            newCf = cfit( fittype('gauss3'), coeff(1)*10, coeff(2), coeff(3)/10, coeff(4), coeff(5), coeff(6), coeff(7), coeff(8), coeff(9));
        else
            % This means the first gaussian is the spike due to zeros
            newCf = cfit( fittype('gauss3'), coeff(1), coeff(2), coeff(3), coeff(4), coeff(5), coeff(6), coeff(7)*10, coeff(8), coeff(9)/10);
        end
    elseif( (coeff(5) <= coeff(2)) && (coeff(8) <= coeff(2)) )
         % This means the first gaussian is the farthest to the right,
         % making it the signal
         if( coeff(4) <= coeff(7) )
             % This means the third gaussian is the spike due to zeros
             newCf = cfit( fittype('gauss3'), coeff(1), coeff(2), coeff(3), coeff(4)*10, coeff(5), coeff(6)/10, coeff(7), coeff(8), coeff(9));
         else
             % This means the second gaussian is the spike due to zeros
             newCf = cfit( fittype('gauss3'), coeff(1), coeff(2), coeff(3), coeff(4), coeff(5), coeff(6), coeff(7)*10, coeff(8), coeff(9)/10);
         end
    end
    %cf = fit(x1', y1', fittype('gauss2'));
    %coeff = coeffvalues(cf);
    %newCf = cfit( fittype('gauss2'), coeff(1)*10, coeff(2), coeff(3)/10, coeff(4), coeff(5), coeff(6));
    n = newCf(x1);
    processed = histeq(image, n);
end