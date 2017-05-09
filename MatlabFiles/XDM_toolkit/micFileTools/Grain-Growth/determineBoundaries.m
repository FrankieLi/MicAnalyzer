function [boundarySnp, snpGridIndex, maxX, maxY] = determineBoundaries(snp1, sw, threshold)
% determineBoundaries - 
%   
%   USAGE:
%
%   [boundarySnp, snpGridIndex, maxX, maxY] = determineBoundaries(snp, sw, threshold)
%
%   INPUT:
%
%   snp1 is n x 10, 
%        a standard mic file loaded into MatLab
%   sw is numeric, 
%        the sidewidth of the sample the mic file corresponds to
%   threshold is numeric,
%        the miminum angle in degrees that the misorientation must be
%        greater than for two voxels to be considered separate grains
%
%   OUTPUT:
%
%   boundarySnp is m x 13,
%       is a standard mic file with three additional columns. The eleventh
%       column indicates if the the voxel is interior (0) or a boundary (1).
%       The twelth column is the maximum misorientation of the voxel with its
%       neighbors in degrees. The thirteenth column is the number of the
%       grain which contains the voxel.
%   snpGridIndex is X x Y x 2,
%       is an array that returns the index of a triangle in the mic file
%       given its X and Y positions relative to the triangle grid and the
%       orientation. This is the same grid produced by triangleGrid.
%   maxX is numeric,
%       the value of the greatest X position on the triangle grid
%   maxY is numeric,
%       the value of the greatest Y position on the triangle grid
%
%   NOTES:  
%
%   * For a file with only generation 5 triangles, takes 30 seconds to run.
%   * For a file with only generation 6 triangles, takes 2 minutes to run.
%   * For a file with only generation 7 triangles, takes 8 minutes to run.
%   * For N triangles, runtime complexity is O(N)
%

% Given mic file with 10 columns and n rows
% Regrid the mic file and sort the rows
    [maxX, maxY, snp1, snpGridIndex] = triangleGrid(sw, snp1(:,1:10));
    minX = maxX - size(snpGridIndex, 1) + 1;
    minY = maxY - size(snpGridIndex, 2) + 1;
% Determine number of rows
    tempsize = size(snp1);
    n = tempsize(1);
% Add 11th and 12th and 13th column to file
    newColumns = zeros(n, 3);
    snp = horzcat(snp1, newColumns);
% Begin looping over mic file to determine boundary voxels
    currentMaxGrain = 0;
    for i=1:n
        triangleIndex = i;
        [snp, currentMaxGrain] = recurseOverGrain(triangleIndex, snp, snpGridIndex, minX, minY, sw, threshold, currentMaxGrain);
    end
% Once loop is complete, plot the orientations of the mic file and also the
% boundaries of the grains.
 boundarySnp = snp;
 figure(1);
 plot_mic(snp, sw, 3, 0);
 figure(2);
 d =  (snp(:, 11) > .75);
 plot_mic(snp(d, 1:10), sw, 3, 0);
 figure(3);
 misorientations = snp(:, 12);
 maxMisorient = max(misorientations);
 snp(:, 10) = snp(:, 12)/maxMisorient;
 plot_mic(snp, sw, 2, (threshold/4)/maxMisorient);
end

function [image, maxGrainNum] = recurseOverGrain(triangleIndex, image, snpGridIndex, minX, minY, sw, threshold, maxGrainNum)
    % Given a voxel, create a neighborhood around it that contains all
    % triangles it shares an edge with
    triangle = image(triangleIndex, :);
    gen = triangle(5);
    triangleSide = sw/(2^gen);
    errorFactor = triangleSide/4;
    xPos = triangle(1);
    xPos = xPos - errorFactor;
    xPos = ceil(xPos/triangleSide);
    yPos = triangle(2);
    yPos = yPos + errorFactor;
    yPos = floor(yPos/(sqrt(3)*triangleSide/2));
    orient = triangle(4);
    if( orient==1)
        if( mod(xPos, 2) == 1)
            indexes = [snpGridIndex(xPos - minX + 1, yPos - minY + 1, 2);
                        snpGridIndex(xPos - minX + 1, yPos + 1 - minY + 1, 2);
                        snpGridIndex(xPos - 1 - minX + 1, yPos + 1 - minY + 1, 2)];
        else
            indexes = [snpGridIndex(xPos - minX + 1, yPos - minY + 1, 2);
                        snpGridIndex(xPos + 1 - minX + 1, yPos + 1 - minY + 1, 2);
                        snpGridIndex(xPos - minX + 1, yPos + 1 - minY + 1, 2)];
        end
    else
        if( mod(xPos, 2) == 1)
            indexes = [snpGridIndex(xPos - minX + 1, yPos - minY + 1, 1);
                        snpGridIndex(xPos - minX + 1, yPos - 1 - minY + 1, 1);
                        snpGridIndex(xPos - 1 - minX + 1, yPos - 1 - minY + 1, 1)];
        else
            indexes = [snpGridIndex(xPos - minX + 1, yPos - minY + 1, 1);
                        snpGridIndex(xPos + 1 - minX + 1, yPos - 1 - minY + 1, 1);
                        snpGridIndex(xPos - minX + 1, yPos - 1 - minY + 1, 1)];
        end
    end
    % Base case for recursion
    if( triangle(13)==0 )
        maxGrainNum = (maxGrainNum+1);
        triangle(13) = maxGrainNum;
        image(triangleIndex, 13) = maxGrainNum;
    end
    % Take the triangle and convert from Euler angles to Rotation Matrix to
    % Quaternion. Repeat for neighboring triangles. Calculate the misorientation 
    % between the triangle and its neighbors.
    % If the misorientation is greater than some threshold, the triangle
    % borders a different grain. If on the border of another grain, make 11th column a 1. If not on
    % the border, make the column a 0.
    removals =  (indexes(:)==0) ;
    indexes(removals) = [];
    tempSize = size(indexes);
    nSize = tempSize(1);
    maxMisorient = 0;
    bound = 0;
    testQuat = QuatOfRMat( RMatOfBunge(transpose(triangle(7:9)), 'degrees') );
    for j=1:nSize
        ind = indexes(j);
        near = image(ind, :);
        nearQuat = QuatOfRMat( RMatOfBunge(transpose(near(7:9)), 'degrees') );
        angle = (180/pi)*Misorientation(testQuat, nearQuat, CubSymmetries() );
        angle = abs(angle);
        if( angle>threshold )
            bound = 1;
        else
            if(near(13)==0)
                image(ind, 13) = triangle(13);
                [image, maxGrainNum] = recurseOverGrain(ind, image, snpGridIndex, minX, minY, sw, threshold, maxGrainNum);
            end
        end
        maxMisorient = max( [maxMisorient, angle] );
    end
    image(triangleIndex, 11) = bound;
    image(triangleIndex, 12) = maxMisorient;
end
