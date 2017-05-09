function TwoThetaList = Get2Thetas_v3(Spots_Isol_by_L_2)

%Sept. 28, 2007
%Input: Spots_Isol_by_L_2 -> [ center of int x, cent of int y, z_dist, theory2theta]

twothetas = Spots_Isol_by_L_2(:,4);
twothetas_sort = sort(twothetas);

N_pts = size(twothetas_sort,1);

cnt = 1;

TwoThetaList(1) = twothetas_sort(1);

for i = 2:N_pts
    if (abs(twothetas_sort(i) - TwoThetaList(cnt)) > 0) 
        cnt = cnt + 1;
        TwoThetaList(cnt) = twothetas_sort(i);
    end
end


