function [sinogram, angleList] = GenerateSinogram(sample, startAngle, finalAngle, interval, sinogramFile, angleFile)
% GenerateSinogram - 
%   
%   USAGE:
%
%   [sinogram] = GenerateSinogram(sample, startAngle, finalAngle, interval, sinogramFile, angleFile)
%   [sinogram, angleList] = GenerateSinogram(sample, startAngle, finalAngle, interval, sinogramFile, angleFile)
%
%   INPUT:
%
%   sample is n1 x m1,
%       is the sample which will be used to generate a sinogram. Each entry
%       in the sample is has a value which corresponds to its absorption 
%       of the beam
%   startAngle is numeric,
%       is the angle in degrees at which the sample will initially be 
%       positioned when the sinogram is being generated.
%   finalAngle is numeric,
%       is the last angle in degrees which the sample will be rotated into
%       when the sinogram is being generated.
%   interval is numeric,
%       is the step size in degrees for the rotation of the sample when the
%       sinogram is being generated.
%   sinogramFile is string,
%       is the name of the file which the sinogram is to be written to.
%   angleFile is string,
%       is the name of the file which the angles are to be written to.
%
%   OUTPUT:
%
%   sinogram is n2 x m2,
%       is a standard sinogram of the sample. The dimensions of the
%       sinogram correspond to the number of detectors, n2, and the number
%       of angles the sample is rotated through, m2.
%   angleList is m2 x 1,
%       is a column list of the angles the sample is rotated through.
%
%   NOTES:  
%
%   * When writing the sinogram, all previous contents of the file will
%       be deleted.
%   * When writing the angles, all previous contents of the file will be
%       deleted.
%   * This also produces a graphical representation of the sinogram.
%

    % Create list of angles
    angleList = (startAngle:interval:finalAngle)';
    % Create sinogram using Radon Transform
    sinogram = radon(sample, angleList);
    % Create image of sinogram
    figure;
    imagesc(sinogram);
    
    % Attempt to prevent crashes during reconstruction
    sinogram = sinogram + 1;
    factor = 2000/max(max(sinogram));
    sinogram = sinogram * factor;
    % May delete at future date
    
    % Write sinogram to the specified file
    SinogramToBinary(sinogram, sinogramFile);
    % Write the angles to the specified file
    AnglesToBinary(angleList, angleFile);
end