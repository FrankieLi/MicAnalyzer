%%
%%  Spot_Finder program, takes in the file name and returns the center of
%%  mass info
%% February 2, 2007
%% Chris Hefferan
%% Program takes image and finds center of mass of valid spots

%% March 1, 2007 
%% Updated to include z distance (0 for L1, 2 for L2, 4 for L3)

%% July 31, 2007
% Update at line 224 to include possibility of finding nothing in
% preliminary stages.  This is IDed by NOSPOTS
%NOSPOTS = 0 means we have no spots
%NOSPOTS = 1 means we do have spots

%September 27, 2007 - version 3
%Note that the CCD camera will assign the first pixel as 0 and the last as
%1023.  Matlab wants to call the first pixel 1 and the last 1024, so we
%need to reflect this and then unapply the Matlab shift in doing a fit
%(since we still use the CCD configuration in fits)

%Oct. 4, 2007 - version 4 - updated for toolbox
%Added Min_Spot_Size to function call.  Used for IDing peaks of different
%material - Gold Min_Spot_Size should = ~5, ruby ~ 40

%Function calls:
%        Borders.m
%        CenterOfMass.m
%        GetIntensity_v3.m


function center_of_mass = Spot_Finder_v4(fit_name_template, d_name_template, omega, L, z, ini_d_filenum, omg_per_layer, Min_Spot_Size)

%% Append extension to image name template according to L distance
if (L == 1)
    img_ext = '.f1';
    int_ext = '.d1';
    d_img_num = ini_d_filenum + omega - 1;
    d_img_num_str = int2str(d_img_num);
    
elseif (L == 2)
    img_ext = '.f2';
    int_ext = '.d2';
    d_img_num = ini_d_filenum + omg_per_layer - 1 + omega
    d_img_num_str = int2str(d_img_num);
else
    img_ext = '.f3';
    int_ext = '.d3';
    d_img_num = ini_d_filenum + 2*omg_per_layer - 1 + omega;
    d_img_num_str = int2str(d_img_num);
end    

if (d_img_num < 10)
    d_0_spacer = '0000';
elseif ((d_img_num > 9) && (d_img_num < 100))
    d_0_spacer = '000';
else 
    d_0_spacer = '00';
end
    
img_name = strcat(fit_name_template, img_ext);
intensity_img_name = strcat(d_name_template, d_0_spacer, d_img_num_str, int_ext);
img_name
intensity_img_name

img = csvread(img_name);

if(size(img,1) == 0) %added during v3 update for possiblity of empty d#/f# file
    center_of_mass = [];
    return
end


XX_raw_pre = img(:,3) + 1; %v3 update to go from 0-1023 to 1-1024
YY_raw_pre = img(:,4) + 1; %v3 update 

XX_sz = size(XX_raw_pre,1);
YY_sz = size(YY_raw_pre,1);


%Commented out for version 3 - Sept 27,2007
% for i = 1:XX_sz
%     if (XX_raw_pre(i) < 0)
%         XX_raw_pre(i) = 1;
%     end
%     
%     if (XX_raw_pre(i) > 1024)
%         XX_raw_pre(i) = 1024;
%     end
% end
% 
% for i=1:YY_sz
%     if (YY_raw_pre(i) < 0)
%         YY_raw_pre(i) = 1;
%     end
%     
%     if (YY_raw_pre(i) > 1024)
%         YY_raw_pre(i) = 1024;
%     end
% end

for i = 1:XX_sz
    if ((XX_raw_pre(i) < 0) || (XX_raw_pre(i) > 1024))
        error('.d# file has pixels out of range!')
    end
end

for i = 1:YY_sz
    if ((YY_raw_pre(i) < 0) || (YY_raw_pre(i) > 1024))
        error('.d# file has pixels out of range!')
    end
end


%YY_raw = 1024 - YY_raw_pre;
YY_raw = 1025 - YY_raw_pre; %v3  (pixel 1024 -> 1, pixel 1 -> 1024)
XX_raw = XX_raw_pre;


