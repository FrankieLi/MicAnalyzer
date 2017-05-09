function ShiftingReconstruction(sinogram, suffix)
% ShiftingReconstruction - 
%   
%   USAGE:
%
%   ShiftingReconstruciton(sinogram, suffix)
%
%   INPUT:
%
%   sinogram is N x M,
%       is a standard sinogram of some sample. The dimensions of the
%       sinogram correspond to the number of detectors, N, and the number
%       of angles the sample is rotated through, M.
%   suffix is string,
%       is a string to be attached to the filenames to help with
%       identification
%
%   OUTPUT:
%
%   none
%
%   NOTES:  
%
%   * This program is used in conjunction with reconComparison to determine
%       the best shift vector for reconstructing a Tomography data set.
%   * Possible shifts from -50 to 50 pixels are generated from the given
%       sinogram.
%   * The only output of this program is a large set of sinogram and
%       reconstruction files. If the suffix specified is the string
%       'suffix', the files corresponding to the zero shift are,
%       'shiftedSinogram_0_suffix.bin' and 'shiftedRecon_0_suffix.bin'.
%

    angleList = (-90:.2:90)';
    matlabpool open;
    parfor i=-50:50
        tempSinogram = ShiftSinogram(sinogram, i);
        fileName = ['shiftedSinogram_', num2str(i), '_', suffix, '.bin'];
        SinogramToBinary(tempSinogram, fileName);
        fileName = ['shiftedRecon_', num2str(i), '_', suffix, '.bin'];
        I = iradon(tempSinogram, angleList, 'pchip', 2048);
        clearvars tempSinogram;
        fid = fopen(fileName, 'w');
        numX = size(I, 1);
        numY = size(I, 2);
        fwrite(fid, numX, 'int', 'l');
        fwrite(fid, numY, 'int', 'l');
        fwrite(fid, I, 'float', 'l');
        fclose(fid);
        clearvars I fileName numX numY;
    end
    matlabpool close;
end