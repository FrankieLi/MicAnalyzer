%%
%%
%%  findFittedOverlap
%%  Input:  path of the det_out files (f files) including the prefix:
%%  
%%  Example: for
%%
%%  /home/sfli/det_out/myFile_x920.f1
%%
%%  prefix1 will be
%%  '/home/sfli/det_out/myfile_x'
%%
%%  ext will be 'f1'
%%
%%  prefix1 and prefix2 indicates where the two sets of fits are located
%%
%%  start and stop are the starting and the stopping file numbers
%%
%%
%%  RETURN:  output is an array of size start-stop + 1 with the number of pixels 
%%           found overlapping the simulation and experimental peaks in
%%           simulation 1 but NOT in simulation 2.  In another words, this
%%           is the set of peaks that are contributing to the simulation
%%           results.
%%
function [output, AllImg] = findFittedOverlap( prefix1, prefix2, start, stop, ext, smLen)



  
AllImg = cell(stop - start+1, 2);

output = zeros(stop - start + 1, 1);
j = 1;
for i = start:stop
   
    numStr = padZero(i, 3);
    
    fName1 = sprintf('%s%s.%s', prefix1, numStr, ext);
    tmp = dlmRead(fName1);
    snp = tmp(2:end, :);
    AllImg{j, 1} = toImage(snp, 1024, 1024, smLen);
  
    fName2 = sprintf('%s%s.%s', prefix2, numStr, ext);
    tmp = dlmRead(fName2);
    snp = tmp(2:end, :);
    AllImg{j, 2} = toImage(snp, 1024, 1024, smLen);
    
    %
    %  In image1 AND NOT image 2  OR in image2 AND NOT image1
    %
    tmp = ( AllImg{j, 2} .* ~AllImg{j, 1} ) + ( AllImg{j, 1} .* ~AllImg{j, 2} ) ;

    findvec = find( tmp(:) > 0);
    output(j) = length(findvec);
    j = j + 1;
end

%%%%
%  Convert snp (columns:  first 2 are pixel position where
%  both experiment and simulation overlap; second 2 are pixel
%  positions of only experiments; third 2 are pixel positions
%  of only simulations
%%%
function overlapImg = toImage(snp, numRows, numCols, smoothLen)


overlapImg = logical(zeros(numRows, numCols));


findvec = find( snp(:, 1) >= 0 );
snp = snp(findvec, :);
snp(:, 1) = snp(:, 1) + 1;
snp(:, 2) = snp(:, 2) + 1;
snpLength = size(snp);

for i = 1:snpLength(1)
    overlapImg( snp(i, 1), snp(i, 2) ) = 1;
    
    for j = snp(i, 1)-smoothLen:snp(i, 1)+smoothLen
        for k = snp(i, 2)-smoothLen:snp(i, 2)+smoothLen
           if(j > 0 & j < numRows)
               if(k > 0 & k < numCols)
                   oerlapImg(j, k) = 1;   
               end
           end
        end
    end
    
end