xx_max_raw = max(XX_raw);
yy_max_raw = max(YY_raw);
xx_min_raw = min(XX_raw);
yy_min_raw = min(YY_raw);
L_borders = Borders(xx_min_raw, xx_max_raw, yy_min_raw, yy_max_raw, L);

size_XX_raw = size(XX_raw,1);

% figure(1)
% plot(XX_raw,YY_raw, 'X')
% axis([0 1024 0 1024])

%% Now reason through the procedure to find meaningful spots
%% Map of 0's for not hits and 1's for hits
mapL(1:1024, 1:1024) = 0;

for i=1:size_XX_raw
      mapL(XX_raw(i),YY_raw(i)) = 1;
end

%Now create a map that averages the pixels in a 3x3 block and sets the
%average value to the center.

%Do interior averaging
avgMapL(1:1024, 1:1024) = 0;

%Works out so that we don't go out of range in the averaging procedure
i_low = max(2, L_borders(3));
i_high = min(1023, L_borders(2));
j_low = max(2, L_borders(5));
j_high = min(1023, L_borders(4));

for i=i_low:i_high
  for j=j_low:j_high
    avgMapL(i,j) = ( mapL(i+1, j-1) + mapL(i,j-1) + mapL(i-1,j-1) + mapL(i,j) + mapL(i+1,j) + mapL(i-1,j) + mapL(i+1,j+1) + mapL(i-1,j+1) + mapL(i,j+1) )/9;  
  end
end

%Picture Frame averaging
if (L_borders(7) == 1) %The left border of image is necessary
   for j=j_low:j_high
       avgMapL(1,j) = ( mapL(1,j) + mapL(1,j+1) + mapL(1,j-1) + mapL(2,j) + mapL(2,j+1) + mapL(2,j-1) ) / 6;
   end
end

if (L_borders(8) == 1) %The top border of image is necessary
   for i=i_low:i_high
       avgMapL(i,1) = ( mapL(i,1) + mapL(i+1,1) + mapL(i-1,1) + mapL(i,2) + mapL(i+1,2) + mapL(i-1,2) ) / 6;
   end
end

if (L_borders(6) == 1) %The right border of image is necessary
   for j=j_low:j_high
       avgMapL(1024,j) = ( mapL(1024,j) + mapL(1024,j+1) + mapL(1024,j-1) + mapL(1023,j) + mapL(1023,j+1) + mapL(1023,j-1) ) / 6;
   end
end

if (L_borders(9) == 1) %The bottom border of image is necessary
    for i=i_low:i_high
        avgMapL(i,1024) = ( mapL(i,1024) + mapL(i+1,1024) + mapL(i-1,1024) + mapL(i,1023) + mapL(i+1,1023) + mapL(i-1,1023) ) / 6;
    end
end

%Averaging corners

 if ((L_borders(7) == 1) && ( L_borders(9) == 1))
         avgMapL(1,1) = ( mapL(1,1) + mapL(2,2) + mapL(1,2) + mapL(2,1))/4;
 end
 
 if ((L_borders(8) == 1) && ( L_borders(6) == 1))
         avgMapL(1024,1024) = (mapL(1024,1024) + mapL(1023,1023) + mapL(1024,1023) + mapL(1023,1024) ) / 4;
 end  
        
 if ((L_borders(9) == 1) && ( L_borders(6) == 1))
         avgMapL(1024,1) = ( mapL(1024,1) + mapL(1024,2) + mapL(1023,1) + mapL(1023,2)) /4;
 end
    
 if ((L_borders(7) == 1) && ( L_borders(8) == 1))
         avgMapL(1,1024) = ( mapL(1,1024) + mapL(2,1024) + mapL(1,1023) + mapL(2,1023)) /4;
 end

%%%Now points in avgMapL that = 0.1111 indicate that the 3x3 box has 1
%%%point, and therefore they can be zeroed since if the point is at the
%%%center of the 3x3 square...it's noise.  If it's on the edge, that
%%%doesn't affect the raw data

% CleanMapL is the matrix that has removed all pixels with an average less
% than 0.2
avg_thresh = 0.2;
for i=1:1024
   for j=1:1024
      if (avgMapL(i,j) > avg_thresh)
         cleanMapL(i,j) = 1;
      else
         cleanMapL(i,j) = 0;
      end
  end
