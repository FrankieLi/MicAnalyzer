%%
%%
%%
%%  Change EBSD files format to standard format, which
%%  is the same as the mic format
%%


%% ////////////////////// EBSD File format
%% //
%% // # Header: Project1::wire_350X_test2_6 cleaned sect 1::All data::Grain 
%% // Size   1/22/2008
%% // #
%% // # Column 1-3: phi1, PHI, phi2 (orientation of point in radians)
%% // # Column 4-5: x, y (coordinates of point in microns)
%% // # Column 6:   IQ (image quality)
%% // # Column 7:   CI (confidence index)
%% // # Column 8:   Fit (degrees)
%% // # Column 9:   Grain ID (integer)
%% // # Column 10:  edge 
%% // # Column 11:  phase name

%% ======= Std (mic) format
%% File Format:
%% Col 1-3 x, y, z
%% Col 4   1 = triangle pointing up, 2 = triangle pointing down
%% Col 5 generation number; triangle size = sidewidth /(2^generation number )
%% Col 6 - phase (1 = filled, 0 empty);
%% Col 7-9 orientation
%% Col 10  Confidence
%%



function stdSnp = EBSD2StdFormat(snp)



snpSize = size(snp);
stdSnp = zeros(snpSize(1), 10);

stdSnp(:, 1:2) = snp(:, 4:5);
stdSnp(:, 7:9) = snp(:, 1:3) * 180/pi;  % EBSD data are in radian
stdSnp(:, 6) = 1;
stdSnp(:, 10) = snp(:, 7);

