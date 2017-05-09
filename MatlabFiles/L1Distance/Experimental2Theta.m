function TwoThetas = Experimental2Theta(AllLines, Spots, L1, pitch_x, pitch_y, direct_beam_x, direct_beam_y, Ldist)

%This function calculates 2Theta explicitly using the lines that were calculated to find L1
%AllLines is the matrix of lines from FindLines3D and HAS been outlier filtered 
%Spots are the list of Spot center of masses
%L1 is the final optimal L1 value
%micronperpixel_x is the pixel pitch in x
%sample_size is the diameter of the sample in microns
%Ldist is either 1,2 or 3 for which plane we are looking at

%Notes - Oct. 5, 2007
%Function calls:
    %FindPlane.m  - NOTE THAT THIS SHOULD EVENTUALLY BE CHANGED TO
    %FindMinDispersion_v2.m, but is fine for the time being

%NOTES - End of this function seems pretty Feb07 specific.  Check later if
%problems
    
twoTheta = [];
sz_AllLines = size(AllLines,1);
L1_microns = L1*1000;
Omega = AllLines(:,4)';

if (Ldist == 1)%L1
    AllLines_indx = 5; %L1 spots are in 5th column of AllLines
    L_offset = 0; 
end

if (Ldist == 2)%L2
    AllLines_indx = 6;
    L_offset = 2000; %L1 + 2.0 mm
end

if (Ldist == 3)%L3
    AllLines_indx = 7;
    L_offset = 4000;
end


    %This for loop calculates the intersection of the 3D line with the L1
    %plane and uses that as the 'beam origin'
    for i=1:sz_AllLines
        tmp = FindPlane(AllLines(i,:), Spots, L1);
        L_spot_x(i) = Spots(AllLines(i,AllLines_indx), 1);
        L_spot_y(i) = Spots(AllLines(i,AllLines_indx), 2);
    
        beam_x = tmp(1);
        beam_y = tmp(2);
        x_spot = Spots(AllLines(i,AllLines_indx),1);
        y_spot = Spots(AllLines(i,AllLines_indx),2);
    
        hypot = sqrt( ((x_spot - beam_x)*pitch_x)^2 + ((y_spot - beam_y)*pitch_y)^2);
        twotheta_1(i) = (atan(hypot / (L1_microns+L_offset)))*(180/pi);
    
        eta_x = x_spot - beam_x;
        eta_y = beam_y - y_spot;
    
        eta(i) = (atan(eta_x / eta_y) * (180/pi));  
    end

    %This method uses the mean intersection of all 3D lines with L1 as the
    %'beam origin'  --- this is ignored
    for i=1:sz_AllLines
        
    
        beam_x = direct_beam_x;
        beam_y = direct_beam_y;
        x_spot = Spots(AllLines(i,7),1);
        y_spot = Spots(AllLines(i,7),2);
    
        hypot = sqrt( ((x_spot - beam_x)*pitch_x)^2 + ((y_spot - beam_y)*pitch_y)^2);
        twotheta_2(i) = (atan(hypot / (L1_microns+4000)))*(180/pi);
    
    end
   

RealOmega = [];
secondwedge = -59.5;
cnt_W = 0;

for i = 1:sz_AllLines
    if (AllLines(i,4) <= 50)
        RealOmega(i) = Omega(i) - 150.5;
    end
    if (AllLines(i,4) > 50)
        RealOmega(i) = secondwedge + cnt_W;
        cnt_W = cnt_W + 1;
    end
end

    
TwoThetas = [Omega', twotheta_1', eta', L_spot_x', L_spot_y'];
    

