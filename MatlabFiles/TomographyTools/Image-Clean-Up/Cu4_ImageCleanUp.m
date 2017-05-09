function Cu4_ImageCleanUp(start, finish)
% Cu4_ImageCleanUp - 
%   
%   USAGE:
%
%   Cu4_ImageCleanUp(start, finish)
%
%   INPUT:
%
%   start is numeric,
%       is the starting index of which images are to be cleaned up.
%   finish is numeric,
%       is the ending index of which images are to be cleaned up.
%
%   OUTPUT:
%
%   none
%
%   NOTES:  
%
%   * The program will automatically load the images from the proper
%       locations on bloch and will write them as well. The clean up is
%       done by calling the Cu_ReconAlgorithm.m .
%
    load_prefix = '/home/abartolo/Work/Cu4-Tomography/Reconstructions/recon_layer_';
    load_suffix = '.bin';
    write_prefix = '/home/abartolo/Work/Cu4-Tomography/CleanUp/recon_layer_';
    write_suffix = '.bin';
    if( start < 852 )
        start = 852;
    end
    if( finish > 1138 )
        finish = 1138;
    end
    matlabpool open;
    parfor i=start:finish
        name1 = [load_prefix, padZero(i-2, 4), load_suffix]; 
        name2 = [load_prefix, padZero(i-1, 4), load_suffix];
        name3 = [load_prefix, padZero(i, 4), load_suffix];
        name4 = [load_prefix, padZero(i+1, 4), load_suffix];
        name5 = [load_prefix, padZero(i+2, 4), load_suffix];
        layer1 = LoadReconstruction(name1);
        layer2 = LoadReconstruction(name2);
        layer3 = LoadReconstruction(name3);
        layer4 = LoadReconstruction(name4);
        layer5 = LoadReconstruction(name5);
        clearvars name1 name2 name3 name4 name5;
        processedLayer3 = Cu_ReconAlgorithm(layer1, layer2, layer3, layer4, layer5);
        clearvars layer1 layer2 layer3 layer4 layer5;
        outputName = [write_prefix, padZero(i, 4), write_suffix];
        fid = fopen(outputName, 'w');
        numX = size(processedLayer3, 1);
        numY = size(processedLayer3, 2);
        fwrite(fid, numX, 'int', 'l');
        fwrite(fid, numY, 'int', 'l');
        fwrite(fid, processedLayer3, 'float', 'l');
        fclose(fid);
        clearvars outputName fid numX numY processedLayer3;
    end
    matlabpool close;
end
