function [Spots_L1_good, Spots_L2_good, Spots_L3_good,Spots_L1, Spots_L2, Spots_L3] = GetSpots(prefix_intensity_list, zList, d_start, N_pix_threshold, N_omegas,CenterGuess,min_group_pixels, d1_ext, d2_ext, d3_ext, beam_edge, N_pix_upperThresh, det_size)
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
    
    
    
    %Create list of presumed scattering pixels
    [SpotList, SpotList_L1, SpotList_L2, SpotList_L3] = MultiLayerSpots_3Ls_2010(prefix_intensity_list, zList, d1_start_List, d2_start_List, d3_start_List, N_pix_threshold, N_pix_upperThresh, N_omegas, d1_ext, d2_ext, d3_ext);
    Spots_L1 = RemoveDirectBeam(SpotList_L1, beam_edge);
    Spots_L2 = RemoveDirectBeam(SpotList_L2, beam_edge);
    Spots_L3 = RemoveDirectBeam(SpotList_L3, beam_edge);

    %Ask user to calibrate a single circle by picking points that lie on it
    fig1 = figure(1);
    plot(Spots_L1(:,1), Spots_L1(:,2), '.')
    axis equal
    axis([ 0 det_size 0 det_size])
    axis ij
    title('L_1 Center of Intensities - All omegas')
    
    [X_cent_guess_L1, Y_cent_guess_L1] = GuessInitialCenter(fig1);
    
    fig2 = figure(2);
    plot(Spots_L2(:,1), Spots_L2(:,2), '.')
    axis equal
    axis([ 0 det_size 0 det_size])
    axis ij
    title('L_2 Center of Intensities - All omegas')
    
    [X_cent_guess_L2, Y_cent_guess_L2] = GuessInitialCenter(fig2);
        
    fig3 = figure(3);
    plot(Spots_L3(:,1), Spots_L3(:,2), '.')
    axis equal
    axis([ 0 det_size 0 det_size])
    axis ij
    title('L_3 Center of Intensities - All omegas')
    
    [X_cent_guess_L3, Y_cent_guess_L3] = GuessInitialCenter(fig3);
    
    %Calculate radius using this guess and sort to spots by radial distance
    %from center
    Spots_L1 = CalcSpotRadiusFromOrigin(Spots_L1, X_cent_guess_L1, Y_cent_guess_L1);
    Spots_L2 = CalcSpotRadiusFromOrigin(Spots_L2, X_cent_guess_L2, Y_cent_guess_L2);
    Spots_L3 = CalcSpotRadiusFromOrigin(Spots_L3, X_cent_guess_L3, Y_cent_guess_L3);
    
    %Plot radii.  You should see clusters of equal radii.
    figure(4)
    plot(Spots_L1(:,11), '.')
    title('Radial Distance from Center - L_1');
    figure(5)
    plot(Spots_L2(:,11), '.')
    title('Radial Distance from Center - L_2');
    figure(6)
    plot(Spots_L3(:,11), '.')
    title('Radial Distance from Center - L_3');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Now figure out which L distance has the best circle fit and replot
    % all three distances using the origin found.  Since the origin should
    % be roughly the same for L1,L2, and L3 the radii should be recaculated
    % using this origin.
    %
    x_L1_center = X_cent_guess_L1;
    y_L1_center = Y_cent_guess_L1;
    x_L2_center = X_cent_guess_L2;
    y_L2_center = Y_cent_guess_L2;
    x_L3_center = X_cent_guess_L3;
    y_L3_center = Y_cent_guess_L3;
    
    useL = input('Which L origin would you like to use? (1, 2, or 3)');
 
    if(useL ==1)
        x_use = x_L1_center;
        y_use = y_L1_center;
    elseif(useL == 2)
        x_use = x_L2_center;
        y_use = y_L2_center;
    elseif(useL == 3)
        x_use = x_L3_center;
        y_use = y_L3_center;
    end
    
    Spots_L1 = CalcSpotRadiusFromOrigin(Spots_L1, x_use, y_use);
    Spots_L2 = CalcSpotRadiusFromOrigin(Spots_L2, x_use, y_use);
    Spots_L3 = CalcSpotRadiusFromOrigin(Spots_L3, x_use, y_use);

    figure(4)
    hold on
    plot(Spots_L1(:,11), 'x')
    figure(5)
    hold on
    plot(Spots_L2(:,11), 'x')
    figure(6)
    hold on
    plot(Spots_L3(:,11), 'x')
    
    x_use
    y_use
    
    keepSingleOrigin = input('Would you like to keep this new origin(xs), or revert back to old numbers (.s)? 1-yes 0-no');
    
    %if we want 3 different origins
    if (keepSingleOrigin == 0)
        x_L1_center = X_cent_guess_L1;
        y_L1_center = Y_cent_guess_L1;
        x_L2_center = X_cent_guess_L2;
        y_L2_center = Y_cent_guess_L2;
        x_L3_center = X_cent_guess_L3;
        y_L3_center = Y_cent_guess_L3;
        Spots_L1 = CalcSpotRadiusFromOrigin(Spots_L1, X_cent_guess_L1, Y_cent_guess_L1);
        Spots_L2 = CalcSpotRadiusFromOrigin(Spots_L2, X_cent_guess_L2, Y_cent_guess_L2);
        Spots_L3 = CalcSpotRadiusFromOrigin(Spots_L3, X_cent_guess_L3, Y_cent_guess_L3);
        
    else      %If we want to use a single (j,k) for all three distances
        x_L1_center = x_use;
        y_L1_center = y_use;
        x_L2_center = x_use;
        y_L2_center = y_use;
        x_L3_center = x_use;
        y_L3_center = y_use;
    end
    
    N_spots1 = size(Spots_L1,1);
    N_spots2 = size(Spots_L2,1);
    N_spots3 = size(Spots_L3,1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Now x,y_L#_center are best guesses.  Let's look for radius groups -
    % 1/15/10
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Find Spikes indicating new radius
    for i=2:N_spots2
        Spots_L2(i,12) = abs(Spots_L2(i,11) - Spots_L2(i-1,11));
    end

    for j=2:N_spots1
        Spots_L1(j,12) = abs(Spots_L1(j,11) - Spots_L1(j-1,11));
    end

    for j=2:N_spots3
        Spots_L3(j,12) = abs(Spots_L3(j,11) - Spots_L3(j-1,11));
    end
       
    figure(10)
    plot(Spots_L1(:,12));
    title('L_1 adjacent radius displacements')
    
    figure(11)
    plot(Spots_L2(:,12));
    title('L_2 adjacent radius displacements')
    
    figure(12)
    plot(Spots_L3(:,12));
    title('L_3 adjacent radius displacements')
        
    %Find these locations where there's a jump in radius, breaks are indicies
    %where jumps occur
    breakstep_L1 = input('What jump threshold for the radial breaks in the L1 set?');
    breakstep_L2 = input('What jump threshold for the radial breaks in the L2 set?');
    breakstep_L3 = input('What jump threshold for the radial breaks in the L3 set?');
    
    [breaks1_start, breaks1_end] = SegmentRadiusGroup(Spots_L1, breakstep_L1);
    [breaks2_start, breaks2_end] = SegmentRadiusGroup(Spots_L2, breakstep_L2);
    [breaks3_start, breaks3_end] = SegmentRadiusGroup(Spots_L3, breakstep_L3);
    
    breaks1_start
    breaks1_end
    breaks2_start
    breaks2_end
    breaks3_start
    breaks3_end
    
    
    group1 = 0;
    clf(4);
    figure(4)
    plot(Spots_L1(:,11), 'x');
    hold on
    vline(breaks1_start(:), 'r');
    group1 = input('Are you content with the break up of the radial groupings? 1-yes 0-no');
    while (group1 == 0)
        [breaks1_start, breaks1_end] = AmendRadiusBreaks(breaks1_start, breaks1_end, Spots_L1, 4);
        group1 = input('Are you content with the break up of the radial groupings? 1-yes 0-no');
    end
    
    group2 = 0;
    clf(5);
    figure(5)
    plot(Spots_L2(:,11), 'x');
    hold on
    vline(breaks2_start(:), 'r');
    group2 = input('Are you content with the break up of the radial groupings? 1-yes 0-no');
    while (group2 == 0)
        [breaks2_start, breaks2_end] = AmendRadiusBreaks(breaks2_start, breaks2_end, Spots_L2, 5);
        group2 = input('Are you content with the break up of the radial groupings? 1-yes 0-no');
    end
    
    group3 = 0;
    clf(6);
    figure(6)
    plot(Spots_L3(:,11), 'x');
    hold on
    vline(breaks3_start(:), 'r');
    group3 = input('Are you content with the break up of the radial groupings? 1-yes 0-no');
    while (group3 == 0)
        [breaks3_start, breaks3_end] = AmendRadiusBreaks(breaks3_start, breaks3_end, Spots_L3, 6);
        group3 = input('Are you content with the break up of the radial groupings? 1-yes 0-no');
    end
  
    
    
    %Find how many points are in each radius group
    %# of radius groups
    N_segments_L1 = length(breaks1_start);
    N_segments_L2 = length(breaks2_start);
    N_segments_L3 = length(breaks3_start);
    
    %# of points in each group
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
            break1_start_good(cntValidL1) = breaks1_start(i);
            break1_end_good(cntValidL1) = breaks1_end(i);
        end
            
    end

    for j=1:N_segments_L2
        if (NptsInSegment_L2(j) > min_group_pixels)
            cntValidL2 = cntValidL2 + 1;
            Spots_L2(breaks2_start(j):breaks2_end(j), 13) = cntValidL2;
            break2_start_good(cntValidL2) = breaks2_start(j);
            break2_end_good(cntValidL2) = breaks2_end(j);
        end
    end

    for j=1:N_segments_L3
        if (NptsInSegment_L3(j) > min_group_pixels)
            cntValidL3 = cntValidL3 + 1;
            Spots_L3(breaks3_start(j):breaks3_end(j), 13) = cntValidL3;
            break3_start_good(cntValidL3) = breaks3_start(j);
            break3_end_good(cntValidL3) = breaks3_end(j);
        end
    end
%     
%     group1 = 0;
%     clf(4);
%     figure(4)
%     plot(Spots_L1(:,11), 'x');
%     hold on
%     vline(break1_start_good(:), 'r');
%     group1 = input('Are you content with the break up of the radial groupings? 1-yes 0-no');
%     while (group1 == 0)
%         [break1_start_good, break2_end_good] = AmendRadiusBreaks(break1_start_good, break1_end_good, Spots_L1, 4);
%         group1 = input('Are you content with the break up of the radial groupings? 1-yes 0-no');
%     end
%     
%     group2 = 0;
%     clf(5);
%     figure(5)
%     plot(Spots_L2(:,11), 'x');
%     hold on
%     vline(break2_start_good(:), 'r');
%     group2 = input('Are you content with the break up of the radial groupings? 1-yes 0-no');
%     while (group2 == 0)
%         [break2_start_good, break2_end_good] = AmendRadiusBreaks(break2_start_good, break2_end_good, Spots_L2, 5);
%         group2 = input('Are you content with the break up of the radial groupings? 1-yes 0-no');
%     end
%     
%     group3 = 0;
%     clf(6);
%     figure(6)
%     plot(Spots_L3(:,11), 'x');
%     hold on
%     vline(break3_start_good(:), 'r');
%     group3 = input('Are you content with the break up of the radial groupings? 1-yes 0-no');
%     while (group3 == 0)
%         [break3_start_good, break3_end_good] = AmendRadiusBreaks(break3_start_good, break3_end_good, Spots_L3, 6);
%         group3 = input('Are you content with the break up of the radial groupings? 1-yes 0-no');
%     end
    
    
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

    figure(100)
    plot(Spots_L1(:,1), Spots_L1(:,2), '.k');
    hold on
    plot(Spots_L1_good(:,1), Spots_L1_good(:,2), '.r');
    axis ij
    axis([0 det_size 0 det_size])
    axis equal
    
    figure(101)
    plot(Spots_L2(:,1), Spots_L2(:,2), '.k');
    hold on
    plot(Spots_L2_good(:,1), Spots_L2_good(:,2), '.r');
    axis ij
    axis([0 det_size 0 det_size])
    axis equal
    
    figure(102)
    plot(Spots_L3(:,1), Spots_L3(:,2), '.k');
    hold on
    plot(Spots_L3_good(:,1), Spots_L3_good(:,2), '.r');
    axis ij
    axis([ 0 det_size 0 det_size])
    axis equal
    
    
%     N_good_L1 = size(Spots_L1_good,1);
%     N_good_L2 = size(Spots_L2_good,1);
%     N_good_L3 = size(Spots_L3_good,1);
%     
%     %Just setup indices so we can take the difference between adjacent
%     %spot group #s
%     idx_1_L1 = 1:1:(N_good_L1-1);
%     idx_2_L1 = 2:1:N_good_L1;
% 
%     idx_1_L2 = 1:1:(N_good_L2-1);
%     idx_2_L2 = 2:1:N_good_L2;
% 
%     idx_1_L3 = 1:1:(N_good_L3-1);
%     idx_2_L3 = 2:1:N_good_L3;
%     
%     
%     %Find the location of breaks in valid radius groups - separates radius
%     %groups. I.e. 14th column is difference between current and previous
%     %radius value, so a big spike indicates a new group.
%     Spots_L1_good(idx_1_L1, 14) = Spots_L1_good(idx_2_L1,13) - Spots_L1_good(idx_1_L1,13);
%     Spots_L2_good(idx_1_L2, 14) = Spots_L2_good(idx_2_L2,13) - Spots_L2_good(idx_1_L2,13);
%     Spots_L3_good(idx_1_L3, 14) = Spots_L3_good(idx_2_L3,13) - Spots_L3_good(idx_1_L3,13);
%     
%     Spots_L1_good(1,14) = 1;
%     Spots_L2_good(1,14) = 1;
%     Spots_L3_good(1,14) = 1;
% 
%     Spots_L1_good(end,14) = 1;
%     Spots_L2_good(end,14) = 1;
%     Spots_L3_good(end,14) = 1;
% 
%     EndPoints_L1 = find(Spots_L1_good(:,14) > 0);
%     EndPoints_L2 = find(Spots_L2_good(:,14) > 0);
%     EndPoints_L3 = find(Spots_L3_good(:,14) > 0);
%     
%     % Calculate the mean and std of the radius groups
% %     for i=2:length(EndPoints_L1)
% %         mu1(i) = mean(Spots_L1_good(EndPoints_L1(i-1):EndPoints_L1(i), 11));
% %         sigma1(i) = std(Spots_L1_good(EndPoints_L1(i-1):EndPoints_L1(i), 11));
% %     end
% % 
% %     for i=2:length(EndPoints_L2)
% %         mu2(i) = mean(Spots_L2_good(EndPoints_L2(i-1):EndPoints_L2(i), 11));
% %         sigma2(i) = std(Spots_L2_good(EndPoints_L2(i-1):EndPoints_L2(i), 11));
% %     end
% % 
% %     for i=2:length(EndPoints_L3)
% %         mu2(i) = mean(Spots_L3_good(EndPoints_L3(i-1):EndPoints_L3(i), 11));
% %         sigma2(i) = std(Spots_L3_good(EndPoints_L3(i-1):EndPoints_L3(i), 11));
% %     end
% % 
% %     %Determine if a radius that was assigned to the group is an outlier
% %     for i=2:length(EndPoints_L3)
% % 
% %         for j=EndPoints_L3(i-1):EndPoints_L3(i)
% % 
% %             if (abs(Spots_L3_good(j,11) - mu1(i)) > 1*sigma1(i))
% %                 Spots_L3_good(j,13) = 0;
% %             end
% %         end
% % %     end
% %     
% %     for i=2:length(EndPoints_L2)
% % 
% %         for j=EndPoints_L2(i-1):EndPoints_L2(i)
% %              
% %             if (abs(Spots_L2_good(j,11) - mu2(i)) > 1*sigma2(i))
% %                 Spots_L2_good(j,13) = 0;
% %             end
% %         end
% %     end
% % 
% %     for i=2:length(EndPoints_L1)
% % 
% %         for j=EndPoints_L1(i-1):EndPoints_L1(i)
% % 
% %             if (abs(Spots_L1_good(j,11) - mu1(i)) > 1*sigma1(i))
% %                 Spots_L1_good(j,13) = 0;
% %             end
% %         end
% %     end

    %Recollect all valid points that belong to a radius group and are within 3
    %stds of the mean
%     Spots_L1_finalpre = sortrows(Spots_L1_good,13);
%     idx_good_L1 = min(find(Spots_L1_finalpre(:,13) > 0));
%     Spots_L1_final = Spots_L1_finalpre(idx_good_L1:end,:);
% 
%     Spots_L2_finalpre = sortrows(Spots_L2_good,13);
%     idx_good_L2 = min(find(Spots_L2_finalpre(:,13) > 0));
%     Spots_L2_final = Spots_L2_finalpre(idx_good_L2:end,:);
%     
%     Spots_L3_finalpre = sortrows(Spots_L3_good,13);
%     idx_good_L3 = min(find(Spots_L3_finalpre(:,13) > 0));
%     Spots_L3_final = Spots_L3_finalpre(idx_good_L3:end,:);
    