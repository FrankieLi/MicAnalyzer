function output = load_PeakFiles(filename, numCols)


fd = fopen(filename);

% remove first line
fgetl(fd);

output = fscanf(fd, '%d %d %d', [numCols, inf]);

output = output';

fclose(fd);