%L1 calculation program for 3DXDM data
%Script by Chris Hefferan

%% Purpose - Intention of this program is to calculate the sample to detector distance (L1) for small crystal data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data files needed:

%.d1/.d2/.d3 files for  intensity values (detector raw files)
%.f1/.f2/.f3 files for  valid spots (detector fit files)
%summary.fix (optional)

%Top row of the .d# and .f# need to be removed so it is purely columns of
%numbers (Not # with bg prep information)

%summary.fix needs the top 2 rows removed


%L1_v3 has been updated to all directory location of f#/d# files. - September 27, 2007

%Update October 4, 2007 - made for generalization and incorporation into
%toolbox

%Script is a combination of old files: UserL1_v3.m and GetL1data.m

%Functions called:
%  FindAllSpots_v4.m 
%  FindLines3D_v2.m
%  LSF_3D.m
%  PlaneLineIntersection.m
%  FindMinDispersion_v2.m
%  OutlierFinder_v3.m
%  IsolateL.m
%  Get2Thetas_v3.m


  %Secondary functions called by above that aren't in the above list:
       %FindAllSpots - Spot_Finder_v4.m, Borders.m, CenterOfMass.m, GetIntensity_v3.m
       %OutlierFinder_v3 - PlaneLineIntersection_xy.m
       %IsolateL - IndexExperiment.m, Theory2Thetas_v4.m, Experimental2Theta.m, FindPlane.m (as of 10/5/07), CalcTwoTheta_50keV_Au.m, CalcTwoTheta_50keV_Ruby.m
       
       
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%        USER DEFINED  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%         PARAMETERS   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Numbers of files:

final_f_num = 100;  % Final number of the .f1/.f2/.f3 files (each file number goes with a specific omega interval)
                    % Hence final_f_num = #, implies that this layer has #
                    % omegas
initial_f_num = 1; % First number of the .f1/.f2/.f3 files to include
initial_d_num = 1; % File number associate with first .d1 file

% File templates:
f_template = 'C:\Research\11-feb07\BgImgFits\Gold_z1\Gold_z1_Nofit\Nofit_z1i_'; % Stamp that occurs on every .f# file, including the "_"
d_template = 'C:\Research\11-feb07\BgImgFits\Gold_z1\Gold_z1_Nofit\Au_inRuby_bgImg_'; %Stamp that occurs on every .d# file, including the "_"

% Pixel Pitches (should be determined by raster):
pix_pitch_x = 4.11;
pix_pitch_y = 4.11;
L1_estimate = 5.111;
L_to_plot = 1;  %This number reflects which plane of spots is recorded in the Spots_Isol_by_L matrix, which can later be used for direct beam determination on plane
                %Spots_Isol_by_L is also useful for indexing single crystals
Min_Spot_Size = 5;  %If Gold use 5, if ruby use ~40.  Indicates how many connected, illuminated pixels are needed to be deemed a diff. spot from sample 
material = 0; % material = 1 for ruby, material = 0 for gold.  Needed in indexing
theta_thresh = 0.3; %Sidebars on theoretical 2 theta values (in degrees) to ID experimental two thetas, with theoretical two thetas

%Reduce data into center of intensities of valid spots
Spots = FindAllSpots_v4(initial_f_num, final_f_num, initial_d_num, f_template, d_template, Min_Spot_Size); 
        %Note if you already have the results of Spots you can just read it
        %in here
        

%Fit lines to colinear spots of 3

AllLines_ini = FindLines3D_v2(Spots);

[AllLines_LSF, Zfit_LSF] = LSF_3D(AllLines_ini, Spots);
sz_AllLines = size(AllLines_LSF,1);

plane_1 =  PlaneLineIntersection(AllLines_LSF, Spots, Zfit_LSF, L1_estimate);
     
L1_data_first = FindMinDispersion_v2(AllLines_LSF ,Zfit_LSF, Spots);
plane_2 =  PlaneLineIntersection(AllLines_LSF, Spots, Zfit_LSF, L1_data_first);


Lines_to_Omit = OutlierFinder_v3(AllLines_LSF, Zfit_LSF, Spots, L1_data_first); %Search for outlier lines
sz_LtO = size(Lines_to_Omit, 2);

if (sz_LtO == 0)
        AllLines_new = AllLines_LSF;
end

if (sz_LtO == 1)
        AllLines_new = [AllLines_LSF(1:(Lines_to_Omit(1) - 1),:); AllLines_LSF((Lines_to_Omit(1) + 1):sz_AllLines,:)];
        sz_Lt0 = 1;
end

if(sz_LtO > 1)
        AllLines_new = [AllLines_LSF(1:(Lines_to_Omit(1) - 1),:)];
           for jj = 2:sz_LtO
                AllLines_new = [AllLines_new; AllLines_LSF((Lines_to_Omit(jj-1) + 1):(Lines_to_Omit(jj) - 1), :)]; 
           end
        
        AllLines_new = [AllLines_new; AllLines_LSF( (Lines_to_Omit(sz_LtO) + 1):sz_AllLines,:)];
end


[AllLines_Final, Zfit_Final] = LSF_3D(AllLines_new, Spots);

L1 = FindMinDispersion_v2(AllLines_Final, Zfit_Final, Spots);
tmpPlane = PlaneLineIntersection(AllLines_Final, Spots, Zfit_Final, L1);
direct_beam_x = tmpPlane(1);
direct_beam_y = tmpPlane(2);


Ldata = [L1; direct_beam_x; direct_beam_y];
 
Spots_Isol_by_L = IsolateL(AllLines_Final, Spots, L1, pix_pitch_x, pix_pitch_y, direct_beam_x, direct_beam_y, L_to_plot, material, theta_thresh);

TwoThetaList = Get2Thetas_v3(Spots_Isol_by_L);

%Output that is relevant from this script:

%L1                 - distance in mm from 1st detector setting to sample
%direct_beam_x      - direct beam in horizontal direction found by taking mean of line intersections with L1 plane
%direct_beam_y      - direct beam in vertical direction found by taking mean of line intersections with L1 plane
%Spots              - information on all center of intensities
%AllLines_Final     - list of lines (with reference to Spots) that contribute to L1 calculation
%Spots_Isol_by_L    - List of spots that contribute to L1 @ given det distance (used for direct_beam by plane calculation and indexing)
%TwoThetaList       - List of theoretical peaks seen in data set (useful for single crystal data)