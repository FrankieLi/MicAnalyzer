function SinogramToBinary(sinogram, fileName)
% SinogramToBinary - 
%   
%   USAGE:
%
%   SinogramToBinary(sinogram, fileName)
%
%   INPUT:
%
%   sinogram is n x m,
%       is a standard sinogram of some sample. The dimensions of the
%       sinogram correspond to the number of detectors, n, and the number
%       of angles the sample is rotated through, m.
%   fileName is string,
%       is the name of the file which the sinogram is to be written to.
%
%   OUTPUT:
%
%   none
%
%   NOTES:  
%
%   * When writing the sinogram, all previous contents of the file will
%       be deleted.
%   * If a reconstruction is to be performed, ensure that for the sinogram,
%       m is equal to the number of angles stored in the angle file.
%

    % Determine the X-dimension of the sinogram, the number of detectors
    numX = size(sinogram, 1);
    % Determine the Y-dimension of the sinogram, the number of angles.
    numY = size(sinogram, 2);
    % Determine the total number of entries in the sinogram.
    numTotal = numX * numY;
    % Open file
    fid = fopen(fileName, 'w');
    % Write necessary data to file in the proper format
    fwrite(fid, numX, 'int', 'l');
    fwrite(fid, numY, 'int', 'l');
    fwrite(fid, numTotal, 'int', 'l');
    fwrite(fid, round(sinogram), 'ushort', 'l');
    % Close file
    fclose(fid);
end