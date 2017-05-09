function output = getMicSubgrain(snp, minX, maxX, minY, maxY)



findvec = find( snp(:, 1) >minX & snp(:,1) < maxX & snp(:, 2) > minY & snp(:, 2) < maxY); 
output = snp(findvec, :);

