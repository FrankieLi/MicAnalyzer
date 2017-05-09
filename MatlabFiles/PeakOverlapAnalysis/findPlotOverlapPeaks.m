%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  Action: Calls crossOmegaAtL for each of L1, L2, and L3, find
%  experimental peaks that are overlapping, and find their respective peaks
%  from the raw file.  The raw files corrosponding to the specific peak
%  file is specified in L1Range, L2Range, and L3Range.  smLen is the
%  smoothing length for each pixel found in the peak.  numCorr specifies
%  the number of files before and after a current file to be correlated
%  
%
%


%function findPlotOverlapPeaks(prefix, min, max, ext, numCorr, smLen,... 
 %                               L1Range, L2Range, L3Range)
                            

 
prefix = 'C:\documents and Settings\notme\my Documents\suterResearch\CurrentWork\PeakMatchTest\data\f1\Au1'
rawfilePrefix = 'C:\documents and Settings\notme\my Documents\suterResearch\Au_inRuby\Au_inRuby_00'
start = 1
stop = 100
numCorr = 0
smLen = 1
offset = 0;
threshold = 5;


L1_tif_start = 0;
L2_tif_start = 101;
L3_tif_start = 202;
% 
% 
                             
[L1_output, L1_AllImg, L1_overlapRange]= crossOmegaAtL(prefix, start, stop, 'f1', numCorr, smLen);
[L2_output, L2_AllImg, L2_overlapRange]= crossOmegaAtL(prefix, start, stop, 'f2', numCorr, smLen);
[L3_output, L3_AllImg, L3_overlapRange]= crossOmegaAtL(prefix, start, stop, 'f3', numCorr, smLen);
 
 


% find the list of overlap that occurs for L1, L2, and L3, with offset
% defined

L1_match_matrix = L1_output(:, :, 2);
L2_match_matrix = L2_output(:, :, 2);
L3_match_matrix = L3_output(:, :, 2);


%%%
%   find the omega where all three L locations have overlap between
%   experimental and simulation
%
matrixSize = size(L1_match_matrix);
rowOfInterest = ceil(matrixSize(2)/2) + offset;  % find the row with the proper offset

L1_matches = find(L1_match_matrix(:, rowOfInterest) > threshold);
L2_matches = find(L2_match_matrix(:, rowOfInterest) > threshold);
L3_matches = find(L3_match_matrix(:, rowOfInterest) > threshold);


findvecLength = max([max(L1_matches); max(L2_matches); max(L3_matches)]);

L1_findvec = zeros(findvecLength, 1);
L2_findvec = zeros(findvecLength, 1);
L3_findvec = zeros(findvecLength, 1);

L1_findvec(L1_matches) = 1;
L2_findvec(L2_matches) = 1;
L3_findvec(L3_matches) = 1;

ThreeL_Overlap = L1_findvec & L2_findvec & L3_findvec;
findvec = find(ThreeL_Overlap > 0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Actually plotting the peaks on a subplot
%
%



range = zeros(1, 4);

plotSideLength = 5;

for i =1:length(findvec)
   
    
    imgIndex = (i-1)*plotSideLength +1;
    subplot(plotSideLength, plotSideLength, imgIndex);
    hold on;
    %% plot the smeared peaks 
    % L1
    [y, x] = find(L1_AllImg{findvec(i), 1} > 0);
    plot(x, y, 'rx');
    
    [y, x] = find(L1_AllImg{findvec(i), 2} > 0);
    plot(x, y, 'ko');
    
    %L2
    [y, x] = find(L2_AllImg{findvec(i), 1} > 0);
    plot(x, y, 'gx');
    
    [y, x] = find(L2_AllImg{findvec(i), 2} > 0);
    plot(x, y, 'ko');
    
    %L3
    [y, x] = find(L3_AllImg{findvec(i), 1} > 0);
    plot(x, y, 'bx');
    
    [y, x] = find(L3_AllImg{findvec(i), 2} > 0);
    plot(x, y, 'ko');
 
    axis([0, 1024, 0, 1024]);
%       axis(L1_overlapRange(findvec(i), 1, :));  

 
    hold off;
    
    %%
    % plot original peaks
    %
    %
    % black + -- simulated peaks
    %

    imgIndex = imgIndex + 1;
    subplot(plotSideLength, plotSideLength, imgIndex);
    hold on;
   
    
    [y, x] = find(L1_AllImg{findvec(i), 3} > 0);
    plot(x, y, 'rx');
    
%    [y, x] = find(L1_AllImg{findvec(i), 4} > 0);
%    plot(x, y, 'k+');

%    [y, x] = find(L2_AllImg{findvec(i), 3} > 0);
%    plot(x, y, 'gx');
    
%    [y, x] = find(L2_AllImg{findvec(i), 4} > 0);
%    plot(x, y, 'k+');

%    [y, x] = find(L3_AllImg{findvec(i), 3} > 0);
%    plot(x, y, 'bx');
    
%    [y, x] = find(L3_AllImg{findvec(i), 4} > 0);
%    plot(x, y, 'k+');

    axis([0, 1024, 0, 1024]);
    hold off;

    
    background = 430;
    max_peak = 5000;
    
    imgIndex = imgIndex + 1;
    tif_index = findvec(i) + L1_tif_start
    fname = getRawFilename(rawfilePrefix, tif_index);
    snp = imread(fname);
    subplot(plotSideLength, plotSideLength, imgIndex);
    imagesc(snp, [background, max_peak]);
%    colormap(gray)
    
    imgIndex = imgIndex + 1;    
    tif_index = findvec(i) + L2_tif_start
    fname = getRawFilename(rawfilePrefix, tif_index);
    imread(fname);
    snp = imread(fname);
    subplot(plotSideLength, plotSideLength, imgIndex);
    imagesc(snp);    
    imagesc(snp, [background, max_peak]);
%    colormap(gray)
    
    imgIndex = imgIndex + 1;
    tif_index = findvec(i) + L3_tif_start
    fname = getRawFilename(rawfilePrefix, tif_index);
    imread(fname);
    snp = imread(fname);
    subplot(plotSideLength, plotSideLength, imgIndex);
    imagesc(snp);    
    imagesc(snp, [background, max_peak]);
   % colormap(gray)
    
end
