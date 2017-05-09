function output = peakDifference(start, stop, cx_path, my_path, diff_path, prefix, ext)


numFiles = stop - start + 1;




for i = start:stop
    
    
    if(i < 10)
      filename = sprintf('%s0000%g', prefix, i);
    elseif(i < 100)
      filename = sprintf('%s000%g', prefix, i);
    else
      filename = sprintf('%s00%g', prefix, i);
    end
    
    cxFile = sprintf( '%s/%s.%s',cx_path, filename, ext);
    myFile = sprintf( '%s/%s.%s',my_path, filename, ext);
    
    inCxNotMineFile = sprintf('%s/%s_cx.tif',diff_path, filename);
    inMineNotCxFile = sprintf('%s/%s_mine.tif',diff_path, filename);    
    
    diffFile = sprintf('%s/%s.tif', diff_path, filename);
    
    cxSnp = load(cxFile);
    mySnp = load(myFile);
    
    mySnp(:, 1:2) = mySnp(:, 1:2) + 1;
    
    
    cxImg = fillImage(cxSnp, 1024, 1024);
    myImg = fillImage(mySnp, 1024, 1024);
    
    
    inCxImg = cxImg > 0;
    inMyImg = myImg > 0;
    
    xorImg = xor(inCxImg, inMyImg);
    
    inMineNotCx = myImg .* ((~inCxImg) & (inMyImg));
    inCxNotMine = cxImg .* (inCxImg) & (~inMyImg);    
    
    
    diffImage = (cxImg - myImg) .* xorImg ;
    imwrite(diffImage, diffFile, 'tiff');
    imwrite(inMineNotCx, inMineNotCxFile, 'tiff');
    imwrite(inCxNotMine, inCxNotMineFile, 'tiff');
end


