function Spots_List = CalcSpotRadiusFromOrigin(Spots_List, X_cent_guess, Y_cent_guess)
 
for i=1:size(Spots_List,1)
        Spots_List(i,11) = sqrt((Spots_List(i,1) - X_cent_guess)^2 + (Spots_List(i,2) - Y_cent_guess)^2);
end

Spots_List = sortrows(Spots_List,11);