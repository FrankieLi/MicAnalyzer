function [maxX, maxY, varargout] = triangleGrid(sw, varargin)
% triangleGrid -
%   
%   USAGE:
%
%   [maxX, maxY, newSnp1, snpGrid1, ....] = 
%       determineBoundaries(sw, snp1, ....)
%
%   INPUT:
%
%   snp1 is n1 x 10, 
%       a standard mic file loaded into MatLab
%   sw is numeric, 
%       the sidewidth of the sample the mic file corresponds to.
%
%   OUTPUT:
%
%   newSnp1 is n2 x 10,
%       is a standard mic file. This mic file is equivalent to the input
%       snp1, however, it has been regridded so each triangle is of the
%       same generation as the triangle with the greatest generation among
%       the several input mic files.
%   snpGrid1 is X x Y x 2,
%       is an array that returns the index of a triangle in newSnp1 given 
%       its X and Y positions (integers) relative to the triangle grid and
%       its orientation. The triangle grid can be thought of as an integer 
%       grid such that the triangle at (0,0) in the mic file has position
%       (0,0, orientation) in the triangle grid. The triangle two rows
%       above and one column to the left will have position 
%       (-1, 2, orientation). Any points on the grid where there is not a
%       triangle will return an index of zero. Because this is a matrix and
%       all indices must be non-zero, the index of a triangle in snpGrid1
%       is only relative to the triangle grid. The triangle on the triangle
%       grid with the lowest X and Y positions is given the indices 
%       (1, 1, orientation). Thus, given the the minimum X position, minX,
%       and the minimum Y position, minY, in the triangle grid, a triangle 
%       with triangle grid coordinates (x, y, orient) can be found in 
%       snpGrid1 at (x - minX, y - minY, orient).
%   maxX is numeric,
%       is the greatest position of any triangle in the snpGrid's relative
%       to the triangle grid.
%   maxY is numeric,
%       is the greatest position of any triangle in the snpGrid's relative
%       to the triangle grid.
%
%   NOTES:  
%
%   * For a file with only generation 5 triangles, takes .006 seconds to run.
%   * For a file with only generation 6 triangles, takes .04 seconds to run.
%   * For a file with only generation 7 triangles, takes .14 seconds to run.
%   * For N triangles, runtime complexity is O(N)
%
%   * All of the input snp's are assumed to have the same sidewidth.
%   * All of the input snp's are assumed to be about the same origin.
%   * If swX = size( snpGrid, 1 ), minX = maxX - swX + 1.
%   * If swY = size( snpGrid, 2 ), minY = maxY - swY + 1.
%
%   * If xPos and yPos are the position of a triangle in a mic file of
%       sidewidth sw and generation n, its triangle grid coordinates can be
%       found as follows:
%        triangleSide = sw/(2^n);
%        errorFactor = triangleSide/4;
%        xPos = xPos - errorFactor;
%        xPos = ceil(xPos/triangleSide);
%        yPos = yPos + errorFactor;
%        yPos = floor(yPos/(sqrt(3)*triangleSide/2));
%    

    % snp are assumed to be of 10-column mic-format
    numSnps = size(varargin,2);
    maxGen = 1;
    % Loop over all input mic's to determine maximum genereation
    for i = 1:numSnps
        tempSnp = varargin{i};
        snpGen = max(tempSnp(:,5));
        maxGen = max( maxGen, snpGen);
    end
    maxX = 0;
    minX = 0;
    maxY = 0;
    minY = 0;
    columnStorage = cell(i);
    % Loop over each input mic
    for i = 1:numSnps
        tempSnp = varargin{i};
        snp = uniform_regrid(tempSnp, maxGen, sw);
        varargout{2*(i-1)+1} = snp;
        tsw = sw/(2^maxGen);
        % Create a grid that has all of the triangle vertices as integer
        % points
        tempColumns = [snp(:,1), snp(:,2)];
        tempColumns(:,1) = tempColumns(:,1) - tsw/4;
        tempColumns(:,1) = tempColumns(:,1) / tsw;
        tempColumns(:,1) = ceil( tempColumns(:,1) );
        tempColumns(:,2) = tempColumns(:,2) + tsw/4;
        tempColumns(:,2) = tempColumns(:,2) / (sqrt(3)*tsw/2);
        tempColumns(:,2) = floor( tempColumns(:,2) );
        % Store grid for later use
        columnStorage{i} = tempColumns;
        % Determine max and min for x and y for the mic file
        snpMaxX = max( tempColumns(:,1) );
        snpMinX = min( tempColumns(:,1) );
        snpMaxY = max( tempColumns(:,2) );
        snpMinY = min( tempColumns(:,2) );
        % Determine global max and min for x and y positions
        maxX = max( maxX, snpMaxX);
        minX = min( minX, snpMinX);
        maxY = max( maxY, snpMaxY);
        minY = min( minY, snpMinY);
    end
    width = maxX - minX + 1;
    height = maxY - minY + 1;    
    % Loop over input mics
    for i = 1:numSnps
        snp = varargout{2*(i-1)+1};
        snpSize = size(snp, 1);
        % Initialize grid
        griddedSnp = zeros(width, height, 2);
        tempColumns = columnStorage{i};
        % Loop over entries in the columns
        for j=1:snpSize
            x = tempColumns(j, 1);
            y = tempColumns(j, 2);
            orient = snp(j, 4);
            % Set the value in the grid to the ind of the triangle in the
            % mic file.
            griddedSnp(x - minX + 1, y - minY + 1, orient) = j;
        end
        varargout{2*(i-1)+2} = griddedSnp;
    end
