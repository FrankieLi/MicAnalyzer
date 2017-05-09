function Spot_List = ConfirmRadiusTwoThetaAssign(Spot_List, det_size, Spot_List_noThresh)

[indx_2theta, TwoThetaList_deg] = Theory2Thetas_Au(9,50);
figure(66)
PlotTheory2Theta(1024, 2012, TwoThetaList_deg(1:(max(Spot_List(:,13))+4)), 0.003, 1); %will plot a typical diffraction ring pattern for gold.  Numbers should synch up with radius grouping.

for i=1:max(Spot_List(:,13))
    figure(68)
    plot(Spot_List_noThresh(:,1), Spot_List_noThresh(:,2), '.k')
    hold on
    plot(Spot_List(:,1), Spot_List(:,2), 'xk');
    radAns = 0;
    hold on
    idx = [];
    idx = find(Spot_List(:,13) == i);
    hold on
    plot(Spot_List(idx,1), Spot_List(idx,2), '.r');
    axis ij
    axis equal
    axis([ 0 det_size 0 det_size])
    radAns = input(strcat('Do you agree that this set should be 2_theta group #' , int2str(i), '? - Press 1 for yes, press 0 for no : '));
    if (radAns == 0)
        radNum = 0;
        radNum = input('Which radius group should this be associated with? Use Figure 66 to determine the radius number.\n If you disagree with the group and wish to omit arc, press -1. \n');
        Spot_List(idx,14) = radNum;
    end
    clf(68);
end

idxToChange = find(Spot_List(:,14) > 0);
Spot_List(idxToChange,13) = Spot_List(idxToChange,14);
toRemove = find(Spot_List(:,14) < 0);
Spot_List(toRemove,:) = [];
Spot_List(:,14) = [];



