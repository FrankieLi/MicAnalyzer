function TomographyReconstruction()
% TomographyReconstruction - 
%   
%   USAGE:
%
%   TomographyReconstruction()
%
%   INPUT:
%
%   none
%
%   OUTPUT:
%
%   none
%
%   NOTES:  
%
%   * Automated program used to reconstruct all layers of the NiMnGa
%       sample. Will automatically write both the sinograms and
%       reconstructions to file under the specified folders on bloch.
%       Similar programs were used to reconstruct the various Copper
%       Samples.
%


    % Load all direct beam measurements
    bkg1 = imread('/raid/Data/18-Mar10/NiMnGa_samp1_Tomography/NiMnGa_DirectBeamBkg1_00000.tiff');
    bkg2 = imread('/raid/Data/18-Mar10/NiMnGa_samp1_Tomography/NiMnGa_DirectBeamBkg1_00001.tiff');
    bkg3 = imread('/raid/Data/18-Mar10/NiMnGa_samp1_Tomography/NiMnGa_DirectBeamBkg1_00002.tiff');
    bkg4 = imread('/raid/Data/18-Mar10/NiMnGa_samp1_Tomography/NiMnGa_DirectBeamBkg1_00003.tiff');
    bkg5 = imread('/raid/Data/18-Mar10/NiMnGa_samp1_Tomography/NiMnGa_DirectBeamBkg1_00004.tiff');
    bkg6 = imread('/raid/Data/18-Mar10/NiMnGa_samp1_Tomography/NiMnGa_DirectBeamBkg1_00005.tiff');
    bkg7 = imread('/raid/Data/18-Mar10/NiMnGa_samp1_Tomography/NiMnGa_DirectBeamBkg1_00006.tiff');
    bkg8 = imread('/raid/Data/18-Mar10/NiMnGa_samp1_Tomography/NiMnGa_DirectBeamBkg1_00007.tiff');
    bkg9 = imread('/raid/Data/18-Mar10/NiMnGa_samp1_Tomography/NiMnGa_DirectBeamBkg1_00008.tiff');
    bkg10 = imread('/raid/Data/18-Mar10/NiMnGa_samp1_Tomography/NiMnGa_DirectBeamBkg1_00009.tiff');
    % Average direct beams to create a net background image
    netBKG = (bkg1 + bkg2 + bkg3 + bkg4 + bkg5 + bkg6 + bkg7 + bkg8 + bkg9 + bkg10)/10;
    % Clear the original direct beam files from the workspace
    clearvars bkg1 bkg2 bkg3 bkg4 bkg5 bkg6 bkg7 bkg8 bkg9 bkg10;
    % Begin parallel processing
    matlabpool open;
    
    % The sinograms for each layer must be created. However, due to memory
    % limitations, it is necessary to only put together a small number of
    % sinograms at a time and write these to disk. Repeating this process, 
    % all of the sinograms can be written to disk and the memory 
    % limitations can be avoided.
    % As each image file is approximately 8 megabytes and and each sinogram
    % borrows one line of data from each image, the maximum amount of
    % memory used must be less than 8 megabytes multiplied by the number of
    % sinograms being reconstructed. Thus, to keep memory usage below
    % 1 gigabyte, only 100 sinograms will be created at a time, using a 
    % maximum of 800 megabytes.
    
    % Creating and writing layers 530 to 600
    createAndWriteSinogram(530, 600, netBKG);
    % Creating and writing layers 601 to 700
    createAndWriteSinogram(601, 700, netBKG);
    % Creating and writing layers 701 to 800
    createAndWriteSinogram(701, 800, netBKG);
    % Creating and writing layers 801 to 900
    createAndWriteSinogram(801, 900, netBKG);
    % Creating and writing layers 901 to 1000
    createAndWriteSinogram(901, 1000, netBKG);
    % Creating and writing layers 1001 to 1100
    createAndWriteSinogram(1001, 1100, netBKG);
    % Creating and writing layers 1101 to 1200
    createAndWriteSinogram(1101, 1200, netBKG);
    % Creating and writing layers 1201 to 1300
    createAndWriteSinogram(1201, 1300, netBKG);
    % Creating and writing layers 1301 to 1400
    createAndWriteSinogram(1301, 1400, netBKG);
    % Creating and writing layers 1401 to 1500
    createAndWriteSinogram(1401, 1500, netBKG);
    % Creating and writing layers 1501 to 1600
    createAndWriteSinogram(1501, 1600, netBKG);
    % Creating and writing layers 1601 to 1700
    createAndWriteSinogram(1601, 1700, netBKG);
    % Creating and writing layers 1701 to 1800
    createAndWriteSinogram(1701, 1800, netBKG);
    % Creating and writing layers 1801 to 1900
    createAndWriteSinogram(1801, 1900, netBKG);
    
    % Clear all variables from the workspace to free up memory
    clear;
    % Prepare for reconstruction of each layer
    angleList = (-90:.2:90)';
    shiftIndex = 13;
    
    % Creating and writing layers 530 to 600
    createAndWriteReconstruction(530, 600, shiftIndex, angleList);
    % Creating and writing layers 601 to 700
    createAndWriteReconstruction(601, 700, shiftIndex, angleList);
    % Creating and writing layers 701 to 800
    createAndWriteReconstruction(701, 800, shiftIndex, angleList);
    % Creating and writing layers 801 to 900
    createAndWriteReconstruction(801, 900, shiftIndex, angleList);
    % Creating and writing layers 901 to 1000
    createAndWriteReconstruction(901, 1000, shiftIndex, angleList);
    % Creating and writing layers 1001 to 1100
    createAndWriteReconstruction(1001, 1100, shiftIndex, angleList);
    % Creating and writing layers 1101 to 1200
    createAndWriteReconstruction(1101, 1200, shiftIndex, angleList);
    % Creating and writing layers 1201 to 1300
    createAndWriteReconstruction(1201, 1300, shiftIndex, angleList);
    % Creating and writing layers 1301 to 1400
    createAndWriteReconstruction(1301, 1400, shiftIndex, angleList);
    % Creating and writing layers 1401 to 1500
    createAndWriteReconstruction(1401, 1500, shiftIndex, angleList);
    % Creating and writing layers 1501 to 1600
    createAndWriteReconstruction(1501, 1600, shiftIndex, angleList);
    % Creating and writing layers 1601 to 1700
    createAndWriteReconstruction(1601, 1700, shiftIndex, angleList);
    % Creating and writing layers 1701 to 1800
    createAndWriteReconstruction(1701, 1800, shiftIndex, angleList);
    % Creating and writing layers 1801 to 1900
    createAndWriteReconstruction(1801, 1900, shiftIndex, angleList);
    
    % End parallel processing
    matlabpool close;