end
    
function new_Data_Set = uniform_regrid(snap, max_gen, sdw)
    % Create an index of all triangles already at the maximum generation
    idx1 = (snap(:,5) == max_gen);
    % Create an index of all triangles not at the necessary generation
    idx2 = (snap(:,5) ~= max_gen);
    % Create a set of good triangles
    goodTriangles = snap(idx1, 1:10);
    % Create a set of triangles that need to be regridded
    regridingTriangles = snap(idx2, :);
    regridSize = size(regridingTriangles);
    % Determine how many regridded triangles there can be
    sz = determineAllocation(regridingTriangles, max_gen);
    new_Data_Set = zeros(sz, 10);
    data_Counter = 1;
    % Loop over the triangles
    for i = 1:regridSize
        triangle1 = regridingTriangles(i, :);
        if(triangle1(5) < max_gen)
            triangle_side = sdw/(2^triangle1(5));
            % Regrid the triangle in question
            processedTriangles = regridTriangle(triangle1, max_gen, triangle_side);
            process_Size = size(processedTriangles);
            process_Size = process_Size(1);
            % Place regridded triangles in a separate set
            new_Data_Set(data_Counter:(data_Counter+process_Size-1), :) = processedTriangles;
            data_Counter = data_Counter + process_Size;
        else
            new_Data_Set(data_Counter, :) = triangle1;
            data_Counter = data_Counter + 1;
        end
    end
    % Combine the good triangles with the triangles that were regridded
    new_Data_Set = [new_Data_Set; goodTriangles];
    new_Data_Set = sortrows(new_Data_Set, [-2,1]);
end

function new_Size = determineAllocation(inputData, final_gen)
    gens = inputData(:, 5);
    regrids = final_gen - gens(:);
    new_Size = 0;
    for i = 1:size(regrids)
        new_Size = new_Size + 4^( regrids(i) );
    end
end

function newTriangles = regridTriangle(inputTriangle, max_generation, side)
    if( inputTriangle(5) >= max_generation)
        % Base case for recursion
        % Returns a triangle as is, if it is already at the maximum
        % generation
        newTriangles = inputTriangle;
    else
        x1 = inputTriangle(1);
        y1 = inputTriangle(2);
        z1 = inputTriangle(3);
        direct1 = inputTriangle(4);
        gen1 = inputTriangle(5);
        phase1 = inputTriangle(6);
        orient1 = inputTriangle(7);
        orient2 = inputTriangle(8);
        orient3 = inputTriangle(9);
        conf1 = inputTriangle(10);
        if( direct1 == 1)
            % Split the triangle into four separate sub-triangles with the
            % same orienation, confidence, and phase as the original
            subTriangle1 = [x1, y1, z1, 1, gen1 + 1, phase1, orient1, orient2, orient3, conf1];
            subTriangle2 = [x1 + side/2, y1, z1, 1, gen1 + 1, phase1, orient1, orient2, orient3, conf1];
            subTriangle3 = [x1 + side/4, y1 + sqrt(3)*side/4, z1, 2, gen1 + 1, phase1, orient1, orient2, orient3, conf1];
            subTriangle4 = [x1 + side/4, y1 + sqrt(3)*side/4, z1, 1, gen1 + 1, phase1, orient1, orient2, orient3, conf1];
            % Regrid each of these triangles (if necessary) until each is
            % at the maximum generation
            finalSubTriangles1 = regridTriangle(subTriangle1, max_generation, side/2);
            finalSubTriangles2 = regridTriangle(subTriangle2, max_generation, side/2);
            finalSubTriangles3 = regridTriangle(subTriangle3, max_generation, side/2);
            finalSubTriangles4 = regridTriangle(subTriangle4, max_generation, side/2);
            % Place all regridded sub-triangles in a set
            newTriangles = [finalSubTriangles1; finalSubTriangles2; finalSubTriangles3; finalSubTriangles4];
        else
            % Split the triangle into four separate sub-triangles with the
            % same orientaitn, confidence, and phase as the original
            subTriangle1 = [x1, y1, z1, 2, gen1 + 1, phase1, orient1, orient2, orient3, conf1];
            subTriangle2 = [x1 + side/2, y1, z1, 2, gen1 + 1, phase1, orient1, orient2, orient3, conf1];
            subTriangle3 = [x1 + side/4, y1 - sqrt(3)*side/4, z1, 1, gen1 + 1, phase1, orient1, orient2, orient3, conf1];
            subTriangle4 = [x1 + side/4, y1 - sqrt(3)*side/4, z1, 2, gen1 + 1, phase1, orient1, orient2, orient3, conf1];
            % Regrid each of these triangles (if necessary) until each is
            % at the maximum generation
            finalSubTriangles1 = regridTriangle(subTriangle1, max_generation, side/2);
            finalSubTriangles2 = regridTriangle(subTriangle2, max_generation, side/2);
            finalSubTriangles3 = regridTriangle(subTriangle3, max_generation, side/2);
            finalSubTriangles4 = regridTriangle(subTriangle4, max_generation, side/2);
            % Place all regridded sub-triangles in a set
            newTriangles = [finalSubTriangles1; finalSubTriangles2; finalSubTriangles3; finalSubTriangles4];          
        end
    end
end
 