function AnglesToBinary(angles, fileName)
% AnglesToBinary - 
%   
%   USAGE:
%
%   AnglesToBinary(angles, fileName)
%
%   INPUT:
%
%   angles is n x 1,
%       is a column list of the angles the sample was rotated through.
%   fileName is string,
%       is the name of the file which the angles are to be written to.
%
%   OUTPUT:
%
%   none
%
%   NOTES:  
%
%   * When writing the angles, all previous contents of the file will be 
%       deleted.
%   * If a reconstruction is to be performed, ensure that for the sinogram,
%       m is equal to the number of angles stored in the angle file.
%

    % Determine number of angles to be stored
    numAngles = size(angles, 1);
    % Open file
    fid = fopen(fileName, 'w');
    % Write data to file
    fwrite(fid, numAngles, 'int', 'l');
    fwrite(fid, angles, 'float', 'l');
    % Close file
    fclose(fid);
end