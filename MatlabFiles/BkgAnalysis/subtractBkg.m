function output = subtractBkg(filename, bkgFilename)


snp = imread(filename);
snpBkg = imread(bkgFilename);

diff = double(snp) - double(snpBkg);
diff = diff .* (diff > 0);
diff = uint16(diff);

output = diff;
