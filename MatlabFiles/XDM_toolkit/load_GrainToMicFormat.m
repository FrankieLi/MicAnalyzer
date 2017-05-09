%
%
%  Read in grainFilename to a mic format.  Assign each voxel the same
%  orientation as its average orientation.
%
%
%
function grainMic = load_GrainToMicFormat(grainFilename)


grainSnp = load(grainFilename);


grainIDs = unique(grainSnp(:, 4));

grainSnpSize = size(grainSnp);
grainMic = zeros(grainSnpSize(1), 10);
grainMic(:, 1:3) = grainSnp(:, 1:3);
%grainMic(:, 5) = 7;
grainMic(:, 4) = 1;  % all triangles pointing up
grainMic(:, 6) = 1;
grainMic(:, 10) = grainSnp(:, 9);

for i = 1:length(grainIDs)

    % find grain average orientation for each grain ID
    findvec = find(grainSnp(:, 4) == grainIDs(i));
    grainAveOrient = averageOrientation(grainSnp(findvec, 5:7) * pi/180);
    
    
    
    % assign
    grainMic(findvec, 7) = grainAveOrient(1) * 180 /pi;
    grainMic(findvec, 8) = grainAveOrient(2) * 180 /pi;
    grainMic(findvec, 9) = grainAveOrient(3) * 180 /pi;
    %grainAveInfo(i, 8) = grainSize(1);  % number of voxels included in a grain
    %grainAveInfo(i, 9) = mean(grainSnp(findvec, 9));
    %grainAveInfo(findvec, 10) = grainSnp(9);
end


