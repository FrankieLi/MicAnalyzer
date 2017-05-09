function output = plot_OneDetectorDistance(prefix, start, stop, ext)

output = zeros(0, 3);
for i=start:stop
   
    if(i < 10)
      filename = sprintf('%s00%g.%s', prefix, i, ext);
    elseif(i < 100)
      filename = sprintf('%s0%g.%s', prefix, i, ext);
    else
      filename = sprintf('%s%g.%s', prefix, i, ext);
    end 
    
    filename
    snp = load_PeakFiles(filename, 3);
    output = [output; snp];
end


plot(output(:, 1), output(:, 2), '.');