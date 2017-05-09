%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% MultiLayerSpots_3Ls_2010.m
% 
% Function filters GetCenterOfIntensity results so that only spots with pixel coverage 
%       indicative of the sample diffraction spots are used.
%
%
% Input - prefix_intensity_List = list of prefixs to .intens files
%         zList = list of layers that are measured (should be 1 unless you're doing a volume)
%         d#_start_List = file # for first omega interval in that detector distance
%         N_pix_threshold = minimum # of pixels in peak  
%         N_pix_upperThresh = maximum # of pixels in peak 
%         N_omegas = # omega files per detector distance
%         d#_extension = '.d1.intens', etc.  
%
%
% Output - SpotList = master list consisting of 10 cols:
%           col 1,2 = (j,k) center of intensity
%           col 3 = # of pixels in peak
%           col 4,5 = vertical pixel edges
%           col 6,7 = horizontal pixel edges
%           col 8 = layer # (z)
%           col 9 = omega interval number
%           col 10 = detector distance (1,2,or 3)
%
%          SpotList_L#, same as SpotList, except only values with col 10 =
%          # retained.
%
% Functions called:
%        ReorgSpotData.m
%        FilterBySpotSize.m
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [SpotList, SpotList_L1, SpotList_L2, SpotList_L3] = MultiLayerSpots_3Ls_2010(prefix_intensity_List, zList, d1_start_List, d2_start_List, d3_start_List, N_pix_lowerThresh,N_pix_upperThresh, N_omegas, d1_extension, d2_extension, d3_extension)

%use strvcat( ' ', ' ') to create prefix_intensity_List

N_zs = length(zList);
d1_end_List = d1_start_List + N_omegas - 1;
d2_end_List = d2_start_List + N_omegas - 1;
d3_end_List = d3_start_List + N_omegas - 1;
SpotList = [];
SpotList_L1 =[];
SpotList_L2 = [];
SpotList_L3 = [];



for i=1:N_zs
    for j = 1:N_omegas

        %File Number
        cur_d1 = j + d1_start_List(i) - 1;
        cur_d2 = j + d2_start_List(i) - 1;
        cur_d3 = j + d3_start_List(i) - 1;

        %Read file
        d1_Str = padZero(cur_d1,5);
        d2_Str = padZero(cur_d2,5);
        d3_Str = padZero(cur_d3,5);

        strcat(prefix_intensity_List(i,:), d1_Str, d1_extension)
        d1 = textread(strcat(prefix_intensity_List(i,:), d1_Str, d1_extension));
        d2 = textread(strcat(prefix_intensity_List(i,:), d2_Str, d2_extension));
        d3 = textread(strcat(prefix_intensity_List(i,:), d3_Str, d3_extension));


        %Reorganize column contents of the omega files.
        d1 = ReorgSpotData(d1);
        d2 = ReorgSpotData(d2);
        d3 = ReorgSpotData(d3);

          %Produce list of valid spots that fall in thresholded pixel size
          %values

        if (size(d1,1) > 0) %If this omega contains spots
            [d1_valid, SpotList, SpotList_L1] = FilterBySpotSize(d1, N_pix_lowerThresh,N_pix_upperThresh, i, j, 1, SpotList, SpotList_L1);
        end

        if (size(d2,1) > 0)
            [d2_valid, SpotList, SpotList_L2] = FilterBySpotSize(d2, N_pix_lowerThresh,N_pix_upperThresh, i, j, 2, SpotList, SpotList_L2);
        end

        if (size(d3,1) > 0)
            [d3_valid, SpotList, SpotList_L3] = FilterBySpotSize(d3, N_pix_lowerThresh,N_pix_upperThresh, i, j, 3, SpotList, SpotList_L3);
        end
    end
end