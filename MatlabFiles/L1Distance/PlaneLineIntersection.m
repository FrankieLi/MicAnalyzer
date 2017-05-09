function plane =  PlaneLineIntersection(AllLines_LSF, Shift_Spot, Zfit_LSF, z_guess)

%Uses method found in http://mathworld.wolfram.com/Line-PlaneIntersection.html

N_Lines = size(AllLines_LSF,1);

z_guess_neg = z_guess*(-1);
X_int = [];
Y_int = [];

for i=1:N_Lines
    Num_Mtx = [1,1,1,1; 1,0,0,Shift_Spot(AllLines_LSF(i,5),1); 0,1,0,Shift_Spot(AllLines_LSF(i,5),2); z_guess_neg, z_guess_neg, z_guess_neg, Zfit_LSF(i,1)];    
    Den_Mtx = [1,1,1,0; 1,0,0,Shift_Spot(AllLines_LSF(i,7),1) - Shift_Spot(AllLines_LSF(i,5),1); 0,1,0,Shift_Spot(AllLines_LSF(i,7),2) - Shift_Spot(AllLines_LSF(i,5),2); z_guess_neg, z_guess_neg, z_guess_neg, Zfit_LSF(i,3) - Zfit_LSF(i,1)];
    
    detN = det(Num_Mtx);
    detD = det(Den_Mtx);
    
    t(i)=-1*(detN/detD);
    
    X_int(i) = Shift_Spot(AllLines_LSF(i,5),1) + ( Shift_Spot(AllLines_LSF(i,7),1) - Shift_Spot(AllLines_LSF(i,5),1))*t(i);
    Y_int(i) = Shift_Spot(AllLines_LSF(i,5),2) + (Shift_Spot(AllLines_LSF(i,7),2) - Shift_Spot(AllLines_LSF(i,5),2))*t(i);
    Z_int(i) = Zfit_LSF(i,1) + (Zfit_LSF(i,3) - Zfit_LSF(i,1))*t(i);
end

%(X_int)
%(Y_int)


mean_x = mean(X_int);
mean_y = mean(Y_int);
z_guess_pos = z_guess;
std_x = std(X_int);
std_y = std(Y_int);
Stdev = sqrt(std_x^2 + std_y^2);

plot(X_int, Y_int, '.');
    
plane = [mean_x, mean_y, z_guess_pos, Stdev];