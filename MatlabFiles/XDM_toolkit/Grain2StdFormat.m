%%
%%
%%
%%  Change .grain files format to standard format, which
%%  is the same as the mic format
%%
%% ====== Grain format
%% Col 1-3 x, y, z
%% Col 4   Grain index
%% Col 5-7 orientation
%% Col 8   Grain Size
%% Col 9   Confidence

%% ======= Std (mic) format
%% File Format:
%% Col 1-3 x, y, z
%% Col 4   1 = triangle pointing up, 2 = triangle pointing down
%% Col 5 generation number; triangle size = sidewidth /(2^generation number )
%% Col 6 - phase (1 = filled, 0 empty);
%% Col 7-9 orientation
%% Col 10  Confidence
%%



function stdSnp = Grain2StdFormat(snp)



snpSize = size(snp);
stdSnp = zeros(snpSize(1), 10);

stdSnp(:, 1:3) = snp(:, 1:3);
stdSnp(:, 7:9) = snp(:, 5:7);
stdSnp(:, 6) = 1;
stdSnp(:, 10) = snp(:, 9);

