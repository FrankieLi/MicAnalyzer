function LineData = FindLines3D_v2(CentOfMass_mtx)
% This function takes the cleaned up version of the spot center of masses
% and fits each set of three dots to a line.  It returns an array yielding
% the slope, intercept of the fitted line, along with it's omega and spot
% # within omega.

% Feb 26 2007 (Will run into problem if you have > 99 Omegas due to memory,
% use FindLinesFix() instead)

%Aug 6 2007 - added in the Good_candidate = 0 -> LineData = [] argument.
%This basically says that you might find spots that are proper size and
%somewhat in line, but still not colinear.  Therefore, we say its not
%colinear.

CofM_size = size(CentOfMass_mtx, 1);
if (CofM_size == 0)
   Cnst = [];
   SlopeX = [];
   SlopeY = [];
   Omegas = [];
end

Good_candidate = 1;

if (CofM_size > 0)
   max_omegas = max(CentOfMass_mtx(:,5));

   Omega_count_1(1:max_omegas) = 0;
   Omega_count_2(1:max_omegas) = 0;
   Omega_count_3(1:max_omegas) = 0;   
   Omega_count_4(1:max_omegas) = 0;
   
    %Routine will count the number of spots associated with each omega

        for i=1:max_omegas
            for j=1:CofM_size
                if( CentOfMass_mtx(j,5) == i)
                    Omega_count_1(i) = Omega_count_1(i) + 1;  %Omega_count_1 counts the number of spots associated with omega = i
                    if (CentOfMass_mtx(j,4) == 1)    
                        Omega_count_2(i) = Omega_count_2(i) + 1; %Omega_count_2 counts the number of spots with omega = i and at L1
                    end
                    
                    if (CentOfMass_mtx(j,4) == 2)
                        Omega_count_3(i) = Omega_count_3(i) + 1; %Omega_count_3 counts the number of spots with omega = i and at L2
                    end
                    if (CentOfMass_mtx(j,4) == 3)
                        Omega_count_4(i) = Omega_count_4(i) + 1; %Omega_count_4 counts the number of spots with omega = i and at L3
                    end
                end
            end
        end
        
        %Routine checks to see if there is at least one L1, L2, L3 spot at
        %each omega.  Does this by taking the product of the number of
        %spots at each distance.
        for i=1:max_omegas
            Prod_Num_Ls = Omega_count_2(i) * Omega_count_3(i) * Omega_count_4(i);
            if (Prod_Num_Ls == 0)
                Omega_count_1(i) = 0;
            end
        end
        

    cnt = 0;
    sets_cnt = 0;
        for i = 1:max_omegas
          i
          CommonLine = [];
          order_proceed_for3spt = 0;
            if (Omega_count_1(i) == 3) % If this omega only has one spot set
                cnt = 0;
                ones(1:3) = 1;
                spt_sizes(1:3) = 0;
                compare_spt_12 = 0;
                compare_spt_13 = 0;
                
                % Do LSF 
                for j=1:CofM_size
                    if (CentOfMass_mtx(j,5) == i)
                        cnt = cnt + 1;
                        X(cnt) = CentOfMass_mtx(j,1)
                        Y(cnt) = CentOfMass_mtx(j,2);
                        Z(cnt) = CentOfMass_mtx(j,6);
                        
                       
                         
                        
                        spt_sizes(cnt) = CentOfMass_mtx(j,3);
                        
                        if (CentOfMass_mtx(j,4) == 1)
                            L_indx(1) = j;
                        elseif (CentOfMass_mtx(j,4) == 2)
                            L_indx(2) = j;
                        else (CentOfMass_mtx(j,4) == 3)
                            L_indx(3) = j;
                        end
                    end
                end
                
                %if((Y(1) > Y(2)) && (Y(2) > Y(1))) - Edit Aug. 6, 2007
                %(seems like this would always be false)
                if ((Y(1) > Y(2)) && (Y(2) > Y(3)))
                   order_proceed_for3spt = 1;
                end
                
                compare_spt_12 = spt_sizes(1) / spt_sizes(2);
                compare_spt_13 = spt_sizes(1) / spt_sizes(3);
                slope_12 = (Y(2) - Y(1)) / (X(2) - X(1));
                slope_13 = (Y(3) - Y(1)) / (X(3) - X(1));
                slope_check = slope_12/slope_13;
                
                
                clear spt_sizes;
                if (((compare_spt_12 > 0.5) && (compare_spt_12 < 1.5)) && ((compare_spt_13 > 0.5) && (compare_spt_13 < 1.5)) && (slope_check > 0.5) && (slope_check < 1.5) && (order_proceed_for3spt == 1))
                
                    A = [ones'  X'  Y'];
                    LSF_params = A \ Z';
                    sets_cnt = sets_cnt + 1;
                    L1_indx(sets_cnt) = L_indx(1);
                    L2_indx(sets_cnt) = L_indx(2);
                    L3_indx(sets_cnt) = L_indx(3);
                    SlopeX(sets_cnt) = LSF_params(3);
                    SlopeY(sets_cnt) = LSF_params(2);
                    Cnst(sets_cnt) = LSF_params(1);
                    Omegas(sets_cnt) = i;
                    clear LSF_params;
                    clear L_indx;
                end    
            end
    
    
            if (Omega_count_1(i) > 3) % We have more than one spot set
                Num_L1s = 0;
                Num_L2s = 0;
                Num_L3s = 0;
                minLs = 0;
                maxLs = 0;
                CommonLine = [];
                CommonLine_test = [];
                compare_spt_12 = 0;
                compare_spt_13 = 0;
                
                for j =1:CofM_size  % count the number of L1s, L2s, L3s
                    if ((CentOfMass_mtx(j,5) == i) && (CentOfMass_mtx(j,4) == 1))
                        Num_L1s = Num_L1s + 1;
                        L1_loc(Num_L1s) = j; %records the spot index of L1's in CentOfMass_mtx
                    end
    
                    if ((CentOfMass_mtx(j,5) == i) && (CentOfMass_mtx(j,4) == 2))
                        Num_L2s = Num_L2s + 1;
                        L2_loc(Num_L2s) = j;
                    end
               
                    if ((CentOfMass_mtx(j,5) == i) && (CentOfMass_mtx(j,4) == 3))
                        Num_L3s = Num_L3s + 1;
                        L3_loc(Num_L3s) = j;
                    end
                end
         
                minLs = min([Num_L1s, Num_L2s, Num_L3s]);
                maxLs = max([Num_L1s, Num_L2s, Num_L3s]);
                
                
                if (minLs == Num_L1s) % If L1 has the fewest spots
                   CommonLine_test = [];
                   
                   
                   for k = 1:Num_L1s
   
                            L1_to_L2 = [];
                            L2_to_L3 = [];                  
                            SpacingGrid = [];
                            Candidate = [];          
                            
                            
                            L1_x = CentOfMass_mtx(L1_loc(k),1); 
                            L1_y = CentOfMass_mtx(L1_loc(k),2);
                  
                            for q=1:Num_L2s
                                L2_x = CentOfMass_mtx(L2_loc(q),1);
                                L2_y = CentOfMass_mtx(L2_loc(q),2);                       
                                L1_to_L2(q) = sqrt( (L2_x - L1_x)^2 + (L2_y - L1_y)^2); %List distance between this L1 spot and all L2's
                      
                                for m=1:Num_L3s
                                    L3_x = CentOfMass_mtx(L3_loc(m),1); 
                                    L3_y = CentOfMass_mtx(L3_loc(m),2);                       
                                    L2_to_L3(q,m) = sqrt( (L3_x - L2_x)^2 + (L3_y - L2_y)^2); %distance between L2 and all L3s
                                end
                            end
                            
                            count_Candidate = 0;
                
                           for t = 1:Num_L2s
                                for tt = 1:Num_L3s
                                    SpacingGrid(t,tt) = L2_to_L3(t,tt)/L1_to_L2(t);
                                    if ((SpacingGrid(t,tt) < 1.025) && (SpacingGrid(t,tt) > 0.975)) %If SpacingGrid is close to zero, then the points should all be on a scattering vector
                                        count_Candidate = count_Candidate + 1;
                                        Candidate(count_Candidate, 1) = t;  %First column of candidate gives L2's, 2nd column gives L3s
                                        Candidate(count_Candidate, 2) = tt;
                                    end
                                end
                            end
                           
                            
                            size_Candidate = size(Candidate,1);
                            
                            
                            if (size_Candidate > 1)
                                Good_candidate = 0;
                                for i=1:size_Candidate
                                    % Get X,Y coords of the spots believed to define a line
                                    L1_x_Cand = CentOfMass_mtx(L1_loc(k),1);
                                    L1_y_Cand = CentOfMass_mtx(L1_loc(k),2);
                                    L2_x_Cand = CentOfMass_mtx(L2_loc(Candidate(i,1)),1);
                                    L2_y_Cand = CentOfMass_mtx(L2_loc(Candidate(i,1)),2);
                                    L3_x_Cand = CentOfMass_mtx(L3_loc(Candidate(i,2)),1);                                    
                                    L3_y_Cand = CentOfMass_mtx(L3_loc(Candidate(i,2)),2);
                                    
                                    %Calculate the slopes between L1 and L2, L2 and L3 to compare (grossly
                                    %different slopes -> not same scattering vector)
                                    slope_Cand_12 = (L2_y_Cand - L1_y_Cand)/(L2_x_Cand - L1_x_Cand);
                                    slope_Cand_23 = (L3_y_Cand - L2_y_Cand)/(L3_x_Cand - L2_x_Cand);
                                    
                                    slope_division = slope_Cand_23/slope_Cand_12;
                                    
                                    if ((slope_division > 0.5) && (slope_division < 1.5))
                                        Good_candidate = i;
                                    end
                                    if (Good_candidate == 0)
                                        size_Candidate = 0;
                                    
                                    end    
                                end
                                
                                if (Good_candidate > 0)
                                    CommonLine_test(k,1) = L1_loc(k);
                                    CommonLine_test(k,2) = L2_loc(Candidate(Good_candidate,1));
                                    CommonLine_test(k,3) = L3_loc(Candidate(Good_candidate,2));
                                    CommonLine_test
                                    
                                end
                            end
                            
                            if(size_Candidate == 1)
                            
                                CommonLine_test(k,1) = L1_loc(k);
                                CommonLine_test(k,2) = L2_loc(Candidate(1,1));
                                CommonLine_test(k,3) = L3_loc(Candidate(1,2));
                                
                            end
                            
                            
                            if(size_Candidate > 0)
                                compare_spt_12 = CentOfMass_mtx(CommonLine_test(k,1),3) / CentOfMass_mtx(CommonLine_test(k,2),3);
                                compare_spt_13 = CentOfMass_mtx(CommonLine_test(k,1),3) / CentOfMass_mtx(CommonLine_test(k,3),3);
                            
    
                                if (((compare_spt_12 > 0.5) && (compare_spt_12 < 1.5)) && ((compare_spt_13 > 0.5) && (compare_spt_13 < 1.5)))
                                    if ( (CentOfMass_mtx(CommonLine_test(k,1),2) > CentOfMass_mtx(CommonLine_test(k,2),2)) && (CentOfMass_mtx(CommonLine_test(k,2),2) > CentOfMass_mtx(CommonLine_test(k,3),2)))
                                         CommonLine = CommonLine_test;
                                    end
                                end
                            end        
                 
                           
                end
                

                elseif (minLs == Num_L2s)
                    
                    CommonLine_test = [];

                    for k = 1:Num_L2s
                        
                            L1_to_L2 = [];
                            L2_to_L3 = [];                  
                            SpacingGrid = [];
                            Candidate = [];
                            
                        L2_x = CentOfMass_mtx(L2_loc(k),1); 
                        L2_y = CentOfMass_mtx(L2_loc(k),2);
                  
                        for q=1:Num_L1s
                                L1_x = CentOfMass_mtx(L1_loc(q),1); 
                                L1_y = CentOfMass_mtx(L1_loc(q),2);                      
                                L2_to_L1(q) = sqrt( (L2_x - L1_x)^2 + (L2_y - L1_y)^2);
                        
                  
                            for m=1:Num_L3s
                                    L3_x = CentOfMass_mtx(L3_loc(m),1); 
                                    L3_y = CentOfMass_mtx(L3_loc(m),2);                       
                                    L2_to_L3(q,m) = sqrt( (L3_x - L2_x)^2 + (L3_y - L2_y)^2);
                            end
                  
                        end
                            count_Candidate = 0;
                            
                            for t = 1:Num_L1s
                                for tt = 1:Num_L3s
                                    SpacingGrid(t,tt) = L2_to_L3(t,tt) / L2_to_L1(t);
                                    if ((SpacingGrid(t,tt) < 1.025) && (SpacingGrid(t,tt) > 0.975))
                                        count_Candidate = count_Candidate + 1;
                                        Candidate(count_Candidate, 1) = t;
                                        Candidate(count_Candidate, 2) = tt;
                                    end
                                end
                            end
                            
                            size_Candidate = size(Candidate,1);
                            

                            if (size_Candidate > 1)
                                Good_candidate = 0;
                                for i=1:size_Candidate
                                    % Get X,Y coords of the spots believed
                                    % to define a line
                                    L2_x_Cand = CentOfMass_mtx(L2_loc(k),1);
                                    L2_y_Cand = CentOfMass_mtx(L2_loc(k),2);
                                    L1_x_Cand = CentOfMass_mtx(L1_loc(Candidate(i,1)),1);
                                    L1_y_Cand = CentOfMass_mtx(L1_loc(Candidate(i,1)),2);
                                    L3_x_Cand = CentOfMass_mtx(L3_loc(Candidate(i,2)),1);                                    
                                    L3_y_Cand = CentOfMass_mtx(L3_loc(Candidate(i,2)),2);
                                    
                                    %Calculate the slopes between L1 and L2, L2 and L3 to compare (grossly
                                    %different slopes -> not same line)
                                    slope_Cand_12 = (L2_y_Cand - L1_y_Cand)/(L2_x_Cand - L1_x_Cand);
                                    slope_Cand_23 = (L3_y_Cand - L2_y_Cand)/(L3_x_Cand - L2_x_Cand);
                                    
                                    slope_division = slope_Cand_23/slope_Cand_12;
                                    
                                    if ((slope_division > 0.5) && (slope_division < 1.5))
                                        Good_candidate = i;
                                    end
                                end
                                if (Good_candidate > 0)   %These will give the indices of three spots believed to be on one line
                                    CommonLine_test(k,2) = L2_loc(k);
                                    CommonLine_test(k,1) = L1_loc(Candidate(Good_candidate,1));
                                    CommonLine_test(k,3) = L3_loc(Candidate(Good_candidate,2));
                                end    
                                 if (Good_candidate == 0)
                                        size_Candidate = 0;
                                 
                                 end
                            end
                            
                            if(size_Candidate == 1)
                            
                                CommonLine_test(k,2) = L2_loc(k);
                                CommonLine_test(k,1) = L1_loc(Candidate(1,1));
                                CommonLine_test(k,3) = L3_loc(Candidate(1,2));
                                
                            end
                            
                        if (size_Candidate > 0)
                            
                            compare_spt_12 = CentOfMass_mtx(CommonLine_test(k,1),3) / CentOfMass_mtx(CommonLine_test(k,2),3);
                            compare_spt_13 = CentOfMass_mtx(CommonLine_test(k,1),3) / CentOfMass_mtx(CommonLine_test(k,3),3);
                            
    
                            if (((compare_spt_12 > 0.5) && (compare_spt_12 < 1.5)) && ((compare_spt_13 > 0.5) && (compare_spt_13 < 1.5)))
                                if ( (CentOfMass_mtx(CommonLine_test(k,1),2) > CentOfMass_mtx(CommonLine_test(k,2),2)) && (CentOfMass_mtx(CommonLine_test(k,2),2) > CentOfMass_mtx(CommonLine_test(k,3),2)))
                                     CommonLine = CommonLine_test;
                                 end     
                            end
                        end
                        
                 end  % End's for loop for k = 1:Num_L2s
     
                else (minLs == Num_L3s)
                    
                    CommonLine_test = []; 
                    
                    for k = 1:Num_L3s
                   
                        L1_to_L2 = [];
                        L2_to_L3 = [];                  
                        SpacingGrid = [];
                        Candidate = [];
                        
                        L3_x = CentOfMass_mtx(L3_loc(k),1); 
                        L3_y = CentOfMass_mtx(L3_loc(k),2);
                        
                        
                        for q=1:Num_L2s
                                L2_x = CentOfMass_mtx(L2_loc(q),1); 
                                L2_y = CentOfMass_mtx(L2_loc(q),2);                       
                                L2_to_L3(q) = sqrt((L2_x - L3_x)^2 + (L2_y - L3_y)^2);
                      
                                for m=1:Num_L1s
                                    L1_x = CentOfMass_mtx(L1_loc(m),1);
                                    L1_y = CentOfMass_mtx(L1_loc(m),2);                      
                                    L1_to_L2(q,m) = sqrt( (L1_x - L2_x)^2 + (L1_y - L2_y)^2);
                                end
                        end
               
                        
                        count_Candidate = 0;
                            
                        for t = 1:Num_L2s
                            for tt = 1:Num_L1s
                               SpacingGrid(t,tt) = L1_to_L2(t,tt)/L2_to_L3(t);
                                    if ((SpacingGrid(t,tt) < 1.025) && (SpacingGrid(t,tt) > 0.975))
                                        count_Candidate = count_Candidate + 1;
                                        Candidate(count_Candidate, 1) = t;
                                        Candidate(count_Candidate, 2) = tt;
                                    end
                            end
                        end
                        
                        size_Candidate = size(Candidate,1);
                            

                         if (size_Candidate > 1)
                             Good_candidate = 0;  
                             for i=1:size_Candidate
                                    % Get X,Y coords of the spots believed
                                    % to define a line
                                    L3_x_Cand = CentOfMass_mtx(L3_loc(k),1);
                                    L3_y_Cand = CentOfMass_mtx(L3_loc(k),2);
                                    L2_x_Cand = CentOfMass_mtx(L2_loc(Candidate(i,1)),1);
                                    L2_y_Cand = CentOfMass_mtx(L2_loc(Candidate(i,1)),2);
                                    L1_x_Cand = CentOfMass_mtx(L1_loc(Candidate(i,2)),1);                                    
                                    L1_y_Cand = CentOfMass_mtx(L1_loc(Candidate(i,2)),2);
                                    
                                    %Calculate the slopes between L1 and L2, L2 and L3 to compare (grossly
                                    %different slopes -> not same line)
                                    slope_Cand_12 = (L2_y_Cand - L1_y_Cand)/(L2_x_Cand - L1_x_Cand);
                                    slope_Cand_23 = (L3_y_Cand - L2_y_Cand)/(L3_x_Cand - L2_x_Cand);
                                                                    
                                    slope_division = slope_Cand_23/slope_Cand_12
                                    
                                    if ((slope_division > 0.5) && (slope_division < 1.5))
                                        Good_candidate = i;
                                    end
                                    if (Good_candidate == 0)
                                        size_Candidate = 0;
                                       
                                    end
                                    
                                end
                                if (Good_candidate > 0)
                                    CommonLine_test(k,3) = L3_loc(k);
                                    CommonLine_test(k,2) = L2_loc(Candidate(Good_candidate,1));
                                    CommonLine_test(k,1) = L1_loc(Candidate(Good_candidate,2));
                                end                    
                            end
                            
                            if(size_Candidate == 1)
                            
                                CommonLine_test(k,3) = L3_loc(k);
                                CommonLine_test(k,2) = L2_loc(Candidate(1,1));
                                CommonLine_test(k,1) = L1_loc(Candidate(1,2));
                                
                            end
                            
                            if (size_Candidate > 0)
                                
                                compare_spt_12 = CentOfMass_mtx(CommonLine_test(k,1),3) / CentOfMass_mtx(CommonLine_test(k,2),3);
                                compare_spt_13 = CentOfMass_mtx(CommonLine_test(k,1),3) / CentOfMass_mtx(CommonLine_test(k,3),3);
                            
    
                                if (((compare_spt_12 > 0.5) && (compare_spt_12 < 1.5)) && ((compare_spt_13 > 0.5) && (compare_spt_13 < 1.5)))
                                    if ( (CentOfMass_mtx(CommonLine_test(k,1),2) > CentOfMass_mtx(CommonLine_test(k,2),2)) && (CentOfMass_mtx(CommonLine_test(k,2),2) > CentOfMass_mtx(CommonLine_test(k,3),2)))
                                        CommonLine = CommonLine_test;
                                    end
                                end
                            end                        
                        
                        
                    end
                end
            
        if (Good_candidate > 0)                
                num_sets = size(CommonLine,1);      
                ones(1:3) = 1;
                       
                % Do LSF 
                cnt = 0;
                
                cnt_Notempty = 0;
                newCmnLine = [];
                
                for qq = 1:num_sets
                  
                    if (CommonLine(qq,1) ~= 0)
                        cnt_Notempty = cnt_Notempty+1;
                        newCmnLine(cnt_Notempty,:) = CommonLine(qq,:);
                    end
                end
               
               CommonLine = [];
               CommonLine = newCmnLine;
                
               Num_sets = size(CommonLine,1);
               
                for k=1:Num_sets
                    
                  if ( (CommonLine(k,1) > 0) && (CommonLine(k,2) > 0) && (CommonLine(k,3) > 0))
                    
                        X = [];
                        Y = [];
                        Z = [];
                        LSF_params = [];
                        L_indx = [];
                        cnt = 0;
                        
                        for aa=1:3  %% loop goes across rows
                    
                            cnt = cnt + 1;
                            Y(cnt) = CentOfMass_mtx(CommonLine(k,aa), 1);
                            X(cnt) = CentOfMass_mtx(CommonLine(k,aa), 2);
                            Z(cnt) = CentOfMass_mtx(CommonLine(k,aa), 6);
                            Omega_now = CentOfMass_mtx(CommonLine(k,aa),5);                
                            L_indx(cnt) = CommonLine(k,aa);
                        end
                                           
                    end
 
                    fit_proceed = 0;
                    %Check colinearity
                       line_m = ( Y(3) - Y(1) ) / ( X(3) - X(1));
                       line_b = Y(1) - line_m * X(1);
                       fit_y = line_m * X(2) + line_b;  
                       
                        if (( abs(Y(2) - fit_y) < 5))
                           fit_proceed = 1;
                        end 
                               
                       
                    if ( fit_proceed == 1)
                         
                        cnt = 0;
                        A = [ones'  X'  Y'];
                        LSF_params = A \ Z';
                        sets_cnt = sets_cnt + 1;
                        L1_indx(sets_cnt) = L_indx(1);
                        L2_indx(sets_cnt) = L_indx(2);
                        L3_indx(sets_cnt) = L_indx(3);
                        SlopeX(sets_cnt) = LSF_params(3);
                        SlopeY(sets_cnt) = LSF_params(2);
                        Cnst(sets_cnt) = LSF_params(1);
                        Omegas(sets_cnt) = Omega_now;
                        
%                         clear LSF_params;
%                         clear L_indx;    
                    end
%                     clear X;
%                     clear Y;
%                     clear Z;
                    end 
                end
                    
            end %% closes the Omega_count(i,1) > 3 block
        end %% closes the for i = 1:max_omegas block
         %% closes the CofM_size > 0 block
     end
     

    if (Good_candidate > 0)
        
       LineData = [Cnst', SlopeX', SlopeY', Omegas', L1_indx', L2_indx', L3_indx'];
   else
       LineData = [];
   end

return