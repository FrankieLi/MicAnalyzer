function [angles, numAngles] = LoadAngles(fileName)
% LoadAngles - 
%   
%   USAGE:
%
%   [angles] = LoadAngles(fileName)
%   [angles, numAngles] = LoadAngles(fileName)
%
%   INPUT:
%
%   fileName is string,
%       is the name of the file where the angles to be loaded are being
%       stored.
%
%   OUTPUT:
%   angles is n x 1,
%       is a column list of the angles the sample is rotated through.
%   numAngles is numeric,
%       is the number of angles the sample is rotated through, n.
%
%   NOTES:  
%
%

    % Open file
    fid = fopen(fileName, 'r');
    % Read data
    numAngles = fread(fid, 1, 'int', 'l');
    angles = fread(fid, numAngles, 'float', 'l');
    % Close file
    fclose(fid);
end