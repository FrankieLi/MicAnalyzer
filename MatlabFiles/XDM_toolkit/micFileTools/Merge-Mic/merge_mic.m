function [merged_good_Data, sw, merged_bad_Data, difference_data] = merge_mic(snp1, snp2, sw, new_good_File_Name, new_bad_File_Name, differences_Name)
% merge_mic - 
%
%   USAGE:
%
%   [merged_good_Data, sw, merged_bad_Data, difference_data] =
%   merge_mic(snp1, snp2, sw, new_good_File_Name, new_bad_File_Name, differences_Name)
%
%   INPUT:
%
%   snp1 is n1 x 10, 
%       is a standard mic file that will be merged with snp2.
%   snp2 is n2 x 10,
%       is a standard mic file that will be merged with snp1.
%   sw is numeric,
%       the sidewidth of the sample the mic files correspond to.
%   new_good_File_Name is text string,
%       is the name under which the new merged data will be stored as a
%       standard mic file.
%   new_bad_File_Name is text string,
%       is the name under which the the triangles that were not used in the
%       merged data will be stored as a standard mic file.
%   differences_Name is text string,
%       is the name under which the difference data will be stored as a
%       fifteen column mic file.
%
%   OUTPUT:
%
%   merged_good_Data is n3 x 10,
%       is the standard mic file produced by merging snp1 and snp2. It 
%       consists of the triangles from each file with the highest 
%       confidence. Defaults to triangles from snp1 when the confidences
%       are equal.
%   sw is numeric,
%       the sidewidth of the sample the mic file corresponds to.
%   merged_bad_Data is n4 x 10,
%       is the standard mic file produced by the triangles with the lower
%       confidences in snp1 and snp2.
%   difference_data is n4 x 15,
%       is a fifteen column mic file corresponding to the triangles where
%       both snp1 and snp2 had non-zero confidence. The first five columns
%       are the standard mic file columns describing the size and location
%       of the triangle. The sixth column is the phase of the triangle that
%       had higher confidence while the seventh is the phase of the other
%       triangle. Columns eight through ten are the Euler angles of the
%       higher confidence triangle. Columns eleven through thirteen are the
%       Euler angles of the lower confidence triangle. The fourteenth
%       column is the confidence of the higher confidence triangle while
%       the fifteenth column is the confidence of the other triangle.
%   
%
%   NOTES:  
%
%   * For a file with only generation 5 triangles, takes .03 seconds to run.
%   * For a file with only generation 6 triangles, takes .1 seconds to run.
%   * For a file with only generation 7 triangles, takes .4 seconds to run.
%   * For N triangles, runtime complexity is O(N)
%

    % Uniformly regrid each data set and produce the index grid
    [maxX, maxY, processed1, snpGridIndex1, processed2, snpGridIndex2] = triangleGrid(sw, snp1, snp2);
    % Merge the two data sets
    [merged_good_Data, merged_bad_Data, difference_data] = merge(processed1, processed2, snpGridIndex1, snpGridIndex2);
    % Write the necessary data files
    write_mic(merged_good_Data, sw, new_good_File_Name, 10);
    write_mic(merged_bad_Data, sw, new_bad_File_Name, 10);
    write_mic(difference_data, sw, differences_Name, 15);
    % Plot differences in confidences
    plot_differences(difference_data, sw);
end
    
