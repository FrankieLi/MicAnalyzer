function L_data = IsolateL(AllLines, Spots, L1, pix_pitch_x, pix_pitch_y, db_x, db_y, L, material, theta_thresh)

%IsolateL takes the raw spot data and returns which spots occur in figuring
%out the L1 and also returns the theoretical 2theta that each one is associated

%Functions called:
%         IndexExperiment.m

%Edited 10/5/07 to include material and theta_thresh as function inputs

maxHKL = 8;

if (L == 1)
    column = 5;
elseif (L == 2)
    column = 6;
elseif (L == 3)
    column = 7;
end

IE = IndexExperiment(AllLines, Spots, L1, pix_pitch_x, pix_pitch_y, maxHKL,theta_thresh, db_x, db_y, L, material);
TwoThetas = IE(:, 5);




sz_Lines = size(AllLines,1);
cnt = 0;


for i = 1:sz_Lines
    
    L_x(i) = Spots(AllLines(i,column), 1);
    L_y(i) = Spots(AllLines(i,column), 2);
    L_z(i) = Spots(AllLines(i,column), 6);
    
end

L_data = [L_x', L_y', L_z', TwoThetas];
        