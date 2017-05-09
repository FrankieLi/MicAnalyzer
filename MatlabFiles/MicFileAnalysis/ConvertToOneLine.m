function ConvertToOneLine(filename,outfile)

if nargin ~= 2
    error('Proper Usage: ConvertToOneLine(filename (cost file), outputName)');
end


file = textread(filename);
N_lines = size(file,1);
N_tomake = N_lines / 7 ;  %each line has 4 entries and there are 28 entries in the standard format

row_mtx = ones(7,4);

for i=1:N_tomake
     row_new = i + ones(7,4);
     row_mtx = [row_mtx; row_new];
end

column = [1:4; 5:8; 9:12; 13:16; 17:20; 21:24; 25:28];
column_mtx = [];

for j=1:N_tomake
    column_mtx = [column_mtx; column];
end

for x=1:N_lines
    for y=1:4
        rowN = row_mtx(x,y);
        colN = column_mtx(x,y);
        
        New(rowN, colN) = file(x,y);
    end
end

size_New = size(New,1);

fid = fopen(outfile, 'w');

for q=1:size_New
    fprintf(fid, '%4i\t  %4i\t %7.6f\t %07.6f\t %07.6f\t %07.6f\t %07.6f\t %07.6f\t %07.6f\t %7.6f\t %7.6f\t %7.6f\t %7.6f\t %7.6f\t %7.6f\t %7.6f\t %7.6f\t %7.6f\t %7.6f\t %7.6f\t %7.6f\t %7.6f\t %7.6f\t %7.6f\t %07.6f\t  %07.6f\t %07.6f\t %3i\n', New(q,1), New(q,2), New(q,3), New(q,4), New(q,5), New(q,6), New(q,7), New(q,8), New(q,9), New(q,10), New(q,11), New(q,12), New(q,13), New(q,14), New(q,15), New(q,16), New(q,17), New(q,18), New(q,19), New(q,20), New(q,21), New(q,22) , New(q,23), New(q,24), New(q,25), New(q,26), New(q,27), New(q,28));
end
fclose(fid);