end

function createAndWriteReconstruction(startInd, endInd, shiftIndex, angleList)
    parfor i=startInd:endInd
        fileName = ['/home/ugrad/abartolo/NiMnGa-Tomography/Sinograms/sinogram_layer_', padZero(i, 4), '.bin'];
        % Load the necessary sinogram for the layer
        sinogram = LoadSinogram(fileName);
        % Shift the sinogram by the proper amount
        shiftedSinogram = ShiftSinogram(sinogram, shiftIndex);
        % Remove the original sinogram from the workspace
        clearvars sinogram;
        % Reconstruct the layer
        I = iradon(shiftedSinogram, angleList, 'pchip', 2048);
        % Remove the shifted sinogram from the workspace
        clearvars shiftedSinogram;
        % Write the reconstructed layer to disk
        fileName = ['/home/ugrad/abartolo/NiMnGa-Tomography/Reconstructions/recon_layer_', padZero(i, 4), '.bin'];
        fid = fopen(fileName, 'w');
        numX = size(I, 1);
        numY = size(I, 2);
        fwrite(fid, numX, 'int', 'l');
        fwrite(fid, numY, 'int', 'l');
        fwrite(fid, I, 'float', 'l');
        fclose(fid);
        % Remove the reconstruction from the workspace
        clearvars I;
    end
end

% Used to create sinograms from the tiff files and then write them to disk
% These sinograms correspond tot he slices of the tiff files between pixels
% startInd and endInd.
function createAndWriteSinogram(startInd, endInd, netBKG)
    partialSinograms = sinogramCell(startInd, endInd, netBKG);
    parfor i=1:(endInd-startInd+1)
        tempSinogram = partialSinograms{i};
        fileName = ['/home/ugrad/abartolo/NiMnGa-Tomography/Sinograms/sinogram_layer_', padZero(i + startInd - 1, 4), '.bin'];
        SinogramToBinary(tempSinogram, fileName);
    end
    clearvars partialSinograms tempSinogram fileName;
end

% Used to generate a cell array of sinograms. These sinograms correspond to
% the slices of the tiff files between pixels startInd and endInd.
function sinograms = sinogramCell(startInd, endInd, netBKG)
    % Prefix and Postfix of tiff files
    prefix = '/raid/Data/18-Mar10/NiMnGa_samp1_Tomography/NiMnGa_samp1_tomo_vol1_';
    postfix = '.tiff';
    % Create an empty sinogram with the necessary dimensions
    sinogram = zeros(2048, 901);
    % Create a cell array to store the sinograms for each layer of the
    % sample
    sinograms = cell((endInd - startInd + 1), 1);
    parfor i=1:(endInd-startInd+1)
        % Populate the cell array
        sinograms{i} = sinogram;
    end
    for i=1:901
    % Loop over each file, adding a row to each sinogram
        name1 = [prefix, padZero(i, 5), postfix];
        trans = imread(name1);
        % Determine absorption from the direct beam and the transmission
        absp = netBKG - trans;
        for j=startInd:endInd
            tempSinogram = sinograms{j-startInd+1};
            line = absp(j, :)';
            tempSinogram(:, i) = line;
            sinograms{j-startInd+1} = tempSinogram;
        end
        clearvars('absp', 'trans', 'line', 'tempSinogram');
    end
end