end

%% Make lists (X_Lc, Y_Lc) of the X,Y coords of remaining pixels after filtering (pixels are
%% still the result of averaging, so they aren't necessarily the same size as the raw data, that
%% is remedied in the next section) 
a = 1;for i=1:1024  for j=1:1024     if (cleanMapL(i,j) == 1)
        X_Lc(a) = i;
        Y_Lc(a) = j;
       a = a + 1;   
     end
  end
end
% figure(2)
% plot(X_Lc,Y_Lc, 'X')
% axis([1 1024 1 1024])

%% Now look for consistencies between the two images:
%% mapL is the raw image data & cleanMapL is the filtered image
%% Only instances where both mapL and cleanMapL = 1 is the pixel
%% meaningful, so do search of that to produce mapGoodL

for i=1:1024
  for j=1:1024
     if ( mapL(i,j) + cleanMapL(i,j) == 2 )
       mapGoodL(i,j) = 1;
     else
       mapGoodL(i,j) = 0;
     end     
 end
end

%% Make lists (x_mGoodL, y_mGoodL) of the X,Y coords of filtered pixels
%% that are still valid
t = 1;
for i=1:1024
  for j=1:1024
     if (mapGoodL(i,j) == 1)        x_mGoodL(t) = i;        y_mGoodL(t) = j;       t = t + 1;   
     end
  end
end


NOSPOTS = 1;

if (t == 1) %There were no legitimate spots in this layer
    NOSPOTS = 0;
end

%% Now get a before and after image from the filtering, with the L's stacked

