%
%
% Given grain filename, output the average orientation and location for
% each grain
%
%
function grainAveInfo = getAverageGrainOrientation(grainFilename)


grainSnp = load(grainFilename);


grainIDs = unique(grainSnp(:, 4));

grainAveInfo = zeros(length(grainIDs), 9);

for i = 1:length(grainIDs)
   
    findvec = find(grainSnp(:, 4) == grainIDs(i));
    
    grainAveOrient = averageOrientation(grainSnp(findvec, 5:7) * pi/180);
    grainAveLoc = getCenterOfMass(grainSnp(findvec, 1:3));
    
    grainAveInfo(i, 1:3) = grainAveLoc;
    grainAveInfo(i, 4) = grainIDs(i);
    grainAveInfo(i, 5:7) = grainAveOrient * 180 /pi;
    grainSize = size(findvec);  
    grainAveInfo(i, 8) = grainSize(1);  % number of voxels included in a grain
    grainAveInfo(i, 9) = mean(grainSnp(findvec, 9));
    grainAveInfo(i, 10) = grainSnp(10);
end



%  Find center of mass of grain - for this getAverageGrainOrientation only
%  (really, the mean location)
%  getCenterOfMass(v), size(v) = [n, 3]
%
%%
function com = getCenterOfMass(v)

com(1) = mean(v(:, 1));
com(2) = mean(v(:, 2));
com(3) = mean(v(:, 3));