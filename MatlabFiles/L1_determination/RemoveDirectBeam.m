function Spot_clean = RemoveDirectBeam(SpotList_wDB, beam_edge)

    beam_min_x = beam_edge(1);
    beam_max_x = beam_edge(2);
    beam_min_y = beam_edge(3);
    beam_max_y = beam_edge(4);
 
    % Removal of pixels that are obviously direct beam
    L_beam_xLess = find(SpotList_wDB(:,1) < beam_max_x); %Note that 1st column is horizontal information
    L_beam_xMore = find(SpotList_wDB(:,1) > beam_min_x);
    
    L_beam_yLess = find(SpotList_wDB(:,2) < beam_max_y);
    L_beam_yMore = find(SpotList_wDB(:,2) > beam_min_y);
    
    %Find peaks within direct beam by having both x & y center in beam window
    L_x_candidate = intersect(L_beam_xLess, L_beam_xMore);
    
    L_y_candidate = intersect(L_beam_yLess, L_beam_yMore);
    
    L_db_index = intersect(L_x_candidate, L_y_candidate);
    
    %Remove these spots in the beam window
    SpotList_wDB(L_db_index,:) = [];
    
    Spot_clean = SpotList_wDB;
