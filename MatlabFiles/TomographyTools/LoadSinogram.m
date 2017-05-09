function [sinogram, numX, numY, numTotal] = LoadSinogram(fileName)
% LoadSinogram - 
%   
%   USAGE:
%
%   [sinogram] = LoadSinogram(fileName)
%   [sinogram, numX, numY, numTotal] = LoadSinogram(fileName)
%
%   INPUT:
%
%   fileName is string,
%       is the name of the file where the sinogram to be loaded is being
%       stored.
%
%   OUTPUT:
%   sinogram is N x M,
%       is a standard sinogram of some sample. The dimensions of the
%       sinogram correspond to the number of detectors, N, and the number
%       of angles the sample is rotated through, M.
%   numX is numeric,
%       is the number of detectors, N.
%   numY is numeric,
%       is the number of angles the sample is rotated through, M.
%   numTotal is numeric,
%       is the total number of entries in the sinogram.
%
%   NOTES:  
%
%   * This also produces a graphical representation of the sinogram.
%

    % Open the file
    fid = fopen(fileName, 'r');
    % Read the data from the file
    numX = fread(fid, 1, 'int', 'l');
    numY = fread(fid, 1, 'int', 'l');
    numTotal = fread(fid, 1, 'int', 'l');
    sinogram = fread(fid, [numX, numY], 'ushort', 'l');
    % Close the file
    fclose(fid);
    % Plot the sinogram
    figure;
    imagesc(sinogram);
end