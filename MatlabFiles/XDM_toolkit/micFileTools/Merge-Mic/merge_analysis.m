function merge_analysis( file1_Name, file2_Name, good_File_Name, differences_File_Name, source_File_Name)
% merge_analysis - 
%   
%   USAGE:
%
%   merge_analysis(file1_Name, file2_Name, good_File_Name, differences_File_Name, source_File_Name)
%
%   INPUT:
%
%   file1_Name is text string,
%       is the name of the mic file that corresponds to the reconstruction
%       of one phase of the sample.
%   file2_Name is text string,
%       is the name of the mic file that corresponds to the reconstruction
%       of the other phase of the sample.
%   good_File_Name is text string,
%       is the name of the mic file that corresponds to the data produced
%       by merging the two reconstructed phases.
%   differences_File_Name is text string,
%       is the name of the mic file that corresponds to the difference data
%       produced by merging the two reconstructed phases.
%   source_File_name is text string,
%       is the name of teh mic file that corresponds to the source data
%       used to generate the scattering.
%
%   OUTPUT:
%
%   None except graphics
%
%   NOTES:  
%
%   * To use this m-file, one should be analyzing the results produced by
%       merge_mic.
%

    % Load all input files
    [snp1, sw] = load_mic(file1_Name, 10);
    [snp2] = load_mic(file2_Name, 10);
    [good] = load_mic(good_File_Name, 10);
    [diff] = load_mic(differences_File_Name, 15);
    [source] = load_mic(source_File_Name, 10);
    % Plot the difference in confidences
    plot_differences(diff, sw);
    % Plot the difference in phase
    plot_phase_differences(good, source, sw);
    % Plot the mic of the reconstruction of one phase
    figure(1);
    plot_mic(snp1, sw, 1, 0);
    figure(2);
    plot_mic(snp1, sw, 2, 0);
    % Plot the mic of the reconstruction of the other phase
    figure(3);
    plot_mic(snp2, sw, 1, 0);
    figure(4);
    plot_mic(snp2, sw, 2, 0);
    % Plot the mic of the merged mic files
    figure(5);
    plot_mic(good, sw, 1, 0);
    figure(6);
    plot_mic(good, sw, 2, 0);
    % Plot the source data
    figure(7);
    plot_mic(source, sw, 1, 0);
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
    figure(8);
    plot_mic(adjusted_Data, width, 2, 0);
    % Plot difference in confidences by bucket
    figure(9);
    scatter( graphingArray(:, 1), graphingArray(:, 2) );
end

function plot_phase_differences(goodData, sourceData, sw)
    figure(10);
    % Regrid data sets and generate index grid
    [maxX, maxY, fGood, goodGridIndex, fSource, sourceGridIndex] = triangleGrid(sw, goodData, sourceData);
    % Determine phase difference data and plot data
    [phase_Differences] = phase_Diff( fGood, goodGridIndex, fSource, sourceGridIndex);
    plot_mic(phase_Differences, sw, 2, 0);
end

function phase_Data = phase_Diff( data_set1, gridIndex1, data_set2, gridIndex2)
    % data_set1 is the data from the merged files
    % data_set2 is the source data
    
    % Find region where the merged data and source data overlap
    overlapIndex = (gridIndex1~=0 & gridIndex2~=0);
    ind1 = gridIndex1(overlapIndex);
    trimmed_data_set1 = data_set1(ind1, :);
    ind2 = gridIndex2(overlapIndex);
    trimmed_data_set2 = data_set2(ind2, :);
    % Determine where in this region the phase was properly assigned
    matchingIndex = (trimmed_data_set1(:,6) == trimmed_data_set2(:,6));
    badIndex = (trimmed_data_set1(:,6) ~= trimmed_data_set2(:,6));
    % Where the phase was correct, a confidence of 1 is given, so when
    % plotted, these areas will be red
    newColumn = ones( sum(sum(matchingIndex)), 1);
    phase_Data1 = [data_set1(matchingIndex,1:9),newColumn];
    % Where the phase was incorrect, a confidence of .1 is given, so when
    % plotted, these areas will be blue
    newColumn = zeros(sum(sum(badIndex)), 1);
    newColumn(:) = .1;
    phase_Data2 = [data_set1(badIndex, 1:9), newColumn];
    % Find the region where the merged data is outside of the source data
    leftoverIndex = (gridIndex1==0 & gridIndex2~=0);
    ind2 = gridIndex2(leftoverIndex);
    % All of the triangles in this region, by definition, have the incorrect
    % phase
    newColumn = zeros( sum(sum(leftoverIndex)), 1);
    newColumn(:) = .1;
    phase_Data3 = [data_set2(ind2, 1:9), newColumn];
    % Combine all of the phase data collected
    phase_Data = [phase_Data1; phase_Data2; phase_Data3];
end

