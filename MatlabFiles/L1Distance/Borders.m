function brd = Borders(x_min, x_max, y_min, y_max, dist)

    brd_x_rt = 0;
    brd_x_lt = 0;
    brd_y_top = 0;
    brd_y_btm = 0;
    
    if  (x_max == 1024) 
        x_high = x_max;
        bdr_x_rt = 1;
    elseif (x_max == 1023)
        x_high = 1024;
        brd_x_rt = 1;    
    else
        x_high = x_max + 1; 
    end

    if ( x_min == 1)
        x_low = x_min;
        brd_x_lt = 1;
    elseif (x_min == 2)
        x_low = 1;
        brd_x_lt = 1;       
    else
        x_low = x_min - 1; 
    end

    if ( y_max == 1024)
        y_high = y_max;
        brd_y_top = 1;
    elseif (y_max == 1023)
        y_high = 1024;
        brd_y_top = 1;    
    else
        y_high = y_max + 1; 
    end

    if ( y_min == 1)
        y_low = y_min;
        brd_y_btm = 1;
    elseif (y_min == 2)
        y_low = 1;
        brd_y_btm = 1;
    else    
        y_low = y_min - 1; 
    end

    brd = [dist; x_high; x_low; y_high; y_low; brd_x_rt; brd_x_lt; brd_y_top; brd_y_btm]';