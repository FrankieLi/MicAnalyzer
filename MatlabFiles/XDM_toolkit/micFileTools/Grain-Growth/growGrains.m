function grownSnp = growGrains(markedSnp, snpGridIndex, maxX, maxY, sw, threshold)
% growGrains - 
%   
%   USAGE:
%
%   grownSnp = growGrains(markedSnp, snpGridIndex, maxX, maxY, sw, threshold)
%
%   INPUT:
%
%   markedSnp is n x 14, 
%       is a standard mic file with four additional columns. The eleventh
%       column indicates if the the voxel is interior (0) or a boundary (1).
%       The twelth column is the maximum misorientation of the voxel with its
%       neighbors in degrees. The thirteenth column is the number of the
%       grain which contains the voxel. The fourteenth column indicates if
%       the grain is growing (1) or not (0).
%   snpGridIndex is X x Y x 2,
%       is an array that returns the index of a triangle in the mic file
%       given its X and Y positions relative to the triangle grid and the
%       orientation. This is the same grid produced by triangleGrid.
%   maxX is numeric,
%       the value of the greatest X position on the triangle grid
%   maxY is numeric,
%       the value of the greatest Y position on the triangle grid
%   sw is numeric, 
%        the sidewidth of the sample the mic file corresponds to
%   threshold is numeric,
%        the miminum angle in degrees that the misorientation must be
%        greater than for two voxels to be considered separate grains
%
%   OUTPUT:
%
%   grownSnp is n x 14,
%       is the mic file produced by allowing the marked grains to grow. This
%       is a standard mic file with four additional columns. The eleventh
%       column indicates if the the voxel is interior (0) or a boundary (1).
%       The twelth column is the maximum misorientation of the voxel with its
%       neighbors in degrees. The thirteenth column is the number of the
%       grain which contains the voxel. The fourteenth column indicates if
%       the grain is growing (1) or not (0). The fourteenth column has been
%       set to zero.
%
%   NOTES:  
%
%   * To use this m-file, one must first apply determineBoundaries and
%       indicateGrowth to the mic file that is to be grown.
%   * For 3 grains of a file with only generation 6 triangles, 3.5 seconds
%   * For fixed number of grains, runtime is approximately independent of 
%        generation.
%

    minX = maxX - size(snpGridIndex, 1) + 1;
    minY = maxY - size(snpGridIndex, 2) + 1;
    % Find all voxels that are on the boundary of a grain that is growing
    growingIndex = find( (markedSnp(:, 11)==1)&(markedSnp(:,14)==1));
    numVoxels = size(growingIndex, 1);
    % Loop over all such voxels
    for i=1:numVoxels
        marker = growingIndex(i);
        triangle = markedSnp(marker, :);
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
        % Find the index of neighboring voxels
        if( orient==1)
            if( mod(xPos, 2) == 1)
                indexes = [snpGridIndex(xPos - minX + 1, yPos - minY + 1, 2);
                            snpGridIndex(xPos - minX + 1, yPos +1 - minY + 1, 2);
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
        % Remove any neighbors that aren't part of the data set
        removals =  (indexes(:)==0) ;
        indexes(removals) = [];
        tempSize = size(indexes);
        nSize = tempSize(1);
        % Loop over the neighbors
        for j=1:nSize
            ind = indexes(j);
            near = markedSnp(ind, :);
            xPos = near(1);
            yPos = near(2);
            % Check if the growing voxel and its neighbor are in the same
            % grain
            if( triangle(13)~=near(13) )
                % Check that the neighboring voxel isn't of the same grain
                % and its not part of a growing grain
                if( near(14)~= 1)
                    % "Grow" the voxel into the neighbor
                    markedSnp(ind, 6:14) = [triangle(6:10),0,0,triangle(13),0];
                    xPos = xPos - errorFactor;
                    xPos = ceil(xPos/triangleSide);
                    yPos = yPos + errorFactor;
                    yPos = floor(yPos/(sqrt(3)*triangleSide/2));
                    orient = near(4);
                    % Find neighbors of the newly grown voxel
                    if( orient==1)
                        if( mod(xPos, 2) == 1)
                            neighbors = [snpGridIndex(xPos - minX + 1, yPos - minY + 1, 2);
                                            snpGridIndex(xPos - minX + 1, yPos + 1 - minY + 1, 2);
                                            snpGridIndex(xPos - 1 - minX + 1, yPos + 1 - minY + 1, 2)];
                        else
                            neighbors = [snpGridIndex(xPos - minX + 1, yPos - minY + 1, 2);
                                            snpGridIndex(xPos + 1 - minX + 1, yPos + 1 - minY + 1, 2);
                                            snpGridIndex(xPos - minX + 1, yPos + 1 - minY + 1, 2)];
                        end
                    else
                        if( mod(xPos, 2) == 1)
                            neighbors = [snpGridIndex(xPos - minX + 1, yPos - minY + 1, 1);
                                            snpGridIndex(xPos - minX + 1, yPos - 1 - minY + 1, 1);
                                            snpGridIndex(xPos - 1 - minX + 1, yPos - minY + 1 - 1, 1)];
                        else
                            neighbors = [snpGridIndex(xPos - minX + 1, yPos - minY + 1, 1);
                                            snpGridIndex(xPos + 1 - minX + 1, yPos - 1 - minY + 1, 1);
                                            snpGridIndex(xPos - minX + 1, yPos - 1 - minY + 1, 1)];
                        end
                    end
                    % Remove any neighbors that aren't part of the data set
                    removals =  (neighbors(:)==0) ;
                    neighbors(removals) = [];
                    % Check the boundary and grain status of the newly
                    % grown voxel, its neighbors, the original voxel, and
                    % its neighbors.
                    checks = [ind; neighbors];
                    markedSnp = checkForBounds(markedSnp, snpGridIndex, minX, minY, sw, checks, threshold);
                end
            end
        end
    end
    % Set the growth column to all zeros.
    markedSnp(:, 14)=0;
    grownSnp = markedSnp;
end

function image = checkForBounds(image, snpGridIndex, minX, minY, sw, indexSet, threshold)
    tempSize = size(indexSet);
    numCells = tempSize(1);
    % Loop over all voxels that need to have boundary status checked
    for q= 1:numCells
        ind = indexSet(q);
        triangle = image(ind, :);
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
        % Find neighbors of the voxel in question
        if( orient==1)
            if( mod(xPos, 2) == 1)
                neighborIndex = [snpGridIndex(xPos - minX + 1, yPos - minY + 1, 2);
                                    snpGridIndex(xPos - minX + 1, yPos + 1 - minY + 1, 2);
                                    snpGridIndex(xPos - 1 - minX + 1, yPos + 1 - minY + 1, 2)];
            else
                neighborIndex = [snpGridIndex(xPos - minX + 1, yPos - minY + 1, 2);
                                    snpGridIndex(xPos + 1 - minX + 1, yPos + 1 - minY + 1, 2);
                                snpGridIndex(xPos - minX + 1, yPos + 1 - minY + 1, 2)];
            end
        else
            if( mod(xPos, 2) == 1)
                neighborIndex = [snpGridIndex(xPos - minX + 1, yPos - minY + 1, 1);
                                snpGridIndex(xPos - minX + 1, yPos - 1 - minY + 1, 1);
                                snpGridIndex(xPos - 1 - minX + 1, yPos - 1 - minY + 1, 1)];
            else
                neighborIndex = [snpGridIndex(xPos - minX + 1, yPos - minY + 1, 1);
                                snpGridIndex(xPos + 1 - minX + 1, yPos - 1 - minY + 1, 1);
                                snpGridIndex(xPos - minX + 1, yPos - 1 - minY + 1, 1)];
            end
        end
        % Remove any neighbors that aren't part of the data set
        removals =  (neighborIndex(:)==0) ;
        neighborIndex(removals) = [];
        % Test if the voxel is a boundary
        [bound, maxMisorientation] = testBoundaries(image, triangle, neighborIndex, threshold);
        image(ind, 11)=bound;
        image(ind, 12)=maxMisorientation;
    end
end

function [bound, maxMisorient] = testBoundaries(snp, triangle, neighbors, threshold)
    % Take the triangle and convert from Euler angles to Rotation Matrix to
    % Quaternion. Repeat for neighboring triangles. Calculate the misorientation 
    % between the triangle and its neighbors.
    % If the misorientation is greater than some threshold, the triangle
    % borders a different grain. If on the border of another grain, make 11th column a 1. If not on
    % the border, make the column a 0.
    tempSize = size(neighbors);
    nSize = tempSize(1);
    maxMisorient = 0;
    bound = 0;
    testQuat = QuatOfRMat( RMatOfBunge(transpose(triangle(7:9)), 'degrees') );
    for j=1:nSize
        ind = neighbors(j);
        near = snp(ind, :);
        nearQuat = QuatOfRMat( RMatOfBunge(transpose(near(7:9)), 'degrees') );
        angle = (180/pi)*Misorientation(testQuat, nearQuat, CubSymmetries() );
        angle = abs(angle);
        if( angle>threshold )
            bound = 1;
        end
        maxMisorient = max( [maxMisorient, angle] );
    end
end
