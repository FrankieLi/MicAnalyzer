function growthSnp = indicateGrowth(boundSnp, grainNum)
% indicateGrowth - 
%   
%   USAGE:
%
%   growthSnp = indicateGrowth(boundSnp, grainNum)
%
%   INPUT:
%
%   boundSnp is n x 13 or n x 14, 
%       is a standard mic file with three or four additional columns. The 
%       eleventh column indicates if the the voxel is interior (0) or a 
%       boundary (1). The twelth column is the maximum misorientation of 
%       the voxel with its neighbors in degrees. The thirteenth column is 
%       the number of the grain which contains the voxel. If the file does
%       not already have a fourteenth column, it will be added.
%   grainNum is m x 1,
%       is a list of which grains will be indicated to grow. This list
%       should be a column vector of grain numbers.
%
%   OUTPUT:
%
%   growthSnp is n x 14,
%       is a standard mic file with four additional columns. The eleventh
%       column indicates if the the voxel is interior (0) or a boundary (1).
%       The twelth column is the maximum misorientation of the voxel with its
%       neighbors in degrees. The thirteenth column is the number of the
%       grain which contains the voxel. The fourteenth column indicates if
%       the grain is growing (1) or not (0).
%
%   NOTES:  
%
%   * To use this m-file, one must first apply determineBoundaries to the
%       file that is to be grown.
%
    tempSize = size(boundSnp);
    numColumn = tempSize(2);
    snpSize = tempSize(1);
    tempSize = size(grainNum);
    numCells = tempSize(1);
    if(numColumn==13)
        newColumn = zeros(snpSize, 1);
        boundSnp = [boundSnp, newColumn];
    end
    for i=1:numCells
        actGrain = grainNum(i);
        index = ( boundSnp(:, 13)==actGrain );
        boundSnp(index, 14) = 1;
    end
    growthSnp = boundSnp;
end
