%%
%
%  Given a prefix, suffix, and the file start and stop number, and
%  the number of files to correlate, we will look to see if these
%  files have overlap accross different files.
%
%  Input files are output of the peak matching program (Suter's program)
%
%%

function [output, AllImg]= crossOmegaCompare(prefix, start, stop, numCorr, smLen)


snp = cell(stop - start+1, 2);
  
AllImg = cell(stop - start+1, 2);


AllOverlap = zeros(stop - start+1   , 2*numCorr+1, 2);

for i = start:stop
    

    if(i < 10)
      filename = sprintf('%s00%g', prefix, i);
    elseif(i < 100)
      filename = sprintf('%s0%g', prefix, i);
    else
      filename = sprintf('%s%g', prefix, i);
    end

    fName = sprintf('%s.f1', filename);
    f1 = dlmread(fName);
    
    fName = sprintf('%s.f2', filename);
    f2 = dlmread(fName);
    
    fName = sprintf('%s.f3', filename);
    f3 = dlmread(fName);
    
    % the first row isn't useful
    
    snp{i, 1} = [f1(2:end, :); f2(2:end, :); f3(2:end, :)];
    snp{i, 2} = filename;   
    [AllImg{i, 1}, AllImg{i, 2}] = toImage(snp{i, 1}, 1024, 1024, smLen);
    
end

for i = start:stop
    n = 1;
    
    Overlap = zeros(2*numCorr +1, 2);
    for j = -numCorr:numCorr
        
       
        otherFile = i +j;
        Overlap(n, 1) = otherFile;
        
        if ((otherFile > start) & (otherFile < stop))
            
            % comparing i-th file (current) with other files
           tmp = AllImg{i, 1} & AllImg{otherFile, 2};
           Overlap(n, 2) = length(nonzeros(tmp));
            
        end
        n = n + 1;
    end
    
    AllOverlap(i, :, :) = Overlap;
    
end
    
output = AllOverlap;
    
%%%%
%  Convert snp (columns:  first 2 are pixel position where
%  both experiment and simulation overlap; second 2 are pixel
%  positions of only experiments; third 2 are pixel positions
%  of only simulations
%%%
function [imgExp, imgSim ]= toImage(snp, numRows, numCols, smoothLen)


imgExp = logical(zeros(numRows, numCols));
imgSim = logical(zeros(numRows, numCols));

snpLength = size(snp);

for i = 1:snpLength(1)
 
    %%
    %%  Simulated + Experimental peaks
%     if ((snp(i, 1) > 0) & (snp(i, 2) > 0))
%         imgSim(snp(i, 1), snp(i, 2)) = 1;
%         imgExp(snp(i, 1), snp(i, 2)) = 1;
%     end
%     
    
    if ((snp(i, 3) > 0) & (snp(i, 4) > 0))
        imgExp(snp(i, 3), snp(i, 4)) = 1;
    end
    
    
    for j = snp(i, 3)-smoothLen:snp(i, 3)+smoothLen
        for k = snp(i, 4)-smoothLen:snp(i, 4)+smoothLen
           if(j > 0 & j < numRows)
               if(k > 0 & k < numCols)
                   imgExp(j, k) = 1;   
               end
           end
        end
    end

    if ((snp(i, 5) > 0) & (snp(i, 6) > 0))
        imgSim(snp(i, 5), snp(i, 6)) = 1;
    end
    
    for j = snp(i, 5)-smoothLen:snp(i, 5)+smoothLen
        for k = snp(i, 6)-smoothLen:snp(i, 6)+smoothLen
           if(j > 0 & j < numRows)
               if(k > 0 & k < numCols)
                   imgSim(j, k) = 1;   
               end
           end
        end
    end
    
    
end
