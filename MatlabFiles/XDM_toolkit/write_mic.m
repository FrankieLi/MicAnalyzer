function write_mic(mic, sw, filename)


x = 0:.1:1; y = [x; exp(x)];

mic_size = size(mic);

fid = fopen(filename,'w+');
fprintf(fid, '%g\n', sw);
for i = 1:mic_size(1)

    fprintf(fid,'%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\n',mic(i, :));

end
fclose(fid);
