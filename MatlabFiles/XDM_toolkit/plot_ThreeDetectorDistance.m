function output = plot_ThreeDetectorDistance(prefix, start, stop, offset)

output_d1 = zeros(0, 3);
output_d2 = zeros(0, 3);
output_d3 = zeros(0, 3);

for i=start:stop
   
    fileNum = i;
    if(fileNum < 10)
      filename1 = sprintf('%s00%g.d1', prefix, fileNum);
    elseif(fileNum < 100)
      filename1 = sprintf('%s0%g.d1', prefix, fileNum);
    else
      filename1 = sprintf('%s%g.d1', prefix, fileNum);
    end 

    fileNum = i + offset;
    if(fileNum < 10)
      filename2 = sprintf('%s00%g.d2', prefix, fileNum);
    elseif(fileNum < 100)
      filename2 = sprintf('%s0%g.d2', prefix, fileNum);
    else
      filename2 = sprintf('%s%g.d2', prefix, fileNum);
    end 
    
    fileNum = i + offset + offset;
    if(fileNum < 10)
      filename3 = sprintf('%s00%g.d3', prefix, fileNum);
    elseif(fileNum < 100)
      filename3 = sprintf('%s0%g.d3', prefix, fileNum);
    else
      filename3 = sprintf('%s%g.d3', prefix, fileNum);
    end 
    
    snp1 = load_PeakFiles(filename1, 3);
    snp2 = load_PeakFiles(filename2, 3);
    snp3 = load_PeakFiles(filename3, 3);
    
    output_d1 = [output_d1; snp1];
    output_d2 = [output_d2; snp2];
    output_d3 = [output_d3; snp3];
end

hold on;
plot(output_d1(:, 1), output_d1(:, 2), 'r.');
plot(output_d2(:, 1), output_d2(:, 2), 'g.');
plot(output_d3(:, 1), output_d3(:, 2), 'b.');
hold off;