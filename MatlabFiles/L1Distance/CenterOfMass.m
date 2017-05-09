function CofMs = CenterOfMass(Spot_Table, Spot_List, Spot_size, Intensity)
    len_Table = size(Spot_Table, 1);
    len_List = size(Spot_List, 2);
    
    for i=1:len_List
       pixel_ct = 0;
       X_sum = 0;
       Y_sum = 0;
       X_avg = 0;
       Y_avg = 0;
       net_intensity = 0;
        for j=1:len_Table
           if (Spot_Table(j,3) == Spot_List(i))
               pixel_ct = pixel_ct + 1;
               net_intensity = Intensity(j) + net_intensity;
               X_sum = Intensity(j)*Spot_Table(j,1) + X_sum;
               Y_sum = Intensity(j)*Spot_Table(j,2) + Y_sum;
           end
         end    
         X_avg = X_sum / net_intensity;
         Y_avg = Y_sum / net_intensity;
         C_o_M(i,1) = X_avg;
         C_o_M(i,2) = Y_avg;
         C_o_M(i,3) = Spot_size(i);        
     end
CofMs = C_o_M;













