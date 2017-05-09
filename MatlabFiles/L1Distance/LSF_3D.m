function [AllLines_LSF, Zfit_LSF] = LSF_3D(AllLines, Shift_Spot)

N_lines = size(AllLines,1);

%Get pixel coordinates
for i=1:N_lines
    
    X(i,1) = Shift_Spot(AllLines(i,5),1); %X for L1
    X(i,2) = Shift_Spot(AllLines(i,6),1); %X for L2
    X(i,3) = Shift_Spot(AllLines(i,7),1); %X for L3
    
    Y(i,1) = Shift_Spot(AllLines(i,5),2); %Y for L1
    Y(i,2) = Shift_Spot(AllLines(i,6),2); %Y for L2
    Y(i,3) = Shift_Spot(AllLines(i,7),2); %Y for L3
    
    Z(i,1) = 0;
    Z(i,2) = 2;
    Z(i,3) = 4;
    
    X_matrix = [1, X(i,1), Y(i,1); 1, X(i,2), Y(i,2); 1, X(i,3), Y(i,3)];
    Y_matrix = [Z(i,1); Z(i,2); Z(i,3)];
    
    b_matrix = ((X_matrix' * X_matrix)^(-1)) * X_matrix' * Y_matrix;
    
    Incpt(i) = b_matrix(1);
    X_slope(i) = b_matrix(2);
    Y_slope(i) = b_matrix(3);
    
    Zfit = X_matrix*b_matrix;
    Zfit_LSF(i,1) = Zfit(1);
    Zfit_LSF(i,2) = Zfit(2);
    Zfit_LSF(i,3) = Zfit(3);
    
    
    AllLines_LSF(i,1) = Incpt(i);
    AllLines_LSF(i,2) = X_slope(i);
    AllLines_LSF(i,3) = Y_slope(i);
    AllLines_LSF(i,4) = AllLines(i,4);
    AllLines_LSF(i,5) = AllLines(i,5);
    AllLines_LSF(i,6) = AllLines(i,6);
    AllLines_LSF(i,7) = AllLines(i,7);
    
end

    
    
    