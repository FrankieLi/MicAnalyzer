%
%  indexStart is either 0 or 1
%
%
%%
function listToTif(filename, indexStart, numCol, numRow, list)

list(:, 1:2) = list(:, 1:2) + (1 - indexStart);

im = fillImage(list, numCol, numRow);

imwrite(uint16(im), filename, 'tiff');