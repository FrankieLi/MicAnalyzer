%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% load ebsd file
%
% sidewidth is the width of one side of the triangle
%
%
% File Format:
% Col 1   grain number
% Col 2-4 Average orientation
% Col 5-6 location (x, y)
% Col 7   Average Image Quality
% Col 8   Average Confidence Index
% Col 9   Average fit degrees)
%
%
%
% 
%
function output= load_ebsd(filename, numCols)



fd = fopen(filename);

% remove first line
for i = 1:8
    sidewidth = fgetl(fd);
end
%sidewidth = str2double(sidewidth);
if(numCols == 9)
    output = fscanf(fd, '%g %g %g %d %d %d %g %g %g', [numCols, inf]);
elseif(numCols == 10)
    output = fscanf(fd, '%g %g %g %d %d %d %g %g %g %g', [numCols, inf]);
end
output = output';

fclose(fd);