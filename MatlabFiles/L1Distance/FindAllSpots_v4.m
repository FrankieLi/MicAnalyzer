%% Script for creating a matrix of spots from raw .f1/.f2/.f3 files.  Will be used in 
%% L1 calculation. This portion of the program calls Spot_Finder for each
%% .f1/.f2/.f3 file.  This will then be fed into a program that forms lines
%% from these spots

%Update to version 3 - Sept. 27, 2007
%Reflects use of 3rd version Spot_Finder

%Update to version 4 - Oct 4, 2007  
%updated by inclusion of Spot_Finder_v4.m for incorporation in toolbox
%added Min_Spot_Size to function input to reflect different size diff.
%spots from different material

function centomass_mtx = FindAllSpots_v4(start_file_num, end_file_num, first_d_filenum, f_template, d_template, Min_Spot_Size) 
%start_file_name refers to the .f1/.f2/.f3 not .tif
% first_d_filenum refers to the first .d1
%f_template is the name that is on the .f1/.f2/.f3 files, INCLUDING THE "_")
% d_template is like f_template only for the .d# files

%N_omegas = end_file_num - start_file_num + 1;
%size_Wdg = 50; %size of wedges in file amount
%N_omg_layer = 100 + 1;

%Function calls:
%Spot_Finder_v3.m


N_omg_layer = end_file_num - start_file_num + 2;

N_Ls = 3; % number of detector distances
CenterOfMass_tot = [];
CenterOfMass_cur = [];
CenterOfMass_valid = [];
CenterOfMass_valid2 = [];

%for i=1:N_omegas
for i = start_file_num:end_file_num
   file_num = int2str(i);
    %Read in file sets
    if (i < 10)
       file_name_L1 = strcat(f_template,'00',file_num);  
       file_name_L2 = strcat(f_template,'00',file_num);
       file_name_L3 = strcat(f_template,'00',file_num);
      
   elseif ((i > 9) && (i < 100)) 
       file_name_L1 = strcat(f_template,'0',file_num);  
       file_name_L2 = strcat(f_template,'0',file_num);
       file_name_L3 = strcat(f_template,'0',file_num);
   else (i > 99)
       file_name_L1 = strcat(f_template,file_num);  
       file_name_L2 = strcat(f_template,file_num);
       file_name_L3 = strcat(f_template,file_num);
       
   end
       
    
   
    CofM_L1 = Spot_Finder_v4(file_name_L1, d_template, i, 1, 0, first_d_filenum, N_omg_layer, Min_Spot_Size); 
    CofM_L2 = Spot_Finder_v4(file_name_L2, d_template, i, 2, 2, first_d_filenum, N_omg_layer, Min_Spot_Size);
    CofM_L3 = Spot_Finder_v4(file_name_L3, d_template, i, 3, 4, first_d_filenum, N_omg_layer, Min_Spot_Size);
    
    CenterOfMass_cur = [CofM_L1; CofM_L2; CofM_L3];

    if (i == 1)
        CenterOfMass_tot = CenterOfMass_cur;
    else
        CenterOfMass_tot = [CenterOfMass_tot; CenterOfMass_cur];
    end
    
    clear file_name_L1;
    clear file_name_L2;
    clear file_name_L3;
    clear image_L1;
    clear image_L2;
    clear image_L3;
    clear CenterOfMass_cur;
end 

%% NEED TO PUT IN SOMETHING THAT CATCHES c_of_masses that occur at the same
%% location on many images (like the scintillator crack)

% Now check for artifacts that aren't spots (i.e. scintillator crack)
% Spits out list with these removed named CenterOfMass_valid2
MtxTot_size = size(CenterOfMass_tot,1);
  if (MtxTot_size == 0)
    CenterOfMass_valid2 = [];
  end

  ct = 0;
  if (MtxTot_size > 0)
    for i=1:MtxTot_size
      x_cur = CenterOfMass_tot(i,1);
      y_cur = CenterOfMass_tot(i,2);
      z_cur = CenterOfMass_tot(i,6); %Added March 1 2007
      
      jstart = i+1;
      for j= jstart:MtxTot_size
          if ( (abs(CenterOfMass_tot(j,1) - x_cur) < 7) && (abs(CenterOfMass_tot(j,2) - y_cur) < 7) && (CenterOfMass_tot(j,5) == CenterOfMass_tot(i,5)))
             CenterOfMass_tot(j,4) = 0;
             CenterOfMass_tot(i,4) = 0;
          end
      end
    
      if (CenterOfMass_tot(i,4) > 0)
        ct = ct + 1;
        CenterOfMass_valid2(ct, :) = CenterOfMass_tot(i,:);
      end
    end
  end
%Routine counts the number of spots found at each omega interval (should be
%multiple of 3)
MtxVal2_size = size(CenterOfMass_valid2, 1);
  if (MtxVal2_size == 0)
      CenterOfMass_valid = [];
  end

  if (MtxVal2_size > 0)
    count = 0;
    %Amts_by_omega(1:N_omegas) = 0; -2/6/2007
     Amts_by_omega(start_file_num:end_file_num) = 0;
        for i=1:MtxVal2_size
        %for j = 1 : N_omegas
            for j=start_file_num:end_file_num
                if (CenterOfMass_valid2(i,5) == j)
                    Amts_by_omega(j) = Amts_by_omega(j) + 1;
                end
            end 
         end
         
%% CenterOfMass_valid2 is a list of only spots that can be used to fit a
%% straight line (need 3)
        ct2 = 0;
        % for i=1:N_omegas
        for i = start_file_num:end_file_num  
            for j = 1:MtxVal2_size
                if ( ( Amts_by_omega(i) >= 3) && (CenterOfMass_valid2(j,5) == i))  %% Big thing to note here is that if we have 3 L3 spots or 
                        ct2 = ct2 + 1;                                             %%%2 L1s and an L3 or something like that, it is deemed valid
                        CenterOfMass_valid(ct2,:) = CenterOfMass_valid2(j,:);
                end
            end
        end
  end 
  
centomass_mtx = CenterOfMass_valid;