if (NOSPOTS > 0)
    X_raw = [XX_raw']';
    Y_raw = [YY_raw']';

    X_filt = [x_mGoodL]';
    Y_filt = [y_mGoodL]';

%figure(3)
%plot(X_raw, Y_raw, 'X')
%axis([0 1024 0 1024])

% figure(4)
% plot(X_filt, Y_filt, 'X')
% axis([0 1024 0 1024])
%%% ACUTAL SPOT FINDING TECHNIQUE

    L_size_filt = size(x_mGoodL,2); %L#_size_filter is the number of pixels that remain after filtering
    SPOTS_L(1:L_size_filt) = 0; %SPOTS is a vector that assigns a number to each pixel, associated with its spot.  All pixels with the same SPOTS number are in the same dense spot
    count_num  = 0;


    for i=1:L_size_filt
       cur_x = x_mGoodL(i);
       cur_y = y_mGoodL(i);
       flag_merg = 0;
       
       if (SPOTS_L(i) == 0) %if this pixel HAS NOT been analyzed yet, it is associated with a new spot.  Increment the count number and set SPOT # to that count
          count_num = count_num + 1;
          SPOTS_L(i) = count_num;
       elseif (SPOTS_L(i) ~= 0) % if this pixel HAS been analyzed before, use that count number (making a spot bigger by virture of spot #) 
          count_num = SPOTS_L(i);  
       end
        
       for j = 1:L_size_filt
            if ( abs( x_mGoodL(j) - cur_x ) < 2)
              if ( abs( y_mGoodL(j) - cur_y ) < 2) 
                  if (SPOTS_L(j) == 0) %If we haven't looked at the pixel already
                      SPOTS_L(j) = count_num;
                  else 
                      SPOTS_L(i) = SPOTS_L(j);  % If we have already assigned the neighboring pixel a #, assign that # to our current spot
                      merge_number = SPOTS_L(j); %save this neighboring pixel number (since we need to rename everything with current # to this already existing number)
                      flag_merge = 1;   
                  end   
              end
            end
        end
        
        if (flag_merge ==1) %If we have have adjacent pixels with unequal spot numbers, we need to change SPOTS_L such that they are equal.  Do this by taking the lower number (merge_number)
           for i=1:L_size_filt
                if (SPOTS_L(i) == count_num)
                    SPOTS_L(i) = merge_number;
                end
            end
        end
        
        count_num = max(SPOTS_L); % Needed in case we bounced into the elseif statement above (count_num needs reset)
    end


%% Now need to re-number everything to ensure that the histogram does the
%% correct numberings (problem due to the merging of spots)
%% I.e. we need can't use the hist function 
    n_spots = max(SPOTS_L);
    HIST(1:n_spots) = 0;
    for i = 1:n_spots
        for j = 1:L_size_filt
            if (SPOTS_L(j) == i)
                HIST(i) = HIST(i) + 1;
            end
        end
    end
    mu_spotsize = mean(HIST);
    sig_spotsize = std(HIST);



%%%% THIS PART USES STATISTICS TO FIND SPOTS (USES STANDARD DEVIATIONS OR ABSOLUTE SIZE)
    found = 0;
    spt_cnt = 0;
    for i=1:size(HIST,2)
%    if (abs(HIST(i) - mu_spotsize) > 4*sig_spotsize) % if the size of the spot is 5 standard deviations greater than average, it's a diffraction spot
         if (HIST(i) > Min_Spot_Size) %if more than 5 compact spots, it's a gold spot
            found = 1;
            spt_cnt = spt_cnt + 1;
            Valid_spt(spt_cnt) = i; % Valid is a list of diffraction spots (labelled with their spot number.  If only spots 1 and 5 give diffraction, Valid_spt = [1,5])     
            Size_of_Spot(spt_cnt) = HIST(i);
        end
    end

    if (found == 1) %If we have found spots
    
        n_valid_spts = size(Valid_spt,2)

       Spot_Table_L_raw = [x_mGoodL; y_mGoodL; SPOTS_L]'; %Spot_Table_L1 contains X,Y coord of pixels, the SPOT these pixels are associated with

  %% Identify diffraction spots in the new matrix that only contains
  %% diffraction spots
        cnt = 0;
        for i = 1:n_valid_spts 
            for j=1:L_size_filt
                if (Spot_Table_L_raw(j,3) == Valid_spt(i)) %if the SPOT number = one of identified, valid spot numbers
                    cnt = cnt + 1;
                    X_valid(cnt) = Spot_Table_L_raw(j,1);
                    %Y_valid(cnt) = 1024 - Spot_Table_L_raw(j,2); %1024 - is due to fixing the earlier flip
                    Y_valid(cnt) = 1025 - Spot_Table_L_raw(j,2); %v3 fix - 1025 - from earlier
                    
                   Spot_num(cnt) = Spot_Table_L_raw(j,3); %only should be ending up with numbers that were in Valid_spt
                end
            end
        end
       
        
  %% Put in the get intensity function
        Intensity = GetIntensity_v3(X_valid, Y_valid, intensity_img_name); 
        size_intensity = size(Intensity,2);
  
        %v3 correction to account for +1 in line 59,60
        X_valid_CCD = X_valid - 1;
        Y_valid_CCD = Y_valid - 1;
        
        Spot_Table_L = [X_valid_CCD; Y_valid_CCD; Spot_num]'; % Spot_Table_L1 is a list of diffraction spots (X coord, Y coord, Spot_number)
        c_of_m_L = CenterOfMass(Spot_Table_L, Valid_spt, Size_of_Spot, Intensity);

  %figure(5)
  %plot(X_valid, Y_valid, 'X')
  %axis([0 1024 0 1024])

  % UPDATED March 1, 2007 to include z record
        if (n_valid_spts > 1)
            L_multi(1:n_valid_spts) = L;
            z_multi(1:n_valid_spts) = z;
            Omega_multi(1:n_valid_spts) = omega;
     
        else
            L_multi = L;
            z_multi = z;
            Omega_multi = omega;
        end
        center_of_mass = [c_of_m_L, L_multi', Omega_multi', z_multi'];
    end

    if (found == 0) %% If we find no spots we return 0 as the x coord, 0 as the y coord, 0 as teh spot number
        center_of_mass = [];
    end
    end

if (NOSPOTS == 0)
    center_of_mass = [];
end

%%% One thing to consider is if L1 and L2 had spots, then maybe lower the
%%% criteria for L3 and find spots (i.e. don't use 5*sigma, but 4*sigma,
%%% etc)

