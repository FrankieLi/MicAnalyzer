%%% NOTES ON 2048 x 2048 CoolSnap camera
%
% Raw tif file to .d# file -> rotation is performed in reduction.  
% Via visual inspection, j_reduction = 2048 - j_tif.  In d file, 
% column 1 is horizontal (j), column 2 is vertical.
%
%

%prefix_intensity_list = 'C:\Research\Jan2010\FromJan10\test_bg20p50\AuTest';
%prefix_intensity_list = '/home/cheffera/Research/17-oct09/Heff2010DataReduction/test/test_bg20p50/AuTest';
prefix_intensity_list = 'C:\Research\Jan2010\Guesthouse\1Grain_1\cofI_jan2010\1grain_50mic_1_';
CenterGuess(1,1) = 512; % X center of direct beam @ L1 (1001 was found by looking at the tif images)
%CenterGuess(1,1) = 1045; % X center of direct beam @ L1 (1001 was found by looking at the tif images)
CenterGuess(1,2) = 1031;% Y center of direct beam @ L1
CenterGuess(2,1) = 518;% X center of direct beam @ L2
%CenterGuess(2,1) = 1045;% X center of direct beam @ L2
CenterGuess(2,2) = 1024;% Y center of direct beam @ L2
CenterGuess(3,1) = 516;% X center of direct beam @ L3
%CenterGuess(3,1) = 1045;% X center of direct beam @ L3
CenterGuess(3,2) = 1021;  % Y center of direct beam @ L3
Energy = 50; %keV
PixPitch_mm = 0.004; %mm/pixel (Currently based on July09)

zList = 1;
d_start = [1, 361, 721];
N_pix_lowerThresh = 20;
N_pix_upperThresh = 500; %added 10/18
N_omegas = 100;
min_group_pixels = 1;
d1_ext = '.d1.intens';
d2_ext = '.d2.intens';
d3_ext = '.d3.intens';
beam_edge = [500,530, 1024-20, 1024+20];
det_size = 1024;

%Partition spots into appropriate 2Theta groupings
[Spots_L1_good, Spots_L2_good, Spots_L3_good, Spots_L1, Spots_L2, Spots_L3] = GetSpots_2010(prefix_intensity_list, zList, d_start, N_pix_lowerThresh, N_omegas,CenterGuess,min_group_pixels, d1_ext, d2_ext, d3_ext,beam_edge, N_pix_upperThresh, det_size);
%Make sure the assignment and groupings are visually correct - user verification
Spots_L1_final = ConfirmRadiusTwoThetaAssign(Spots_L1_good, det_size, Spots_L1);
Spots_L2_final = ConfirmRadiusTwoThetaAssign(Spots_L2_good, det_size, Spots_L2);
Spots_L3_final = ConfirmRadiusTwoThetaAssign(Spots_L3_good, det_size, Spots_L3);


[L1Info, L2Info, L3Info] = GetL1s_Au(Spots_L1_final, Spots_L2_final, Spots_L3_final, Energy, PixPitch_mm, det_size);


L1Info
L2Info
L3Info