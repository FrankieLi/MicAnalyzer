%%
%%
%%
%%  Change Grid files format to standard format, which
%%  is the same as the mic format
%%


%% ======= Grid format
%%
%% snp is a nx * ny *k matrix, with the first two dimensions
%% being the grid dimensions, and third dimension holds the
%% orientation data
%%
%%  k = 
%%  1-3   Position
%%  4     Grain size
%%  7:9   Orientation

%% ======= Std (mic) format
%% File Format:
%% Col 1-3 x, y, z
%% Col 4   1 = triangle pointing up, 2 = triangle pointing down
%% Col 5 generation number; triangle size = sidewidth /(2^generation number )
%% Col 6 - phase (1 = filled, 0 empty);
%% Col 7-9 orientation
%% Col 10  Confidence
%%


%%  WARNING - I wouldn't use this for anything more than
%%            debuggin
function stdSnp = DataGrid2StdFormat(snp)



snpSize = size(snp);
stdSnp = zeros(snpSize(1)*snpSize(2), 10);

%
%
%  Convert grid to mic files.
%




% slow but works
k =1;
for i = 1:snpSize(1)
    for j = 1:snpSize(2)
    
        stdSnp(k, 1:3) = squeeze(snp(i,j, 1:3))';
        stdSnp(k, 7:9) = squeeze(snp(i,j, 7:9))';
        stdSnp(k, 6) = any(snp(i, j, 7:9)) * 1;
        stdSnp(k, 10) = squeeze(snp(i, j, 10))';  
        k = k +1;
    end
end

