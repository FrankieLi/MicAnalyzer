function [Mask, Mask_std] = StdPeakMask(Image, radius)

Mask  = Image;
Mask_std = zeros(1024, 1024);
for i = 1:1024
   
    for j = 1:1024
        
        xBottom = max(i - radius, 1);
        xTop = min(i + radius, 1024);
        
        yBottom = max(j - radius, 1);
        yTop = min(j + radius, 1024);
        
        tmp = double(Image(:, xBottom:xTop, yBottom:yTop));
        
        tmp = RemoveOutlier( tmp(:) );
        tmpStd = std( tmp );  % can use IQR as well - better outlier
                                            % detection, tighter the bound
        
        tmpMedian = median( tmp );
        intensity = Mask(:, i, j);

        Mask( abs(intensity(:) - tmpMedian) < (3* tmpStd), i, j) = 0;
        Mask_std(i, j) = tmpStd;
    end
    
end
