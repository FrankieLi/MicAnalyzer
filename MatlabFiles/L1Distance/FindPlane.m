
function plane = FindPlane(AllLines, Spot_Data, z_guess_pos)

num_Lines = size(AllLines, 1);

% Define plane  - currently not used
z_guess = (z_guess_pos)*(-1);



% Figure out x,y,z coords of spots on best fit line, see pg. 814 of James
% Stewart Calc book
for i = 1:num_Lines
    
    x_pt_1 = Spot_Data(AllLines(i,5), 1);
    y_pt_1 = Spot_Data(AllLines(i,5), 2);
    z_pt_1 = AllLines(i,1) + AllLines(i,2)*x_pt_1 + AllLines(i,3) * y_pt_1;
    
    x_pt_2 = Spot_Data(AllLines(i,7), 1);
    y_pt_2 = Spot_Data(AllLines(i,7), 2);
    z_pt_2 = AllLines(i,1) + AllLines(i,2)*x_pt_2 + AllLines(i,3) * y_pt_2;
    
    slp_x = x_pt_2 - x_pt_1;
    slp_y = y_pt_2 - y_pt_1;
    slp_z = z_pt_2 - z_pt_1;
    
    t = (z_guess - z_pt_1)/slp_z;
    
    x_plane_int(i) = x_pt_1 + slp_x * t;
    y_plane_int(i) = y_pt_1 + slp_y * t;
end

    std_x = std(x_plane_int);
    std_y = std(y_plane_int);
    mean_x = mean(x_plane_int);
    mean_y = mean(y_plane_int);
    
    Stdev = sqrt(std_x^2 + std_y^2);
    
    figure(4);
    plot(x_plane_int, y_plane_int, '.');
    
plane = [mean_x, mean_y, z_guess_pos, Stdev];

