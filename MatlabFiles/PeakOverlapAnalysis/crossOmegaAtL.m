%%
%
%  Given a prefix, suffix, and the file start and stop number, and
%  the number of files to correlate, we will look to see if these
%  files have overlap accross different files **For a specific L location**
%  denoted by the extension of the file, specified as a separate parameter
%
%  Input files are output of the peak matching program (Suter's program)
%
%
%
%
%  AllImg is a n by 4 cell of [imgExp, imgSim, origExp, origSim]
%
%%

function [output, AllImg, overlapRange]= crossOmegaAtL(prefix, start, stop, ext, numCorr, smLen)


snp = cell(stop - start+1, 2);
  
AllImg = cell(stop - start+1, 2);


AllOverlap = zeros(stop - start + 1, 2 * numCorr + 1, 2);
overlapRange = zeros(stop - start + 1, 2 * numCorr + 1, 4);
for i = start:stop
    

    if(i < 10)
      filename = sprintf('%s_00%g', prefix, i);
    elseif(i < 100)
      filename = sprintf('%s_0%g', prefix, i);
    else
      filename = sprintf('%s_%g', prefix, i);
    end

    fName = sprintf('%s.%s', filename, ext);
    tmp = dlmRead(fName);
    snp{i, 1} = tmp(2:end, :);
    snp{i, 2} = filename;   
    [AllImg{i, 1}, AllImg{i, 2}, AllImg{i, 3}, AllImg{i, 4}] = toImage(snp{i, 1}, 1024, 1024, smLen);
    
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
           
           [overlapX, overlapY] = find(tmp > 0);
           if(length(overlapX) >1)
               overlapRange(i, n, 1) = min(overlapX(2:end));
               overlapRange(i, n, 2) = max(overlapX);
           end
           if(length(overlapY) > 1)
               overlapRange(i, n, 3) = min(overlapY(2:end));           
               overlapRange(i, n, 4) = max(overlapY);
           end   
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
function [imgExp, imgSim, origExp, origSim ]= toImage(snp, numRows, numCols, smoothLen)


imgExp = logical(zeros(numRows, numCols));
imgSim = logical(zeros(numRows, numCols));
origExp = imgExp;
origSim = imgSim;

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
        origExp(snp(i, 3), snp(i, 4)) = 1;
    end
    
    
    %%%
    %
    %  Save matched peaks onto the original files
    %
    if ((snp(i, 1) > 0) & (snp(i, 2) > 0))
        origSim(snp(i, 1), snp(i, 2)) = 1;
        origExp(snp(i, 1), snp(i, 2)) = 1;
        imgExp(snp(i, 1), snp(i, 2)) = 1;
        imgSim(snp(i, 1), snp(i, 2)) = 1;
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

    %%%%%%%%%%%
    %  Save simulated peaks
    %
    if ((snp(i, 5) > 0) & (snp(i, 6) > 0))
        imgSim(snp(i, 5), snp(i, 6)) = 1;
        origSim(snp(i, 5), snp(i, 6)) = 1;
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
