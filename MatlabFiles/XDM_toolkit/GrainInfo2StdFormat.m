

%%
%%
%%
%%  Change GrainInfo snp files format to standard format, which
%%  is the same as the mic format
%%


%% ////////////////////// EBSD File format
%% //
%% // # Header: Project1::wire_350X_test2_6 cleaned sect 1::All data::Grain 
%% // Size   1/22/2008
%% // #
    
%% grainAveInfo(i, 1:3) = grainAveLoc;
%% grainAveInfo(i, 4) = grainIDs(i);
%% grainAveInfo(i, 5:7) = grainAveOrient * 180 /pi;(in degree already)
%% grainSize = size(findvec);  
%% grainAveInfo(i, 8) = grainSize(1);  % number of voxels included in a grain
%% grainAveInfo(i, 9) = mean(grainSnp(findvec, 9));


%% ======= Std (mic) format
%% File Format:
%% Col 1-3 x, y, z
%% Col 4   1 = triangle pointing up, 2 = triangle pointing down
%% Col 5 generation number; triangle size = sidewidth /(2^generation number )
%% Col 6 - phase (1 = filled, 0 empty);
%% Col 7-9 orientation
%% Col 10  Confidence
%%



function GrainInfo2StdFormat(snp)

snpSize = size(snp);
stdSnp = zeros(snpSize(1), 10);

stdSnp(:, 1:3) = snp(:, 1:3);
stdSnp(:, 7:9) = snp(:, 5:7);
stdSnp(:, 6) = 1;
stdSnp(:, 10) = snp(:, 7);

