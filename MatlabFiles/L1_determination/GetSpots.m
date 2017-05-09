function [Spots_L1_final, Spots_L2_final, Spots_L3_final] = GetSpots(prefix_intensity_list, zList, d_start, N_pix_threshold, N_omegas,CenterGuess,min_group_pixels, d1_ext, d2_ext, d3_ext, beam_edge, N_pix_upperThresh)
    %Create a list containing spots on L1 and L2 that contain at least
    
    d1_start_List = d_start(1);
    d2_start_List = d_start(2);
    d3_start_List = d_start(3);
    X_cent_guess_L1 = CenterGuess(1,1);
    Y_cent_guess_L1 = CenterGuess(1,2);
    X_cent_guess_L2 = CenterGuess(2,1);
    Y_cent_guess_L2 = CenterGuess(2,2);    
    X_cent_guess_L3 = CenterGuess(3,1);
    Y_cent_guess_L3 = CenterGuess(3,2);
    beam_min_x = beam_edge(1);
    beam_max_x = beam_edge(2);
    beam_min_y = beam_edge(3);
    beam_max_y = beam_edge(4);
    
    %Create list of presumed scattering pixels
    [SpotList, SpotList_L1, SpotList_L2, SpotList_L3] = MultiLayerSpots_3Ls(prefix_intensity_list, zList, d1_start_List, d2_start_List, d3_start_List, N_pix_threshold, N_pix_upperThresh, N_omegas, d1_ext, d2_ext, d3_ext);
    
    
    % Removal of pixels that are obviously direct beam
    L1_beam_xLess = find(SpotList_L1(:,1) < beam_max_x); %Note that 1st column is horizontal information
    L1_beam_xMore = find(SpotList_L1(:,1) > beam_min_x);
    L2_beam_xLess = find(SpotList_L2(:,1) < beam_max_x);
    L2_beam_xMore = find(SpotList_L2(:,1) > beam_min_x);
    L3_beam_xLess = find(SpotList_L3(:,1) < beam_max_x);
    L3_beam_xMore = find(SpotList_L3(:,1) > beam_min_x);
    
    L1_beam_yLess = find(SpotList_L1(:,2) < beam_max_y);
    L1_beam_yMore = find(SpotList_L1(:,2) > beam_min_y);
    L2_beam_yLess = find(SpotList_L2(:,2) < beam_max_y);
    L2_beam_yMore = find(SpotList_L2(:,2) > beam_min_y);
    L3_beam_yLess = find(SpotList_L3(:,2) < beam_max_y);
    L3_beam_yMore = find(SpotList_L3(:,2) > beam_min_y);
    
    %Find peaks within direct beam by having both x & y center in beam window
    L1_x_candidate = intersect(L1_beam_xLess, L1_beam_xMore);
    L2_x_candidate = intersect(L2_beam_xLess, L2_beam_xMore);
    L3_x_candidate = intersect(L3_beam_xLess, L3_beam_xMore);
    
    L1_y_candidate = intersect(L1_beam_yLess, L1_beam_yMore);
    L2_y_candidate = intersect(L2_beam_yLess, L2_beam_yMore);
    L3_y_candidate = intersect(L3_beam_yLess, L3_beam_yMore);
    
    L1_db_index = intersect(L1_x_candidate, L1_y_candidate);
    L2_db_index = intersect(L2_x_candidate, L2_y_candidate);
    L3_db_index = intersect(L3_x_candidate, L3_y_candidate);
    
    SpotList_L1(L1_db_index,:) = [];
    SpotList_L2(L2_db_index,:) = [];
    SpotList_L3(L3_db_index,:) = [];
    
    
    Spots_L1 = SpotList_L1;
    Spots_L2 = SpotList_L2;
    Spots_L3 = SpotList_L3;
    
    size(Spots_L1)
    size(Spots_L2)
    size(Spots_L3)

    plot(SpotList_L3(:,1), SpotList_L3(:,2), '.')
    axis equal
    axis([ 0 2048 0 2048])
    axis ij
    
    
    %Calculate the radius of the points - Assign to row 11
    for i=1:size(SpotList_L1,1)
        Spots_L1(i,11) = sqrt((SpotList_L1(i,1) - X_cent_guess_L1)^2 + (SpotList_L1(i,2) - Y_cent_guess_L1)^2);
    end

    for i=1:size(SpotList_L2,1)
        Spots_L2(i,11) = sqrt((SpotList_L2(i,1) - X_cent_guess_L2)^2 + (SpotList_L2(i,2) - Y_cent_guess_L2)^2);
    end

    for i=1:size(SpotList_L3,1)
        Spots_L3(i,11) = sqrt((SpotList_L3(i,1) - X_cent_guess_L3)^2 + (SpotList_L3(i,2) - Y_cent_guess_L3)^2);
    end
    
    N_spots1 = size(Spots_L1,1);
    N_spots2 = size(Spots_L2,1);
    N_spots3 = size(Spots_L3,1);

    %Sort by radial size 
    size(Spots_L1)
    size(Spots_L2)
    size(Spots_L3)
    Spots_L1 = sortrows(Spots_L1,11);
    Spots_L2 = sortrows(Spots_L2,11);
    Spots_L3 = sortrows(Spots_L3,11);

    figure(10)
    plot(Spots_L3(:,3),Spots_L3(:,11), '.')
    figure(11)
    plot(Spots_L1(:,3),Spots_L1(:,11), '.')
    %Find Spikes indicating new radius
    for i=2:N_spots2
        Spots_L2(i,12) = Spots_L2(i,11) - Spots_L2(i-1,11);
    end

    for j=2:N_spots1
        Spots_L1(j,12) = Spots_L1(j,11) - Spots_L1(j-1,11);
    end

    for j=2:N_spots3
        Spots_L3(j,12) = Spots_L3(j,11) - Spots_L3(j-1,11);
    end
    
    %Find these locations where there's a jump in radius, breaks are indicies
    %where jumps occur
    breaks1 = find(Spots_L1(:,12) > 2);
    breaks2 = find(Spots_L2(:,12) > 2);
    breaks3 = find(Spots_L3(:,12) > 2);

    breaks1_start(1) = 1;
    breaks2_start(1) = 1;
    breaks3_start(1) = 1;

    Nb1 = length(breaks1);
    Nb2 = length(breaks2);
    Nb3 = length(breaks3);
    
    breaks1_start(2:Nb1+1) = breaks1;
    breaks2_start(2:Nb2+1) = breaks2;
    breaks3_start(2:Nb3+1) = breaks3;
    
    breaks1_end = breaks1_start - 1;
    breaks2_end = breaks2_start - 1;
    breaks3_end = breaks3_start - 1;
    
    breaks1_end = breaks1_end(2:end);
    breaks2_end = breaks2_end(2:end);
    breaks3_end = breaks3_end(2:end);
    
    breaks3_end(end+1) = size(Spots_L3,1);
    breaks2_end(end+1) = size(Spots_L2,1);
    breaks1_end(end+1) = size(Spots_L1,1);

    %Find how many points are in each radius group

    N_segments_L1 = length(breaks1_start);
    N_segments_L2 = length(breaks2_start);
    N_segments_L3 = length(breaks3_start);

    NptsInSegment_L1 = breaks1_end - breaks1_start;
    NptsInSegment_L2 = breaks2_end - breaks2_start;
    NptsInSegment_L3 = breaks3_end - breaks3_start;

    %Assign numbers in the 13th column to valid groups of points for a radius.
    %To be valid there must be at least min_Pixels # of pixels in the radius
    %group.

    cntValidL1 = 0;
    cntValidL2 = 0;
    cntValidL3 = 0;

    for i=1:N_segments_L1
        if (NptsInSegment_L1(i) > min_group_pixels)
            cntValidL1 = cntValidL1 + 1;
            Spots_L1(breaks1_start(i):breaks1_end(i), 13) = cntValidL1; %Assign the 13th col of Spots_L1 the radius grp #
        end
    end

    for j=1:N_segments_L2
        if (NptsInSegment_L2(j) > min_group_pixels)
            cntValidL2 = cntValidL2 + 1;
            Spots_L2(breaks2_start(j):breaks2_end(j), 13) = cntValidL2;
        end
    end

    for j=1:N_segments_L3
        if (NptsInSegment_L3(j) > min_group_pixels)
            cntValidL3 = cntValidL3 + 1;
            Spots_L3(breaks3_start(j):breaks3_end(j), 13) = cntValidL3;
        end
    end
    
    %Get rid of points that were in invalid radius groups
    
    Spots_L1 = sortrows(Spots_L1,13);
    L1_good_start = min(find(Spots_L1(:,13) > 0));
    Spots_L1_good = Spots_L1(L1_good_start:end,:); %Spots_L1_good now contain only spots that are on a defined ring.

    Spots_L2 = sortrows(Spots_L2,13);
    L2_good_start = min(find(Spots_L2(:,13) > 0));
    Spots_L2_good = Spots_L2(L2_good_start:end,:);

    Spots_L3 = sortrows(Spots_L3,13);
    L3_good_start = min(find(Spots_L3(:,13) > 0));
    Spots_L3_good = Spots_L3(L3_good_start:end,:);


    N_good_L1 = size(Spots_L1_good,1);
    N_good_L2 = size(Spots_L2_good,1);
    N_good_L3 = size(Spots_L3_good,1);
    
    %Just setup indices so we can take the difference between adjacent
    %spot group #s
    idx_1_L1 = 1:1:(N_good_L1-1);
    idx_2_L1 = 2:1:N_good_L1;

    idx_1_L2 = 1:1:(N_good_L2-1);
    idx_2_L2 = 2:1:N_good_L2;

    idx_1_L3 = 1:1:(N_good_L3-1);
    idx_2_L3 = 2:1:N_good_L3;
    
    
    %Find the location of breaks in valid radius groups - separates radius
    %groups. I.e. 14th column is difference between current and previous
    %radius value, so a big spike indicates a new group.
    Spots_L1_good(idx_1_L1, 14) = Spots_L1_good(idx_2_L1,13) - Spots_L1_good(idx_1_L1,13);
    Spots_L2_good(idx_1_L2, 14) = Spots_L2_good(idx_2_L2,13) - Spots_L2_good(idx_1_L2,13);
    Spots_L3_good(idx_1_L3, 14) = Spots_L3_good(idx_2_L3,13) - Spots_L3_good(idx_1_L3,13);
    
    Spots_L1_good(1,14) = 1;
    Spots_L2_good(1,14) = 1;
    Spots_L3_good(1,14) = 1;

    Spots_L1_good(end,14) = 1;
    Spots_L2_good(end,14) = 1;
    Spots_L3_good(end,14) = 1;

    EndPoints_L1 = find(Spots_L1_good(:,14) > 0);
    EndPoints_L2 = find(Spots_L2_good(:,14) > 0);
    EndPoints_L3 = find(Spots_L3_good(:,14) > 0);
    
    % Calculate the mean and std of the radius groups
