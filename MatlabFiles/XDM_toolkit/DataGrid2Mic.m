%
%  DataGrid - the gridded mic file
%  sidewidth - sidewidth of the triangle
%  generation - generation number to be used - specification of different
%               generation is to ensure that the mic file doesn't come out
%               with empty white triangles between triangles.
function output = DataGrid2Mic(DataGrid, sw, generation)

output = DataGrid2StdFormat(DataGrid);


output(:, 5) = generation;

% make all triangles pointing up
output(:, 4) = 1;
findvec = find(output(:, 6) >0);
output = output(findvec, :);