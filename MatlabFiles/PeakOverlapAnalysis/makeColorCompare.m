function output = makeColorCompare(start, stop, cx_path, my_path, orig_path, diff_path, prefix, ext)


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
    origFile = sprintf( '%s/%s.tif',orig_path, filename);
    
    
    diffFile = sprintf('%s/%s_diff.tif',diff_path, filename);
    
    
    cxSnp = load(cxFile);
    mySnp = load(myFile);
    orig = imread(origFile);
    
    cxSnp(:, 1:2) = cxSnp(:, 1:2) + 1;
    mySnp(:, 1:2) = mySnp(:, 1:2) + 1;
    
    
    cxImg = uint16(fillImage(cxSnp, 1024, 1024));
    myImg = uint16(fillImage(mySnp, 1024, 1024));
    
    myImage = uint16(zeros(1024, 1024, 3));
    myImage(:, :, 1) = orig * 20;
    myImage(:, :, 2) = myImg * 40;
    myImage(:, :, 3) = cxImg * 40;
    
    imwrite(myImage, diffFile, 'tif');
end


