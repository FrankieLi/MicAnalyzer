function [compared_Data, sw] = pointMisorientation(snp1, snp2, sw, noiseThreshold)
% pointMisorientation - 
%   
%   USAGE:
%
%   [compared_Data, sw] = pointMisorientation(snp1, snp2, sw, noiseThreshold)
%
%   INPUT:
%
%   snp1 is n1 x 10, 
%       is a standard mic file that will be compared with snp2.
%   snp2 is n2 x 10,
%       is a standard mic file that will be compared with snp1.
%   sw is numeric,
%       the sidewidth of the sample the mic files correspond to.
%   noiseThreshold is numeric,
%       the minimum value that a misorientation must be greater than to be
%       considered effectively different. Any misorientation less than this
%       value will be assumed to be caused by rounding errors and set to
%       zero.
%
%   OUTPUT:
%
%   compared_Data is n3 x 10,
%       is the standard mic file produced by comparing snp1 and snp2. The
%       Euler angles of each triangle in this mic file correspond to the
%       rotation between the corresponding triangles in snp1 and
%       snp2.
%   sw is numeric,
%       the sidewidth of the sample the mic file corresponds to.   
%
%   NOTES:  
%
%   * The minimum value for the noiseThreshold is .0001 . If a value lower
%       than this is provided, it will be set to .0001 . 
%   * The Euler angles in compared_Data correspond to the rotation
%       necessary to transition from the triangle in snp1 to the triangle
%       in snp2.
%   * For a file with only generation 5 triangles, takes 1 second to run.
%   * For a file with only generation 6 triangles, takes 5 seconds to run.
%   * For a file with only generation 7 triangles, takes 17 seconds to run.
%   * For N triangles, runtime complexity is O(N)
%

    % Set noise threshold. Minimum value of .0001 due to potential rounding
    % error
    noiseThreshold = max(1E-4, noiseThreshold);
    % Generate uniform triangle grids for both data set.
    [maxX, maxY, processed1, snpGridIndex1, processed2, snpGridIndex2] = triangleGrid(sw, snp1, snp2);
    % Generate misorientation data
    [compared_Data] = comparison(processed1, processed2, snpGridIndex1, snpGridIndex2, noiseThreshold);
    temp = size(compared_Data);
    numVoxels = temp(1);
    % Display relevant statistics on misorientations calculated
    maxMisorient = max(compared_Data(:, 10) );
    disp(['Maximum Misorientation: ', num2str(maxMisorient)]);
    ind1 = find( compared_Data(:, 10) > .01 );
    temp = size(ind1);
    numCrit = temp(1);
    disp(['Percentage with Misorientation greater than .01 degrees: ', num2str(numCrit/numVoxels),'%']);
    ind2 = find( compared_Data(:, 10) > .1 );
    temp = size(ind2);
    numCrit = temp(1);
    disp(['Percentage with Misorientation greater than .1 degrees: ', num2str(numCrit/numVoxels),'%']);
    ind3 = find( compared_Data(:, 10) > 1);
    temp = size(ind3);
    numCrit = temp(1);
    disp(['Percentage with Misorientation greater than 1 degree: ', num2str(numCrit/numVoxels), '%']);
    ind4 = find( compared_Data(:, 10) > 10);
    temp = size(ind4);
    numCrit = temp(1);
    disp(['Percentage with Misorientation greater than 10 degrees: ', num2str(numCrit/numVoxels), '%']);
    ind5 = find( compared_Data(:, 10) > 30);
    temp = size(ind5);
    numCrit = temp(1);
    disp(['Percentage with Misorientation greater than 30 degrees: ', num2str(numCrit/numVoxels), '%']);
    compared_Data(:, 10) = compared_Data(:, 10)/maxMisorient;    
    % Plot misorienations as Euler angles and as Rodriguez vectors
    figure; plot_mic(compared_Data, sw, 1, .01);
    figure; plot_mic(compared_Data, sw, 3, .01);
end
    
function [compared_data] = comparison(data_set1, data_set2, snpGridIndex1, snpGridIndex2, noiseThreshold)
    % Create logical index of region in which the data sets overlap
    vect = (snpGridIndex1 ~= 0 & snpGridIndex2 ~= 0);
    % Retrieve triangles from each data set in this region
    indSet1 = snpGridIndex1(vect);
    triangleSet1 = data_set1(indSet1, :);
    indSet2 = snpGridIndex2(vect);
    triangleSet2 = data_set2(indSet2, :);
    % Determine Rotation Matrices for each set of triangles
    rmats1 = RMatOfBunge( transpose( triangleSet1(:, 7:9) ), 'degrees' );
    rmats2 = RMatOfBunge( transpose( triangleSet2(:, 7:9) ), 'degrees' );
    % Calculate quaternions from the rotation matrices
    quats1 = QuatOfRMat( rmats1);
    quats2 = QuatOfRMat( rmats2);
    % Determine inverse of the quaternions from one data set
    invQuats1 = quats1;
    invQuats1(2:4, :) = -quats1(2:4, :);
    % Take the product of the quaternions and the inverses to determine the
    % quaternion describing the misorientation
    products = QuatProd(invQuats1, quats2);
    % Determine the misorientation from the quaternion
    mis = ToFundamentalRegionQ(products, CubSymmetries());
    angles = 2*acos(min(1, mis(1, :)));
    angles = transpose(angles);
    % Determine Rotation Matrices describing the misorienations
    netRMats = RMatOfQuat( products );
    % Convert Rotation Matrices to Euler angles
    netBunges = BungeOfRMat( netRMats, 'degrees' );
    compared_data = [triangleSet1(:, 1:6), transpose( netBunges ), min( triangleSet1(:, 10), triangleSet2(:, 10) )];
    % Create logical index of misorientations less than the noise threshold
    a = ((180/pi)*angles < noiseThreshold);
    % Set the Euler angles and confidence of such regions to zero.
    compared_data(a, 7:10) = zeros(sum(a), 4);
end