%     for i=2:length(EndPoints_L1)
%         mu1(i) = mean(Spots_L1_good(EndPoints_L1(i-1):EndPoints_L1(i), 11));
%         sigma1(i) = std(Spots_L1_good(EndPoints_L1(i-1):EndPoints_L1(i), 11));
%     end
% 
%     for i=2:length(EndPoints_L2)
%         mu2(i) = mean(Spots_L2_good(EndPoints_L2(i-1):EndPoints_L2(i), 11));
%         sigma2(i) = std(Spots_L2_good(EndPoints_L2(i-1):EndPoints_L2(i), 11));
%     end
% 
%     for i=2:length(EndPoints_L3)
%         mu2(i) = mean(Spots_L3_good(EndPoints_L3(i-1):EndPoints_L3(i), 11));
%         sigma2(i) = std(Spots_L3_good(EndPoints_L3(i-1):EndPoints_L3(i), 11));
%     end
% 
%     %Determine if a radius that was assigned to the group is an outlier
%     for i=2:length(EndPoints_L3)
% 
%         for j=EndPoints_L3(i-1):EndPoints_L3(i)
% 
%             if (abs(Spots_L3_good(j,11) - mu1(i)) > 1*sigma1(i))
%                 Spots_L3_good(j,13) = 0;
%             end
%         end
% %     end
%     
%     for i=2:length(EndPoints_L2)
% 
%         for j=EndPoints_L2(i-1):EndPoints_L2(i)
%              
%             if (abs(Spots_L2_good(j,11) - mu2(i)) > 1*sigma2(i))
%                 Spots_L2_good(j,13) = 0;
%             end
%         end
%     end
% 
%     for i=2:length(EndPoints_L1)
% 
%         for j=EndPoints_L1(i-1):EndPoints_L1(i)
% 
%             if (abs(Spots_L1_good(j,11) - mu1(i)) > 1*sigma1(i))
%                 Spots_L1_good(j,13) = 0;
%             end
%         end
%     end

    %Recollect all valid points that belong to a radius group and are within 3
    %stds of the mean
    Spots_L1_finalpre = sortrows(Spots_L1_good,13);
    idx_good_L1 = min(find(Spots_L1_finalpre(:,13) > 0));
    Spots_L1_final = Spots_L1_finalpre(idx_good_L1:end,:);

    Spots_L2_finalpre = sortrows(Spots_L2_good,13);
    idx_good_L2 = min(find(Spots_L2_finalpre(:,13) > 0));
    Spots_L2_final = Spots_L2_finalpre(idx_good_L2:end,:);
    
    Spots_L3_finalpre = sortrows(Spots_L3_good,13);
    idx_good_L3 = min(find(Spots_L3_finalpre(:,13) > 0));
    Spots_L3_final = Spots_L3_finalpre(idx_good_L3:end,:);
    