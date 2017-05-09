%
%
%  convertEBSD2Mic
%  Crude conversion between EBSD file to mic file
%  with fixed size
%
%

function output = convertEBSD2Mic(EBSD, sw, outname);

EBSD_size = size(EBSD);
mic = zeros(EBSD_size(1), 10);

mic(:, 7:9) = EBSD(:, 1:3) * 180/pi;
mic(:, 1) = EBSD(:, 4) - sw/2;
mic(:, 2) = EBSD(:, 5) - sw/2 * atan(30*pi/180);
mic(:, 4) = 1;
mic(:, 5) = 0;
mic(:, 6) = 1;
mic(:, 10) = EBSD(:, 7);


write_mic(mic, sw, outname);

output = mic;