function LineData = FindLines3D_v3(Spots)

N_spots = size(Spots,1);

Omg_max = max(Spots(:,5));
Omg_min = min(Spots(:,5));

for j = Omg_min:Omg_max
    
    cnt_omg_L1 = 0;
    cnt_omg_L2 = 0;
    cnt_omg_L3 = 0;
    
    for i=1:N_spots
        if (Spots(i,5) == j)
            if (Spots(i,4) == 1)          
               cnt_omg_L1 = cnt_omg_L1 + 1;
               Spots_Omg_L1(cnt_omg_L1, :) = Spots(i,:);
            
                elseif(Spots(i,4) == 2)
                cnt_omg_L2 = cnt_omg_L2 + 1;
                Spots_Omg_L2(cnt_omg_L2,:) = Spots(i,:);
            
                elseif(Spots(i,4) == 3)
                cnt_omg_L3 = cnt_omg_L3 + 1;
                Spots_Omg_L3(cnt_omg_L3,:) = Spots(i,:);
            
                else
                error('Incorrect spot indexing in Spots file.  Column 4 should only have 1, 2 or 3');
            end
                
        end
    end
    % We now have 3 matricies for omega = i:  Spots_Omg_L1, Spots_Omg_L2, Spots_Omg_L3
    
    %Now calculate the distance from the L1 spots to the L2 spots & L2 to L3 spots
    
    L1toL2 = [];
    L2toL3 = [];
    
    N_L1spots = size(Spots_Omg_L1,1);
    N_L2spots = size(Spots_Omg_L2,1);
    N_L3spots = size(Spots_Omg_L3,1);
    
    for i1 = 1:N_L1spots
        for j1 = 1:N_L2spots
            L1toL2(i1,j1) = sqrt( (Spots_Omg_L1(i1,1) - Spots_Omg_L2(j1,1))^2 + (Spots_Omg_L1(i1,2) - Spots_Omg_L2(j1,2))^2 );
        end
    end
    
    for i2 = 1:N_L2spots
        for j2 = 1:N_L3spots
            L2toL3(i2,j2) = sqrt( (Spots_Omg_L2(i2,1) - Spots_Omg_L3(j2,1))^2 + (Spots_Omg_L2(i2,2) - Spots_Omg_L3(j2,2))^2 );
        end
    end
    
    