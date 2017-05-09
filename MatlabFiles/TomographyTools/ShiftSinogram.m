function shiftedSinogram = ShiftSinogram(sinogram, shiftIndex)
% ShiftSinogram - 
%   
%   USAGE:
%
%   [shiftedSinogram] = ShiftSinogram(sinogram, shiftIndex)
%
%   INPUT:
%
%   sinogram is N x M,
%       is a standard sinogram of some sample. The dimensions of the
%       sinogram correspond to the number of detectors, N, and the number
%       of angles the sample is rotated through, M.
%   shiftIndex is numeric,
%       is an integer corresponding to how many pixels the sinogram is to
%       be shifted. This may be positive, negative, or zero. 
%
%   OUTPUT:
%
%   shiftedSinogram is N x M,
%       is the result of shifting the input sinogram by the specified
%       number of pixels. The dimensions of the shiftedSinogram are the 
%       same as the input sinogram's.
%
%   NOTES:  
%
%   * When shifting the sinogram, each pixel of the new rows has a
%       value equal to the minimum value of the entire sinogram.
%   * Some data is lost when the sinogram is shifted. This is done so that
%       the dimensions of the sinogram may remain constant.
%   * If the shiftIndex has value 5, this will result in the data in row 1
%       being moved to row 6 and the data in row 2 being moved to row 7 
%       and so on.
%
    
    m = min( min(sinogram) );
    if shiftIndex==0 
        shiftedSinogram = sinogram;
    elseif (shiftIndex >0)
        numTheta = size(sinogram, 2);
        data = sinogram(1:(end-shiftIndex), :);
        extra = zeros(shiftIndex, numTheta);
        extra(:,:) = m;
        shiftedSinogram = [extra; data];
    else
        numTheta = size(sinogram, 2);
        shiftIndex = -shiftIndex;
        data = sinogram((1+shiftIndex):end, :);
        extra = zeros(shiftIndex, numTheta);
        extra(:,:) = m;
        shiftedSinogram = [data; extra];
    end
end