function [combined_good_data, combined_bad_data, data_difference] = merge(data_set1, data_set2, snpGridIndex1, snpGridIndex2)
    %Section #1 , triangles common to both data files
    vect = (snpGridIndex1 ~= 0 & snpGridIndex2 ~= 0);
    ind1 = snpGridIndex1(vect);
    ind2 = snpGridIndex2(vect);
    triangleSet1 = data_set1(ind1, :);
    triangleSet2 = data_set2(ind2, :);
    compareInd = ( triangleSet1(:, 10) < triangleSet2(:, 10) );
    % Find triangles from data set two with higher confidences than data
    % set one
    combined_good_data1_1 = triangleSet2(compareInd, :);
    % Find corresponding triangles from data set one
    potential_bad = triangleSet1(compareInd, :);
    % Find index of any triangles with zero confidence
    removals = (potential_bad(:,10)==0);
    % Find "Difference" data
    % Consists of data from bad triangles with a non-zero confidence and
    % their corresponding good triangles
    if( size(removals,1)==0)
        data_difference1_1 = [ combined_good_data1_1(:, 1:6), potential_bad(:, 6), combined_good_data1_1(:, 7:9), potential_bad(:, 7:9), combined_good_data1_1(:, 10), potential_bad(:, 10) ];
    else
        data_difference1_1 = [ combined_good_data1_1(~removals, 1:6), potential_bad(~removals, 6), combined_good_data1_1(~removals, 7:9), potential_bad(~removals, 7:9), combined_good_data1_1(~removals, 10), potential_bad(~removals, 10) ];
    end
    % Remove any triangles with zero confidence
    potential_bad(removals) = [];
    combined_bad_data1_1 = potential_bad;
    % Repeat for triangles from data set one with higher confidences than
    % data set two
    combined_good_data1_2 = triangleSet1(~compareInd, :);
    potential_bad = triangleSet2(~compareInd, :);
    removals = (potential_bad(:,10)==0);
    if( size(removals,1)==0 )
        data_difference1_2 = [ combined_good_data1_2(:, 1:6), potential_bad(:, 6), combined_good_data1_2(:, 7:9), potential_bad(:, 7:9), combined_good_data1_2(:, 10), potential_bad(:, 10) ];
    else
        data_difference1_2 = [ combined_good_data1_2(~removals, 1:6), potential_bad(~removals, 6), combined_good_data1_2(~removals, 7:9), potential_bad(~removals, 7:9), combined_good_data1_2(~removals, 10), potential_bad(~removals, 10) ];
    end
    potential_bad(removals) = [];
    combined_bad_data1_2 = potential_bad;
    % Merge all data from section 1
    combined_good_data1 = [combined_good_data1_1; combined_good_data1_2];
    combined_bad_data1 = [combined_bad_data1_1; combined_bad_data1_2];
    data_difference1 = [data_difference1_1; data_difference1_2];
    
    
    % Section #2 , triangles only found in the first data file
    vect = (snpGridIndex1~=0 & snpGridIndex2==0);
    ind1 = snpGridIndex1(vect);
    % Find all such triangles
    triangleSet1 = data_set1(ind1, :);
    % All of these triangles are necessarily part of the merged data
    combined_good_data2 = triangleSet1;
    
    
    % Section 3 , triangles only found in the second data file
    vect = (snpGridIndex1==0 & snpGridIndex2~=0);
    ind2 = snpGridIndex2(vect);
    % Find all such triangles
    triangleSet2 = data_set2(ind2, :);
    % All of these triangles are necessarily part of the merged data
    combined_good_data3 = triangleSet2;
    
    
    % Merge all data
    combined_good_data = [combined_good_data1; combined_good_data2; combined_good_data3];
    combined_bad_data = combined_bad_data1;
    data_difference = data_difference1;
end

function plot_differences(data_Difference, width)
    % Create data set of differences in confidence
    adjusted_Data = [data_Difference(:, 1:9), abs(data_Difference(:,15)-data_Difference(:,14))];
    % Generate a number of buckets for plotting the data
    numBuckets = 25;
    graphingArray = zeros(numBuckets, 2);
    % Loop over buckets. Find number of voxels with a confidence difference
    % corresponding to the bucket
    for i = 1:numBuckets
        graphingArray(i, 1) = (i-1)*1.0/numBuckets;
        ind = ( (i-1)/numBuckets <= adjusted_Data & adjusted_Data < i/numBuckets );
        numMatches = sum( sum(ind) );
        graphingArray(i, 2) = numMatches;
    end
    % Plot difference in confidences spatially
    figure(1);
    plot_mic(adjusted_Data, width, 2, 0);
    % Plot difference in confidences by bucket
    figure(2);
    scatter( graphingArray(:, 1), graphingArray(:, 2) );
end

function write_mic(mic, sw, filename, numColumns)
mic_size = size(mic);

fid = fopen(filename,'wt');
fprintf(fid, '%g\n', sw);
if( numColumns == 10)
    for i = 1:mic_size(1)
        fprintf(fid,'%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\n',mic(i, :));
    end
end
if( numColumns == 15)
    for i = 1:mic_size(1)
        fprintf(fid,'%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t',mic(i, :));
    end
end
fclose(fid);
end
