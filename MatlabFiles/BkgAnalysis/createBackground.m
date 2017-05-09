%
%  createBackground
%
%
%  Attempt to create a background image given the list of all
%  images taken for one detector distance.  For the first version,
%  we will first calculate the mean and variance of the system.  The
%  backround will be taken at mean + sqrt(variance)
%
%  To speed up the process, variance will be calculated using
%  var = E(x^2) - E(x)^2
%
%  A more sophisticated method may be employed in the future
%

function [bkg, average, s_var, s_median, E_x, E_sqx] = createBackground(prefix, start, stop,...
                                                                        bkgPrefix, imageSize, ext)

if( nargin < 6 )
    ext  = 'tif';
end

bkgFilename = [ bkgPrefix, '.', ext];

E_x = zeros( imageSize(1), imageSize(2) );
E_sqx = zeros( imageSize(1), imageSize(2) );
s = uint16(zeros(stop - start + 1, imageSize(1), imageSize(2) ));
currentMin = ones( imageSize(1), imageSize(2) ) * 1e12;

% currentMedian = ones(3, 1024, 1024);
% lowerElement(1, :, :) = -1e12;
% currentMedian(2, :, :) = 0;
% upperElement(3, :, :) = 1e12;
% numElement = 0;
for i=start:stop
   

curNumString = padZero(i, 5);
filename = sprintf('%s%s.%s', prefix, curNumString, ext);
    
    snp = imread(filename);
    s(i-start+1, :, :) = snp;
    E_x = E_x + single(snp);
    E_sqx = E_sqx + single(snp).^2;
    
    
    %  find the median by flags
    % numElement = numElement + 1;
    %
    % not working yet
    
    %  take the min by using flags
    currentMin = (snp > currentMin).* currentMin + (snp <= currentMin) .*double(snp);
end
E_x = E_x / (stop -start + 1);
E_sqx = E_sqx / (stop -start+ 1);

s_var = E_sqx - E_x.^2;

s_std = sqrt(s_var);

% break the matrix into smaller this because the amount of space required is too much
s_median = zeros( imageSize(1), imageSize(2) );

increment = 32;
i_start = 1;
i_stop = increment;
for i = 1: floor( imageSize(1) / increment )+1
    j_start = 1;
    j_stop = increment;
    
    i_stop = min( [ i_stop, imageSize(1) ] );
    
    for j = 1:floor( imageSize(2) / increment )+1
        j_stop = min( [ j_stop, imageSize(2) ] );
        s_median(i_start:i_stop, j_start:j_stop) = median(double(s(:, i_start:i_stop, j_start:j_stop)), 1);
        j_start = j_start + increment;
        j_stop = j_stop + increment;
    end
    
    i_start = i_start + increment;
    i_stop = i_stop + increment;
end


%bkg = currentMin .* (s_median < s_std) + E_x .* (s_median > s_std);

bkg = s_median;
imwrite(uint16(s_std), [bkgPrefix, '_bkg_Std.tiff'], 'tiff');
imwrite(uint16(bkg), bkgFilename,  'tiff');
%bkg = E_x;%+ sqrt(var);
average = E_x;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  now in a separate file
% function intString = padZero(n, numLen)
% 
% if(n ~= 0)
%   numDigit = floor(log10(n)) + 1;
% else
%   numDigit = 1;
% end
% 
% intString = num2str(n);
% 
% for i = (numDigit+1):numLen
% 
%   intString = sprintf('0%s', intString);
% 
% end
