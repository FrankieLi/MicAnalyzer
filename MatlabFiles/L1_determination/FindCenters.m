function [Centers, x_cent, y_cent, Spots_newRadii] = FindCenters(Spots_final)

N_radii = max(Spots_final(:,13));

for i=1:N_radii
    x =[];
    y =[];
    u = [];
    v = [];
    
    idx_radii = find(Spots_final(:,13) == i);
    if (length(idx_radii) > 0)
        
        x = Spots_final(idx_radii, 2);
        y = Spots_final(idx_radii,1);
        
        N_pts = length(x);
        
        
        X_bar = mean(x);
        Y_bar = mean(y);
        
        u = x - X_bar;
        v = y - Y_bar;
        
        Suu = sum(u.*u);
        Suv = sum(u.*v);
        Suuu = sum(u.*u.*u);
        Suvv = sum(u.*v.*v);
        Svv = sum(v.*v);
        Svvv = sum(v.*v.*v);
        Svuu = sum(v.*u.*u);
        
        v_c = (0.5*(Svvv + Svuu - ((Suuu*Suv)/Suu) - ((Suvv*Suv)/Suu)))/(Svv - ((Suv*Suv)/Suu));
        
        u_c = (0.5*(Suuu + Suvv) - v_c*Suv)/Suu;
          
        R = sqrt(u_c^2 + v_c^2 + ((Suu + Svv)/N_pts));
        
        x_c = u_c + X_bar;
        y_c = v_c + Y_bar;
        
        Centers(i,1) = x_c;
        Centers(i,2) = y_c;
        Centers(i,3) = R;
        Centers(i,4) = N_pts;
        
    end
end

Weight_x_c = sum(Centers(:,1).*Centers(:,4));
Weight_y_c = sum(Centers(:,2).*Centers(:,4));

x_cent = Weight_x_c / (sum(Centers(:,4)));
y_cent = Weight_y_c / (sum(Centers(:,4)));

N_spots = size(Spots_final,1);

Spots_newRadii = Spots_final;

for i=1:N_spots
    Spots_newRadii(i,11) = sqrt((Spots_final(i,1) - x_cent)^2 + (Spots_final(i,2) - y_cent)^2);
end