function reconstruction = LoadReconstruction(fileName)
% LoadReconstruction - 
%   
%   USAGE:
%
%   [reconstruction] = LoadReconstruction(fileName)
%
%   INPUT:
%
%   fileName is string,
%       is the name of the file where the reconstructed sample to be 
%       loaded is being stored.
%
%   OUTPUT:
%
%   reconstruction is n x m,
%       is a reconstruction of some sample. This reconstruction was created
%       by analyzing the sinogram produced by the sample. Each entry in the
%       reconstruction has a value that corresponds to its absorption of
%       the beam.
%
%   NOTES:  
%
%   * This also produces a graphical representation of the reconstruction.
%

    % Open file
    fid = fopen(fileName, 'r');
    % Read data
    numX = fread(fid, 1, 'int', 'l');
    numY = fread(fid, 1, 'int', 'l');
    reconstruction = fread(fid, [numX, numY], 'float', 'l');
    % Close file
    fclose(fid);
    % Display reconstruction
    figure;
    imagesc(-reconstruction);
end